local M = {}

local menu = require("goctl.ui.menu")
local notify = require("goctl.notify")
local util = require("goctl.util")
local job = require("goctl.job")

function M.menu()
	local cmd = { "goctl", "model" }
	local type_submit = function(item)
		if item.key ~= item.value then
			table.insert(cmd, item.key)
		end
		table.insert(cmd, item.value)

		if item.value == "ddl" then
			local on_submit = function(kv)
				for k, v in pairs(kv) do
					table.insert(cmd, "-" .. k)
					table.insert(cmd, v)
				end
				job:new(cmd)
			end
			menu:newMenu(item.text, { src = util.relative_path(), dir = "." }, on_submit):display()
		else
			local datasource = {
				user = "root",
				pass = "",
				host = "localhost",
				port = "3306",
				database = "",
				params = "",
			}
			local datasourceFmt = "%s:%s@tcp(%s:%s)/%s?%s"

			if item.value == "pg" then
				datasource.user = "postgres"
				datasource.port = 5432
				datasourceFmt = "postgres://%s:%s@%s:%s/%s?%s"
			end

			local on_submit = function(kv)
				local datasourceStr =
					string.format(datasourceFmt, kv.user, kv.pass, kv.host, kv.port, kv.database, kv.params)
				table.insert(cmd, "datasource")
				table.insert(cmd, "--url")
				table.insert(cmd, datasourceStr)

				job:new(cmd)
			end

			menu:newMenu("DataSource", datasource, on_submit):display()
		end
	end

	menu:new("Model", {
		{ text = "MYSQL", key = "mysql", value = "mysql" },
		{ text = "PostgreSQL", key = "pg", value = "pg" },
		{ text = "MongoDB", key = "mongo", value = "mongo" },
		{ text = "DDL", key = "mysql", value = "ddl" },
	}, type_submit):display()
end

return M
