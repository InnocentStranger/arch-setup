-- lua/plugins/git/lazygit.lua
--
-- lazygit.nvim — A seamless bridge between Neovim and the LazyGit terminal UI.
-- Allows you to manage commits, rebase, and stash without ever leaving your editor.

return {
  "kdheepak/lazygit.nvim",
  -- Load only when you actually trigger the command or press the keymap
  lazy = true,
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Plugs directly into your existing Telescope setup
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    -- Safely load the telescope extension so you can search your git repos
    -- using `:Telescope lazygit`
    local ok, telescope = pcall(require, "telescope")
    if ok then
      telescope.load_extension("lazygit")
    end

    -- Optional: If you want to change the floating window transparency
    -- vim.g.lazygit_floating_window_winblend = 0
  end,
  keys = {
    -- The standard 2026 keymap for opening the Git interface
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit: Open GUI" },

    -- Very useful: Opens LazyGit filtered to show ONLY the commit history
    -- of the exact file you are currently looking at.
    { "<leader>gf", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit: File History" },
  },
}
