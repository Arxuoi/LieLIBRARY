local UserInputService = game:GetService("UserInputService")
local Create = require(script.Parent.Parent.utilities.Create)
local Style = require(script.Parent.Parent.utilities.Style)
local Animation = require(script.Parent.Parent.utilities.Animation)
local Icons = require(script.Parent.Parent.utilities.Icons)
local Tab = require(script.Parent.Tab)

return function(context, config, order)
	local size = typeof(config.Size) == "UDim2" and config.Size or UDim2.fromOffset(720, 500)
	local position = typeof(config.Position) == "UDim2" and config.Position or UDim2.fromScale(.5, .5)
	local root = Style.panel(context.Theme, context.Root, { Name = config.Title or "BreezeWindow", AnchorPoint = Vector2.new(.5,.5), Position = position, Size = size, BackgroundTransparency = .08, ZIndex = 10 + order, Active = true })
	local constraint = Create.instance("UISizeConstraint", { MinSize = config.MinSize or Vector2.new(320, 260), MaxSize = config.MaxSize or Vector2.new(1200, 900), Parent = root })
	local header = Create.instance("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1,0,0,66), ZIndex = root.ZIndex+1, Parent=root })
	local logo = Create.instance("ImageLabel", { BackgroundTransparency=1, Image=Icons(config.Logo or "home"), Position=UDim2.fromOffset(17,17), Size=UDim2.fromOffset(32,32), ZIndex=header.ZIndex, Parent=header })
	local title = Style.text(context.Theme, header, { Text=tostring(config.Title or "Breeze"), Font=Enum.Font.GothamBold, TextSize=17, Position=UDim2.fromOffset(60,13), Size=UDim2.new(1,-170,0,22), ZIndex=header.ZIndex })
	local subtitle = Style.text(context.Theme, header, { Text=tostring(config.Subtitle or ""), TextSize=12, Muted=true, Position=UDim2.fromOffset(60,36), Size=UDim2.new(1,-170,0,17), ZIndex=header.ZIndex })
	local minimize = Create.instance("TextButton", { Text="—", Font=Enum.Font.GothamBold, TextSize=16, AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-50,0,15), Size=UDim2.fromOffset(32,32), BackgroundTransparency=1, ZIndex=header.ZIndex+1, Parent=header }); context.Theme:Bind(minimize,{TextColor3="MutedText"})
	local closeButton = minimize:Clone(); closeButton.Text="×"; closeButton.Position=UDim2.new(1,-14,0,15); closeButton.Parent=header
	local navigation = Create.instance("ScrollingFrame", { BackgroundTransparency=1, BorderSizePixel=0, Position=UDim2.fromOffset(12,70), Size=UDim2.new(0,170,1,-82), CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y, ScrollBarThickness=2, ZIndex=root.ZIndex+1, Parent=root }); Create.instance("UIListLayout",{Padding=UDim.new(0,5),Parent=navigation})
	local pages = Create.instance("Frame", { BackgroundTransparency=1, Position=UDim2.fromOffset(192,70), Size=UDim2.new(1,-204,1,-82), ZIndex=root.ZIndex+1, Parent=root })
	local tabs, active, destroyed, hidden, minimized = {}, nil, false, false, false
	local expandedSize = size
	local window = { Instance=root }
	local tabContext = table.clone(context); tabContext.Navigation=navigation; tabContext.Pages=pages
	local function activate(tab) if active==tab then return end; if active then active:SetActive(false) end; active=tab; tab:SetActive(true) end
	function window:AddTab(options) local tab=Tab(tabContext,type(options)=="table" and options or {},activate); table.insert(tabs,tab); if not active then activate(tab) end; return tab end
	function window:Minimize() if minimized then return end; minimized=true; expandedSize=root.Size; navigation.Visible=false; pages.Visible=false; Animation.tween(root,{Size=UDim2.new(expandedSize.X.Scale,expandedSize.X.Offset,0,66)},.22) end
	function window:Restore() if not minimized then return end; minimized=false; Animation.tween(root,{Size=expandedSize},.22).Completed:Once(function() if root.Parent then navigation.Visible=true; pages.Visible=true end end) end
	function window:Hide() hidden=true; Animation.tween(root,{BackgroundTransparency=1,Size=root.Size-UDim2.fromOffset(12,12)},.14).Completed:Once(function() if hidden and root.Parent then root.Visible=false end end) end
	function window:Show() hidden=false; root.Visible=true; root.Size=root.Size-UDim2.fromOffset(12,12); Animation.tween(root,{BackgroundTransparency=.08,Size=minimized and UDim2.new(expandedSize.X.Scale,expandedSize.X.Offset,0,66) or expandedSize},.16) end
	function window:SetTitle(v) title.Text=tostring(v or "") end; function window:SetSubtitle(v) subtitle.Text=tostring(v or "") end; function window:SetLogo(v) logo.Image=Icons(v) end
	function window:Destroy() if destroyed then return end; destroyed=true; for _,tab in tabs do tab:Destroy() end; root:Destroy(); context.OnDestroyed(window) end
	local dragging, dragStart, startPos
	header.InputBegan:Connect(function(input) if config.Draggable==false then return end; if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=input; dragStart=input.Position; startPos=root.Position end end)
	local changedConnection=UserInputService.InputChanged:Connect(function(input) if not dragging or (input.UserInputType~=Enum.UserInputType.MouseMovement and input.UserInputType~=Enum.UserInputType.Touch) then return end; local d=input.Position-dragStart; local viewport=context.Root.AbsoluteSize; local x=math.clamp(startPos.X.Offset+d.X,-viewport.X/2+80,viewport.X/2-80); local y=math.clamp(startPos.Y.Offset+d.Y,-viewport.Y/2+35,viewport.Y/2-35); root.Position=UDim2.new(startPos.X.Scale,x,startPos.Y.Scale,y) end)
	local endedConnection=UserInputService.InputEnded:Connect(function(input) if input==dragging or input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=nil end end)
	local originalDestroy=window.Destroy; function window:Destroy() if destroyed then return end; changedConnection:Disconnect(); endedConnection:Disconnect(); originalDestroy(self) end
	root.InputBegan:Connect(function() context.Activate(window) end); minimize.Activated:Connect(function() if minimized then window:Restore() else window:Minimize() end end); closeButton.Activated:Connect(function() window:Destroy() end)
	return window
end
