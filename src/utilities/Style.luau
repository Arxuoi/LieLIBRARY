local Create = require(script.Parent.Create)
local Style = {}
function Style.text(theme, parent, props)
	props = props or {}; props.BackgroundTransparency = 1; props.Font = props.Font or Enum.Font.Gotham
	props.TextSize = props.TextSize or 14; props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
	props.Parent = parent
	local label = Create.instance("TextLabel", props); theme:Bind(label, { TextColor3 = props.Muted and "MutedText" or "Text" }); return label
end
function Style.panel(theme, parent, props)
	props = props or {}; props.Parent = parent; props.BorderSizePixel = 0
	local frame = Create.instance("Frame", props); theme:Bind(frame, { BackgroundColor3 = "Surface" })
	Create.corner(frame, theme:Get().CornerRadius); local stroke = Create.stroke(frame, theme:Get().Stroke); theme:Bind(stroke, { Color = "Stroke" }); return frame
end
return Style
