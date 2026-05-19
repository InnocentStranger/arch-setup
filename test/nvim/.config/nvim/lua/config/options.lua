-- ========================================================================== --
--                               LEADER KEY                                   --
-- ========================================================================== --
vim.g.mapleader = " "

-- ========================================================================== --
--                                 OPTIONS                                    --
-- ========================================================================== --
-- Line Numbers
vim.o.number = true
vim.o.relativenumber = true

-- Mouse Control
vim.o.mouse = "a"

-- Indentation (Sane defaults, overridden by .editorconfig or tools automatically)
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

-- Search Behavior
vim.o.ignorecase = true
vim.o.smartcase = true

-- copy & paste
vim.keymap.set({ "n", "x" }, "<Leader>y", '"+y', { silent = true }) -- Copy to system clipboard in normal/visual mode
vim.keymap.set({ "n", "x" }, "<Leader>p", '"+p', { silent = true }) -- Paste from system clipboard in normal/visual mode
vim.keymap.set({ "n", "x" }, "<Leader>d", '"+d', { silent = true }) -- Copy to system clipboard in normal/visual mode

-- UI & Windows
vim.o.wrap = false
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.splitright = true
vim.o.splitbelow = true
-- vim.opt.clipboard = "unnamedplus" -- Natively syncs Neovim clipboard with system clipboard

-- Autoread (Updates Neovim if file is changed externally, e.g., git branch swap)
-- vim.o.autoread = true
-- vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
    -- command = "checktime",
-- })

-- ========================================================================== --
--                                KEYMAPS                                     --
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
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>",       { desc = "New tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>",     { desc = "Close tab" })
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<CR>",      { desc = "Close other tabs" })

-- ========================================================================== --
--                           CUSTOM FUNCTIONS                                 --
-- ========================================================================== --
-- Function to copy current diagnostic message to system clipboard
local function copy_diagnostic_to_clipboard()
    local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
    if #diagnostics > 0 then
        local messages = {}
        for _, diagnostic in ipairs(diagnostics) do
            table.insert(messages, diagnostic.message)
        end
        local msg = table.concat(messages, "\n")
        vim.fn.setreg("+", msg)
        print("Diagnostic messages copied to clipboard!")
    else
        print("No diagnostic messages found under the cursor.")
    end
end

-- Map Custom Diagnostic function
vim.keymap.set("n", "<leader>cd", copy_diagnostic_to_clipboard, { silent = true, desc = "Copy Diagnostic to Clipboard" })
