-- lsp/lua_ls.lua
--
-- Config for lua-language-server.
--
-- NOTE: workspace.library is intentionally NOT set here.
-- lazydev.nvim dynamically manages workspace libraries for Neovim config editing.
-- Setting workspace.library manually here would conflict with lazydev and produce
-- duplicate or stale type information.
--
-- nvim-lspconfig already provides (do not repeat):
--   cmd          = { "lua-language-server" }
--   filetypes    = { "lua" }
--   root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git" }

return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
        -- Do NOT set library here. lazydev.nvim handles this dynamically.
      },
      diagnostics = {
        globals = { "vim" },
        disable = { "missing-fields" },
      },
      completion = {
        callSnippet = "Replace",
      },
      hint = {
        enable     = true,
        arrayIndex = "Disable",
        paramName  = "All",
        paramType  = true,
        semicolon  = "Disable",
        setType    = true,
      },
      telemetry = { enable = false },
    },
  },
}
