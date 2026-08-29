local UserInputService = game:GetService("UserInputService")
local Create = require(script.Parent.Parent.utilities.Create)
local Animation = require(script.Parent.Parent.utilities.Animation)
local Validation = require(script.Parent.Parent.utilities.Validation)
local Base = require(script.Parent.Base)

return function(context, config, multiple)
	local handle, frame = Base(context, config, 76)
	local trigger = Create.instance("TextButton", { AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -12, .5, 0), Size = UDim2.fromOffset(150, 34), Text = "", TextTruncate = Enum.TextTruncate.AtEnd, Font = Enum.Font.Gotham, TextSize = 12, AutoButtonColor = false, Parent = frame }); Create.corner(trigger, 8); context.Theme:Bind(trigger, { BackgroundColor3 = "SurfaceSecondary", TextColor3 = "Text" })
	local values = Validation.values(config.Values)
	local selected = multiple and {} or nil
	local popup, outsideConnection
	local function selectedList()
		local output = {}; for _, value in values do if selected[value] then table.insert(output, value) end end; return output
	end
	local function render()
		if multiple then local list = selectedList(); trigger.Text = #list == 0 and "Select…" or table.concat(list, ", ") else trigger.Text = selected or "Select…" end
	end
	local close
	local function emit(fromState)
		local result = multiple and selectedList() or selected
		if config.Flag and not fromState then context.State:Set(config.Flag, result, handle._stateListener) end
		if not fromState then context.Safe("Dropdown: " .. tostring(config.Title), config.Callback, result) end
	end
	local function set(value, fromState)
		if multiple then
			table.clear(selected); if type(value) == "table" then for _, item in value do if table.find(values, tostring(item)) then selected[tostring(item)] = true end end end
		elseif value == nil or table.find(values, tostring(value)) then selected = value and tostring(value) or nil end
		render(); emit(fromState)
	end
	local function build()
		popup = Create.instance("Frame", { AnchorPoint = Vector2.new(0, 0), Position = UDim2.fromOffset(frame.AbsolutePosition.X, frame.AbsolutePosition.Y + frame.AbsoluteSize.Y + 5), Size = UDim2.fromOffset(math.max(frame.AbsoluteSize.X, 220), 210), BorderSizePixel = 0, ZIndex = 110, Parent = context.Overlay.Layer }); Create.corner(popup, 12); context.Theme:Bind(popup, { BackgroundColor3 = "Surface" })
		local viewport = context.Root.AbsoluteSize; if popup.AbsolutePosition.Y + 210 > viewport.Y then popup.Position = UDim2.fromOffset(frame.AbsolutePosition.X, math.max(8, frame.AbsolutePosition.Y - 215)) end
		local search = Create.instance("TextBox", { ClearTextOnFocus = false, PlaceholderText = "Search", Text = "", Font = Enum.Font.Gotham, TextSize = 13, Position = UDim2.fromOffset(10, 9), Size = UDim2.new(1, -20, 0, 32), BackgroundTransparency = .25, ZIndex = 111, Parent = popup }); Create.corner(search, 8); context.Theme:Bind(search, { BackgroundColor3 = "SurfaceSecondary", TextColor3 = "Text", PlaceholderColor3 = "MutedText" })
		local scroll = Create.instance("ScrollingFrame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(8, 49), Size = UDim2.new(1, -16, 1, -57), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ZIndex = 111, Parent = popup })
		local layout = Create.instance("UIListLayout", { Padding = UDim.new(0, 4), Parent = scroll })
		local options = {}
		for _, value in values do
			local option = Create.instance("TextButton", { Text = value, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.new(1, -4, 0, 34), BackgroundTransparency = .45, ZIndex = 112, Parent = scroll }); Create.corner(option, 7); Create.padding(option, 10, 0); context.Theme:Bind(option, { BackgroundColor3 = "SurfaceSecondary", TextColor3 = "Text" })
			option.Activated:Connect(function()
				if multiple then selected[value] = not selected[value]; option.BackgroundTransparency = selected[value] and .05 or .45; render(); emit(false) else set(value); close() end
			end)
			option.BackgroundTransparency = (multiple and selected[value] or selected == value) and .05 or .45; options[option] = value
		end
		search:GetPropertyChangedSignal("Text"):Connect(function() local query = search.Text:lower(); for option, value in options do option.Visible = query == "" or value:lower():find(query, 1, true) ~= nil end end)
		popup.Size = UDim2.fromOffset(math.max(frame.AbsoluteSize.X, 220), 0); Animation.tween(popup, { Size = UDim2.fromOffset(math.max(frame.AbsoluteSize.X, 220), 210) }, .15)
		outsideConnection = UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
			task.defer(function() if popup and popup.Parent then local p, s, pos = popup.AbsolutePosition, popup.AbsoluteSize, input.Position; if pos.X < p.X or pos.X > p.X+s.X or pos.Y < p.Y or pos.Y > p.Y+s.Y then close() end end end)
		end)
	end
	function close() if outsideConnection then outsideConnection:Disconnect(); outsideConnection=nil end; if popup then local old=popup; popup=nil; Animation.tween(old,{Size=UDim2.fromOffset(old.AbsoluteSize.X,0)},.1).Completed:Once(function() old:Destroy() end) end; context.Overlay:Close() end
	trigger.Activated:Connect(function() if handle:IsDisabled() then return end; if popup then close() else context.Overlay:Open(close); build() end end)
	function handle:Set(v) set(v) end; function handle:Get() return multiple and selectedList() or selected end; function handle:Clear() set(multiple and {} or nil) end
	function handle:SetValues(nextValues) values = Validation.values(nextValues); set(handle:Get(), true); if popup then close() end end
	function handle:Open() if not popup then context.Overlay:Open(close); build() end end; function handle:Close() close() end
	local baseDestroy = handle.Destroy; function handle:Destroy() close(); baseDestroy(handle) end
	handle._stateListener = function(v) set(v, true) end
	if config.Flag then handle._cleanup = context.State:Register(config.Flag, config.Default or (multiple and {} or nil), handle._stateListener); set(context.State:Get(config.Flag), true) else set(config.Default, true) end
	return handle
end
