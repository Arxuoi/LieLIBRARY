local Create = require(script.Parent.Parent.utilities.Create)
local Animation = require(script.Parent.Parent.utilities.Animation)
local Base = require(script.Parent.Base)

local Basic = {}

function Basic.Button(context, config)
	local handle, frame = Base(context, config)
	local button = Create.instance("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.fromScale(1, 1), ZIndex = 3, AutoButtonColor = false, Selectable = true, Parent = frame })
	button.MouseEnter:Connect(function() if not handle:IsDisabled() then Animation.tween(frame, { BackgroundTransparency = 0.02 }, 0.12) end end)
	button.MouseLeave:Connect(function() Animation.tween(frame, { BackgroundTransparency = context.Theme:Get().Transparency }, 0.12) end)
	button.Activated:Connect(function() if handle:IsDisabled() then return end; Animation.tween(frame, { Size = UDim2.new(1, -4, 0, 56) }, 0.07); task.delay(0.08, function() if frame.Parent then Animation.tween(frame, { Size = UDim2.new(1, 0, 0, 58) }, 0.1) end end); context.Safe("Button: " .. tostring(config.Title), config.Callback) end)
	return handle
end

local function binary(context, config, checkbox)
	local handle, frame = Base(context, config)
	local track = Create.instance("Frame", { AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -14, .5, 0), Size = checkbox and UDim2.fromOffset(24, 24) or UDim2.fromOffset(42, 24), BorderSizePixel = 0, Parent = frame })
	Create.corner(track, checkbox and 6 or 12)
	local knob = Create.instance("Frame", { Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(3, 3), BorderSizePixel = 0, Parent = track }); Create.corner(knob, checkbox and 4 or 9)
	context.Theme:Bind(track, { BackgroundColor3 = "SurfaceSecondary" }); context.Theme:Bind(knob, { BackgroundColor3 = "Text" })
	local value = config.Default == true
	local function render(animated)
		local theme = context.Theme:Get(); local trackColor = value and theme.Accent or theme.SurfaceSecondary
		local pos = checkbox and UDim2.fromOffset(3, 3) or UDim2.fromOffset(value and 21 or 3, 3)
		if animated then Animation.tween(track, { BackgroundColor3 = trackColor }, .15); Animation.tween(knob, { Position = pos, BackgroundTransparency = checkbox and (value and 0 or 1) or 0 }, .15)
		else track.BackgroundColor3 = trackColor; knob.Position = pos; knob.BackgroundTransparency = checkbox and (value and 0 or 1) or 0 end
	end
	local function set(nextValue, fromState)
		value = nextValue == true; render(true)
		if config.Flag and not fromState then context.State:Set(config.Flag, value, set) end
		if not fromState then context.Safe((checkbox and "Checkbox: " or "Toggle: ") .. tostring(config.Title), config.Callback, value) end
	end
	local button = Create.instance("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.fromScale(1, 1), ZIndex = 3, Parent = frame })
	button.Activated:Connect(function() if not handle:IsDisabled() then set(not value) end end)
	function handle:Set(v) set(v) end; function handle:Get() return value end
	if config.Flag then handle._cleanup = context.State:Register(config.Flag, value, set); value = context.State:Get(config.Flag) end
	render(false); return handle
end
function Basic.Toggle(context, config) return binary(context, config, false) end
function Basic.Checkbox(context, config) return binary(context, config, true) end

function Basic.Label(context, config)
	local handle, _, title = Base(context, config, config.Description and 58 or 42); title.Position = UDim2.fromOffset(14, config.Description and 9 or 11); return handle
end
function Basic.Paragraph(context, config)
	local handle, frame, title, description = Base(context, config, 76); description.TextWrapped = true; description.TextYAlignment = Enum.TextYAlignment.Top; description.Size = UDim2.new(1, -28, 0, 38); return handle
end
function Basic.Divider(context, config)
	local line = Create.instance("Frame", { Name = config.Title or "Divider", Size = UDim2.new(1, 0, 0, 17), BackgroundTransparency = 1, Parent = context.Parent })
	local rule = Create.instance("Frame", { Position = UDim2.new(0, 0, .5, 0), Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0, Parent = line }); context.Theme:Bind(rule, { BackgroundColor3 = "Stroke" })
	return { Instance = line, SetVisible = function(_, v) line.Visible = v ~= false end, Destroy = function() line:Destroy() end }
end
function Basic.Image(context, config)
	local handle, frame = Base(context, config, config.Height or 160)
	local image = Create.instance("ImageLabel", { BackgroundTransparency = 1, Image = context.Icons(config.Image), Position = UDim2.fromOffset(10, 10), Size = UDim2.new(1, -20, 1, -20), ScaleType = Enum.ScaleType.Fit, Parent = frame })
	function handle:Set(v) image.Image = context.Icons(v) end; function handle:Get() return image.Image end; return handle
end
function Basic.ProgressBar(context, config)
	local handle, frame = Base(context, config, 70)
	local track = Create.instance("Frame", { Position = UDim2.new(0, 14, 1, -16), Size = UDim2.new(1, -28, 0, 7), BorderSizePixel = 0, Parent = frame }); Create.corner(track, 4); context.Theme:Bind(track, { BackgroundColor3 = "SurfaceSecondary" })
	local fill = Create.instance("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, Parent = track }); Create.corner(fill, 4); context.Theme:Bind(fill, { BackgroundColor3 = "Accent" })
	local value = 0; function handle:Set(v) value = math.clamp(tonumber(v) or 0, 0, 1); Animation.tween(fill, { Size = UDim2.fromScale(value, 1) }, .18) end; function handle:Get() return value end; handle:Set(config.Default or 0); return handle
end
return Basic
