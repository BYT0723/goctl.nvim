local whid = {}
local api = vim.api
local fn = vim.fn

-- define float window and buffer
local buf, win

local function open_window()
	buf = api.nvim_create_buf(false, true)

	api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	api.nvim_buf_set_option(buf, "filetype", "whid")

	local width = api.nvim_get_option("columns")
	local height = api.nvim_get_option("lines")

	local win_width = math.ceil(width * 0.8)
	local win_height = math.ceil(height * 0.8 - 4)

	local row = math.ceil((height - win_height) / 2 - 1)
	local col = math.ceil((width - win_width) / 2)

	local opts = {
		style = "minimal",
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
	}

	local border_opts = {
		style = "minimal",
		relative = "editor",
		width = win_width + 2,
		height = win_height + 2,
		row = row - 1,
		col = col - 1,
	}

	local border_setting = function()
		--border setting
		local border_buf = api.nvim_create_buf(false, true)

		local border_lines = { "╔" .. string.rep("═", win_width) .. "╗" }
		local middle_line = "║" .. string.rep(" ", win_width) .. "║"

		for i = 1, win_height do
			table.insert(border_lines, middle_line)
		end
		table.insert(border_lines, "╚" .. string.rep("═", win_width) .. "╝")

		api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

		api.nvim_open_win(border_buf, true, border_opts)

		return border_buf
	end
	local border_buf = border_setting()

	-- border buf has been set

	win = api.nvim_open_win(buf, true, opts)

	api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "' .. border_buf)

	api.nvim_win_set_option(win, "cursorline", true)
end

local function center(str)
	local width = api.nvim_win_get_width(0)
	local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
	return string.rep(" ", shift) .. str
end

-- 更新试图内容
local function update_view()
	api.nvim_buf_set_option(buf, "modifiable", true)
	local result = fn.systemlist("find -type f")

	for i, _ in pairs(result) do
		result[i] = result[i]
	end

	api.nvim_buf_set_lines(buf, 0, -1, false, { center("Title"), center("Hello world") })
	api.nvim_buf_set_lines(buf, 2, -1, false, result)

	-- add highlight
	api.nvim_buf_add_highlight(buf, -1, "WhidHeader", 0, 0, -1)
	api.nvim_buf_add_highlight(buf, -1, "WhidSubHeader", 1, 0, -1)

	api.nvim_buf_set_option(buf, "modifiable", false)
end

local function set_mappings()
	local mappings = {
		["["] = "update_view()",
		["]"] = "update_view()",
		["<cr>"] = "open_file()",
		h = "update_view()",
		l = "update_view()",
		q = "close_window()",
		k = "move_cursor()",
	}

	for k, v in pairs(mappings) do
		api.nvim_buf_set_keymap(buf, "n", k, ':lua require"whid".' .. v .. "<cr>", {
			nowait = true,
			noremap = true,
			silent = true,
		})
	end

	local other_chars = {
		"a",
		"b",
		"c",
		"d",
		"e",
		"f",
		"g",
		"i",
		"n",
		"o",
		"p",
		"r",
		"s",
		"t",
		"u",
		"v",
		"w",
		"x",
		"y",
		"z",
		"A",
		"B",
		"C",
		"D",
		"E",
		"F",
		"G",
		"I",
		"N",
		"O",
		"P",
		"R",
		"S",
		"T",
		"U",
		"V",
		"W",
		"X",
		"Y",
		"Z",
	}
	for _, v in pairs(other_chars) do
		api.nvim_buf_set_keymap(buf, "n", v, "", { nowait = true, noremap = true, silent = true })
		api.nvim_buf_set_keymap(buf, "n", v:upper(), "", { nowait = true, noremap = true, silent = true })
		api.nvim_buf_set_keymap(buf, "n", "<c-" .. v .. ">", "", { nowait = true, noremap = true, silent = true })
	end
end

function whid.close_window()
	api.nvim_win_close(win, true)
end

function whid.move_cursor()
	local new_pos = math.max(1, api.nvim_win_get_cursor(win)[1] - 1)
	api.nvim_win_set_cursor(win, { new_pos, 0 })
end

function whid.open_file()
	local str = api.nvim_get_current_line()
	api.nvim_command("edit " .. str)
	whid.close_window()
end

function whid.init()
	open_window()
	set_mappings()
	update_view()
end

return whid
