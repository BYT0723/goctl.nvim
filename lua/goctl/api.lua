local M = {}

local api, fn = vim.api, vim.fn
local input = require("goctl.ui.input")
local menu = require("goctl.ui.menu")

local job = require("goctl.job")
local notify = require("goctl.notify")
local util = require("goctl.util")

---
--- validate stderr event
---
local function on_validate_stderr(_, data)
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

      -- stylua: ignore
			vim.diagnostic.set(ns, 0, {{
					bufnr = 0,
					lnum = row - 1,
					col = col,
					message = msg,
				}}, nil)
	end
end

---
--- format stdout event
---
local function on_format_stdout(_, data)
	if table.concat(data) ~= "" then
		api.nvim_buf_set_lines(0, 0, -1, false, data)
	end
end

---
---Validate api file
---
function M.validate()
	local cmd = { "goctl", "api", "format", "--stdin" }
	local job_id = fn.jobstart(cmd, {
		on_stderr = on_validate_stderr,
		stderr_buffered = true,
	})
	local lines = api.nvim_buf_get_lines(0, 0, -1, false)
	fn.chansend(job_id, lines)
	fn.chanclose(job_id, "stdin")
end

---
---Format api file
---
function M.format()
	local cmd = { "goctl", "api", "format --stdin" }
	local job_id = fn.jobstart(cmd, {
		on_stdout = on_format_stdout,
		stdout_buffered = true,
	})
	local lines = api.nvim_buf_get_lines(0, 0, -1, false)
	fn.chansend(job_id, lines)
	fn.chanclose(job_id, "stdin")
end

function M.new()
	local cmd = { "goctl", "api", "new" }

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

function M.doc()
	local cmd = { "goctl", "api", "doc", "--dir", "." }
	job:new(cmd)
end

function M.generate()
	local cmd = { "goctl", "api" }
	local type = "go"

	local pkg_submit = function(value)
		local pkg = vim.trim(value)
		if pkg == "" then
			return
		end

		table.insert(cmd, "--pkg")
		table.insert(cmd, pkg)

		job:new(cmd)
	end

	local ts_webapi_submit = function(item)
    -- stylua: ignore
		input:new(item.text, "", function(value)
			local path = vim.trim(value)
			if path == "" then
				return
			end
      table.insert(cmd, item.id)
      table.insert(cmd, path)

      job:new(cmd)
		end):display()
	end

	local dart_hostname_submit = function(value)
		local path = vim.trim(value)
		if path == "" then
			return
		end
		table.insert(cmd, "--hostname")
		table.insert(cmd, path)

		job:new(cmd)
	end

	local dir_submit = function(value)
		local path = vim.trim(value)
		if path == "" then
			return
		end

		table.insert(cmd, "--api")
		table.insert(cmd, util.absolute_path())

		table.insert(cmd, "--dir")
		table.insert(cmd, util.cwd() .. "/" .. path)

		if type == "go" then
			job:new(cmd)
		elseif type == "kt" then
			input:new("Package", util.filename_ex_suffix(), pkg_submit):display()
		elseif type == "ts" then
			menu:new("Web Api", {
				{ text = "Caller", id = "--caller" },
				{ text = "WebApi", id = "--webapi" },
			}, ts_webapi_submit):display()
		elseif type == "dart" then
      -- stylua: ignore
			input:new("Hostname", "", dart_hostname_submit):display()
		end
	end

	local type_submit = function(item)
		table.insert(cmd, item.id)
		type = item.id
		input:new("Path", util.filename_ex_suffix(), dir_submit):display()
	end

	menu:new("Api Generate", {
		{ text = "Golang", id = "go" },
		{ text = "Typescript", id = "ts" },
		{ text = "Dart", id = "dart" },
		{ text = "Kotlin", id = "kt" },
	}, type_submit):display()
end

function M.menu()
	local on_submit = function(item)
		M[item.id]()
	end
	menu:new("Api Dashboard", {
		{ text = "New Service", id = "new" },
		{ text = "Generate Service", id = "generate" },
		{ text = "Generate Document", id = "doc" },
	}, on_submit):display()
end

return M
