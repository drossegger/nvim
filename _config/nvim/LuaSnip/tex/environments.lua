local helpers = require('luasnip-helper-functions')
local get_visual=helpers.get_visual
local in_mathzone=helpers.tex_in_mathzone
local is_first_line=helpers.is_first_line
local line_begin=require("luasnip.extras.expand_conditions").line_begin

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
  s({ trig="sec" },
    fmta(
      [[
      \section{<>}\label{sec:<>}
      ]],
      { i(1),
        i(2),
      }),
    { condition = line_begin }
    ),
  s({ trig="sub" },
    fmta(
      [[
      \subsection{<>}\label{subsec:<>}
      ]],
      { i(1),
        i(2),
      }),
    { condition= line_begin }
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
      ),
      {condition = line_begin }
    ),
    s({trig="enum"},
    fmta(
      [[
      \begin{enumerate}
        \tightlist
        \item <>
      \end{enumerate}
      ]],
      {
        i(0),
      }
      ),
      { condition = line_begin }
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
  s({trig="def"},
    fmta(
      [[
      \define{<>}
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
          
          \address{Institute of Discrete Mathematics and Geometry, Technische Universit\"at Wien}
          \email{dino.rossegger@tuwien.ac.at}
          
          
          %%%
          %TODO: update funding information
          %TODO: UPDATE subjclass (03C57,03D45)
          \subjclass{}
          \thanks{}
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

local mathhighlight = { [ "mf" ]="mathfrak", [ "mbf" ]="mathbf", [ "mbb" ]="mathbb", [ "mrm" ]="mathrm", [ "unl" ] = "underline", [ "ovl" ] = "overline" }
for short,long in pairs(mathhighlight) do 
  table.insert(snippets,
    s({ trig=short , snippetType="autosnippet" },
      {
        t("\\"..long.."{"),
        i(1),
        t("}")
      },
      { condition = in_mathzone}
      ))
  table.insert(snippets,
    s({ trig=long },
      {
        t("\\"..long.."{"),
        d(1,get_visual),
        t("}")
      },
      { condition = in_mathzone}
      ))
end


table.insert(snippets,
  s({trig="%^%-1",snippetType="autosnippet",regTrig=true,wordTrig=false},{t("^{-1}")}))

return snippets
