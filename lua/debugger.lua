local dap = require('dap')

dap.adapters.codelldb = {
    type = 'executable',
    command = 'codelldb',
}

dap.configurations.cpp = {
    {
        name = 'Launch executable',
        type = 'codelldb',
        request = 'launch',
        program = function()
            local path = vim.fn.input('Executable: ', vim.fn.getcwd() .. '/', 'file')
            if path == '' then
                return dap.ABORT
            end
            return path
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
}

dap.configurations.c = dap.configurations.cpp

vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Start or continue debugging' })
vim.keymap.set('n', '<leader>dn', dap.step_over, { desc = 'Debug step over' })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug step into' })
vim.keymap.set('n', '<leader>do', dap.step_out, { desc = 'Debug step out' })
vim.keymap.set('n', '<leader>dr', dap.repl.toggle, { desc = 'Toggle debug REPL' })
vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'Terminate debugging' })
