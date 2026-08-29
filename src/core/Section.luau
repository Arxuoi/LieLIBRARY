local Create = require(script.Parent.Parent.utilities.Create)
local Style = require(script.Parent.Parent.utilities.Style)
local Animation = require(script.Parent.Parent.utilities.Animation)
local Basic = require(script.Parent.Parent.components.Basic)
local Slider = require(script.Parent.Parent.components.Slider)
local Input = require(script.Parent.Parent.components.Input)
local Dropdown = require(script.Parent.Parent.components.Dropdown)
local Keybind = require(script.Parent.Parent.components.Keybind)

return function(context, config)
	local root = Style.panel(context.Theme, context.Parent, { Name = config.Title or "Section", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = .35 })
	local header = Create.instance("TextButton", { Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, config.Description and 58 or 44), Parent = root })
	Style.text(context.Theme, header, { Text = tostring(config.Title or "Section"), Position = UDim2.fromOffset(14, 10), Size = UDim2.new(1, -28, 0, 18), Font = Enum.Font.GothamMedium })
	Style.text(context.Theme, header, { Text = tostring(config.Description or ""), Visible = config.Description ~= nil, Position = UDim2.fromOffset(14, 30), Size = UDim2.new(1, -28, 0, 16), TextSize = 12, Muted = true })
	local content = Create.instance("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(10, config.Description and 58 or 44), Size = UDim2.new(1, -20, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = root })
	Create.instance("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = content }); Create.padding(content, 0, 8)
	local collapsed, destroyed = config.Collapsed == true, false
	local controls = {}
	local section = { Instance = root }
	local childContext = table.clone(context); childContext.Parent = content
	local function add(factory, options, ...)
		if destroyed then error("Cannot add a control to a destroyed section", 2) end
		local control = factory(childContext, type(options) == "table" and options or {}, ...); table.insert(controls, control); return control
	end
	function section:AddButton(c) return add(Basic.Button, c) end
	function section:AddToggle(c) return add(Basic.Toggle, c) end
	function section:AddCheckbox(c) return add(Basic.Checkbox, c) end
	function section:AddSlider(c) return add(Slider, c) end
	function section:AddInput(c) return add(Input, c) end
	function section:AddTextbox(c) c = type(c)=="table" and table.clone(c) or {}; c.Multiline=true; return add(Input,c) end
	function section:AddDropdown(c) return add(Dropdown, c, false) end
	function section:AddMultiDropdown(c) return add(Dropdown, c, true) end
	function section:AddKeybind(c) return add(Keybind, c) end
	function section:AddLabel(c) return add(Basic.Label, c) end
	function section:AddParagraph(c) return add(Basic.Paragraph, c) end
	function section:AddDivider(c) return add(Basic.Divider, c) end
	function section:AddImage(c) return add(Basic.Image, c) end
	function section:AddProgressBar(c) return add(Basic.ProgressBar, c) end
	function section:SetCollapsed(value)
		collapsed = value == true; content.Visible = not collapsed
		Animation.tween(root, { BackgroundTransparency = collapsed and .52 or .35 }, .15)
	end
	function section:Toggle() self:SetCollapsed(not collapsed) end
	function section:SetVisible(v) root.Visible = v ~= false end
	function section:Destroy() if destroyed then return end; destroyed=true; for _, control in controls do control:Destroy() end; root:Destroy() end
	header.Activated:Connect(function() section:Toggle() end); section:SetCollapsed(collapsed)
	return section
end
