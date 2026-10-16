local M = {}

local namespace = vim.api.nvim_create_namespace("jbang-diagnostics")

local known = {
  DEPS = true,
  REPOS = true,
  JAVA = true,
  PREVIEW = true,
  COMPILE_OPTIONS = true,
  RUNTIME_OPTIONS = true,
  JAVAC_OPTIONS = true,
  JAVA_OPTIONS = true,
  NATIVE_OPTIONS = true,
  SOURCES = true,
  FILES = true,
  MAIN = true,
  MODULE = true,
  MANIFEST = true,
  CDS = true,
  JAVAAGENT = true,
  KOTLIN = true,
  GROOVY = true,
  DESCRIPTION = true,
}

local likely_directives = {
  "DEP", "REP", "JAVA", "PREVIEW", "COMPIL",
  "RUNTIME", "SOURCES", "FILES", "MAIN", "MODULE",
  "MANIFEST", "CDS", "KOTLIN", "GROOVY", "DESCRIPTION",
}

local function add(diagnostics, line, start_col, end_col, severity, message)
  diagnostics[#diagnostics + 1] = {
    lnum = line,
    col = start_col,
    end_col = math.max(start_col + 1, end_col),
    severity = severity,
    source = "jbang",
    message = message,
  }
end

local function looks_like_directive(name)
  for _, prefix in ipairs(likely_directives) do
    if name:sub(1, #prefix) == prefix then
      return true
    end
  end

  return false
end

local function validate_dependency(value, diagnostics, lnum, line)
  if value == "" then
    add(diagnostics, lnum, 0, #line, vim.diagnostic.severity.ERROR,
      "//DEPS requires a Maven coordinate (group:artifact[:version])")
    return
  end

  for coordinate in value:gmatch("%S+") do
    -- Ignore an optional classifier suffix when validating the coordinate.
    local base = coordinate:match("^([^@]+)") or coordinate
    local group, artifact, version =
      base:match("^([^:]+):([^:]+):?(.*)$")

    if not group or not artifact then
      local start_col = line:find(coordinate, 1, true) or 1
      add(diagnostics, lnum, start_col - 1,
        start_col - 1 + #coordinate,
        vim.diagnostic.severity.ERROR,
        ("Invalid Maven coordinate '%s'; expected group:artifact[:version]")
          :format(coordinate))
    elseif group:find("%s") or artifact:find("%s") then
      add(diagnostics, lnum, 0, #line,
        vim.diagnostic.severity.ERROR,
        "Maven group and artifact must not contain whitespace")
    elseif base:sub(-1) == ":" or version == "" and select(2, base:gsub(":", "")) >= 2 then
      -- An unfinished version is common while typing, so keep this as a hint.
      add(diagnostics, lnum, 0, #line,
        vim.diagnostic.severity.HINT,
        "Add a version to complete this Maven coordinate")
    end
  end
end

local function validate_line(text, lnum, diagnostics)
  local indent, name, value =
    text:match("^(%s*)//([A-Z][A-Z_]*)(.*)$")

  if not name then
    return
  end

  value = vim.trim(value)

  if not known[name] then
    if looks_like_directive(name) then
      add(diagnostics, lnum, #indent + 2,
        #indent + 2 + #name,
        vim.diagnostic.severity.WARN,
        ("Unknown JBang directive '%s'"):format(name))
    end
    return
  end

  local value_col = #indent + 2 + #name

  if name == "DEPS" then
    validate_dependency(value, diagnostics, lnum, text)

  elseif name == "REPOS" then
    if value == "" then
      add(diagnostics, lnum, value_col, #text,
        vim.diagnostic.severity.ERROR,
        "//REPOS requires a repository URL")
    elseif not value:match("^https?://[^%s]+$") then
      add(diagnostics, lnum, value_col, #text,
        vim.diagnostic.severity.WARN,
        "Expected a repository URL beginning with http:// or https://")
    end

  elseif name == "JAVA" then
    if value == "" then
      add(diagnostics, lnum, value_col, #text,
        vim.diagnostic.severity.ERROR,
        "//JAVA requires a Java version")
    elseif not value:match("^%d+") then
      add(diagnostics, lnum, value_col, #text,
        vim.diagnostic.severity.WARN,
        "Expected a Java version, such as 17, 21, or 25")
    end

  elseif name == "SOURCES" or name == "FILES" or name == "MAIN"
      or name == "MODULE" or name == "JAVAAGENT"
      or name == "KOTLIN" or name == "GROOVY"
      or name == "DESCRIPTION" then
    if value == "" then
      add(diagnostics, lnum, value_col, #text,
        vim.diagnostic.severity.WARN,
        ("//%s has no value"):format(name))
    end
  end
end

function M.check(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local diagnostics = {}
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for lnum, line in ipairs(lines) do
    validate_line(line, lnum - 1, diagnostics)
  end

  vim.diagnostic.set(namespace, bufnr, diagnostics, {})
end

function M.setup()
  local group = vim.api.nvim_create_augroup("JBangDiagnostics", {
    clear = true,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "java", "kotlin", "groovy" },
    callback = function(ev)
      local buf = ev.buf

      local buffer_group = vim.api.nvim_create_augroup(
        "JBangDiagnosticsBuffer" .. buf,
        { clear = true }
      )

      vim.api.nvim_create_autocmd({
        "BufEnter",
        "BufWritePost",
        "TextChanged",
        "TextChangedI",
      }, {
        group = buffer_group,
        buffer = buf,
        callback = function()
          M.check(buf)
        end,
      })

      M.check(buf)
    end,
  })
end

return M
