local Create = require(script.Parent.Parent.utilities.Create)
local Icons = require(script.Parent.Parent.utilities.Icons)
local Section = require(script.Parent.Section)

return function(context, config, activate)
	local button = Create.instance("TextButton", { Name = config.Title or "Tab", Text = "  " .. tostring(config.Title or "Tab"), TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 13, AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.new(1, -8, 0, 40), Selectable = true, Parent = context.Navigation })
	Create.corner(button, 9); Create.padding(button, 10, 0); context.Theme:Bind(button, { BackgroundColor3 = "SurfaceSecondary", TextColor3 = "MutedText" })
	local page = Create.instance("ScrollingFrame", { Name = (config.Title or "Tab") .. "Page", BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 4, Visible = false, Parent = context.Pages })
	Create.instance("UIListLayout", { Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page }); Create.padding(page, 4, 4)
	local sections, disabled, destroyed = {}, config.Disabled == true, false
	local tab = { Instance = page, Button = button, Icon = Icons(config.Icon) }
	function tab:AddSection(options)
		local child = table.clone(context); child.Parent = page
		local section = Section(child, type(options)=="table" and options or {}); table.insert(sections, section); return section
	end
	function tab:SetActive(value) page.Visible = value == true; button.BackgroundTransparency = value and .2 or 1; button.TextColor3 = value and context.Theme:Get().Text or context.Theme:Get().MutedText end
	function tab:SetDisabled(value) disabled=value==true; button.TextTransparency=disabled and .55 or 0 end
	function tab:SetTitle(value) button.Text = "  " .. tostring(value or "Tab") end
	function tab:Destroy() if destroyed then return end; destroyed=true; for _, s in sections do s:Destroy() end; button:Destroy(); page:Destroy() end
	button.Activated:Connect(function() if not disabled then activate(tab) end end)
	return tab
end
