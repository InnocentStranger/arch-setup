-- lua/plugins/telescope.lua
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
-- ─── TELESCOPE DEFAULT VALUES YOU DON'T NEED TO SET ─────────────────────────
--   layout_strategy  = "horizontal"   ← already the default
--   winblend         = 0              ← already the default
--   sorting_strategy = "descending"   ← default (we override to "ascending")
--   file_ignore_patterns = {}         ← already empty
--   border           = {}             ← NOT a boolean; don't set border = true
--   borderchars      = the rounded ones ← already the default
--
-- ─── SYSTEM REQUIREMENTS ─────────────────────────────────────────────────────
--   ripgrep (rg)  → live_grep, grep_string
--   fd            → find_files (faster than the rg fallback)
--   gcc/clang     → telescope-fzf-native (C compile step)
--   bat (optional)→ syntax-highlighted file previews
--
-- INSTALL:
--   brew install ripgrep fd bat
--   apt  install ripgrep fd-find
--   (bat is optional — telescope works without it, just no syntax in preview)

local builtin = nil   -- lazily required inside keys callbacks

local function b(picker, opts)
  return function()
    builtin = builtin or require("telescope.builtin")
    builtin[picker](opts or {})
  end
end

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    lazy   = true,
    cmd    = "Telescope",

    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond  = function() return vim.fn.executable("make") == 1 end,
      },
    },

    keys = {
      -- ────────────────────────────────────────────────────────────────────────
      -- FILES
      -- ────────────────────────────────────────────────────────────────────────
      -- Normal files (respects .gitignore — the common case)
      { "<leader>ff", b("find_files"),                                    desc = "Find files" },
      -- Include hidden dotfiles (.env, .github/, .eslintrc, etc.)
      { "<leader>fF", b("find_files", { hidden = true }),                 desc = "Find files (+ hidden)" },
      -- Ignore gitignore entirely — find EVERYTHING (slow on big repos)
      { "<leader>fa", b("find_files", { hidden = true, no_ignore = true }), desc = "Find ALL files" },
      -- Recent files (mru)
      { "<leader>fr", b("oldfiles"),                                      desc = "Recent files" },

      -- ────────────────────────────────────────────────────────────────────────
      -- SEARCH / GREP
      -- ────────────────────────────────────────────────────────────────────────
      -- Live grep (respects .gitignore by default)
      { "<leader>fg", b("live_grep"),                                     desc = "Live grep" },
      -- Live grep including hidden files
      { "<leader>fG", b("live_grep", { additional_args = { "--hidden" } }), desc = "Live grep (+ hidden)" },
      -- Grep the word under cursor (great for finding usages)
      { "<leader>fw", b("grep_string"),                                   desc = "Grep word under cursor" },
      { "<leader>fw", b("grep_string"),  mode = "v",                      desc = "Grep selection" },
      -- Fuzzy search inside the current buffer only
      { "<leader>f/", b("current_buffer_fuzzy_find"),                     desc = "Grep in buffer" },

      -- ────────────────────────────────────────────────────────────────────────
      -- BUFFERS & NAVIGATION
      -- ────────────────────────────────────────────────────────────────────────
      { "<leader>fb", b("buffers", { sort_mru = true, sort_lastused = true }), desc = "Buffers" },
      -- Quick buffer switch (like Ctrl+Tab in VSCode)
      { "<leader><leader>", b("buffers", { sort_mru = true }),            desc = "Switch buffer" },

      -- ────────────────────────────────────────────────────────────────────────
      -- LSP — these replace gd/gr in a picker UI
      -- ────────────────────────────────────────────────────────────────────────
      { "<leader>fs", b("lsp_document_symbols"),                          desc = "Document symbols" },
      { "<leader>fS", b("lsp_workspace_symbols"),                         desc = "Workspace symbols" },
      { "<leader>fd", b("diagnostics", { bufnr = 0 }),                    desc = "Buffer diagnostics" },
      { "<leader>fD", b("diagnostics"),                                   desc = "All diagnostics" },
      -- These override the gd/gr keymaps set in lsp.lua to show them in a picker
      { "gr",         b("lsp_references",      { show_line = false }),    desc = "LSP references" },
      { "gd",         b("lsp_definitions"),                               desc = "LSP definitions" },
      { "gI",         b("lsp_implementations"),                           desc = "LSP implementations" },
      { "gy",         b("lsp_type_definitions"),                          desc = "LSP type definitions" },

      -- ────────────────────────────────────────────────────────────────────────
      -- GIT
      -- ────────────────────────────────────────────────────────────────────────
      -- Status (jump to any changed file)
      { "<leader>gs", b("git_status"),                                    desc = "Git status" },
      -- Commits for the whole repo
      { "<leader>gc", b("git_commits"),                                   desc = "Git commits" },
      -- Commits that touched the current buffer (git log -- <file>)
      { "<leader>gC", b("git_bcommits"),                                  desc = "Git commits (buffer)" },
      -- Branches — switch with <CR>, create with <C-n>
      { "<leader>gb", b("git_branches"),                                  desc = "Git branches" },
      -- Stash list
      { "<leader>gS", b("git_stash"),                                     desc = "Git stash" },
      -- Files tracked by git (faster than find_files in very large repos)
      { "<leader>gf", b("git_files"),                                     desc = "Git-tracked files" },

      -- ────────────────────────────────────────────────────────────────────────
      -- VIM / NEOVIM INTERNALS
      -- (this is what VSCode's command palette gives you — telescope goes further)
      -- ────────────────────────────────────────────────────────────────────────
      -- Command palette — every :command telescope knows about
      { "<leader>fc", b("commands"),                                       desc = "Commands (palette)" },
      -- Search through all available keymaps
      { "<leader>fk", b("keymaps"),                                       desc = "Keymaps" },
      -- Browse all :help tags
      { "<leader>fh", b("help_tags"),                                     desc = "Help tags" },
      -- Man pages (system manual)
      { "<leader>fm", b("man_pages"),                                     desc = "Man pages" },
      -- Vim options (:set)
      { "<leader>fo", b("vim_options"),                                   desc = "Vim options" },
      -- Autocommands list
      { "<leader>fA", b("autocommands"),                                  desc = "Autocommands" },
      -- Highlight groups (great when building a colorscheme)
      { "<leader>fH", b("highlights"),                                    desc = "Highlight groups" },
      -- Registers — paste from any register
      { "<leader>\"",  b("registers"),                                    desc = "Registers" },
      -- Jump list
      { "<leader>fj", b("jumplist"),                                      desc = "Jump list" },
      -- Location / quickfix list
      { "<leader>fq", b("quickfix"),                                      desc = "Quickfix list" },
      { "<leader>fl", b("loclist"),                                       desc = "Location list" },
      -- Spell suggestions for word under cursor
      { "z=",         b("spell_suggest"),                                 desc = "Spell suggest" },
      -- Resume the last picker (extremely useful after accidental close)
      { "<leader>fp", "<cmd>Telescope resume<CR>",                        desc = "Resume last picker" },

      -- ────────────────────────────────────────────────────────────────────────
      -- TREESITTER
      -- ────────────────────────────────────────────────────────────────────────
      -- All symbols in the file via Treesitter (works without LSP)
      { "<leader>ft", b("treesitter"),                                    desc = "Treesitter symbols" },

      -- ────────────────────────────────────────────────────────────────────────
      -- COLORSCHEMES
      -- ────────────────────────────────────────────────────────────────────────
      -- Live-preview colorschemes as you browse
      { "<leader>fC", b("colorscheme", { enable_preview = true }),        desc = "Colorschemes" },
    },

    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          -- ── Layout ────────────────────────────────────────────────────────────
          -- Prompt at the top is more VSCode-like (default is bottom)
          -- Requires sorting_strategy = "ascending" to match visually
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width   = 0.5,
            },
            -- These control the overall picker size
            width  = 0.9,
            height = 0.85,
          },
          -- "ascending" so results grow downward from the prompt at top
          sorting_strategy = "ascending",

          -- ── Ignoring ──────────────────────────────────────────────────────────
          -- DO NOT set file_ignore_patterns here.
          -- fd and rg already respect .gitignore. Lua-level patterns are slow
          -- and redundant. If a directory is polluting results, add it to
          -- your project's .gitignore or a global ~/.gitignore.

          -- ── rg arguments for live_grep / grep_string ──────────────────────────
          -- These are the telescope defaults — listed here for visibility.
          -- Add --hidden below if you want to grep inside dotfiles by default.
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            -- "--hidden",    ← uncomment to grep inside dotfiles by default
            -- "--glob", "!.git",  ← only needed if you add --hidden above
          },

          -- ── Picker keymaps ────────────────────────────────────────────────────
          mappings = {
            i = {
              -- Vim-style navigation in the results list
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              -- History navigation
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              -- Send ALL results to quickfix and open it
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              -- Send SELECTED results to quickfix (select with <Tab> first)
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              -- Open in splits / tabs
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              -- Close
              ["<Esc>"] = actions.close,
              -- Preview scrolling without leaving the prompt
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-u>"] = actions.preview_scrolling_up,
              -- Show all available keymaps for this picker
              ["<C-h>"] = "which_key",
            },
            n = {
              ["q"]     = actions.close,
              ["<Esc>"] = actions.close,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            },
          },

          -- ── Path display ───────────────────────────────────────────────────────
          -- "truncate" shows the full path but cuts from the left when narrow
          -- "smart" shows only the unique suffix of the path
          path_display = { "truncate" },
        },

        -- ── Per-picker overrides ───────────────────────────────────────────────
        pickers = {
          find_files = {
            -- fd is faster; rg is the fallback if fd is not installed.
            -- No --hidden here: gitignored files (node_modules, .git) are
            -- already excluded. Add --hidden only if you want dotfiles.
            find_command = vim.fn.executable("fd") == 1
              and { "fd", "--type", "f", "--color", "never" }
              or  nil,    -- nil = telescope picks rg or find automatically
          },

          -- Don't show the line content in references (cleaner)
          lsp_references  = { show_line = false },
          lsp_definitions = { show_line = false },

          -- Use dropdown theme for short pickers
          buffers = {
            sort_mru      = true,
            sort_lastused = true,
            mappings = {
              i = { ["<C-d>"] = actions.delete_buffer },
              n = { ["d"]     = actions.delete_buffer },
            },
          },

          -- git_commits: show full diff in preview
          git_commits = {
            mappings = {
              i = {
                -- Checkout the selected commit
                ["<C-r>"] = actions.git_checkout,
              },
            },
          },

          -- Spell suggestions: use dropdown (no preview needed)
          spell_suggest = {
            theme = "dropdown",
          },

          -- Colorscheme: small dropdown, enable preview
          colorscheme = {
            enable_preview = true,
            theme = "dropdown",
          },
        },

        extensions = {
          fzf = {
            fuzzy                   = true,
            override_generic_sorter = true,   -- use fzf for generic lists
            override_file_sorter    = true,   -- use fzf for file lists
            case_mode               = "smart_case",
          },
        },
      })

      -- Load fzf native extension (C-compiled, much faster sorting)
      pcall(telescope.load_extension, "fzf")
    end,
  },
}

-- ─────────────────────────────────────────────────────────────────────────────
-- USING TELESCOPE TO ITS FULL POTENTIAL
-- ─────────────────────────────────────────────────────────────────────────────
--
-- INSIDE ANY PICKER:
--   <C-h>          → show all keymaps for this picker (your cheat sheet)
--   <Tab>          → multi-select an item (then <C-q> to send all to quickfix)
--   <C-q>          → send ALL results to quickfix list
--   <M-q>          → send SELECTED (Tab'd) items to quickfix
--   <C-s>          → open in horizontal split
--   <C-v>          → open in vertical split
--   <C-t>          → open in new tab
--   <C-d>/<C-u>    → scroll the preview pane
--
-- WORKFLOWS YOU PROBABLY DON'T KNOW ABOUT:
--
--   1. Multi-file refactor:
--      <leader>fw (grep word) → <Tab> each occurrence → <C-q> → quickfix
--      Then use :cdo s/old/new/g | update to change all at once
--
--   2. Resume last picker:
--      <leader>fp → reopens the last picker exactly where you left it
--      Critical when you accidentally close a search
--
--   3. Git blame at a commit:
--      <leader>gC (git_bcommits) → see commits that touched current file
--      → <CR> to checkout, or <C-d> to diff
--
--   4. Browse your :help without leaving Neovim:
--      <leader>fh → type any topic → preview shows the help page inline
--
--   5. Paste from any register:
--      <leader>" (registers) → see all registers with content preview → <CR>
--
--   6. Spell correct:
--      z= on a misspelled word → dropdown with suggestions → no more guessing
--
--   7. Jump anywhere in the file without LSP:
--      <leader>ft (treesitter) → all functions, classes, variables in file
--      Works even without an LSP server attached
--
--   8. Find what changed in git:
--      <leader>gs (git_status) → see all dirty files → <CR> to open
--      <leader>gc (git_commits) → browse full repo history with diffs
--
--   9. Theme switching:
--      <leader>fC (colorscheme) → live preview as you arrow through themes
--
--  10. Search command history:
--      <C-p> inside the telescope prompt to cycle through past searches
--
-- ADDING TO QUICKFIX (batch operations):
--   1. Run any search (e.g. live_grep for "TODO")
--   2. Press <Tab> to mark items (or skip to send all)
--   3. Press <C-q> to send to quickfix
--   4. :cdo <cmd> to run a command on every quickfix item
--   Example: replace "foo" with "bar" across all matching files:
--     <leader>fw (grep "foo") → <C-q> → :cdo s/foo/bar/g | update
--
-- ADDING PER-EXTENSION PICKERS (optional, add as dependencies):
--
--   "nvim-telescope/telescope-ui-select.nvim"
--     → makes vim.ui.select() use telescope (code actions etc. appear in picker)
--
--   "nvim-telescope/telescope-file-browser.nvim"
--     → full file manager inside telescope (create, rename, delete files)
--
--   "prochri/telescope-all-recent.nvim"
--     → frecency sorting: shows most-recently-used files first across pickers
