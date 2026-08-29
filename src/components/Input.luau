local Create = require(script.Parent.Parent.utilities.Create)
local Base = require(script.Parent.Base)

return function(context, config)
	local handle, frame = Base(context, config, config.Multiline and 112 or 82)
	local box = Create.instance("TextBox", { ClearTextOnFocus = false, MultiLine = config.Multiline == true, TextWrapped = config.Multiline == true, PlaceholderText = tostring(config.Placeholder or "Type here"), Text = tostring(config.Default or ""), Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = config.Multiline and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center, Position = UDim2.fromOffset(12, 51), Size = UDim2.new(1, -24, 0, config.Multiline and 50 or 22), BackgroundTransparency = 1, Parent = frame })
	context.Theme:Bind(box, { TextColor3 = "Text", PlaceholderColor3 = "MutedText" })
	local value = box.Text
	local function normalize(text)
		if config.Numeric then text = text:gsub("[^%d%.%-]", "") end
		local limit = tonumber(config.CharacterLimit); if limit and #text > limit then text = text:sub(1, limit) end
		return text
	end
	local function set(text, fromState)
		value = normalize(tostring(text or "")); if box.Text ~= value then box.Text = value end
		if config.Flag and not fromState then context.State:Set(config.Flag, value, set) end
	end
	box:GetPropertyChangedSignal("Text"):Connect(function() set(box.Text); context.Safe("Input changed: " .. tostring(config.Title), config.Changed, value) end)
	box.FocusLost:Connect(function(enter) context.Safe("Input submitted: " .. tostring(config.Title), config.Callback, value, enter) end)
	function handle:Set(v) set(v) end; function handle:Get() return value end; function handle:Focus() box:CaptureFocus() end; function handle:Clear() set("") end
	if config.Flag then handle._cleanup = context.State:Register(config.Flag, value, set); set(context.State:Get(config.Flag), true) end
	return handle
end
