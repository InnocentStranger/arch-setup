-- lua/plugins/git/diffview.lua
--
-- ─── WHY diffview.nvim ────────────────────────────────────────────────────────
--
-- gitsigns.nvim is for line-by-line editor feedback.
-- diffview.nvim is for massive, repository-wide tasks:
--   1. Reviewing an entire branch before a PR.
--   2. Resolving complex 3-way merge conflicts.
--   3. Tracing the commit history of a single file across time.
--
-- ─── THE 2026 FORK CONTEXT ────────────────────────────────────────────────────
--
-- The original `sindrets/diffview.nvim` is unmaintained. We use the active
-- `dlyongemallo/diffview.nvim` fork, which fixes Neovim 0.10+ deprecations
-- but uses the exact same API.

return {
  "dlyongemallo/diffview.nvim",
  dependencies = { "nvim-mini/mini.icons" },

  -- Lazy-load only when you type a command or press a keymap.
  -- This keeps your startup time at 0ms.
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewFileHistory",
  },

  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview: Open Git Diff" },
    { "<leader>gx", "<cmd>DiffviewClose<CR>", desc = "Diffview: Close" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "Diffview: Current File History" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview: Branch History" },
  },

  opts = {
    -- ── UI Polish ───────────────────────────────────────────────────────────
    enhanced_diff_hl = true, -- Use modern, smoother highlighting for diffs
    use_icons = true,
    show_help_hints = false, -- Disables the noisy hints at the bottom of the screen

    -- ── The Merge Tool ──────────────────────────────────────────────────────
    -- Diffview is the best merge conflict resolution tool in Neovim.
    view = {
      merge_tool = {
        -- 'diff3_mixed' gives you the target branch, the incoming branch,
        -- and a bottom window showing the resolved result.
        layout = "diff3_mixed",
        -- Hide LSP errors while resolving conflicts (the code is technically
        -- broken during a conflict, so the LSP will just scream at you).
        disable_diagnostics = true,
      },
    },

    -- ── File Panel Config ───────────────────────────────────────────────────
    file_panel = {
      listing_style = "tree", -- Groups files by folder instead of a flat list
      win_config = {
        position = "left",
        width = 35,
      },
    },

    -- ── Default Keymaps Note ────────────────────────────────────────────────
    -- We leave the keymaps table empty because the plugin's defaults are
    -- universally considered perfect. When inside the Diffview UI:
    --   [c and ]c  -> jump between changes
    --   <cr>       -> open the file under cursor
    --   s          -> stage / unstage the highlighted file
    --   g?         -> open a cheat sheet of all commands
    keymaps = {
      disable_defaults = false,
    },
  },

  config = function(_, opts)
    require("diffview").setup(opts)

    -- ── The 2026 Visual Standard for Diffs ──────────────────────────────────
    -- By default, Neovim paints deleted lines as giant solid blocks of color.
    -- This modern trick replaces deleted lines with a sleek diagonal hatch
    -- pattern (╱), making diffs significantly easier on the eyes.
    vim.opt.fillchars:append({ diff = "╱" })
  end,
}
