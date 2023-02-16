local fn = vim.fn
local empty = require("goctl.util").empty
---
---Goctl api doc generate.
---
---@param dir?    string default=.
---@param output? string default=api_name
local function goctl_api_generate_doc(dir, output)
	if empty(dir) then
		dir = fn.getcwd()
	end
	local cmd = "goctl api doc --dir " .. dir
	if not empty(output) then
		cmd = cmd .. " -o " .. output
	end
	os.execute(cmd)
end

---@alias apiType
---|>"go"   # Golang
---| "ts"   # Typescript
---| "dart" # Dart
---| "kt"   # Kotlin

---
---Goctl api go generate
---
---@param type    apiType The type of be generated api file
---@param api     string       The api file path
---@param dir?    string       The target dir, default=.
---@param style?  string       The file naming format, default: gozero
---@param branch? string       The branch of the remote repo, it does work with --remote
---@param remote? string       The remote git repo of the template, --home and --remote cannot be set at the same time, if they are, --remote has higher priority. The git repo directory must be consistent with the https://github.com/zeromicro/go-zero-template directory structure
---@param home?   string       The goctl home path of the template, --home and --remote cannot be set at the same time, if they are, --remote has higher priority
local function goctl_api_generate(type, api, dir, opt)
	if empty(api) then
		error("api file can't be empty")
		return
	end
	if empty(dir) then
		dir = fn.getcwd()
	end
	local cmd = "goctl api " .. type .. " --api " .. api .. " --dir " .. dir

	os.execute(cmd)
end

-- opt={
--    go: style, branch, remote, home
--    kt:
--      --pkg string   Define package name for kotlin file
--    ts:
--      --caller string   The web api caller
--      --help            help for ts
--      --unwrap          Unwrap the webapi caller for import
--      --webapi string   The web api file path
--    dart:
--      --api string        The api file
--      --dir string        The target dir
--      --help              help for dart
--      --hostname string   hostname of the server
--      --legacy            Legacy generator for flutter v1
-- }

---
---Fast create api service
---
---@param   name    string The service name
---@param   branch? string The branch of the remote repo, it does work with --remote
---@param   home?   string The goctl home path of the template, --home and --remote cannot be set at the same time, if they are, --remote has higher priority
---@param   remote? string The remote git repo of the template, --home and --remote cannot be set at the same time, if they are, --remote has higher priority. The git repo directory must be consistent with the https://github.com/zeromicro/go-zero-template directory structure
---@param   style?  string The file naming format, see [https://github.com/zeromicro/go-zero/blob/master/tools/goctl/config/readme.md] (default "gozero")
local function goctl_api_fast_new(name)
	if empty(name) then
		error("service name can't be empty")
		return
	end
	local cmd = "goctl api new " .. name
	os.execute(cmd)
end

---
---Generate Dockerfile
---
---@param base    string The base image to build the docker image, default scratch (default "scratch")
---@param branch  string The branch of the remote repo, it does work with --remote
---@param exe     string The executable name in the built image
---@param go      string The file that contains main function
---@param home    string The goctl home path of the template, --home and --remote cannot be set at the same time, if they are, --remote has higher priority
---@param port    int    The port to expose, default none
---@param remote  string The remote git repo of the template, --home and --remote cannot be set at the same time, if they are, --remote has higher priority. The git repo directory must be consistent with the https://github.com/zeromicro/go-zero-template directory structure
---@param tz      string The timezone of the container (default "Asia/Shanghai")
---@param version string The goctl builder golang image version
local function goctl_docker_()
  local cmd = "!goctl docker"
  vim.cmd(cmd)
end

---
---Generate Kubenetes deploy yaml
---
---@param image           string The docker image of deployment (required)
---@param name            string The name of deployment (required)
---@param namespace       string The namespace of deployment (required)
---@param o               string The output yaml file (required)
---@param port            int    The port of the deployment to listen on pod (required)
---@param branch          string The branch of the remote repo, it does work with --remote
---@param home            string The goctl home path of the template, --home and --remote cannot be set at the same time, if they are, --remote has higher priority
---@param imagePullPolicy string Image pull policy. One of Always, Never, IfNotPresent
---@param limitCpu        int    The limit cpu to deploy (default 1000)
---@param limitMem        int    The limit memory to deploy (default 1024)
---@param maxReplicas     int    The max replicas to deploy (default 10)
---@param minReplicas     int    The min replicas to deploy (default 3)
---@param nodePort        int    The nodePort of the deployment to expose
---@param remote          string The remote git repo of the template, --home and --remote cannot be set at the same time, if they are, --remote has higher priority. The git repo directory must be consistent with the https://github.com/zeromicro/go-zero-template directory structure
---@param replicas        int    The number of replicas to deploy (default 3)
---@param requestCpu      int    The request cpu to deploy (default 500)
---@param requestMem      int    The request memory to deploy (default 512)
---@param revisions       int    The number of revision history to limit (default 5)
---@param secret          string The secret to image pull from registry
---@param serviceAccount  string The ServiceAccount for the deployment
---@param targetPort      int    The targetPort of the deployment, default to port
local function goctl_kube_deploy()
  local cmd = "!goctl kube deploy" 
  -- ...
  vim.cmd(cmd)
end



--[[
--  wait develop ......
--]]

---@alias modelType
---|>"mysql"     # MySQL
---| "mongo"     # MongoDB
---| "pg"        # PostgresQL

---
---Generate model file
---
---@param type modelType The type of datebase
---@return  
local function goctl_model(type)
  
end

---
---Fast new a rpc service
---
---@param branch string   The branch of the remote repo, it does work with --remote
---@param home string     The goctl home path of the template, --home and --remote cannot be set at the same time, if they are, --remote has higher priority
---@param idea            Whether the command execution environment is from idea plugin.
---@param remote string   The remote git repo of the template, --home and --remote cannot be set at the same time, if they are, --remote has higher priority. The git repo directory must be consistent with the https://github.com/zeromicro/go-zero-template directory structure
---@param style string    The file naming format, see [https://github.com/zeromicro/go-zero/tree/master/tools/goctl/config/readme.md] (default "gozero")
---@param verbose         Enable log output
local function goctl_rpc_fast_new(name)
  local cmd = "goctl rpc new "..name
  -- ....
  vim.cmd(cmd)
end


---
---Generate a proto file
---
---@param branch string   The branch of the remote repo, it does work with --remote
---@param help            help for template
---@param home string     The goctl home path of the template, --home and --remote cannot be set at the same time, if they are, --remote has higher priority
---@param o string        Output a sample proto file
---@param remote string   The remote git repo of the template, --home and --remote cannot be set at the same time, if they are, --remote has higher priority. The git repo directory must be consistent with the https://github.com/zeromicro/go-zero-template directory structure
local function goctl_rpc_new_proto(output)
  local cmd = "goctl rpc template -o "..output
  -- ......
  vim.cmd(cmd)
end

---
---Generate rpc service by proto file
---
---@param branch string     The branch of the remote repo, it does work with --remote
---@param help              help for protoc
---@param home string       The goctl home path of the template, --home and --remote cannot be set at the same time, if they are, --remote has higher priority
---@param multiple          Generated in multiple rpc service mode
---@param remote string     The remote git repo of the template, --home and --remote cannot be set at the same time, if they are, --remote has higher priority. The git repo directory must be consistent with the https://github.com/zeromicro/go-zero-template directory structure
---@param style string      The file naming format, see [https://github.com/zeromicro/go-zero/tree/master/tools/goctl/config/readme.md] (default "gozero")
---@param verbose           Enable log output
---@param zrpc_out string   The zrpc output directory
local function goctl_rpc_generate(proto)
  --sample
  --goctl rpc protoc xx.proto --go_out=./pb --go-grpc_out=./pb --zrpc_out=.
  local cmd = "goctl rpc "..proto
  -- ......
  vim.cmd(cmd)
end

