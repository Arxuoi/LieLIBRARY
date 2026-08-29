local UserInputService = game:GetService("UserInputService")
local Create = require(script.Parent.Parent.utilities.Create)
local Base = require(script.Parent.Base)

return function(context, config)
	local handle, frame = Base(context, config)
	local key = typeof(config.Default) == "EnumItem" and config.Default or Enum.KeyCode.Unknown
	local listening = false
	local button = Create.instance("TextButton", { AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -12, .5, 0), Size = UDim2.fromOffset(90, 32), Text = "", Font = Enum.Font.GothamMedium, TextSize = 12, AutoButtonColor = false, Parent = frame }); Create.corner(button, 8); context.Theme:Bind(button, { BackgroundColor3 = "SurfaceSecondary", TextColor3 = "Text" })
	local function render() button.Text = listening and "Press a key…" or (key == Enum.KeyCode.Unknown and "Unbound" or key.Name) end
	button.Activated:Connect(function() if not handle:IsDisabled() then listening = true; render() end end)
	local connection = UserInputService.InputBegan:Connect(function(input, processed)
		if listening then
			if input.KeyCode == Enum.KeyCode.Escape then listening = false elseif input.KeyCode ~= Enum.KeyCode.Unknown then key = input.KeyCode; listening = false; context.Safe("Keybind changed: " .. tostring(config.Title), config.Changed, key) end
			render(); return
		end
		if not processed and not handle:IsDisabled() and input.KeyCode == key then context.Safe("Keybind: " .. tostring(config.Title), config.Callback, key) end
	end)
	handle._cleanup = function() connection:Disconnect() end
	function handle:Set(v) if typeof(v) == "EnumItem" then key = v; render() end end; function handle:Get() return key end; function handle:Cancel() listening = false; render() end
	render(); return handle
end
