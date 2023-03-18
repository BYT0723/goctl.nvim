local M = {}

local api, fn = vim.api, vim.fn

function M.cwd()
	return fn.getcwd()
end

function M.project_name()
	return fn.fnamemodify(M.cwd(), ":t")
end

function M.absolute_path()
	return api.nvim_buf_get_name(0)
end

function M.relative_path()
	return fn.fnamemodify(M.absolute_path(), ":.")
end

function M.relative_path_ex_name()
	return fn.fnamemodify(M.absolute_path(), ":h")
end

function M.filename()
	return fn.fnamemodify(M.absolute_path(), ":t")
end

function M.filename_ex_suffix()
	return fn.fnamemodify(M.absolute_path(), ":t:r")
end

return M
