local UserInputService = game:GetService("UserInputService")
return function(cleanup)
	local manager = { LastInput = UserInputService:GetLastInputType() }
	local listeners = {}
	cleanup:Add(UserInputService.LastInputTypeChanged:Connect(function(kind)
		manager.LastInput = kind
		for _, callback in listeners do callback(kind) end
	end))
	function manager:OnInputChanged(callback) table.insert(listeners, callback); return function() local i = table.find(listeners, callback); if i then table.remove(listeners, i) end end end
	function manager:IsTouch() return UserInputService.TouchEnabled and not UserInputService.MouseEnabled end
	function manager:TrackDrag(target, onMove, onEnd)
		local dragging, input
		cleanup:Add(target.InputBegan:Connect(function(began)
			if began.UserInputType == Enum.UserInputType.MouseButton1 or began.UserInputType == Enum.UserInputType.Touch then dragging = true; input = began end
		end))
		cleanup:Add(UserInputService.InputChanged:Connect(function(changed)
			if dragging and (changed == input or changed.UserInputType == Enum.UserInputType.MouseMovement or changed.UserInputType == Enum.UserInputType.Touch) then onMove(changed.Position) end
		end))
		cleanup:Add(UserInputService.InputEnded:Connect(function(ended)
			if dragging and (ended == input or ended.UserInputType == Enum.UserInputType.MouseButton1) then dragging = false; if onEnd then onEnd() end end
		end))
	end
	return manager
end
