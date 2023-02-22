local M = {}

local api = vim.api
local fn = vim.fn

---
---Check whether obj is empty
---
---@param obj any
---
---If type of obj is string, when obj is empty string, return true
function M.empty(obj)
	if obj == nil then
		return true
	end
	if type(obj) == string and obj == "" then
		return true
	end

	return false
end

---
---Validate api file
---
function M.goctl_api_validate()
	local cmd = "goctl api validate --api " .. api.nvim_buf_get_name(0)
	local handle = io.popen(cmd)
	if handle == nil then
		return
	end
	local msg = string.match(handle:read("*a"), "%d+:%d+[0-9a-zA-z%s']+")
	handle:close()

	local ns = api.nvim_create_namespace("goctl.nvim")

	if msg == nil or msg == "" then
		vim.diagnostic.reset(ns, 0)
	else
		local i = string.find(msg, ":")
		local j = string.find(msg, " ")
		local row = tonumber(string.sub(msg, 0, i - 1))
		local col = tonumber(string.sub(msg, i + 1, j))
		msg = string.sub(msg, j + 1)

		vim.diagnostic.set(ns, 0, { {
			bufnr = 0,
			lnum = row - 1,
			col = col,
			message = msg,
		} }, nil)
	end
end

---
---Format api file
---
---@param dir? string The target dir
function M.goctl_api_format(dir)
	if M.empty(dir) then
		dir = fn.getcwd()
	end
	local cmd = "!goctl api format --dir " .. dir
	vim.cmd(cmd)
end

return M
