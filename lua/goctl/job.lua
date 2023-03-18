local M = {}

local fn = vim.fn
local notify = require("goctl.notify")

local function on_event(job_id, data, event)
	if vim.trim(table.concat(data)) == "" then
		return
	end

	if event == "stdout" then
		notify:Info(data)
	elseif event == "stderr" then
		notify:Error(data)
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
