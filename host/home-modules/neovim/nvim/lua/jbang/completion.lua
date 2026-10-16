local M = {}

local directives = {
  { name = "DEPS", description = "Declare Maven dependencies" },
  { name = "REPOS", description = "Declare Maven repositories" },
  { name = "JAVA", description = "Select the Java version" },
  { name = "PREVIEW", description = "Enable Java preview features" },
  { name = "COMPILE_OPTIONS", description = "Set compiler options" },
  { name = "RUNTIME_OPTIONS", description = "Set runtime options" },
  { name = "JAVAC_OPTIONS", description = "Set javac options" },
  { name = "JAVA_OPTIONS", description = "Set Java options" },
  { name = "NATIVE_OPTIONS", description = "Set native-image options" },
  { name = "SOURCES", description = "Include source files" },
  { name = "FILES", description = "Include additional files" },
  { name = "MAIN", description = "Set the main class" },
  { name = "MODULE", description = "Set the Java module" },
  { name = "MANIFEST", description = "Set manifest entries" },
  { name = "CDS", description = "Configure Class Data Sharing" },
  { name = "JAVAAGENT", description = "Add a Java agent" },
  { name = "KOTLIN", description = "Set the Kotlin version" },
  { name = "GROOVY", description = "Set the Groovy version" },
  { name = "DESCRIPTION", description = "Describe the script" },
}

local source = {}
local cache = {}

local function encode(value)
  return (value:gsub("[^%w%-_%.~]", function(char)
    return string.format("%%%02X", char:byte())
  end))
end

local function escape_solr(value)
  return (value:gsub("([+%-!(){}%[%]^\"~*?:\\/])", "\\%1"))
end

local function get_root(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local root = vim.fs.root(filename, {
    ".git",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "settings.gradle",
    "settings.gradle.kts",
    "flake.nix"
  })

  return root or vim.fn.getcwd()
end

local function item(label, insert_text, detail, documentation, kind)
  return {
    label = label,
    insertText = insert_text,
    kind = kind,
    detail = detail,
    documentation = documentation,
  }
end

local function complete_directives(prefix, cmp)
  local items = {}

  for _, directive in ipairs(directives) do
    if directive.name:sub(1, #prefix) == prefix then
      items[#items + 1] = item(
        directive.name,
        directive.name,
        "JBang directive",
        directive.description,
        cmp.lsp.CompletionItemKind.Keyword
      )
    end
  end

  return items
end

local function coordinate_items(docs, prefix, version_search, cmp)
  local items = {}
  local seen = {}

  for _, doc in ipairs(docs or {}) do
    local group = doc.g
    local artifact = doc.a
    local version = doc.v or doc.latestVersion

    if group and artifact then
      local coordinate

      if version_search then
        if version then
          coordinate = group .. ":" .. artifact .. ":" .. version
        end
      elseif prefix:find(":", 1, true) then
        if version then
          coordinate = group .. ":" .. artifact .. ":" .. version
        else
          coordinate = group .. ":" .. artifact .. ":"
        end
      elseif group:sub(1, #prefix) == prefix then
        coordinate = group .. ":"
      elseif artifact:sub(1, #prefix) == prefix then
        coordinate = group .. ":" .. artifact .. ":" .. (version or "")
      end

      if coordinate and not seen[coordinate] then
        seen[coordinate] = true
        items[#items + 1] = item(
          coordinate,
          coordinate,
          "Maven dependency",
          doc.description or ("Maven coordinate: " .. coordinate),
          cmp.lsp.CompletionItemKind.Module
        )
      end
    end
  end

  return items
end

local function search_maven(prefix, callback, cmp)
  local group, artifact, version =
    prefix:match("^([^:]+):([^:]*):?(.*)$")

  local query
  local version_search = false
  local core = nil

  if prefix:find(":", 1, true) then
    if select(2, prefix) >= 2 then
      version_search = true
      core = "gav"

      query = "g:" .. escape_solr(group)
        .. " AND a:" .. escape_solr(artifact)

      if version ~= "" then
        query = query .. " AND v:" .. escape_solr(version) .. "*"
      end
    else
      query = "g:" .. escape_solr(group)
        .. " AND a:" .. escape_solr(artifact) .. "*"
    end
  else
    local escaped = escape_solr(prefix)
    query = "g:" .. escaped .. "* OR a:" .. escaped .. "*"
  end

  local url = "https://central.sonatype.com/solrsearch/select?q="
  .. encode(query)
  .. "&rows=100&wt=json"

  if core then
    url = url .. "&core=gav&sort=v%20desc"
  end
  if cache[url] then
    callback(coordinate_items(cache[url], prefix, version_search, cmp))
    return
  end

  if vim.fn.executable("curl") ~= 1 then
    callback({})
    vim.notify("JBang completion: curl is required for Maven search",
      vim.log.levels.WARN)
    return
  end

  vim.system({
    "curl", "-fsSL", "--max-time", "4", url,
  }, { text = true }, function(result)
    local docs = {}

    if result.code == 0 and result.stdout then
      local ok, response = pcall(vim.json.decode, result.stdout)

      if ok and response.response and response.response.docs then
        docs = response.response.docs
        cache[url] = docs
      end
    end

    vim.schedule(function()
      callback(coordinate_items(docs, prefix, version_search, cmp))
    end)
  end)
end

local function complete_paths(line, prefix, bufnr, cmp)
  local root = get_root(bufnr)
  local search_prefix = prefix
  local insert_prefix = ""

  -- For //FILES target=source, complete the source side.
  if line:match("^%s*//FILES%s+") then
    local before_equals, after_equals = prefix:match("^(.-=)(.*)$")
    if before_equals then
      insert_prefix = before_equals
      search_prefix = after_equals
    end
  end

  local pattern = search_prefix .. "*"
  local paths = vim.fn.globpath(root, pattern, false, true)
  local items = {}

  table.sort(paths)

  for _, absolute in ipairs(paths) do
    local relative = vim.fs.relpath(root, absolute) or absolute
    local stat = vim.uv.fs_stat(absolute)

    if stat then
      relative = relative:gsub("\\", "/")

      if stat.type == "directory" then
        relative = relative .. "/"
      end

      items[#items + 1] = item(
        relative,
        insert_prefix .. relative,
        stat.type == "directory" and "Directory" or "File",
        absolute,
        stat.type == "directory"
          and cmp.lsp.CompletionItemKind.Folder
          or cmp.lsp.CompletionItemKind.File
      )
    end
  end

  return items
end

function source:get_debug_name()
  return "JBang"
end

function source:get_trigger_characters()
  return { "/", ":", "." }
end

function source:get_keyword_pattern()
  local line = vim.api.nvim_get_current_line()
  local before = line:sub(1, vim.api.nvim_win_get_cursor(0)[2])

  if before:match("^%s*//[%w_]*$") then
    return [[\k\+]]
  end

  return [[\f\+]]
end

function source:complete(params, callback)
  local cmp = require("cmp")
  local before = params.context.cursor_before_line or ""

  -- Directive names, e.g. //DEP
  local directive_prefix = before:match("^%s*//([%w_]*)$")
  if directive_prefix then
    callback({
      items = complete_directives(directive_prefix, cmp),
      isIncomplete = false,
    })
    return
  end

  -- Maven dependencies, e.g. //DEPS org.slf4j:slf4j-api:
  local deps_prefix = before:match("^%s*//DEPS%s+(%S*)$")
  if deps_prefix then
    search_maven(deps_prefix, function(items)
      callback({
        items = items,
        isIncomplete = false,
      })
    end, cmp)
    return
  end

  -- Local sources and files
  local directive, path_prefix =
    before:match("^%s*//(SOURCES|FILES)%s+(%S*)$")

  if directive and path_prefix then
    callback({
      items = complete_paths(
        before,
        path_prefix,
        params.context.bufnr,
        cmp
      ),
      isIncomplete = false,
    })
    return
  end

  callback({ items = {}, isIncomplete = false })
end

function M.setup()
  cache = {}
  local cmp = require("cmp")
  cmp.register_source("jbang", source)

  cmp.setup.filetype("java", {
    sources = cmp.config.sources({
      {
        name = "jbang",
        priority = 1000,
        keyword_length = 0,
        trigger_characters = { "/", ":", "." },
      },
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
      { name = "buffer" },
    }),
  })
end

return M

