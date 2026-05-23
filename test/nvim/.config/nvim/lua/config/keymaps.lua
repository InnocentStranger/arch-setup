-- ========================================================================== --
-- KEYMAPS                                                                    --
-- ========================================================================== --

-- Split Windows Manually
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Move Lines Up/Down (Ctrl + Alt + j/k)
vim.keymap.set("n", "<C-A-j>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
vim.keymap.set("n", "<C-A-k>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
vim.keymap.set("x", "<C-A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
vim.keymap.set("x", "<C-A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- Tab creation
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "Close other tabs" })

-- copy & paste
vim.keymap.set({ "n", "x" }, "<Leader>y", '"+y', { silent = true }) -- Copy to system clipboard in normal/visual mode
vim.keymap.set({ "n", "x" }, "<Leader>p", '"+p', { silent = true }) -- Paste from system clipboard in normal/visual mode
vim.keymap.set({ "n", "x" }, "<Leader>d", '"+d', { silent = true }) -- Copy to system clipboard in normal/visual mode

-- Normal mode: <leader>/ triggers gcc (Line comment)
vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle Comment Line" })

-- Visual mode: <leader>/ triggers gc (Selection comment)
vim.keymap.set("v", "<leader>/", "gc", { remap = true, desc = "Toggle Comment Selection" })

-- Command-line menu navigation (C-j,k overridden by blink.nvim)
-- vim.keymap.set("c", "<C-j>", "<C-n>", { desc = "Command line next item/history" })
-- vim.keymap.set("c", "<C-k>", "<C-p>", { desc = "Command line prev item/history" })
