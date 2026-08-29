return function()
	local values, defaults, listeners = {}, {}, {}
	local state = { Flags = values }
	function state:Register(flag, defaultValue, listener)
		if not flag then return function() end end
		if defaults[flag] == nil then defaults[flag] = defaultValue end
		if values[flag] == nil then values[flag] = defaultValue end
		listeners[flag] = listeners[flag] or {}; table.insert(listeners[flag], listener)
		return function() local list = listeners[flag]; if list then local i = table.find(list, listener); if i then table.remove(list, i) end end end
	end
	function state:Get(flag) return values[flag] end
	function state:Set(flag, value, source)
		values[flag] = value
		for _, listener in listeners[flag] or {} do if listener ~= source then listener(value, true) end end
	end
	function state:Reset()
		for flag, value in defaults do self:Set(flag, value) end
	end
	function state:Destroy() table.clear(values); table.clear(defaults); table.clear(listeners) end
	return state
end
