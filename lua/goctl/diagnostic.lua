local fn = vim.fn
local empty = require("common.util").empty

---
---Validate api file
---
---@param api string
local function goctl_api_validate(api)
	if empty(api) then
		error("api can't be empty")
		return
	end
	local cmd = "!goctl api validate --api " .. api
	-- os.execute(cmd)
	vim.cmd(cmd)
end

---
---Format api file
---
---@param dir? string The target dir
local function goctl_api_format(dir)
	if empty(dir) then
		dir = fn.getcwd()
	end
	local cmd = "!goctl api format --dir " .. dir
	vim.cmd(cmd)
end
