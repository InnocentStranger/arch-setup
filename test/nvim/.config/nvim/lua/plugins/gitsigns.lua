-- lua/plugins/git.lua

return {

  -- ────────────────────────────────────────────────────────────────────
  -- 1. GITSIGNS — gutter indicators, blame, hunk operations
  -- Always-on, attaches to every git buffer automatically
  -- ────────────────────────────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      signs_staged_enable = true,

      -- CRITICAL: lower than LSP diagnostic default (10)
      -- so diagnostics win the inner sign column slot
      sign_priority = 6,

      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,

      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 600,
        -- higher number = beats inlay hints in virtual text priority
        virt_text_priority = 100,
      },
      current_line_blame_formatter = "<author>, <author_time:%d %b %Y> • <summary>",

      on_attach = function(buf)
        local gs = package.loaded.gitsigns

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end

        -- Navigate hunks (works in diff mode too)
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")

        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")

        map("n", "]H", function()
          gs.nav_hunk("last")
        end, "Last Hunk")
        map("n", "[H", function()
          gs.nav_hunk("first")
        end, "First Hunk")

        -- Hunk staging & resetting
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")

        -- Diff current file against index (opens Neovim split diff)
        map("n", "<leader>ghd", gs.diffthis, "Diff This (index)")
        map("n", "<leader>ghD", function()
          gs.diffthis("~")
        end, "Diff This (last commit)")

        -- Preview hunk inline float
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")

        -- Toggle blame line
        map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle Line Blame")

        -- Text object: select hunk with ih in operator/visual mode
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk (text obj)")
      end,
    },
  },

  -- ────────────────────────────────────────────────────────────────────
  -- 2. LAZYGIT.NVIM — full git panel in a float
  -- Requires lazygit binary: https://github.com/jesseduffield/lazygit
  -- Install: brew install lazygit / pacman -S lazygit / etc.
  -- ────────────────────────────────────────────────────────────────────
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gG", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit (current file)" },
    },
  },

  -- ────────────────────────────────────────────────────────────────────
  -- 3. DIFFVIEW — Neovim-native side-by-side diff + file history + conflicts
  -- Using the maintained fork (original stale since Aug 2024)
  -- Drop this block if you're happy doing all diffs inside lazygit
  -- ────────────────────────────────────────────────────────────────────
  {
    "dlyongemallo/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFileHistory",
    },
    keys = {
      {
        "<leader>gd",
        function()
          -- toggle: open if no diffview active, close if one is
          if next(require("diffview.lib").views) == nil then
            vim.cmd("DiffviewOpen")
          else
            vim.cmd("DiffviewClose")
          end
        end,
        desc = "Toggle Diffview",
      },
      { "<leader>gfh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (current)" },
      { "<leader>gFH", "<cmd>DiffviewFileHistory<cr>", desc = "File History (repo)" },
    },
    opts = {
      enhanced_diff_hl = true, -- word-level diff highlighting inside hunks
      use_icons = true,
      view = {
        default = {
          -- side-by-side layout (standard)
          layout = "diff2_horizontal",
          winbar_info = true,
        },
        merge_tool = {
          -- three-way for conflict resolution
          layout = "diff3_mixed",
          disable_diagnostics = true,
        },
      },
    },
  },
}
