{pkgs, ...}: {
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    plugins = with pkgs.vimPlugins; [
      monokai-pro-nvim
      vim-mustache-handlebars
      none-ls-nvim
      telescope-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      friendly-snippets
      luasnip
      oil-nvim
      nvim-metals
      lualine-nvim
      render-markdown-nvim
      {
        plugin = nvim-lspconfig;
        config = ''
          vim.lsp.enable("nixd")
          vim.lsp.enable("jdtls", {
            cmd = { "jdtls" }
          })
          vim.lsp.enable("svelte")
          vim.lsp.enable("ts_ls")
          vim.lsp.enable("html")
          vim.lsp.enable("cssls")
          vim.lsp.config("nixd", {
            cmd = {"nixd"},
            settings = {
              nixd = {
                nixpkgs = {
                  expr = "import <nixpkgs> { }"
                },
                formatting = {
                  command = {"alejandra"}
                }
              }
            }
          })
          vim.lsp.enable("clangd")

          vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            client.server_capabilities.semanticTokensProvider = nil
          end,
          })
          vim.diagnostic.config({
            virtual_text = false,
            signs = true,
            underline = true,
            severity_sort = true,
          })


          vim.keymap.set("n", "<C-x>", function()
          vim.diagnostic.open_float(nil, { focus = false })
          end)
          vim.keymap.set("n", "H", vim.lsp.buf.hover, {})
          vim.keymap.set("n", "S", vim.lsp.buf.signature_help, {})
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
          vim.keymap.set("n", "sdc", vim.lsp.buf.declaration, {})
          vim.keymap.set("n", "sdf", vim.lsp.buf.definition, {})
          vim.keymap.set("n", "sim", vim.lsp.buf.implementation, {})
          vim.keymap.set("n", "rnm", vim.lsp.buf.rename, {})
        '';
        type = "lua";
      }
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require('nvim-treesitter').setup {
            install_dir = vim.fn.stdpath('data') .. '/site'
          }
        '';
      }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          local completionData = {
              sources = {
                {
                  { name = "nvim_lsp" },
                  { name = "luasnip" },
                  { name = "buffer" }
                }
              },
              icons = {
                "",
                Text = "",
                Variable = "",
                Function = "󰡱",
                Snippet = "",
                Field = "",
                Method = "",
                Keyword = "",
                Class = "",
                Module = "󱒌",
                Interface = "",
                Value = "",
                Constant = ""
              },
              getWindow = function(cmp)
                return {
                  col_offset = -3,
                  completion = cmp.config.window.bordered(
                    {
                      border = "shadow",
                      scrollbar = false
                    }
                  ),
                  documentation = { max_height = 7 }
                }
              end
            }
            local configure = function()
              vim.api.nvim_set_hl(0, "CmpItemKind", {
                foreground = "#AE81FF",
                background = "NONE",
                italic = true,
              })
              vim.api.nvim_set_hl(0, "CmpItemMenu", {
                foreground = "#A6E22E",
                background = "NONE",
                italic = true,
              })
              vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", {
                foreground = "#E6DB74",
                background = "NONE",
                italic = true,
              })
              vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", {
                foreground = "#E6DB74",
                background = "NONE",
                italic = true,
              })
              vim.cmd("set pumheight=7")
            end
            local cmp = require("cmp")

            configure()
            require("luasnip.loaders.from_vscode").lazy_load()
            cmp.setup({
              snippet = {
                expand = function(args)
                  require("luasnip").lsp_expand(args.body)
                end,
              },
              window = completionData.getWindow(cmp),
              mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                ["<C-d>"] = cmp.mapping(function(fallback)
                  if cmp.visible_docs() then
                    cmp.close_docs()
                  elseif cmp.visible() then
                    cmp.open_docs()
                  else
                    fallback()
                  end
                end),
              }),
              sources = cmp.config.sources(unpack(completionData.sources)),
              formatting = {
                  fields = { "abbr", "menu", "kind" },
                  format = function(_, vim_item)
                    local icons = completionData.icons
                    local kind = vim_item.kind
                    local icon = icons[kind]
                    local kindText = "(" .. kind:lower() .. ")"
                    local expected = icon and icon .. " " .. kindText
                    local default = icons[1] .. " " .. kindText

                    vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
                    vim_item.menu = vim_item.menu and string.sub(vim_item.menu, 1, 19)
                    vim_item.kind = expected or default
                    return vim_item
                  end,
                },
             })
        '';
      }
    ];
    extraPackages = with pkgs; [
      # formatters
      stylua
      black
      nodePackages.prettier
      shfmt
      alejandra
      # lsp
      nixd
      lemminx
      luajitPackages.lua-lsp
      bash-language-server
      nodePackages.vscode-langservers-extracted
      typescript-language-server
      vscode-css-languageserver
      jdt-language-server
      clang-tools
      svelte-language-server
      metals
      coursier
      scala-cli
      # extra
      ripgrep
    ];
    initLua = ''
      -- **************
      -- editor config
      -- **************
        vim.cmd("set tabstop=2")
        vim.cmd("set shiftwidth=2")
        vim.cmd("set softtabstop=2")
        vim.cmd("set expandtab")
        vim.cmd("set ignorecase")
      vim.cmd("set history=1000")
      vim.cmd("set wildmenu")
        vim.cmd("set relativenumber")
        vim.cmd("set clipboard+=unnamedplus")
        vim.cmd("set noswapfile")
        vim.cmd("set cmdheight=2")
        vim.opt.spell = true
        vim.opt.spelllang = "en_us"
        vim.opt.shell = "zsh"
        require("monokai-pro").setup({
          transparent_background = true,
          terminal_colors = true,
          styles = {
            comment = { italic = true },
            keyword = { italic = true },
            type = { italic = true },
            storageclass = { italic = true },
            structure = { italic = true },
            parameter = { italic = true },
            annotation = { italic = true },
            tag_attribute = { italic = true },
          },
          background_clear = {
            "telescope",
          },
          filter = "classic",
        })
        vim.cmd([[colorscheme monokai-pro]])
        require("oil").setup({
        default_file_explorer = true,
          columns = {
            "size",
            "icon",
          },
          keymaps = {
            ["<leader>rf"] = "actions.refresh",
            ["-"] = "actions.parent",
            ["_"] = "actions.open_cwd",
          },
          view_options = {
            show_hidden = true,
            is_hidden_file = function(name, _)
              return vim.startswith(name, ".")
            end,
            case_insensitive = false,
            sort = {
              { "type", "asc" },
              { "name", "asc" },
            },
            is_always_hidden = function(name, _)
              if name == ".." or name == ".git" then
                return true
              end
              return false
            end,
          },
        })
        vim.keymap.set("n", "-", function()
          require("oil").open()
        end)
        -- **************
        -- metals config
        -- **************
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local metals_config = require("metals").bare_config()

        metals_config.settings = {
          showImplicitArguments = true,
          excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        }
        local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "scala", "sbt", "java" },
          callback = function()
         local capable = cmp_nvim_lsp.default_capabilities()
         local configuration = vim.tbl_deep_extend("keep", metals_config, capable)
            require("metals").initialize_or_attach(configuration)
          end,
          group = nvim_metals_group,
        })

        -- **************
        -- keymaps config
        -- **************
      local doKeyStroke = function(keys_to_type)
          local replaced_keys = vim.api.nvim_replace_termcodes(keys_to_type, true, false, true)
          vim.api.nvim_feedkeys(replaced_keys, 'm', false)
      end
      local string = require("string")
      local augroup = vim.api.nvim_create_augroup("buffer_events", { clear = true })
      local isTerm = function()
        return vim.api.nvim_buf_get_option(0, "buftype") == "terminal"
      end
      local isInTermNormal = function()
        local in_terminal = vim.v.mode ~= 't'
        local is_terminal_buffer = vim.bo.buftype == 'terminal'
        return in_terminal and is_terminal_buffer
      end
      vim.keymap.set("n", "<C-d>", "<C-d>zz", {noremap = true, silent = true})
      vim.keymap.set("n", "<C-u>", "<C-u>zz", {noremap = true, silent = true})
      vim.keymap.set("n", "n", "nzzzv", {noremap = true, silent = true})
      vim.keymap.set("n", "N", "Nzzzv", {noremap = true, silent = true})
      vim.keymap.set({"n", "t"}, "<C-]>", function() vim.cmd("rightbelow vnew") end, {noremap = true, silent = true})
      vim.keymap.set({"n", "t"}, "<Esc>", "<Esc>", {noremap = true, silent = true})
      vim.keymap.set({"n", "t"}, "<C-[>", function() vim.cmd("leftabove vnew") end, {noremap = true, silent = true})
      vim.keymap.set({"n", "t"}, "<A-->", function() vim.cmd("rightbelow new") end, {noremap = true, silent = true})
      vim.keymap.set({"n", "t"}, "<A-=>", function() vim.cmd("new") end, {noremap = true, silent = true})
      vim.keymap.set("n", "<C-t>", function()
        if not isTerm() then
          vim.cmd("terminal")
          vim.cmd("set nospell")
        end
        doKeyStroke("a")
      end)
      vim.keymap.set({"n", "t"}, "<leader>n", "<C-\\><C-n>", { noremap = true, silent = true })
      vim.keymap.set("t", "<C-t>", "<leader>n")
      vim.keymap.set({"n", "t"}, "<C-Tab>", function()
        vim.cmd("bnext")
        vim.api.nvim_create_autocmd("BufEnter", {
            group = augroup,
            callback = function()
              if isInTermNormal() then
                doKeyStroke("a")
              end
            end,
            pattern = "*",
            once = true
          })
      end)
      vim.keymap.set({"n", "t"}, "<S-Tab>", function()
        vim.cmd("bp")
        vim.api.nvim_create_autocmd("BufEnter", {
          group = augroup,
          callback = function()
            if isInTermNormal() then
              doKeyStroke("a")
            end
          end,
          pattern = "*",
          once = true
        })

      end)
      vim.keymap.set({"n", "t"}, "<leader>w", function()
        if isTerm() then
          doKeyStroke("<leader>n<C-w>")
        else
          doKeyStroke("<C-w>")
          doKeyStroke(string.char(vim.fn.getchar()))
          vim.api.nvim_create_autocmd("BufEnter", {
            group = augroup,
            callback = function()
              if isInTermNormal() then
                doKeyStroke("a")
              end
            end,
            pattern = "*",
            once = true
          })
        end
      end)

      -- **************
      -- lualine
      -- **************
      local lualine = require("lualine")

      lualine.setup({
        options = { theme = "auto" },
      })

      -- **************
      -- null-ls
      -- **************
      require("null-ls").setup()
      vim.keymap.set({ "n", "i" }, "<C-f>", vim.lsp.buf.format, {})

      -- **************
      -- telescope
      -- **************
      local builtin = require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "%.git",
            "%.sbp",
            "%.metals",
            "%.classpath",
            "target",
            "out",
            "node_modules"
          }
        }
      })
      local builtin = require('telescope.builtin')
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

      -- **************
      -- markdown
      -- **************

      require("render-markdown").setup({ render_modes = { "n" } })
    '';
  };
}
