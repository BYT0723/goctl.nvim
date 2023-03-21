local M = {}

local fn = vim.fn
local notify = require("goctl.notify")

local function on_event(job_id, data, event)
	if vim.trim(table.concat(data)) == "" then
		return
	end

	local res = {}

	for _, v in ipairs(data) do
		if vim.trim(v) ~= "" then
			local line = string.gsub(v, "\x1b[\\[0-9]+m", "")
			table.insert(res, line)
		end
	end

	if event == "stdout" then
		notify:Info(res)
	elseif event == "stderr" then
		notify:Error(res)
	else
		notify:Info("Done!")
	end
end

function M:new(cmd)
	fn.jobstart(cmd, {
		on_stdout = on_event,
		on_stderr = on_event,
	})
end

return M
