---
---Check whether obj is empty
---
---@param obj any
---
---If type of obj is string, when obj is empty string, return true
local function empty(obj)
	if obj == nil then
		return true
	end
	if type(obj) == string and obj == "" then
		return true
	end

	return false
end

return {
	empty = empty,
}
