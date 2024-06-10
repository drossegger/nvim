local helpers = require('luasnip-helper-functions')

local snippets = {
  s({trig='tikz'},
    fmta(
      [[
      \begin{tikzpicture}
      <>
      \end{tikzpicture}
      ]],
      { 
        i(0) 
      }
      ),
    { condition = line_begin }
  ),
  s({trig='fd', snippetType='autosnippet'},
    fmta(
      [[
      \filldraw[<>] 
      ]],
      {
        i(1,'params'),
      }
    ),
    { condition = helpers.tex_in_tikz }
  ),
  s({trig='dd', snippetType='autosnippet'},
    fmta(
      [[
      \draw[<>] 
      ]],
      {
        i(1,'params'),
      }
    ),
    { condition = helpers.tex_in_tikz }
  ),
}
return snippets
