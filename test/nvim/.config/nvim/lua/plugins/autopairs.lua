-- lua/plugins/autopairs.lua
--
-- ─── WHY mini.pairs OVER nvim-autopairs ───────────────────────────────────────
--
-- nvim-autopairs has a blink.cmp integration gap:
--   The cmp_autopairs.on_confirm_done() integration hooks into nvim-cmp's
--   confirm_done event. The maintainer marked blink.cmp support as wontfix.
--   This means the "auto-insert ( after function completion" feature of
--   nvim-autopairs does not work with blink.cmp.
--
-- This doesn't matter because blink.cmp handles it natively:
--   completion.accept.auto_brackets.enabled = true in blink.lua already
--   inserts () after confirming a function/method completion item.
--
-- mini.pairs:
--   - Part of echasnovski/mini.nvim — actively maintained
--   - No completion plugin integration needed or expected
--   - Works correctly with blink.cmp out of the box
--   - Lighter than nvim-autopairs (no rule engine, no handler system)
--
-- ─── WHAT mini.pairs DOES ─────────────────────────────────────────────────────
--
-- Typing (  → inserts ()  and puts cursor between them
-- Typing "  → inserts ""  and puts cursor between them
-- Typing {  → inserts {}  and puts cursor between them
-- Cursor before )  → pressing ) skips over it instead of inserting
-- Pressing <BS> between a pair  → deletes both characters
--
-- ─── WHAT mini.pairs DOES NOT DO ──────────────────────────────────────────────
--
-- Treesitter-aware pairing (string context detection)  → use nvim-autopairs
-- FastWrap (<M-e> to wrap a word in brackets)          → use nvim-autopairs
-- Per-filetype rule customization via Rule()           → use nvim-autopairs
--
-- If you need any of the above, swap this file for nvim-autopairs.
-- The blink.cmp auto_brackets feature still handles () after function completion
-- regardless of which autopairs plugin you use.

return {
    {
        "echasnovski/mini.pairs",
        version = false,         -- mini.nvim does not use semver tags; use HEAD
        event   = "InsertEnter", -- only needed in insert mode

        opts    = {
            -- Pairs to auto-close. Each entry: opening = { closing, opts }
            -- 'action' controls what triggers the pair: 'open', 'close', or 'closeopen'
            modes = { insert = true, command = false, terminal = false },

            -- These are the default pairs. Listed explicitly so they're visible.
            -- Remove a pair by setting it to false, e.g. ["'"] = false
            mappings = {
                ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
                ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
                ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
                [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
                ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
                ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
                ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
                ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
                ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
            },
        },
    },
}
