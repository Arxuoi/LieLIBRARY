local Create = require(script.Parent.Parent.utilities.Create)
local Animation = require(script.Parent.Parent.utilities.Animation)
local Base = require(script.Parent.Base)

return function(context, config)
	local min, max = tonumber(config.Min) or 0, tonumber(config.Max) or 100
	if min > max then min, max = max, min end
	if min == max then max = min + 1 end
	local increment = math.max(math.abs(tonumber(config.Increment) or 1), 1e-6)
	local handle, frame = Base(context, config, 78)
	local valueLabel = Create.instance("TextLabel", { BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, Position = UDim2.new(1, -74, 0, 9), Size = UDim2.fromOffset(60, 19), Parent = frame }); context.Theme:Bind(valueLabel, { TextColor3 = "Accent" })
	local track = Create.instance("Frame", { Active = true, Position = UDim2.new(0, 14, 1, -20), Size = UDim2.new(1, -28, 0, 8), BorderSizePixel = 0, Parent = frame }); Create.corner(track, 4); context.Theme:Bind(track, { BackgroundColor3 = "SurfaceSecondary" })
	local fill = Create.instance("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, Parent = track }); Create.corner(fill, 4); context.Theme:Bind(fill, { BackgroundColor3 = "Accent" })
	local value = min
	local function set(raw, fromState)
		local number = math.clamp(tonumber(raw) or min, min, max); number = min + math.floor(((number - min) / increment) + .5) * increment; number = math.clamp(number, min, max)
		value = number; valueLabel.Text = tostring(number); Animation.tween(fill, { Size = UDim2.fromScale((number - min) / (max - min), 1) }, .08)
		if config.Flag and not fromState then context.State:Set(config.Flag, value, set) end
		if not fromState then context.Safe("Slider: " .. tostring(config.Title), config.Callback, value) end
	end
	context.Input:TrackDrag(track, function(position) if handle:IsDisabled() then return end; set(min + math.clamp((position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1) * (max - min)) end)
	function handle:Set(v) set(v) end; function handle:Get() return value end
	if config.Flag then handle._cleanup = context.State:Register(config.Flag, config.Default or min, set) end
	set(config.Flag and context.State:Get(config.Flag) or config.Default or min, true)
	return handle
end
