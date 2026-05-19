-- lua/plugins/telescope.lua
--
-- ─── VERSION ─────────────────────────────────────────────────────────────────
--
--   version = "*"   ← use this. Pins to the latest GitHub release tag.
--   NOT branch = "master"  — not recommended for production configs.
--
-- ─── HOW fd AND rg HANDLE IGNORING (NO CONFIG NEEDED) ────────────────────────
--
-- fd (find_files):
--   ✓ Respects .gitignore automatically
--   ✓ Respects .ignore and .fdignore files
--   ✓ Skips .git/ directory natively
--   ✗ Does NOT show hidden files (dotfiles) by default → pass --hidden to include them
--
-- rg (live_grep / grep_string):
--   ✓ Respects .gitignore automatically
--   ✓ Respects .ignore and .rgignore files
--   ✓ Skips binary files natively
--   ✗ Does NOT search hidden files by default → pass --hidden to include them
--
-- WHAT THIS MEANS:
--   node_modules/, .venv/, dist/, build/ — ignored IF they are in .gitignore
--   (they almost always are). You do NOT need file_ignore_patterns for them.
--   file_ignore_patterns is a slow Lua-level filter that runs AFTER fd/rg already
--   filtered. Only use it for edge cases where gitignore can't help.
--
-- THE ONLY REAL DECISION: do you want hidden files (dotfiles) shown?
--   find_files:  add hidden = true  to show .env, .github/, etc.
--   live_grep:   add --hidden flag   to grep inside dotfiles
--   Default is NO — which is usually what you want.
--
-- ─── SYSTEM REQUIREMENTS ─────────────────────────────────────────────────────
--   ripgrep (rg)  → live_grep, grep_string        (pacman -S ripgrep)
--   fd            → find_files (faster than find)  (pacman -S fd)
--   gcc / make    → telescope-fzf-native C build   (pacman -S base-devel)
--                   NOTE: you do NOT need the fzf CLI tool itself.
--                   telescope-fzf-native compiles its own C sorter via `make`.
--   bat (optional)→ syntax-highlighted file previews (pacman -S bat)
--
-- ─── LSP KEYBINDS: WHERE THEY LIVE ───────────────────────────────────────────
--
-- There are two kinds of LSP-related telescope pickers:
--
--   1. NAVIGATION OVERRIDES: gd, gr, gI, gy
--      These override vim's default motions (e.g. gd = go to local definition).
--      They should only be active when an LSP server is attached to the buffer.
--      → These belong in LspAttach in lsp.lua, NOT here.
--        They just happen to call telescope.builtin.lsp_* instead of vim.lsp.buf.*
--
--   2. DELIBERATE PICKER ACTIONS: <leader>fs, <leader>fd, <leader>fD, <leader>fS
--      These are intentional "open a picker" keymaps, not motion overrides.
--      They live here because they are telescope actions the user explicitly invokes.
--      (They silently fail / show empty results if no LSP is attached — acceptable.)
--
-- ─── telescope-ui-select ─────────────────────────────────────────────────────
--
-- vim.ui.select() is a built-in Neovim API that plugins call when they need
-- the user to pick one item from a list. The default implementation is an
-- ugly numbered prompt in the command line:
--
--   Select one of:
--   1: Add missing import
--   2: Fix spelling
--   Type number and <Enter> (q cancels):
--
-- telescope-ui-select replaces that default with a proper telescope picker —
-- fuzzy-searchable, same UI as everything else. It affects EVERY plugin that
-- uses vim.ui.select(), including:
--   • LSP code actions  (<leader>ca)
--   • vim.lsp.buf.rename() confirmations
--   • Any plugin that uses the API (conform.nvim action menus, etc.)
--
-- No extra keymaps needed. Loading the extension is all it takes.
--
-- ─── TELESCOPE DEFAULT VALUES (not repeated in config below) ─────────────────
--   layout_strategy  = "horizontal"   ← already the default, not set below
--   winblend         = 0              ← already the default, not set below
--   file_ignore_patterns = {}         ← already empty, not set below
--   border           = {}             ← NOT a boolean; never set border = true

local function b(picker, opts)
  return function()
    require("telescope.builtin")[picker](opts or {})
  end
end


return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",              -- latest release tag (NOT branch = "0.1.x", that's obsolete)
    lazy    = true,
    cmd     = "Telescope",

    dependencies = {
      "nvim-lua/plenary.nvim",

      -- telescope-fzf-native: C-compiled fzf sorting algorithm.
      -- Requires gcc + make (pacman -S base-devel).
      -- Does NOT require the fzf CLI tool to be installed.
      -- build = "make" compiles the .so on first install.
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond  = function() return vim.fn.executable("make") == 1 end,
      },

      -- telescope-ui-select: replaces vim.ui.select() with a telescope picker.
      -- Affects code actions, rename prompts, and any plugin using vim.ui.select().
      -- No keymaps needed — registering the extension is enough.
      "nvim-telescope/telescope-ui-select.nvim",
    },

    keys = {
      -- ── Files ─────────────────────────────────────────────────────────────────
      -- Normal files (respects .gitignore — the common case)
      { "<leader>ff", b("find_files"),                                    desc = "Find files" },
      -- Include hidden dotfiles (.env, .github/, .eslintrc, etc.)
      { "<leader>fF", b("find_files", { hidden = true }),                 desc = "Find files (+ hidden)" },
      -- Ignore gitignore entirely — find EVERYTHING (slow on big repos)
      { "<leader>fa", b("find_files", { hidden = true, no_ignore = true }), desc = "Find ALL files" },
      -- Recent files (mru)
      { "<leader>fr", b("oldfiles"),                                      desc = "Recent files" },

      -- ── Search / Grep ──────────────────────────────────────────────────────────
      -- Full horizontal layout — grep needs space to show results and preview
      { "<leader>fg", b("live_grep"),                                                                              desc = "Live grep" },
      { "<leader>fG", b("live_grep", { additional_args = { "--hidden" } }),                                        desc = "Live grep (+ hidden)" },
      { "<leader>fw", b("grep_string"),                                                                            desc = "Grep word under cursor" },
      { "<leader>fw", b("grep_string"),                          mode = "v",                                       desc = "Grep selection" },
      { "<leader>f/", b("current_buffer_fuzzy_find"),                                                             desc = "Grep in buffer" },

      -- ── Buffers ────────────────────────────────────────────────────────────────
      { "<leader>fb", b("buffers", { sort_mru = true, sort_lastused = true }), desc = "Buffers" },
      -- Quick buffer switch (like Ctrl+Tab in VSCode)
      { "<leader><leader>", b("buffers", { sort_mru = true }),            desc = "Switch buffer" },

      -- ── LSP pickers (deliberate actions, NOT motion overrides) ────────────────
      -- These are "open a picker" keymaps that the user explicitly invokes.
      -- gd / gr / gI / gy are NOT here — those override vim defaults and must
      -- only activate when LSP is attached. Set them in LspAttach in lsp.lua.
      { "<leader>fs", b("lsp_document_symbols"),                                                                   desc = "Document symbols" },
      { "<leader>fS", b("lsp_workspace_symbols"),                                                                  desc = "Workspace symbols" },
      { "<leader>fd", b("diagnostics", { bufnr = 0 }),                                                            desc = "Buffer diagnostics" },
      { "<leader>fD", b("diagnostics"),                                                                            desc = "All diagnostics" },

      -- ── Git ────────────────────────────────────────────────────────────────────
      -- { "<leader>gs", b("git_status"),                                                                             desc = "Git status" },
      -- { "<leader>gc", b("git_commits"),                                                                            desc = "Git commits" },
      -- { "<leader>gC", b("git_bcommits"),                                                                           desc = "Git commits (buffer)" },
      -- { "<leader>gb", b("git_branches"),                                                                           desc = "Git branches" },
      -- { "<leader>gS", b("git_stash"),                                                                              desc = "Git stash" },
      -- { "<leader>gf", b("git_files"),                                                                              desc = "Git-tracked files" },

      -- ── Vim / Neovim internals ─────────────────────────────────────────────────
      -- Compact dropdown for short lists that don't need preview
      { "<leader>fc", b("commands"),                                                                               desc = "Commands (palette)" },
      { "<leader>fk", b("keymaps"),                                                                                desc = "Keymaps" },
      { "<leader>fh", b("help_tags"),                                                                              desc = "Help tags" },
      { "<leader>fm", b("man_pages"),                                                                              desc = "Man pages" },
      { "<leader>fo", b("vim_options"),                                                                            desc = "Vim options" },
      { "<leader>fA", b("autocommands"),                                                                           desc = "Autocommands" },
      { "<leader>fH", b("highlights"),                                                                             desc = "Highlight groups" },
      { "<leader>\"",  b("registers"),                                                                             desc = "Registers" },
      { "<leader>fj", b("jumplist"),                                                                               desc = "Jump list" },
      { "<leader>fq", b("quickfix"),                                                                               desc = "Quickfix list" },
      { "<leader>fl", b("loclist"),                                                                                desc = "Location list" },
      -- Spell suggest as compact dropdown — no preview needed for a word list
      { "z=",         b("spell_suggest"),                                     desc = "Spell suggest" },
      -- Resume the last picker exactly where you left it — use this constantly
      { "<leader>fp", "<cmd>Telescope resume<CR>",                                                                 desc = "Resume last picker" },
      -- Treesitter symbols — works without LSP, useful as a fallback
      { "<leader>ft", b("treesitter"),                                                                             desc = "Treesitter symbols" },

      -- ── Colorscheme ────────────────────────────────────────────────────────────
      -- Full picker with preview — the whole point is seeing the theme live
      { "<leader>fC", b("colorscheme", { enable_preview = true }),                                                 desc = "Colorschemes" },
    },

    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          -- ── Layout ─────────────────────────────────────────────────────────────
          -- Prompt at the top, results grow downward (more VSCode-like).
          -- sorting_strategy = "ascending" must match prompt_position = "top".
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width   = 0.5,
            },
            width  = 0.9,
            height = 0.85,
          },
          sorting_strategy = "ascending",


          -- ── Path display ───────────────────────────────────────────────────────
          -- "truncate" shows the full path but cuts from the left when narrow.
          -- Alternatives: "smart" (unique suffix only), "filename_first"
          path_display = { "truncate" },

          -- ── rg args for live_grep / grep_string ───────────────────────────────
          -- These are close to telescope's defaults — listed here for visibility.
          -- Uncomment --hidden to grep inside dotfiles by default (or use <leader>fG).
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            -- "--hidden",        -- uncomment to grep dotfiles by default
            -- "--glob", "!.git", -- only needed alongside --hidden above
          },

          -- ── Keymaps inside the picker ──────────────────────────────────────────
          mappings = {
            i = {
              -- Vim-style navigation in the results list
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              -- History navigation
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              -- Send only Tab-selected items to quickfix (intentional, not all results)
              -- Use <Tab> to mark items first, then <C-q>
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              -- Send ALL results to quickfix (no selection needed)
              ["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
              -- Open in splits / new tab
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              -- Close picker
              ["<Esc>"] = actions.close,
              -- Scroll the preview pane while staying in the prompt
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-u>"] = actions.preview_scrolling_up,
              -- Show all available keymaps for the current picker
              ["<C-h>"] = "which_key",
            },
            n = {
              ["q"]     = actions.close,
              ["<Esc>"] = actions.close,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },

        -- ── Per-picker overrides ────────────────────────────────────────────────
        pickers = {
          find_files = {
            -- fd is faster than rg or find for file discovery.
            -- nil = telescope auto-selects rg or find as fallback.
            -- No --hidden here: dotfiles excluded by default (use <leader>fF to include).
            -- No --exclude .git: already excluded by gitignore.
            find_command = vim.fn.executable("fd") == 1
              and { "fd", "--type", "f", "--color", "never" }
              or  nil,
          },

          lsp_references  = { show_line = false },
          lsp_definitions = { show_line = false },

          buffers = {
            sort_mru      = true,
            sort_lastused = true,
            mappings = {
              -- Delete a buffer directly from the picker without opening it
              i = { ["<C-d>"] = actions.delete_buffer },
              n = { ["d"]     = actions.delete_buffer },
            },
          },

          colorscheme = { enable_preview = true  },
        },

        -- ── Extensions ─────────────────────────────────────────────────────────
        extensions = {
          fzf = {
            fuzzy                   = true,
            override_generic_sorter = true,   -- fzf sorts all generic lists
            override_file_sorter    = true,   -- fzf sorts file lists
            case_mode               = "smart_case",
          },

          -- ui-select: controls the theme used when vim.ui.select() is called.
          -- "dropdown" keeps it compact — code action lists are usually short.
          -- Change to get_cursor({}) for a cursor-relative popup instead.
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      -- Load native fzf sorter (compiled C, significantly faster than Lua sorter)
      pcall(telescope.load_extension, "fzf")

      -- Load ui-select — this is what actually overrides vim.ui.select().
      -- Must be called AFTER telescope.setup(), otherwise the extension
      -- config above won't have been registered yet.
      pcall(telescope.load_extension, "ui-select")
    end,
  },
}

-- ─────────────────────────────────────────────────────────────────────────────
-- USING TELESCOPE TO ITS FULL POTENTIAL
-- ─────────────────────────────────────────────────────────────────────────────
--
-- INSIDE ANY PICKER:
--   <C-h>          → show all keymaps for this picker (your cheat sheet)
--   <Tab>          → multi-select an item
--   <C-q>          → send Tab-selected items to quickfix
--   <M-q>          → send ALL results to quickfix
--   <C-p>          → toggle preview pane on/off
--   <C-s>          → open in horizontal split
--   <C-v>          → open in vertical split
--   <C-t>          → open in new tab
--   <C-d>/<C-u>    → scroll the preview pane
--
-- WORKFLOWS YOU PROBABLY DON'T KNOW ABOUT:
--
--   1. Multi-file rename / refactor:
--      <leader>fw (grep word) → <Tab> each file → <C-q> → quickfix open
--      Then: :cfdo %s/OldName/NewName/g | update
--      (cfdo = run on each FILE in quickfix, not each match line)
--
--   2. Resume last picker:
--      <leader>fp → reopens the last picker exactly where you left it.
--      Use this constantly when you accidentally close a search.
--
--   3. Git file history:
--      <leader>gC (git_bcommits) → every commit that touched the current file
--      Preview shows the diff. <C-r>h to hard reset to that commit.
--
--   4. Browse :help inline:
--      <leader>fh → type any topic → preview shows the help page
--      No need to :help and then :q — stay in your flow.
--
--   5. Paste from any register:
--      <leader>" (registers) → see all registers with their content → <CR> to paste
--
--   6. Spell correct with telescope:
--      z= on a misspelled word → dropdown of suggestions → <CR> to fix
--
--   7. Jump anywhere in file without LSP:
--      <leader>ft (treesitter) → all functions, classes, variables in the file
--      Works even when no LSP server is attached.
--
--   8. Find changed files in git:
--      <leader>gs (git_status) → every dirty file → <CR> to open
--
--   9. Switch themes live:
--      <leader>fC → arrow through colorschemes with live preview
--
--  10. Delete buffers from the picker:
--      <leader>fb → navigate to a buffer → <C-d> to delete without opening it
--
-- ADDING TO QUICKFIX (batch operations):
--   1. Run any search (e.g. <leader>fg for a term)
--   2. <Tab> to mark files (or skip to <M-q> to send all)
--   3. <C-q> or <M-q> to send to quickfix
--   4. :cfdo %s/foo/bar/g | update  ← runs per FILE (what you almost always want)
--      :cdo s/foo/bar/g  | update   ← runs per MATCH LINE (use when you want control)
--
-- OPTIONAL EXTENSIONS (add as dependencies when needed):
--
--   "nvim-telescope/telescope-file-browser.nvim"
--     → full file manager inside telescope (create, rename, delete, move files)
--
--   "prochri/telescope-all-recent.nvim"
--     → frecency sorting: files you use most recently score higher across all pickers
