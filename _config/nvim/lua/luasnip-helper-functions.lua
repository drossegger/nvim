local line_begin = require("luasnip.extras.expand_conditions").line_begin
-- Summary: When `SELECT_RAW` is populated with a visual selection, the function
-- returns an insert node whose initial text is set to the visual selection.
-- When `SELECT_RAW` is empty, the function simply returns an empty insert node.
local M = {} 

local ls=require("luasnip")
local sn=ls.snippet_node
local i=ls.insert_node

function M.get_visual(args, parent)
  if (#parent.snippet.env.SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else  -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end
function M.is_first_line()
  local line_number = vim.fn['line']('.')
  if (line_number == 1) then
    return true
  else
    return false
  end
end


function M.tex_in_mathzone()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

function M.tex_in_text()
  return not M.tex_in_mathzone()
end
function M.tex_in_comment()  -- comment detection
  return vim.fn['vimtex#syntax#in_comment']() == 1
end
function M.tex_in_env(name)  -- generic environment detection
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end
-- A few concrete environments---adapt as needed
function M.tex_in_equation()  -- equation environment detection
    return M.tex_in_env('equation')
end
function M.tex_in_itemize()  -- itemize environment detection
    return M.tex_in_env('itemize')
end
function M.tex_in_tikz()  -- TikZ picture environment detection
    return M.tex_in_env('tikzpicture')
end 
--M["tex_utils"]=tex_utils
return M
