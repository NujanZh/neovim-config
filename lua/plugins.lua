vim.pack.add({
    { src = "https://github.com/mason-org/mason.nvim" },
})

require("mason").setup({})

vim.pack.add({
    { src = "https://github.com/sainnhe/everforest" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/cbochs/grapple.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/mfussenegger/nvim-dap" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

vim.o.background = 'dark'
vim.g.everforest_background = 'medium'
vim.g.everforest_transparent_background = 2
vim.g.everforest_float_style = 'blend'
vim.cmd.colorscheme('everforest')

local fzf = require('fzf-lua')
fzf.setup({
    fzf_colors = true,
})

vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Find project files' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Search project text' })
vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Find open buffers' })
vim.keymap.set('n', '<leader>fr', fzf.resume, { desc = 'Resume last search' })

local grapple = require('grapple')
grapple.setup({
    scope = 'git',
    icons = false,
    status = false,
})

vim.keymap.set('n', '<leader>ha', grapple.toggle, { desc = 'Toggle file tag' })
vim.keymap.set('n', '<leader>hm', grapple.toggle_tags, { desc = 'Open tagged files' })

for index = 1, 4 do
    vim.keymap.set('n', '<leader>h' .. index, function()
        grapple.select({ index = index })
    end, { desc = 'Open tagged file ' .. index })
end

require('oil').setup({
    columns = {},
})

vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })
