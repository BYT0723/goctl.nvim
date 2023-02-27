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

function M.ToStringEx(value)
	if type(value) == "table" then
		return TableToStr(value)
	elseif type(value) == "string" then
		return "'" .. value .. "'"
	else
		return tostring(value)
	end
end

function TableToStr(t)
	if t == nil then
		return ""
	end
	local retstr = "{"

	local i = 1
	for key, value in pairs(t) do
		local signal = ","
		if i == 1 then
			signal = ""
		end

		if key == i then
			retstr = retstr .. signal .. M.ToStringEx(value)
		else
			if type(key) == "number" or type(key) == "string" then
				retstr = retstr .. signal .. "[" .. M.ToStringEx(key) .. "]=" .. M.ToStringEx(value)
			else
				if type(key) == "userdata" then
					retstr = retstr
						.. signal
						.. "*s"
						.. TableToStr(getmetatable(key))
						.. "*e"
						.. "="
						.. M.ToStringEx(value)
				else
					retstr = retstr .. signal .. key .. "=" .. M.ToStringEx(value)
				end
			end
		end

		i = i + 1
	end

	retstr = retstr .. "}"
	return retstr
end

local function on_event(job_id, data, event)
	if event == "stdout" and table.concat(data) ~= "" then
		api.nvim_buf_set_lines(0, 0, -1, false, data)
	elseif event == "stderr" then
		local msg = string.match(data[1], "%d+:%d+[^\n]+")

		local ns = api.nvim_create_namespace("goctl.nvim")

		if msg == nil or msg == "" then
			vim.diagnostic.reset(ns, 0)
		else
			local i = string.find(msg, ":")
			local j = string.find(msg, " ")
			local row = tonumber(string.sub(msg, 0, i - 1))
			local col = tonumber(string.sub(msg, i + 1, j))
			msg = string.sub(msg, j + 1)

			vim.diagnostic.set(
				ns,
				0,
				{ {
					bufnr = 0,
					lnum = row - 1,
					col = col,
					message = msg,
				} },
				nil
			)
		end
	end
end

---
---Validate api file
---
function M.goctl_api_validate()
	local cmd = "goctl api format --stdin"
	local job_id = fn.jobstart(cmd, {
		on_stderr = on_event,
		stderr_buffered = true,
	})
	local lines = api.nvim_buf_get_lines(0, 0, -1, false)
	fn.chansend(job_id, lines)
	fn.chanclose(job_id, "stdin")
end

---
---Format api file
---
function M.goctl_api_format()
	local cmd = "goctl api format --stdin"
	local job_id = fn.jobstart(cmd, {
		on_stdout = on_event,
		stdout_buffered = true,
	})
	local lines = api.nvim_buf_get_lines(0, 0, -1, false)
	fn.chansend(job_id, lines)
	fn.chanclose(job_id, "stdin")
end

return M
