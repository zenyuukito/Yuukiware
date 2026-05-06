local CoreGui = game:GetService("CoreGui")

local DECAL_ID = "111918789930704" 
local DRAG_URL = "https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Functions/Dragging.lua"

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuukiWare"
ScreenGui.Parent = CoreGui

local MainIcon = Instance.new("ImageButton")
MainIcon.Name = "MainIcon"
MainIcon.Parent = ScreenGui
MainIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainIcon.BorderSizePixel = 0
MainIcon.Position = UDim2.new(0.1, 0, 0.1, 0)
MainIcon.Size = UDim2.new(0, 42, 0, 42) 
MainIcon.AutoButtonColor = false
MainIcon.ClipsDescendants = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainIcon

local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Parent = MainIcon
Logo.BackgroundTransparency = 1
Logo.AnchorPoint = Vector2.new(0.5, 0.5)
Logo.Position = UDim2.new(0.5, 0, 0.5, 0)
Logo.Size = UDim2.new(0.85, 0, 0.85, 0) 
Logo.Image = "rbxthumb://type=Asset&id=" .. DECAL_ID .. "&w=420&h=420"
Logo.ScaleType = Enum.ScaleType.Fit

task.spawn(function()
    local success, DragModule = pcall(function()
        return loadstring(game:HttpGet(DRAG_URL))()
    end)
    
    if success and DragModule then
        DragModule.MakeDraggable(MainIcon)
    end
end)
