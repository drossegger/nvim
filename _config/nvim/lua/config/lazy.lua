-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})

    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  ---------------------------------------------------------------------------
  -- Theme
  ---------------------------------------------------------------------------
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_border = true
      require("nord").set()
    end,
  },

  ---------------------------------------------------------------------------
  -- LaTeX / writing
  ---------------------------------------------------------------------------
  {
    "lervag/vimtex",
    ft = { "tex", "plaintex", "bib" },
    init = function()
      -- These must be set before VimTeX loads.
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_engine = "lualatex"
      vim.g.vimtex_compiler_progname = "nvr"
      vim.g.vimtex_complete_enabled = 0
      vim.g.vimtex_fold_enabled = 1
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    -- If Markdown Preview has not installed its Node dependencies yet,
    -- uncomment the next line, provided npm is available:
    -- build = "cd app && npm install",
  },

  {
    "folke/twilight.nvim",
    cmd = "Twilight",
  },

  {
    "folke/zen-mode.nvim",
    keys = {
      {
        "<leader>zen",
        function()
          require("zen-mode").toggle({
            plugins = {
              alacritty = {
                enabled = true,
                font = "18",
              },
            },
            window = {
              options = {
                number = false,
              },
            },
          })
        end,
        desc = "Toggle Zen mode",
      },
    },
  },

  ---------------------------------------------------------------------------
  -- Treesitter
  ---------------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- The main branch may use the singular module name, while older
      -- stable versions use "nvim-treesitter.configs".
      local ok, treesitter = pcall(require, "nvim-treesitter.config")
      if not ok then
        treesitter = require("nvim-treesitter.configs")
      end

      treesitter.setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "latex",
          "bibtex",
          "markdown",
          "markdown_inline",
          "python",
          "html",
          "javascript",
          "typescript",
          "json",
          "yaml",
        },
        highlight = {
          enable = true,

          -- VimTeX's syntax highlighting is normally better for LaTeX.
          disable = { "latex" },
        },
        indent = {
          enable = true,
        },
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- LSP / Mason
  ---------------------------------------------------------------------------
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {},
  },

  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      -----------------------------------------------------------------------
      -- Native Neovim completion
      -----------------------------------------------------------------------
      vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }
      vim.opt.autocomplete = true

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("NativeLspCompletion", {
          clear = true,
        }),
        callback = function(args)
          local client_id = args.data.client_id
          if not client_id then
            return
          end

          local client = vim.lsp.get_client_by_id(client_id)

          if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client_id, args.buf, {
              autotrigger = true,
            })
          end
        end,
      })

      -----------------------------------------------------------------------
      -- Personal spelling dictionary, shared by Neovim and LTeX+
      -----------------------------------------------------------------------
      local spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

      vim.fn.mkdir(vim.fn.fnamemodify(spellfile, ":h"), "p")
      vim.opt.spellfile = spellfile

      local dictionary_words = {}
      if vim.fn.filereadable(spellfile) == 1 then
        dictionary_words = vim.fn.readfile(spellfile)
      end

      -----------------------------------------------------------------------
      -- LTeX+: grammar and spelling diagnostics for prose
      -----------------------------------------------------------------------
      vim.lsp.config("ltex_plus", {
        filetypes = { "tex", "plaintex", "bib", "markdown" },
        settings = {
          ltex = {
            language = "en-US",
            dictionary = {
              ["en-US"] = dictionary_words,
            },
          },
        },
      })

      -----------------------------------------------------------------------
      -- Texlab: LSP features only.
      -- VimTeX remains responsible for compiling and viewing PDFs.
      -----------------------------------------------------------------------
      vim.lsp.config("texlab", {
        settings = {
          texlab = {
            build = {
              onSave = false,
              forwardSearchAfter = false,
            },
          },
        },
      })

      -----------------------------------------------------------------------
      -- Python
      -----------------------------------------------------------------------
      vim.lsp.config("pyright", {})

      vim.lsp.config("ruff", {
        on_attach = function(client)
          -- Let Pyright provide hover documentation, preventing duplicate
          -- hover results from Ruff and Pyright.
          client.server_capabilities.hoverProvider = false
        end,
      })

      -----------------------------------------------------------------------
      -- Lua / HTML / JavaScript / TypeScript
      -----------------------------------------------------------------------
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      })

      vim.lsp.config("html", {})
      vim.lsp.config("ts_ls", {})

      -----------------------------------------------------------------------
      -- Install and automatically enable the language servers.
      --
      -- Keep this after vim.lsp.config(...) calls above. Otherwise, Mason
      -- could start a server before its custom configuration is registered.
      -----------------------------------------------------------------------
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ltex_plus",
          "texlab",
          "pyright",
          "ruff",
          "lua_ls",
          "html",
          "ts_ls",
        },
        automatic_enable = true,
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- Non-LSP external tools
  ---------------------------------------------------------------------------
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "stylua",
        "prettier",
      },
    },
  },

  ---------------------------------------------------------------------------
  -- Snippets
  ---------------------------------------------------------------------------
  {
    "L3MON4D3/LuaSnip",
    lazy = false,
    config = function()
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_lua").load({
        paths = vim.fn.stdpath("config") .. "/LuaSnip/",
      })

      luasnip.config.set_config({
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
        update_events = "TextChanged,TextChangedI",
      })

      vim.keymap.set({ "i", "s" }, "<Tab>", function()
        if vim.fn.pumvisible() == 1 then
          return "<C-n>"
        elseif luasnip.expand_or_jumpable() then
          return "<Plug>luasnip-expand-or-jump"
        else
          return "<Tab>"
        end
      end, {
        expr = true,
        silent = true,
        desc = "Completion or next snippet field",
      })

      vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        if vim.fn.pumvisible() == 1 then
          return "<C-p>"
        elseif luasnip.jumpable(-1) then
          return "<Plug>luasnip-jump-prev"
        else
          return "<S-Tab>"
        end
      end, {
        expr = true,
        silent = true,
        desc = "Previous completion or snippet field",
      })
    end,
  },

  ---------------------------------------------------------------------------
  -- Statusline / bufferline
  ---------------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local function texstatus()
        local compiler = vim.b.vimtex and vim.b.vimtex.compiler
        local status = compiler and compiler.status

        return ({
          [1] = "c",
          [2] = "✓",
          [3] = "✗",
        })[status] or "i"
      end

      local function is_visual_mode()
        local mode = vim.fn.mode(1)
        return mode == "v" or mode == "V" or mode == "\22"
      end

      local function get_words()
        local count = vim.fn.wordcount()

        if is_visual_mode() then
          return (count.visual_words or 0) .. " w"
        end

        return count.words .. " w"
      end

      local function get_chars()
        local count = vim.fn.wordcount()

        if is_visual_mode() then
          return (count.visual_chars or 0) .. " c"
        end

        return count.chars .. " c"
      end

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "nord",
          component_separators = {
            left = "",
            right = "",
          },
          section_separators = {
            left = "",
            right = "",
          },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = {
            "mode",
            {
              texstatus,
              cond = function()
                return vim.bo.filetype == "tex"
              end,
            },
            "searchcount",
          },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location", get_chars, get_words },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    lazy=false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "]b",
        "<cmd>BufferLineCycleNext<CR>",
        desc = "Next buffer",
      },
      {
        "b]",
        "<cmd>BufferLineCyclePrev<CR>",
        desc = "Previous buffer",
      },
    },
    opts = {
      options = {
        separator_style = "slant",
      },
    },
  },

  ---------------------------------------------------------------------------
  -- File tree / Git / search
  ---------------------------------------------------------------------------
  {
    "preservim/nerdtree",
    cmd = {
      "NERDTree",
      "NERDTreeFind",
      "NERDTreeToggle",
    },
    keys = {
      {
        "<leader>t",
        "<cmd>NERDTreeToggle<CR>",
        desc = "Toggle file tree",
      },
      {
        "<leader>f",
        "<cmd>NERDTreeFind<CR>",
        desc = "Find current file in tree",
      },
    },
    dependencies = {
      "ryanoasis/vim-devicons",
    },
  },

  "tpope/vim-surround",

  "tpope/vim-fugitive",

 {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.1",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>ff",
      "<cmd>Telescope find_files<CR>",
      desc = "Find files",
    },
    {
      "<leader>fg",
      "<cmd>Telescope live_grep<CR>",
      desc = "Search project text",
    },
    {
      "<leader>fb",
      "<cmd>Telescope buffers<CR>",
      desc = "Find buffers",
    },
    {
      "<leader>fh",
      "<cmd>Telescope help_tags<CR>",
      desc = "Search help",
    },
  },
}, 

  ---------------------------------------------------------------------------
  -- Todo files / escape behavior
  ---------------------------------------------------------------------------
  "vim-scripts/todo-txt.vim",

  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup()
    end,
  },

  ---------------------------------------------------------------------------
  -- Diagnostics lists
  ---------------------------------------------------------------------------
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<CR>",
        desc = "Diagnostics",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
        desc = "Buffer diagnostics",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<CR>",
        desc = "Symbols",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
        desc = "LSP definitions / references",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<CR>",
        desc = "Location list",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<CR>",
        desc = "Quickfix list",
      },
    },
  },
})
