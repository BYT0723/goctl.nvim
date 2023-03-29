local M = {}

local Menu = require("nui.menu")
local Input = require("goctl.ui.input")

---
--- new menu component
---
---@param  title string
---@param  items table
---@param  on_submit function
---@param  on_change? function
function M:new(title, items, on_submit, on_change)
	M.items = items

	local lines = {}
	for _, v in ipairs(items) do
		table.insert(lines, Menu.item(v.text, v))
	end
	local menu = Menu({
		position = { row = "30%", col = "50%" },
		size = {
			width = 25,
			height = 10,
		},
		border = {
			style = "single",
			text = {
				top = "[" .. title .. "]",
				top_align = "center",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal",
		},
	}, {
		lines = lines,
		max_width = 30,
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { "<Esc>", "<C-c>" },
			submit = { "<CR>", "<Space>" },
		},
		on_close = function() end,
		on_submit = on_submit,
		on_change = on_change,
	})

	M.payload = menu

	return M
end

function M:newMenu(title, items, on_submit)
	local item_submit = function(item)
		if item.value == "submit" then
			on_submit(M.values)
		else
			M.payload:unmount()
			Input:new(item.key, M.values[item.key], function(value)
				M.values[item.key] = value
				M:renders()
				M:display()
			end):display()
		end
	end

	M.opt = {
		position = { row = "30%", col = "50%" },
		size = {
			width = 25,
			height = 10,
		},
		border = {
			style = "single",
			text = {
				top = "[" .. title .. "]",
				top_align = "center",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal",
		},
	}
	M.prop = {
		lines = {},
		max_width = 30,
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { "<Esc>", "<C-c>" },
			submit = { "<CR>", "<Space>" },
		},
		on_close = function() end,
		on_submit = item_submit,
		on_change = function() end,
	}
	M.items = items
	M.values = {}

	M.prop.on_close = function()
		if M.parent then
			M.parent.payload:display()
		end
	end

	M:renders()

	return M
end

function M:renders()
	M.prop.lines = {}

	for k, v in pairs(M.items) do
		if not M.values[k] then
			M.values[k] = v
		end
		table.insert(M.prop.lines, Menu.item(k .. ": " .. M.values[k], { key = k, value = v }))
	end
	table.insert(M.prop.lines, Menu.separator("", { char = "-" }))
	table.insert(M.prop.lines, Menu.item("OK", { value = "submit" }))

	M.payload = Menu(M.opt, M.prop)
end

function M:display()
	M.payload:mount()
end

return M
