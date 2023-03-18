local M = {}

local api, fn = vim.api, vim.fn
local input = require("goctl.ui.input")
local menu = require("goctl.ui.menu")

local job = require("goctl.job")
local notify = require("goctl.notify")
local util = require("goctl.util")

function M.new()
	local cmd = { "goctl", "rpc", "new" }

	local on_submit = function(value)
		local path = vim.trim(value)
		if path == "" then
			return
		end

		if fn.isdirectory(fn.getcwd() .. "/" .. path) == 1 then
			notify:Warn("Path already exists")
			return
		end

		table.insert(cmd, path)

		job:new(cmd)
	end

	input:new("Path", "greet", on_submit):display()
end

function M.protoc()
	local cmd = { "goctl", "rpc", "protoc" }

	local zrpc_out_submit = function(value)
		local path = vim.trim(value)
		if path == "" then
			return
		end

		table.insert(cmd, "--zrpc_out=" .. path)

		job:new(cmd)
	end

	local go_grpc_out_submit = function(value)
		local path = vim.trim(value)
		if path == "" then
			return
		end

		table.insert(cmd, "--go-grpc_out=" .. path)
		input:new("zrpc_out", ".", zrpc_out_submit):display()
	end

	local go_out_submit = function(value)
		local path = vim.trim(value)
		if path == "" then
			return
		end

		table.insert(cmd, "--go_out=" .. path)
		input:new("go-grpc_out", path, go_grpc_out_submit):display()
	end

	table.insert(cmd, util.relative_path())

	input:new("go_out", ".", go_out_submit):display()
end

return M
