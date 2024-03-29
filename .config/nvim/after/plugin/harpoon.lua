local mark = require('harpoon.mark')
local ui = require('harpoon.ui')
local cmd_ui = require('harpoon.cmd-ui')
local term = require('harpoon.term')

vim.keymap.set('n', '<leader>a', mark.add_file)
vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu)

vim.keymap.set('n', '<C-h>', function() ui.nav_file(1) end)
vim.keymap.set('n', '<C-t>', function() ui.nav_file(2) end)
vim.keymap.set('n', '<C-n>', function() ui.nav_file(3) end)
vim.keymap.set('n', '<C-s>', function() ui.nav_file(4) end)

vim.keymap.set('n', '<leader>c', cmd_ui.toggle_quick_menu)
vim.keymap.set('n', '<leader>gt1', function() term.gotoTerminal(1) end)
vim.keymap.set('n', '<leader>br', function() term.sendCommand(1, 'build_ros') end)
