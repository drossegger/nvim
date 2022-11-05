-- Runtime path setup
package.path=package.path .. ';/home/dino/.config/nvim/?.lua'
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
vim.wo.number = true
vim.wo.relativenumber = false 
vim.wo.signcolumn = 'yes'
vim.wo.wrap = true 
vim.o.swapfile=false
vim.g.mapleader=' '
vim.g.maplocalleader="'"
vim.g.tw=80

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
  use 'tjdevries/colorbuddy.nvim'
  use 'bkegley/gloombuddy'

  
  -- sneaking some formatting in here too
  use {'prettier/vim-prettier', run = 'yarn install' }


  use 'preservim/nerdtree'
  use 'ryanoasis/vim-devicons'
  --use {'neoclide/coc.nvim', branch='release'}

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  -- For vsnip users.
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
end 
)

vim.g.colors_name = 'gloombuddy'

-- Plugin config
vim.g.vim_markdown_math = 1
vim.g.tex_flavor='latex'
vim.g.vimtex_view_method='zathura'
vim.g.vimtex_compiler_engine='lualatex'
vim.g.vimtex_compiler_progname='nvr'
-- Completion setup
--
vim.opt.completeopt={'menu','menuone','noselect'}

-- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['ltex'].setup {
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

require('markdown')
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"},{
  pattern = {"*.md"},
  callback = create_keymaps,})

