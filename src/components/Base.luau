local Create = require(script.Parent.Parent.utilities.Create)
local Style = require(script.Parent.Parent.utilities.Style)

return function(context, config, height)
	local frame = Style.panel(context.Theme, context.Parent, { Name = config.Title or "Control", Size = UDim2.new(1, 0, 0, height or 58), BackgroundTransparency = context.Theme:Get().Transparency })
	local title = Style.text(context.Theme, frame, { Text = tostring(config.Title or ""), Position = UDim2.fromOffset(14, 9), Size = UDim2.new(1, -28, 0, 19), TextTruncate = Enum.TextTruncate.AtEnd })
	local description = Style.text(context.Theme, frame, { Text = tostring(config.Description or ""), Position = UDim2.fromOffset(14, 30), Size = UDim2.new(1, -28, 0, 16), TextSize = 12, Muted = true, TextTruncate = Enum.TextTruncate.AtEnd, Visible = config.Description ~= nil })
	local blocker = Create.instance("Frame", { BackgroundTransparency = 0.45, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 8, Visible = config.Disabled == true, Parent = frame })
	Create.corner(blocker, context.Theme:Get().CornerRadius); context.Theme:Bind(blocker, { BackgroundColor3 = "Background" })
	local destroyed, disabled = false, config.Disabled == true
	local handle = { Instance = frame }
	function handle:SetTitle(value) title.Text = tostring(value or "") end
	function handle:SetDescription(value) description.Text = tostring(value or ""); description.Visible = value ~= nil and value ~= "" end
	function handle:SetVisible(value) frame.Visible = value ~= false end
	function handle:SetDisabled(value) disabled = value == true; blocker.Visible = disabled end
	function handle:IsDisabled() return disabled end
	function handle:Destroy() if destroyed then return end; destroyed = true; frame:Destroy(); if handle._cleanup then handle._cleanup() end end
	frame.Visible = config.Visible ~= false
	return handle, frame, title, description
end
