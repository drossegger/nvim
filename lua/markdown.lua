local execute = vim.api.nvim_command
function open_pdf()
  execute('!mupdf '..vim.fn.expand('%<')..'.pdf &\\!')
end

local key_mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    {noremap = true, silent = true}
  )
end


function  create_keymaps()
  key_mapper('n','<LocalLeader>lv',':lua open_pdf()<CR><CR>')
 
end
