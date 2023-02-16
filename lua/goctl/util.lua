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
