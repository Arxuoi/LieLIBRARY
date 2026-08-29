local Players=game:GetService("Players")
local Cleanup=require(script.utilities.Cleanup); local SafeCallback=require(script.utilities.SafeCallback); local Icons=require(script.utilities.Icons)
local ThemeManager=require(script.managers.ThemeManager); local State=require(script.core.State); local InputManager=require(script.managers.InputManager); local OverlayManager=require(script.managers.OverlayManager)
local Window=require(script.core.Window); local NotificationManager=require(script.managers.NotificationManager); local DialogManager=require(script.managers.DialogManager)

local cleanup=Cleanup.create(); local screen=Instance.new("ScreenGui"); screen.Name="BreezeUI"; screen.IgnoreGuiInset=true; screen.ResetOnSpawn=false; screen.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; screen.DisplayOrder=50
local parent
local coreOk=pcall(function() local core=game:GetService("CoreGui"); screen.Parent=core; parent=core end)
if not coreOk then local player=Players.LocalPlayer; parent=player and (player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui",5)); if parent then screen.Parent=parent end end
assert(parent and screen.Parent,"[Breeze] A writable PlayerGui or CoreGui is required"); cleanup:Add(screen)
local root=Instance.new("Frame"); root.Name="Root"; root.BackgroundTransparency=1; root.Size=UDim2.fromScale(1,1); root.Parent=screen
local theme=ThemeManager("Breeze"); local state=State(); local input=InputManager(cleanup); local overlay=OverlayManager(root,cleanup)
local windows={}; local persistence
local context={Root=root,Theme=theme,State=state,Input=input,Overlay=overlay,Icons=Icons,Safe=SafeCallback}
function context.Activate(window) for i,item in windows do item.Instance.ZIndex=10+i end; window.Instance.ZIndex=10+#windows+1 end
function context.OnDestroyed(window) local i=table.find(windows,window); if i then table.remove(windows,i) end end
local notifications=NotificationManager(context); local dialogs=DialogManager(context); cleanup:Add(notifications); cleanup:Add(dialogs)
local Library={Flags=state.Flags,Version="1.0.0"}
function Library:CreateWindow(config) config=type(config)=="table" and config or {}; if config.Theme then theme:Set(config.Theme) end; local window=Window(context,config,#windows+1); table.insert(windows,window); return window end
function Library:Notify(config) return notifications:Notify(config) end
function Library:Dialog(config) return dialogs:Dialog(config) end
function Library:SetTheme(value) return theme:Set(value) end; function Library:GetTheme() return theme:Get() end
function Library:GetFlag(flag) return state:Get(flag) end; function Library:SetFlag(flag,value) state:Set(flag,value) end; function Library:ResetFlags() state:Reset() end
function Library:SetPersistenceAdapter(adapter) if adapter~=nil and type(adapter)~="table" then error("Persistence adapter must be a table or nil",2) end; persistence=adapter end
function Library:Save(name) if not persistence or type(persistence.Save)~="function" then return false,"No persistence adapter" end; return SafeCallback("Persistence Save",persistence.Save,persistence,name,table.clone(state.Flags)) end
function Library:Load(name) if not persistence or type(persistence.Load)~="function" then return false,"No persistence adapter" end; local ok,data=SafeCallback("Persistence Load",persistence.Load,persistence,name); if ok and type(data)=="table" then for flag,value in data do state:Set(flag,value) end end; return ok end
function Library:Destroy() for i=#windows,1,-1 do windows[i]:Destroy() end; overlay:Close(); theme:Destroy(); state:Destroy(); cleanup:Clean() end
return Library
