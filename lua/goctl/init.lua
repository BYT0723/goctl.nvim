local common = require("goctl.common")

local function init()
  if not common.goctl_check() then
    common.goctl_install()
  end
end

return {
  init = init
}

