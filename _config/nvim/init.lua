-- Runtime path setup package.path=package.path .. ';/home/dino/.config/nvim/?.lua'
--
vim.o.linebreak=true 
vim.o.filetype='on'
vim.o.syntax='on'
vim.o.errorbells=false
vim.o.smartcase=true
vim.o.mouse='a'
vim.o.undodir = vim.fn.stdpath('config') .. '/undodir'
vim.o.undofile = true
vim.o.incsearch = true
vim.o.hidden = true
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.tw=0
vim.wo.number = true
vim.wo.relativenumber = false
vim.wo.signcolumn = 'yes'
-- vim.wo.wrap = true
vim.o.swapfile=false
vim.g.mapleader=' '
vim.g.maplocalleader="'"
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
key_mapper('i','<C-t>','<Tab><Tab><Tab><Tab><Tab><Tab><Tab><Tab><Tab><Tab>')

local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn

-- Load lazy nvim
--
--
require("config.lazy")

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
vim.g.vimtex_complete_enabled= 0

local function texstatus()
  local running=vim.b.vimtex.compiler.status
  --local running=vim.b.vimtex.compiler.is_running()
  if running==1 then
    return [[c]]
  elseif running==2 then
    return [[✓]]
  elseif running==3 then
    return [[✗]]
  else 
    return [[i]]
  end
end

local function getWords()
    -- the third string here is the string for visual-block mode (^V)
    if vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "" then
        return vim.fn.wordcount().visual_words .. " w"
    else
        return vim.fn.wordcount().words .. " w"
    end
end
local function getChars()
    -- the third string here is the string for visual-block mode (^V)
    if vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "" then
        return vim.fn.wordcount().visual_chars .. " c"
    else
        return vim.fn.wordcount().chars.. " c"
    end
end


require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'nord',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
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
    }
  },
  sections = {
    lualine_a = {'mode',
                {
                  texstatus, 
                  cond = function() return (vim.bo.filetype=='tex') end,
                  --color= function(section)
                  --  if vim.b.vimtex ~= nil then
                  --    if texstatus()==3 then
                  --      return { bg="#bf616a" }
                  --    elseif texstatus()==2 then
                  --      return { bg="#a3be8c" }
                  --    end
                  --  else 
                  --    return { bg="grey" }
                  --  end
                  --end
                }, 'searchcount'
                },
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location', { getChars }, { getWords } }
    },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
}

require("bufferline").setup{ options= { separator_style="slant" } }
-- LuaSnip
--
-- Optimized Tab mapping for Native LSP Completion + LuaSnip
vim.keymap.set({ 'i', 's' }, '<Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-n>' -- Navigate down the completion popup menu
  elseif require('luasnip').expand_or_jumpable() then
    return '<Plug>luasnip-expand-or-jump'
  else
    return '<Tab>'
  end
end, { expr = true, silent = true })

vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-p>' -- Navigate up the completion popup menu
  elseif require('luasnip').jumpable(-1) then
    return '<Plug>luasnip-jump-prev'
  else
    return '<S-Tab>'
  end
end, { expr = true, silent = true })

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
vim.opt.completeopt = "menu,menuone,noselect,popup" -- Ensures the menu appears even for a single match and uses the native popup window.
vim.o.autocomplete = true -- Enables the overall completion feature.

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
  callback = function(args)
    local client_id = args.data.client_id
    if not client_id then
      return
    end

    local client = vim.lsp.get_client_by_id(client_id)
    if client and client:supports_method("textDocument/completion") then
      -- Enable native LSP completion for this client + buffer
      vim.lsp.completion.enable(true, client_id, args.buf, {
        autotrigger = true,   -- auto-show menu as you type (recommended)
        -- You can also set { autotrigger = false } and trigger manually with <C-x><C-o>
      })
    end
  end,
})

-- Spelling
vim.opt.spellfile=vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
local words = {}
for word in io.open(vim.fn.stdpath("config") .. "/spell/en.utf-8.add", "r"):lines() do
	table.insert(words, word)
end
-- LSP
require('mason').setup()
require('mason-tool-installer').setup({
  ensure_installed = {
    'stylua',
    'prettier',
    'ltex_plus',
    'texlab',
  },
})
require('mason-lspconfig').setup({
  automatic_enable = true,
})

vim.lsp.config('ltex_plus',{
  settings= {
    ltex={
      filetypes= {'tex','bib', 'markdown'},
      language='en-US',
      dictionary={
        ['en-US']=words,
      },
    },
  },
})
vim.lsp.config('texlab',{
  settings = {
    texlab = {
      -- We let Vimtex handle compilation, so we leave Texlab's builder blank
      build = { executable = '', args = {} }, 
      forwardSearch = { executable = '' },
    },
  },
})
--
-- key_mapper('n','<Leader>n',':NERDTree<CR>')
key_mapper('n','<Leader>t',':NERDTreeToggle<CR>')
key_mapper('n','<Leader>f',':NERDTreeFind<CR>')
key_mapper('n',']b',':BufferLineCycleNext<CR>')
key_mapper('n','b]',':BufferLineCyclePrev<CR>')

vim.api.nvim_create_user_command('Todo', '80vsplit /home/dino/cloud/Dokumente/todo/todo.txt',{})


-- Treesitter
require 'nvim-treesitter.config'.setup {
  highlight = {
    enable = true,
    disable= {'latex',},
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    -- additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  }
}
-- Zen Mode
--

local zenoptions= {
  plugins = {
    alacritty = {
     enabled = true,
     font = '18' 
   },
  },
  window = {
    options = {
      number = false
    }
  }
}
vim.keymap.set('n','<Leader>zen',function() require("zen-mode").toggle(
zenoptions ) end )

