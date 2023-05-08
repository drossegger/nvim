-- Runtime path setup package.path=package.path .. ';/home/dino/.config/nvim/?.lua'
--
vim.o.filetype='on'
vim.o.syntax='on'
vim.o.errorbells=false
vim.o.smartcase=true
vim.o.mouse='a'
vim.o.undodir = vim.fn.stdpath('config') .. '/undodir'
vim.o.undofile = true
vim.o.incsearch = true
vim.o.hidden = true
vim.o.completeopt='menuone,noinsert,noselect'
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.tw=80
vim.wo.number = true
vim.wo.relativenumber = false
vim.wo.signcolumn = 'yes'
-- vim.wo.wrap = true
vim.o.swapfile=false
vim.g.mapleader=' '
vim.g.maplocalleader="'"
vim.g.tw=80
vim.g.loaded_perl_provider=0
vim.g.loaded_ruby_provider=0
vim.o.splitright=true
local key_mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    {noremap = true, silent = true}
  )
end

key_mapper('', '<up>', '<nop>')
key_mapper('', '<down>', '<nop>')
key_mapper('', '<left>', '<nop>')
key_mapper('', '<right>', '<nop>')

-- Plugin Manager Packer
--
--
--
local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn
-- ensure that packer is installed
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
end
vim.cmd('packadd packer.nvim')
local packer = require'packer'
local util = require'packer.util'
packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})
--- startup and add configure plugins
packer.startup(function()
  local use = use
  -- add you plugins here like:
  -- use 'neovim/nvim-lspconfig'
  use 'lervag/vimtex'
  use 'tpope/vim-surround'
  use 'vim-pandoc/vim-pandoc-syntax'
  use 'vim-pandoc/vim-pandoc'
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use 'sheerun/vim-polyglot'

  -- theme
  --use 'tjdevries/colorbuddy.nvim'
  --use 'bkegley/gloombuddy'
  --use "ellisonleao/gruvbox.nvim"
  --vim.o.background = 'dark'
  --vim.cmd([[colorscheme gruvbox]])
  use 'shaunsingh/nord.nvim'
  -- sneaking some formatting in here too
  use {'prettier/vim-prettier', run = 'yarn install' }


  use 'preservim/nerdtree'
  use 'ryanoasis/vim-devicons'
  use 'nvim-tree/nvim-web-devicons'
  --use {'neoclide/coc.nvim', branch='release'}

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-omni'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-emoji'
  use 'onsails/lspkind-nvim'

  -- For vsnip users.
  -- use 'hrsh7th/cmp-vsnip'
  -- use 'hrsh7th/vim-vsnip'

  use 'vim-scripts/todo-txt.vim'

  use 'jdhao/better-escape.vim'
  -- statusline
  --use 'feline-nvim/feline.nvim'
  -- use 'vim-airline/vim-airline'
  --use 'vim-airline/vim-airline-themes'
  use { 'nvim-lualine/lualine.nvim', requires = { 'nvim-tree/nvim-web-devicons', opt=true } }
  use { 'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons' }
  use 'jalvesaq/zotcite'

  -- snippets
  use 'L3MON4D3/LuaSnip'
end
)

-- Color Scheme
  vim.g.nord_contrast = true
  vim.g.nord_border= true
  require('nord').set()
-- Plugin config
vim.g.vim_markdown_math = 1
-- vim.g.tex_flavor='latex'
vim.g.vimtex_quickfix_mode=0
vim.g.vimtex_view_method='zathura'
vim.g.vimtex_compiler_engine='lualatex'
vim.g.vimtex_compiler_progname='nvr'
require('lualine').setup()

require("bufferline").setup{ options= { separator_style="slant" } }
-- LuaSnip
--
vim.cmd[[
" Use Tab to expand and jump through snippets
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

" Use Shift-Tab to jump backwards through snippets
imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
]]
require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})
require("luasnip").config.set_config({ -- Setting LuaSnip config

  -- Enable autotriggered snippets
  enable_autosnippets = true,

  -- Use Tab (or some other key if you prefer) to trigger visual selection
  store_selection_keys = "<Tab>",
  update_events='TextChanged,TextChangedI',
})


-- Completion setup
--
vim.opt.completeopt={'menu','menuone','noselect'}

-- Set up nvim-cmp.
  local cmp = require'cmp'
  local lspkind=require'lspkind'

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = {
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
         fallback()
        end
      end,
      ['<S-Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
      ['<Esc>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
      { name = 'nvim_lua' }, 
      { name = 'path' }, 
 --     { name = 'omni' },
      { name = 'buffer' },
      { name = 'emoji', insert = true, },
    }, 
    completion = {
      keyword_length = 1,
      completeopt = "menu,noselect"
    },
    view = {
      entries = 'custom',
    },
    formatting = {
      format = lspkind.cmp_format({
        mode = "symbol_text",
        menu = ({
          nvim_lsp = "[LSP]",
          ultisnips = "[US]",
          nvim_lua = "[Lua]",
          path = "[Path]",
          buffer = "[Buffer]",
          emoji = "[Emoji]",
--  	      omni = "[Omni]",
        }),
      }),
    },
  })

  -- Set up lspconfig.
  --local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['texlab'].setup {
    capabilities = capabilities
  }
---- LSP
--local lspconfig = require'lspconfig'
--local completion = require'completion'
--local function custom_on_attach(client)
--  print('Attaching to ' .. client.name)
--  completion.on_attach(client)
--end
--local default_config = {
--  on_attach = custom_on_attach,
--}
---- setup language servers here
--lspconfig.tsserver.setup(default_config)

-- key_mapper('n','<Leader>n',':NERDTree<CR>')
key_mapper('n','<Leader>t',':NERDTreeToggle<CR>')
key_mapper('n','<Leader>f',':NERDTreeFind<CR>')

-- Include COC config
--require 'include.coc'

-- require('markdown')
-- vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"},{
--   pattern = {"*.md"},
--   callback = create_keymaps,})

vim.api.nvim_create_user_command('Todo', '80vsplit /home/dino/Dropbox/Dokumente/todo/todo.txt',{})

vim.env.ZoteroSQLpath="/home/dino/snap/zotero-snap/common/Zotero/zotero.sqlite"

-- Statusbar
--require('feline_config')
