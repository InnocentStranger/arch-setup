return {
    "numToStr/Comment.nvim",
    event = "InsertEnter",
    config = function()
        require('Comment').setup()
        -- In your init.lua or keybindings.lua
        vim.api.nvim_set_keymap('n', '<leader>/', 'gcc', { noremap = false, silent = true })  -- Single-line comment
        vim.api.nvim_set_keymap('n', 'cb', 'gbc', { noremap = false, silent = true })  -- Block comment

        vim.api.nvim_set_keymap('v', '<leader>/', 'gcc', { noremap = false, silent = true })  -- Single-line comment
        vim.api.nvim_set_keymap('v', 'cb', 'gbc', { noremap = false, silent = true })  -- Block comment
    end
}

