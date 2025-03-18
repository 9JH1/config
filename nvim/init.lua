-- setup plugins
require("config.lazy")
require('lualine').setup{
	options={
		theme="gruvbox_dark"
	}
}

require("telescope").setup({

})
require('gitsigns').setup()

require('nvim-tree').setup{
	view = {
 	side="right"
	},
}
vim.notify = require("notify")
require("notify").setup{
	background = "#ff0000"
}
wilder = require("wilder")
 wilder.set_option('renderer', wilder.popupmenu_renderer({
  pumblend = 20,
}))
vim.api.nvim_create_autocmd("BufEnter", {
nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
      vim.cmd "quit"
    end
  end
})

-- set defaults
vim.cmd([[colorscheme gruvbox]])
vim.cmd("call wilder#setup({'modes': [':', '/', '?']})")


-- set vim config
vim.o.background = "dark" -- or "light" for light mode
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.guicursor= "n-v-c-i:block"
vim.opt.syntax = "on"
vim.opt.rnu = true
vim.opt.mouse = "a"
vim.opt.nu = true
vim.opt.wrap = false
vim.opt.numberwidth = 1
vim.opt.foldmethod = "syntax"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.swapfile = false
vim.opt.shortmess:append("I")
vim.opt.autoread = true
vim.opt.foldlevel = 999

-- Key mappings
vim.api.nvim_set_keymap('i', '<C-f>', '<C-O>:normal! za<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>', ':normal! za<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<Esc>[Z', '<Esc>:normal! gT<CR>i', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Esc>[Z', ':normal! gT<CR>', { noremap = true, silent = true })

-- Enable filetype detection and plugins
vim.cmd([[
  filetype plugin on
  filetype indent on
]])

-- Custom fold text function
function MyFoldText()
	local fold_start = vim.v.foldstart
    local fold_end = vim.v.foldend
    local fold_line_count = fold_end - fold_start + 1
    local first_line = "+< " .. vim.fn.getline(vim.v.foldstart) .. " "
		local last_line = " [ " .. fold_line_count .. " Lines ] "
    local spaces = string.rep(' ', vim.o.columns - string.len(first_line)-7-string.len(last_line))
    return first_line .. ' ' .. spaces .. last_line
end

-- set fold 
vim.opt.foldtext = "v:lua.MyFoldText()"

-- vim.keymap.del('i', '<C-r>')
vim.api.nvim_set_keymap('n', '<C-s>', ':NvimTreeToggle<CR>', {noremap = true,silent = true })
vim.api.nvim_set_keymap('n', '<C-a>', ':tabprev<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-d>', ':tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-t>', ':tabnew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-w>', ':tabclose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-S-c>', ':tabnew | :tabprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-g>',':Telescope colorscheme enable_preview=true<CR>',{noremap=true,silent=true})

vim.cmd([[
  augroup TabHistory
    autocmd!
    autocmd BufDelete * if tabpagenr('$') > 1 | tabnew | endif
  augroup END
]])

-- activate the cursor option
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

vim.cmd("NvimTreeOpen")

