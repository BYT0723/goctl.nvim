local M = {}

local api = vim.api
local fn = vim.fn

---Check goctl binary
function M.goctl_check()
	local status = false
	local gopath = os.getenv("GOPATH")
	if gopath == "" then
		error("%GOPATH not found")
		return status
	end
	local goctl, _ = io.open(os.getenv("GOPATH") .. "/bin/goctl", "r")
	if goctl ~= nil then
		status = true
		goctl:close()
	end
	return status
end

---Install goctl
function M.goctl_install()
	local cmd = "GOPROXY=https://goproxy.cn/,direct go install github.com/zeromicro/go-zero/tools/goctl@latest"
	fn.jobstart(cmd)

	cmd = "!goctl env check -i -f -v"
	fn.jobstart(cmd)
end

---Upgrade goctl
function M.goctl_upgrade()
	local cmd = "goctl upgrade"
	fn.jobstart(cmd)
end

---Check goctl environment
function M.goctl_env()
	local cmd = "!goctl env"
	api.nvim_exec(cmd, false)
end

return M
