local M = {}

local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

---
--- new a input component
---
---@param title string
---@param default string
---@param on_submit function
function M:new(title, default, on_submit)
	local input = Input({
		position = "50%",
		size = {
			width = 30,
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
		prompt = "=> ",
		default_value = default,
		on_close = function() end,
		on_submit = on_submit,
	})

	input:on(event.BufLeave, function()
		input:unmount()
	end)

	M.payload = input

	return M
end

function M:display()
	M.payload:on(event.BufLeave, function()
		M.payload:unmount()
	end)

	M.payload:mount()
end

return M
