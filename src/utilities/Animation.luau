local TweenService = game:GetService("TweenService")
local active = setmetatable({}, { __mode = "k" })
local Animation = {}

function Animation.tween(object, properties, duration, style, direction)
	if active[object] then active[object]:Cancel() end
	local tween = TweenService:Create(object, TweenInfo.new(duration or 0.16, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out), properties)
	active[object] = tween
	tween.Completed:Once(function() if active[object] == tween then active[object] = nil end end)
	tween:Play()
	return tween
end

function Animation.cancel(object)
	if active[object] then active[object]:Cancel(); active[object] = nil end
end

return Animation
