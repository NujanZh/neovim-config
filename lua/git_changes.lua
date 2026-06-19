require('gitsigns').setup({
    current_line_blame = false,
    on_attach = function(bufnr)
        local gitsigns = require('gitsigns')
        local function map(lhs, rhs, desc)
            vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map(']h', function()
            gitsigns.nav_hunk('next')
        end, 'Next Git hunk')
        map('[h', function()
            gitsigns.nav_hunk('prev')
        end, 'Previous Git hunk')
        map('<leader>gp', gitsigns.preview_hunk, 'Preview Git hunk')
        map('<leader>gs', gitsigns.stage_hunk, 'Stage or unstage Git hunk')
        map('<leader>gb', function()
            gitsigns.blame_line({ full = true })
        end, 'Blame current line')
    end,
})
