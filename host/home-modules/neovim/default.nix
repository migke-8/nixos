{ inputs, pkgs, config, ... }: 
  let
  inherit (config.lib) nixvim;
in
  {
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];
  programs.nixvim = {

    nixpkgs.pkgs = pkgs;
    enable = true;
    colorschemes.monokai-pro = {
      enable = true;
      settings = {
        transparent_background = true;
        terminal_colors = true;
        styles = {
          comment = { italic = true; };
          keyword = { italic = true; };
          type = { italic = true; };
          storageclass = { italic = true; };
          structure = { italic = true; };
          parameter = { italic = true; };
          annotation = { italic = true; };
          tag_attribute = { italic = true; };
        };
        background_clear = [
          "telescope"
        ];
        filter = "classic";
      };
    };
    plugins = {
      luasnip = {
        enable = true;
        fromVscode = [{
          paths = "${pkgs.vimPlugins.friendly-snippets}";
        }];
      };
      cmp_luasnip.enable = true;
      cmp = {
        autoEnableSources = true;
        enable = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<Tab>" = "cmp.mapping.confirm({ select = true })";
            "<C-d>" = ''
                cmp.mapping(function(fallback)
                  if cmp.visible_docs() then
                    cmp.close_docs()
                    elseif cmp.visible() then
                    cmp.open_docs()
                  else
                    fallback()
                  end
                end)
            '';
          };
        };
      };
      telescope = {
        enable = true;
        settings = {
          defaults = {
            file_ignore_patterns = [
              "%.git"
              "%.sbp"
              "%.metals"
              "%.classpath"
              "target"
              "out"
              "node_modules"
            ];
          };
        };
      };
      oil = {
        enable = true;
        settings = {
          default_file_explorer = true;
          columns = [
            "size"
            "icon"
          ];
          keymaps = {
            "<leader>rf" = "actions.refresh";
            "-" = "actions.parent";
            "_" = "actions.open_cwd";
          };
          view_options = {
            show_hidden = true;
            is_hidden_file = nixvim.mkRaw ''
                function(name, _)
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
                end
                '';
          };
        };
        lualine.enable = true;
        treesitter = {
          enable = true;
          settings = {
            highlight = {
              enable = true;
              additional_vim_regex_highlighting = false;
            };
            indent = {
              enable = true;
            };
          };
        };
        lsp = {
          enable = true;
          servers = {
            clangd = {
              enable = true;
            };
            nixd = {
              enable = true;
            };
          };
        mini = {
          enable = true;
          modules.icons = {};
        };
        render-markdown = {
          enable = true;
          settings = {
            heading = {
              icons = [
                "󰉏 " # H1
                "󰘦 " # H2
                "󰞋 " # H3
                "󰙔 " # H4
                "󰘧 " # H5
                "󰦨 "
              ];
            };
            render_modes = [ "n" ];
          };
        };
      };

      extraConfigLua = ''
      -- **************
      -- extra
      -- **************
      local builtin = require('telescope.builtin')
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

      vim.keymap.set("n", "-", function()
        require("oil").open()
      end)
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
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
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
      '';
    };
  }
