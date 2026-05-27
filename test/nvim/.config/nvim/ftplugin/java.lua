-- ftplugin/java.lua

local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
  return
end

local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
if not mason_registry_ok then
  return
end

local jdtls_path = mason_registry.get_package("jdtls"):get_install_path()

local launcher_list = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true, true)
local launcher = launcher_list[1]

-- Determine OS for the correct config directory
local os_config = "linux"
if vim.fn.has("mac") == 1 then
  os_config = "mac"
elseif vim.fn.has("win32") == 1 then
  os_config = "win"
end
local config_dir = jdtls_path .. "/config_" .. os_config

local lombok_jar = jdtls_path .. "/lombok.jar"
local lombok_exists = vim.uv.fs_stat(lombok_jar) ~= nil

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" }
local root_dir = vim.fs.root(0, root_markers) or vim.fn.getcwd()

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name

local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_blink, blink = pcall(require, "blink.cmp")
if has_blink then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

local cmd = {
  "java", -- NOTE: java must be present in path
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true",
  "-Dlog.level=ALL",
  "-Xmx4g", -- 4GB memory
  "-Djava.import.generatesMetadataFilesAtProjectRoot=false",

  -- Java 17+ Module System requirements
  "--add-modules=ALL-SYSTEM",
  "--add-opens",
  "java.base/java.util=ALL-UNNAMED",
  "--add-opens",
  "java.base/java.lang=ALL-UNNAMED",
}

if lombok_exists then
  table.insert(cmd, "-javaagent:" .. lombok_jar)
end

vim.list_extend(cmd, {
  "-jar",
  launcher,
  "-configuration",
  config_dir,
  "-data",
  workspace_dir,
})

local config = {
  cmd = cmd,
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
