local builtins = {
	Breeze = require(script.Parent.Parent.themes.Breeze), Dark = require(script.Parent.Parent.themes.Dark),
	Light = require(script.Parent.Parent.themes.Light), Midnight = require(script.Parent.Parent.themes.Midnight),
}

return function(initial)
	local current = builtins.Breeze
	local bindings = setmetatable({}, { __mode = "k" })
	local manager = {}

	function manager:Get() return current end
	function manager:Bind(instance, mapping)
		bindings[instance] = mapping
		for property, token in mapping do instance[property] = current[token] end
		return function() bindings[instance] = nil end
	end
	function manager:Set(theme)
		local candidate = type(theme) == "string" and builtins[theme] or theme
		if type(candidate) ~= "table" then warn("[Breeze] Unknown theme; keeping current theme"); return false end
		local merged = table.clone(builtins.Breeze)
		for key, value in candidate do merged[key] = value end
		current = merged
		for instance, mapping in bindings do
			if instance.Parent then for property, token in mapping do instance[property] = current[token] end else bindings[instance] = nil end
		end
		return true
	end
	function manager:Destroy() table.clear(bindings) end
	manager:Set(initial or "Breeze")
	return manager
end
