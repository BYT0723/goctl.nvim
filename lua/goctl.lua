local M = {}
local api = vim.api

local common = require("goctl.common")
local command = require("goctl.command")
local goctl_api = require("goctl.api")
local goctl_rpc = require("goctl.rpc")

-- variable
local FILETYPE = "goctl"
local AUGROUP = "Goctl"

local function set_autocommands()
	api.nvim_create_augroup(AUGROUP, { clear = true })

	local atcmd = api.nvim_create_autocmd

	atcmd({ "BufRead", "BufNewFile" }, {
		pattern = "*.api",
		group = AUGROUP,
		nested = true,
		callback = function()
			vim.cmd("set filetype=" .. FILETYPE)
		end,
	})

	atcmd({ "BufRead", "TextChanged", "TextChangedI" }, {
		pattern = "*.api",
		group = AUGROUP,
		nested = true,
		callback = goctl_api.validate,
	})
end

local function set_commands()
	local cmd = api.nvim_create_user_command

	-- common --
	cmd("GoctlUpgrade", function()
		if not common.goctl_check() then
			common.goctl_install()
		else
			common.goctl_upgrade()
		end
	end, {})

	cmd("GoctlEnv", common.goctl_env, {})

	-- util ---
	cmd("GoctlApiFormat", goctl_api.format, {})

	cmd("GoctlApiNew", goctl_api.new, {})
	cmd("GoctlApiDoc", goctl_api.doc, {})
	cmd("GoctlApiGenerate", goctl_api.generate, {})
	cmd("GoctlApi", goctl_api.menu, {})

	cmd("GoctlRpcNew", goctl_rpc.new, {})
	cmd("GoctlRpcProtoc", goctl_rpc.protoc, {})
end

function M.setup(user_prefs)
	-- config.set(user_prefs)
	-- set_mappings()
	set_autocommands()
	set_commands()
end

return M
