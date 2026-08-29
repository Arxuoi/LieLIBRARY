local Create = require(script.Parent.Parent.utilities.Create)
return function(root, cleanup)
	local layer = Create.instance("Frame", { Name = "Overlays", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 100, Parent = root })
	cleanup:Add(layer)
	local current
	local manager = { Layer = layer }
	function manager:Close()
		if current then local close = current; current = nil; close() end
	end
	function manager:Open(close) self:Close(); current = close end
	function manager:IsOpen(close) return current == close end
	return manager
end
