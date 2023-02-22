---Check goctl binary
local function goctl_check()
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
local function goctl_install()
	local cmd = "GOPROXY=https://goproxy.cn/,direct go install github.com/zeromicro/go-zero/tools/goctl@latest"
	os.execute(cmd)
end

---Upgrade goctl
local function goctl_upgrade()
	local cmd = "goctl upgrade"
	os.execute(cmd)
end

---Check goctl environment
local function goctl_env()
	local cmd = "!goctl env"
	vim.cmd(cmd)
end

return {
	goctl_check = goctl_check,
	goctl_install = goctl_install,
	goctl_upgrade = goctl_upgrade,
	goctl_env = goctl_env,
}
