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
  -- 'neovim/nvim-lspconfig',
  'lervag/vimtex',
  'tpope/vim-surround',
  --'vim-pandoc/vim-pandoc-syntax',
  --'vim-pandoc/vim-pandoc',
  {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
  'sheerun/vim-polyglot',

  -- theme
  --'tjdevries/colorbuddy.nvim',
  --'bkegley/gloombuddy',
  --use "ellisonleao/gruvbox.nvim"
  --vim.o.background = 'dark'
  --vim.cmd([[colorscheme gruvbox]])
  'shaunsingh/nord.nvim',
  -- sneaking some formatting in here too
  --use {'prettier/vim-prettier', build = 'yarn install' }


  'preservim/nerdtree',
  'ryanoasis/vim-devicons',
  'nvim-tree/nvim-web-devicons',
  --use {'neoclide/coc.nvim', branch='release'}

  'neovim/nvim-lspconfig',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-omni',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lua',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-emoji',
  'onsails/lspkind-nvim',

  -- For vsnip users.
  -- 'hrsh7th/cmp-vsnip',
  -- 'hrsh7th/vim-vsnip',

  'vim-scripts/todo-txt.vim',

  'jdhao/better-escape.vim',
  -- statusline
  --'feline-nvim/feline.nvim',
  -- 'vim-airline/vim-airline',
  --'vim-airline/vim-airline-themes',
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons', opt=true } },
  {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
  'jalvesaq/zotcite',
  'jalvesaq/cmp-zotcite',

  -- snippets
  'L3MON4D3/LuaSnip',
  {
   'nvim-telescope/telescope.nvim', tag = '0.1.1',
  -- or                            , branch = '0.1.x',
   dependencies = { {'nvim-lua/plenary.nvim'} }
  },

  "mickael-menu/zk-nvim",
  --use {
  --  'iamcco/markdown-preview.nvim',
  --  ft = 'markdown',
  --  build = 'cd app && yarn install'
  --}
  'iamcco/markdown-preview.nvim',
  'junegunn/limelight.vim',
  'folke/twilight.nvim',
  'folke/zen-mode.nvim',

  'tpope/vim-fugitive',
  'vigoux/LanguageTool.nvim',
  'ledger/vim-ledger',
  'machakann/vim-swap',
  {
  'Julian/lean.nvim',
  event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-lua/plenary.nvim',
    -- you also will likely want nvim-cmp or some completion engine
  },

  -- see details below for full configuration options
  opts = {
    lsp = {},
    mappings = true,
  }
}
} 
)

