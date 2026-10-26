-- ============================================================================
-- Leader keys
-- Must be set before loading lazy.nvim/plugin specifications.
-- ============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = "'"

-- ============================================================================
-- Basic Neovim behavior
-- ============================================================================

vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

vim.opt.termguicolors = true

vim.opt.mouse = "a"
vim.opt.hidden = true

vim.opt.smartcase = true
vim.opt.incsearch = true

vim.opt.errorbells = false

-- Line numbers / diagnostics
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes"

-- Default behavior for code files.
-- Prose files such as TeX and Markdown override these settings below.
vim.opt.wrap = false
vim.opt.linebreak = false
vim.opt.breakindent = false

-- Indentation defaults: appropriate for Lua, JavaScript, HTML, JSON, etc.
vim.opt.autoindent = true
vim.opt.smartindent = false

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Do not automatically insert hard line breaks.
vim.opt.textwidth = 0

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Folds are enabled, but start open.
-- This lets you selectively fold sections/environments when useful.
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- Do not permanently reserve a column for fold markers.
-- Use "1" instead if you want to always see fold indicators.
vim.opt.foldcolumn = "0"
-- ============================================================================
-- Persistent undo and swap files
-- ============================================================================

local undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undodir, "p")

vim.opt.undodir = undodir
vim.opt.undofile = true

-- Keeping swap files enabled provides useful crash recovery.
-- Store them outside project directories.
local swapdir = vim.fn.stdpath("state") .. "/swap"
vim.fn.mkdir(swapdir, "p")

vim.opt.swapfile = true
vim.opt.directory = swapdir .. "//"

-- If you strongly prefer to disable swap files entirely, use this instead:
-- vim.opt.swapfile = false

-- ============================================================================
-- Disable unused language providers
-- ============================================================================

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- ============================================================================
-- General mappings
-- ============================================================================

-- Disable arrow keys in Normal, Visual, and Operator-pending mode.
-- This does not disable them in Insert mode.
vim.keymap.set({ "n", "v", "o" }, "<Up>", "<Nop>", {
  silent = true,
  desc = "Disable arrow key",
})

vim.keymap.set({ "n", "v", "o" }, "<Down>", "<Nop>", {
  silent = true,
  desc = "Disable arrow key",
})

vim.keymap.set({ "n", "v", "o" }, "<Left>", "<Nop>", {
  silent = true,
  desc = "Disable arrow key",
})

vim.keymap.set({ "n", "v", "o" }, "<Right>", "<Nop>", {
  silent = true,
  desc = "Disable arrow key",
})

-- Do not restore the old <C-t> Insert-mode mapping that inserted ten tabs.
-- Neovim's built-in <C-t> behavior indents the current line and is more useful.

-- ============================================================================
-- Filetype-specific settings
-- ============================================================================

local prose_group = vim.api.nvim_create_augroup("ProseOptions", {
  clear = true,
})

-- Writing-oriented behavior for LaTeX, Markdown, and ordinary text.
vim.api.nvim_create_autocmd("FileType", {
  group = prose_group,
  pattern = {
    "tex",
    "plaintex",
    "bib",
    "markdown",
    "text",
  },
  callback = function()
    -- Wrap visually, but do not insert hard line breaks into the file.
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.textwidth = 0

    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "nc"
    -- Neovim spelling; LTeX+ provides additional grammar/spelling diagnostics.
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en_us" }
    -- Do not automatically continue LaTeX comments, e.g.:
    -- % comment
    -- % cursor here after pressing Enter
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

local indent_group = vim.api.nvim_create_augroup("FiletypeIndentation", {
  clear = true,
})

-- Python conventionally uses four spaces.
vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = "python",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Explicit two-space settings for your other common programming languages.
vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = {
    "lua",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "html",
    "css",
    "json",
    "yaml",
  },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Makefiles require literal tab characters.
vim.api.nvim_create_autocmd("FileType", {
  group = indent_group,
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false
  end,
})

-- ============================================================================
-- Personal commands
-- ============================================================================

local todo_file = vim.fn.expand("~/cloud/Dokumente/todo/todo.txt")

vim.api.nvim_create_user_command("Todo", function()
  vim.cmd("80vsplit " .. vim.fn.fnameescape(todo_file))
end, {
  desc = "Open todo file in a vertical split",
})

-- ============================================================================
-- Fold remembering
-- ============================================================================
local view_group = vim.api.nvim_create_augroup("RememberViews", {
  clear = true,
})

vim.api.nvim_create_autocmd("BufWinLeave", {
  group = view_group,
  pattern = { "*.tex", "*.bib", "*.md", "*.markdown" },
  callback = function()
    if vim.bo.buftype == "" then
      vim.cmd("silent! mkview")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = view_group,
  pattern = { "*.tex", "*.bib", "*.md", "*.markdown" },
  callback = function()
    if vim.bo.buftype == "" then
      vim.cmd("silent! loadview")
    end
  end,
})
-- ============================================================================
-- Plugin loading
-- ============================================================================

require("config.lazy")
