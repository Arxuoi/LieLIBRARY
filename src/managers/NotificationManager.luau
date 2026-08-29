local Create=require(script.Parent.Parent.utilities.Create); local Style=require(script.Parent.Parent.utilities.Style); local Animation=require(script.Parent.Parent.utilities.Animation)
return function(context)
	local host=Create.instance("Frame",{BackgroundTransparency=1,AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-16,1,-16),Size=UDim2.fromOffset(330,500),ZIndex=200,Parent=context.Root}); Create.instance("UIListLayout",{VerticalAlignment=Enum.VerticalAlignment.Bottom,Padding=UDim.new(0,8),Parent=host})
	local active={}; local manager={}
	function manager:Notify(config)
		config=type(config)=="table" and config or {}; while #active>=5 do active[1]:Dismiss() end
		local card=Style.panel(context.Theme,host,{Size=UDim2.new(1,0,0,88),BackgroundTransparency=.05,ZIndex=201}); card.Position=UDim2.fromOffset(35,0)
		local token=({Success="Success",Warning="Warning",Error="Error",Info="Accent"})[config.Type] or "Accent"
		local accent=Create.instance("Frame",{Size=UDim2.new(0,4,1,-18),Position=UDim2.fromOffset(5,9),BorderSizePixel=0,ZIndex=202,Parent=card}); Create.corner(accent,2); context.Theme:Bind(accent,{BackgroundColor3=token})
		Style.text(context.Theme,card,{Text=tostring(config.Title or config.Type or "Notification"),Font=Enum.Font.GothamBold,Position=UDim2.fromOffset(14,11),Size=UDim2.new(1,-48,0,20),ZIndex=202})
		Style.text(context.Theme,card,{Text=tostring(config.Content or ""),TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top,Muted=true,Position=UDim2.fromOffset(14,35),Size=UDim2.new(1,-28,0,40),ZIndex=202})
		local close=Create.instance("TextButton",{Text="×",BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-8,0,7),Size=UDim2.fromOffset(28,28),ZIndex=203,Parent=card}); context.Theme:Bind(close,{TextColor3="MutedText"})
		local item={}; local dismissed=false
		function item:Dismiss() if dismissed then return end; dismissed=true; local i=table.find(active,item); if i then table.remove(active,i) end; Animation.tween(card,{Position=UDim2.fromOffset(360,0),BackgroundTransparency=1},.18).Completed:Once(function() card:Destroy() end) end
		close.Activated:Connect(function() item:Dismiss() end); table.insert(active,item); Animation.tween(card,{Position=UDim2.fromOffset(0,0)},.2); task.delay(math.max(tonumber(config.Duration) or 4,.5),function() item:Dismiss() end); return item
	end
	function manager:Destroy() for i=#active,1,-1 do active[i]:Dismiss() end; host:Destroy() end
	return manager
end
