local M = {}

local opt = {
	title = "Goctl.nvim",
}

function M:Info(msg)
	vim.notify(msg, vim.log.levels.INFO, opt)
end

function M:Error(msg)
	vim.notify(msg, vim.log.levels.ERROR, opt)
end

function M:Warn(msg)
	vim.notify(msg, vim.log.levels.WARN, opt)
end

return M
