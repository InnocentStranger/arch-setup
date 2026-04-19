-- Leader Key
vim.g.mapleader = " "

-- Show Numbers
vim.o.relativenumber = true
vim.o.number = true

-- Indentation
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.autoindent = true

-- WordWrap
vim.o.wrap = true

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.cursorline = true

vim.o.termguicolors = true
vim.o.background = "dark"
vim.o.signcolumn = "yes" -- Fixed Sign Column, helps in maintaining indentation during warning or errors symbols

vim.o.backspace = "indent,eol,start"

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	command = "checktime",
})

-- Keybinds

vim.keymap.set({ "n", "x" }, "<Leader>y", '"+y', { silent = true }) -- Copy to system clipboard in normal/visual mode
vim.keymap.set({ "n", "x" }, "<Leader>p", '"+p', { silent = true }) -- Paste from system clipboard in normal/visual mode
vim.keymap.set({ "n", "x" }, "<Leader>d", '"+d', { silent = true }) -- Copy to system clipboard in normal/visual mode
-- Move lines up, down in normal & visual mode
vim.keymap.set("n", "<C-A-k>", ":m .-2<CR>==", { silent = true })
vim.keymap.set("n", "<C-A-j>", ":m .+1<CR>==", { silent = true })
vim.keymap.set("x", "<C-A-k>", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("x", "<C-A-j>", ":m '>+1<CR>gv=gv", { silent = true })

-- Function to copy diagnostic message to clipboard
local function copy_diagnostic_to_clipboard()
	-- Get the current diagnostic at the cursor position
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if #diagnostics > 0 then
		-- Create an empty table to store all the diagnostic messages
		local messages = {}

		-- Loop through all diagnostics and collect the messages
		for _, diagnostic in ipairs(diagnostics) do
			table.insert(messages, diagnostic.message)
		end

		-- Join all messages into a single string with a newline separator
		local msg = table.concat(messages, "\n")

		-- Copy it to the clipboard using the '+' register
		vim.fn.setreg("+", msg)

		-- Provide feedback to the user
		print("Diagnostic messages copied to clipboard!")
	else
		print("No diagnostic messages found under the cursor.")
	end
end

-- Create a custom command to copy the diagnostic message
vim.api.nvim_create_user_command("CopyDiagnostic", copy_diagnostic_to_clipboard, {})

-- Map a key to trigger the CopyDiagnostic command
vim.api.nvim_set_keymap("n", "<leader>cd", ":CopyDiagnostic<CR>", { noremap = true, silent = true })
