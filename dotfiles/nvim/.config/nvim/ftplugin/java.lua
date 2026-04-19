-- Java LSP (jdtls) setup for Neovim
local keymap = vim.keymap
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local opts = { noremap = true, silent = true }
local on_attach = function(_, bufnr)
	opts.buffer = bufnr

	-- set keybinds
	opts.desc = "Show LSP references"
	keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

	opts.desc = "Go to declaration"
	keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

	opts.desc = "Show LSP definitions"
	keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

	opts.desc = "Show LSP implementations"
	keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

	opts.desc = "Show LSP type definitions"
	keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

	opts.desc = "See available code actions"
	keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

	opts.desc = "Smart rename"
	keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	opts.desc = "Show buffer diagnostics"
	keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

	opts.desc = "Show line diagnostics"
	keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

	opts.desc = "Go to previous diagnostic"
	keymap.set("n", "[d", function()
		vim.diagnostic.jump({ count = -1, float = true })
	end, opts)

	opts.desc = "Go to next diagnostic"
	keymap.set("n", "]d", function()
		vim.diagnostic.jump({ count = 1, float = true })
	end, opts)

	opts.desc = "Show documentation for what is under cursor"
	keymap.set("n", "K", vim.lsp.buf.hover, opts)

	opts.desc = "Restart LSP"
	keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
end

local capabilities = cmp_nvim_lsp.default_capabilities()

-- Project and workspace setup
local home = vim.env.HOME
local root_markers = {
	".git",
	".classpath",
	"mvnw",
	"gradlew",
	"pom.xml",
	"build.gradle",
	"build.gradle.kts",
	"settings.gradle",
}
local root_dir = require("jdtls.setup").find_root(root_markers) or vim.fn.getcwd()
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name
vim.fn.mkdir(workspace_dir, "p")

-- Determine OS for JDTLS config
local system_os
if vim.fn.has("mac") == 1 then
	system_os = "mac"
elseif vim.fn.has("unix") == 1 then
	system_os = "linux"
elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
	system_os = "win"
else
	system_os = "linux"
end

-- Locate JDTLS installation via Mason
local mason_pkg_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
-- Ensure the directory exists
if vim.fn.isdirectory(mason_pkg_path) == 0 then
	vim.notify("JDTLS Error: mason package jdtls not found at " .. mason_pkg_path, vim.log.levels.ERROR)
	return
end
local jdtls_path = mason_pkg_path

-- Locate Equinox launcher JAR
local jdtls_launcher_jars = vim.split(vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"), "\n")
if #jdtls_launcher_jars == 0 then
	vim.notify("JDTLS Error: Could not find Equinox launcher JAR in " .. jdtls_path .. "/plugins", vim.log.levels.ERROR)
	return
end
local jdtls_launcher_jar = jdtls_launcher_jars[1]
local jdtls_config_dir = jdtls_path .. "/config_" .. system_os

-- Lombok support
local lombok_path = jdtls_path .. "/lombok.jar"
if vim.fn.filereadable(lombok_path) == 0 then
	vim.notify("JDTLS Warning: lombok.jar not found at " .. lombok_path, vim.log.levels.WARN)
end

-- LSP configuration
local config = {
	cmd = {
		home .. "/.sdkman/candidates/java/current/bin/java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. vim.fn.fnameescape(lombok_path),
		"-Xmx4g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		vim.fn.fnameescape(jdtls_launcher_jar),
		"-configuration",
		vim.fn.fnameescape(jdtls_config_dir),
		"-data",
		vim.fn.fnameescape(workspace_dir),
	},
	root_dir = root_dir,
	settings = {
		java = {
			home = home .. "/.sdkman/candidates/java/current/",
			configuration = { downloadSources = true, updateBuildConfiguration = "interactive" },
			runtimes = {
				{ name = "JavaSE-1.8", path = home .. "/.sdkman/candidates/java/8.0.442-tem/" },
				{ name = "JavaSE-11", path = home .. "/.sdkman/candidates/java/11.0.26-tem/" },
				{ name = "JavaSE-17", path = home .. "/.sdkman/candidates/java/17.0.15-tem/" },
				{ name = "JavaSE-21", path = home .. "/.sdkman/candidates/java/21.0.8-tem/" },
			},
			maven = { downloadSources = true },
			gradle = { enabled = true, downloadSources = true },
			implementationsCodeLens = { enabled = true },
			referencesCodeLens = { enabled = true },
			references = { includeDecompiledSources = true },
			signatureHelp = { enabled = true },
			completion = { importOrder = { "java", "javax", "com", "org" } },
			sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
			import = { gradle = { enabled = true }, maven = { enabled = true } },
		},
	},
	init_options = { bundles = {} },
	on_attach = on_attach,
	capabilities = capabilities,
}

-- Start or attach to the JDTLS server
require("jdtls").start_or_attach(config)
