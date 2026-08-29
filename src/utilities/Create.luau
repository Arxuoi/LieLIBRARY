local Create = {}

function Create.instance(className, properties, children)
	local object = Instance.new(className)
	for key, value in properties or {} do
		if key ~= "Parent" then object[key] = value end
	end
	for _, child in children or {} do child.Parent = object end
	if properties and properties.Parent then object.Parent = properties.Parent end
	return object
end

function Create.corner(parent, radius)
	return Create.instance("UICorner", { CornerRadius = UDim.new(0, radius), Parent = parent })
end

function Create.stroke(parent, color, transparency)
	return Create.instance("UIStroke", { Color = color, Transparency = transparency or 0.55, Thickness = 1, Parent = parent })
end

function Create.padding(parent, horizontal, vertical)
	return Create.instance("UIPadding", { PaddingLeft = UDim.new(0, horizontal), PaddingRight = UDim.new(0, horizontal), PaddingTop = UDim.new(0, vertical), PaddingBottom = UDim.new(0, vertical), Parent = parent })
end

return Create
