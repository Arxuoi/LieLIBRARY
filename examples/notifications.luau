local Breeze = require(game.ReplicatedStorage.Breeze)
for _, kind in { "Default", "Info", "Success", "Warning", "Error" } do
	Breeze:Notify({ Title = kind, Content = "A " .. kind:lower() .. " notification.", Type = kind, Duration = 3 })
	task.wait(.3)
end
