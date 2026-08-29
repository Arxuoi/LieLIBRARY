local UserInputService=game:GetService("UserInputService"); local Create=require(script.Parent.Parent.utilities.Create); local Style=require(script.Parent.Parent.utilities.Style); local Animation=require(script.Parent.Parent.utilities.Animation)
return function(context)
	local dialogs={}; local manager={}
	function manager:Dialog(config)
		config=type(config)=="table" and config or {}; local backdrop=Create.instance("TextButton",{Text="",AutoButtonColor=false,BackgroundColor3=Color3.new(),BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=300,Parent=context.Root})
		local card=Style.panel(context.Theme,backdrop,{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(0,0),BackgroundTransparency=.03,ZIndex=301})
		Style.text(context.Theme,card,{Text=tostring(config.Title or "Notice"),Font=Enum.Font.GothamBold,TextSize=18,Position=UDim2.fromOffset(20,18),Size=UDim2.new(1,-40,0,24),ZIndex=302})
		Style.text(context.Theme,card,{Text=tostring(config.Content or ""),TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top,Position=UDim2.fromOffset(20,54),Size=UDim2.new(1,-40,0,80),Muted=true,ZIndex=302})
		local buttons=Create.instance("Frame",{BackgroundTransparency=1,Position=UDim2.new(0,20,1,-58),Size=UDim2.new(1,-40,0,40),ZIndex=302,Parent=card}); Create.instance("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Right,Padding=UDim.new(0,8),Parent=buttons})
		local handle={}; local closed=false; local connection
		function handle:Close() if closed then return end; closed=true; if connection then connection:Disconnect() end; local i=table.find(dialogs,handle); if i then table.remove(dialogs,i) end; Animation.tween(backdrop,{BackgroundTransparency=1},.15); Animation.tween(card,{Size=UDim2.fromOffset(380,0)},.15).Completed:Once(function() backdrop:Destroy() end) end
		for _,option in (type(config.Buttons)=="table" and config.Buttons or {{Title="Okay"}}) do local button=Create.instance("TextButton",{Text=tostring(option.Title or "Okay"),Font=Enum.Font.GothamMedium,TextSize=13,Size=UDim2.fromOffset(110,38),ZIndex=303,Parent=buttons}); Create.corner(button,9); context.Theme:Bind(button,{BackgroundColor3=option.Primary and "Accent" or "SurfaceSecondary",TextColor3="Text"}); button.Activated:Connect(function() context.Safe("Dialog: "..tostring(option.Title),option.Callback); if option.Close~=false then handle:Close() end end) end
		if config.DismissOnOutside then backdrop.Activated:Connect(function() handle:Close() end) end
		connection=UserInputService.InputBegan:Connect(function(input,processed) if not processed and (input.KeyCode==Enum.KeyCode.Escape or input.KeyCode==Enum.KeyCode.ButtonB) then handle:Close() end end)
		table.insert(dialogs,handle); Animation.tween(backdrop,{BackgroundTransparency=.42},.15); Animation.tween(card,{Size=UDim2.fromOffset(math.min(context.Root.AbsoluteSize.X-32,420),210)},.2); return handle
	end
	function manager:Destroy() for i=#dialogs,1,-1 do dialogs[i]:Close() end end
	return manager
end
