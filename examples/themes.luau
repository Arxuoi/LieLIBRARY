local Breeze = require(game.ReplicatedStorage.Breeze)
local section = Breeze:CreateWindow({ Title = "Theme explorer" }):AddTab({ Title = "Themes" }):AddSection({ Title = "Built-ins" })
for _, name in { "Breeze", "Dark", "Light", "Midnight" } do section:AddButton({ Title = name, Callback = function() Breeze:SetTheme(name) end }) end
