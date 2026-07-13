-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
-- Setup lazy.nvim

require("lazy").setup({
  -- add you plugins here like:
  'lervag/vimtex',
  'tpope/vim-surround',
  'tpope/vim-fugitive',
  {'nvim-treesitter/nvim-treesitter', branch='main', build = ':TSUpdate'},
  {
    "mason-org/mason.nvim",
    opts = {}
  },
  "neovim/nvim-lspconfig",
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
  },
  {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  dependencies = { 'mason-org/mason.nvim' },
  opts = {
    ensure_installed = {
      'lua_ls',
      'stylua',
      'prettier',
      'goimports',
    },
  },
},
  -- theme
  'shaunsingh/nord.nvim',
  'preservim/nerdtree',
  'ryanoasis/vim-devicons',
  'nvim-tree/nvim-web-devicons',
  'vim-scripts/todo-txt.vim',

  { 'max397574/better-escape.nvim',
    config = function ()
      require("better_escape").setup()
    end,
  },
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons', opt=true } },
  {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
  -- snippets
  'L3MON4D3/LuaSnip',
  {
   'nvim-telescope/telescope.nvim', tag = '0.1.1',
  -- or                            , branch = '0.1.x',
   dependencies = { {'nvim-lua/plenary.nvim'} }
  },

 'iamcco/markdown-preview.nvim',
 'folke/twilight.nvim',
 'folke/zen-mode.nvim',
  {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  }
}
}
)

