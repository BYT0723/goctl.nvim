local M = {}
local api = vim.api

local common = require("goctl.common")
local generate = require("goctl.generate")
local command = require("goctl.command")
local util = require("goctl.util")
local goctl_api = require("goctl.api")

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

	cmd("GoctlFastNew", function()
		generate.goctl_api_fast_new()
	end, { complete = command.goctl_api_fast_new_complete, nargs = "*" })

	cmd("GoctlDocker", function()
		generate.goctl_docker()
	end, { complete = command.docker_complete, nargs = "*" })

	cmd("GoctlKubeDeploy", function()
		generate.goctl_kube_deploy()
	end, { complete = command.kube_deploy_complete, nargs = "*" })

	cmd("GoctlRpcFastNew", function()
		generate.goctl_rpc_fast_new()
	end, { complete = command.rpc_fast_new_complete, nargs = "*" })

	cmd("GoctlRpcNewProto", function()
		generate.goctl_rpc_new_proto()
	end, { complete = command.rpc_new_proto_complete, nargs = "*" })

	cmd("GoctlRpcGenerate", function()
		generate.goctl_rpc_generate()
	end, { complete = command.rpc_generate_complete, nargs = "*" })
end

function M.setup(user_prefs)
	-- config.set(user_prefs)
	-- set_mappings()
	set_autocommands()
	set_commands()
end

return M
