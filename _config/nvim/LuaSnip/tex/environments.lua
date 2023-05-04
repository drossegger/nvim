local line_begin = require("luasnip.extras.expand_conditions").line_begin
-- Summary: When `SELECT_RAW` is populated with a visual selection, the function
-- returns an insert node whose initial text is set to the visual selection.
-- When `SELECT_RAW` is empty, the function simply returns an empty insert node.

local get_visual = function(args, parent)
  if (#parent.snippet.env.SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else  -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end
local in_mathzone = function()
  -- The `in_mathzone` function requires the VimTeX plugin
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
local is_first_line =function()
  local line_number = vim.fn['line']('.')
  if (line_number == 1) then
    return true
  else
    return false
  end
end
local populate_authors = function(args, parent)
  local authors = {} 
  -- if args[0] == nil then
  --   return ""
  -- end
  for author in string.gmatch(args[1][1],'[^,]+') do 
    table.insert(authors, "\\author{".. string.gsub(author,"^%s+","") .."}")
  end
  return authors 
end
  
local snippets = {
  s({trig="question", snippetType="autosnippet"},
    fmta(
      [[
      \begin{question}\label{ques:<>}
        <>
      \end{question}
      ]],
      {
        i(1),
        i(0),
      }
      ),
    { condition = line_begin }
    ),
  s({trig="env",snippetType="autosnippet"},
    fmta(
      [[
      \begin{<>}\label{<>}
          <>
      \end{<>}
      ]],
      {
        i(1),
        i(2),
        i(0),
        rep(1),
      }
      )
    ),
  s({trig="emph"},
    fmta(
      [[
      \emph{<>}
      ]],
      {
        d(1,get_visual),
      }
      )
    ),
  s({trig="nca"},
    fmta(
      [[
        \newcommand{<>}[<>]{<>}
      ]],
      { 
        i(1),
        i(2,"arg"),
        i(3)
      }
      ),
    { condition= line_begin }
    ),
   s({trig="nc"},
    fmta(
      [[
        \newcommand{<>}{<>}
      ]],
      { 
        i(1),
        i(2),
      }
      ),
    { condition= line_begin }
    ),
  s({trig="preamble",snippetType="autosnippet", descr="Insert basic preamble"},
    fmta(
      [[
          \documentclass{amsart}
          \usepackage[draft]{dino}
          \title{<>}
          % <>
          <>
          
          %%BIBLIOGRAPHY
          \addbibresource{mybib.bib}
          %%AUTHOR Adresses, in alphabetic order
          
          \address{Department of Mathematics, University of California, Berkeley {\normalfont and} Institute of Discrete Mathematics and Geometry, Technische Universit\"at Wien}
          \email{dino@math.berkeley.edu}
          
          
          %%%
          %TODO: update funding information
          %TODO: UPDATE subjclass (03C57,03D45)
          \subjclass{}
          \thanks{The work of Rossegger was supported by the European Union's Horizon 2020 Research and Innovation Programme under the Marie Sk\l{}odowska-Curie grant agreement No. 101026834 — ACOSE}
          \begin{document}
          \maketitle
          %\begin{abstract}
          %\end{abstract}
          <>
          \printbibliography
          \end{document}

      ]],
      {
        i(1),
        i(2,"authors comma separated"),
        f(populate_authors,{2}),
        i(0),
      }
      ),
      {condition=is_first_line}
      ),
      s({ trig="cbgreen" },
        fmta( 
          [[ 
            \colorbox{cyan}{<>}
          ]],
          { i(1) })
      ),
    s({trig="proof",snippetType="autosnippet" },
      fmta(
        [[
        \begin{proof}
        <>
        \end{proof}
        ]],
        {
          i(0)
        }),
      { condition= line_begin }
      ),
    s({ trig="wlog", snippetType="autosnippet" },
      { t("without loss of generality"), }
      ),
}

local mathhighlight = { [ "mf" ]="mathfrak", [ "mbf" ]="mathbf", [ "mbb" ]="mathbb" }
for short,long in pairs(mathhighlight) do 
  table.insert(snippets,
    s({ trig=short , snippetType="autosnippet" },
      {
        t("\\"..long.."{"),
        i(1),
        t("}")
      },
      { condition=in_mathzone }
      ))
end


return snippets
