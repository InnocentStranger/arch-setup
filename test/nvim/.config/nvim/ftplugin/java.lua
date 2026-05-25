-- ftplugin/java.lua

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

-- ── 1. Resolve Paths Dynamically ────────────────────────────────────────────
local mason_registry = require("mason-registry")
local jdtls_path = mason_registry.get_package("jdtls"):get_install_path()

-- Find the launcher jar (version changes, so we glob it)
local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true)

-- Determine OS for the correct config directory
local os_config = "linux"
if vim.fn.has("mac") == 1 then
  os_config = "mac"
elseif vim.fn.has("win32") == 1 then
  os_config = "win"
end
local config_dir = jdtls_path .. "/config_" .. os_config

local lombok_jar = jdtls_path .. "/lombok.jar"

-- ── 2. Workspace & Root ─────────────────────────────────────────────────────
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = vim.fs.root(0, root_markers) or vim.fn.getcwd()

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name

-- ── 3. Capabilities ─────────────────────────────────────────────────────────
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_blink, blink = pcall(require, "blink.cmp")
if has_blink then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

-- ── 4. Server Configuration ─────────────────────────────────────────────────
local config = {
  cmd = {
    "java", -- NOTE: java must be present in path
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",

    "-Xmx4g", -- 4GB memory
    "-javaagent:" .. lombok_jar,
    "-Djava.import.generatesMetadataFilesAtProjectRoot=false",

    -- Java 17+ Module System requirements
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",

    "-jar",
    launcher,
    "-configuration",
    config_dir,
    "-data",
    workspace_dir,
  },

  root_dir = root_dir,
  capabilities = capabilities,

  settings = {
    java = {
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      configuration = { updateBuildConfiguration = "interactive" },
      referencesCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
      inlayHints = { parameterNames = { enabled = "all" } },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
    },
  },

  init_options = { bundles = {} },
}

-- ── 5. Attach ───────────────────────────────────────────────────────────────
jdtls.start_or_attach(config)
