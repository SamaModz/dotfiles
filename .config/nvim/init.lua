require('core.options')
require('core.keymaps')
require('core.autocmds')
require('core.plugins')


vim.cmd('silent !mkdir -p ' .. vim.fn.shellescape(vim.fn.expand('%:p:h'), 1))
vim.cmd('edit ' .. vim.fn.expand('%'))
