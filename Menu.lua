local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

local DRAG_URL = "https://raw.githubusercontent.com/zenyuukito/Dragging-logic/10f5932f5aa0f0106075a80cbf5704b40e7507ad/Dragging.lua"
local ICON_ASSET = "rbxthumb://type=Asset&id=111918789930704&w=420&h=420"

if CoreGui:FindFirstChild("YuukiWare") then CoreGui.YuukiWare:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "YuukiWare"

local UIScale = Instance.new("UIScale", ScreenGui)
local function UpdateScale() UIScale.Scale = math.clamp(Camera.ViewportSize.X / 1920, 0.75, 1.25) end
UpdateScale()
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)

local function Create(class, props)
    local inst = Instance.new(class)
    for i, v in pairs(props) do inst[i] = v end
    return inst
end

-- Toggle Icon
local MainIcon = Create("ImageButton", {Parent = ScreenGui, BackgroundColor3 = Color3.new(0,0,0), Position = UDim2.new(0.05, 0, 0.1, 0), Size = UDim2.new(0, 50, 0, 50)})
Instance.new("UICorner", MainIcon).CornerRadius = UDim.new(0, 12)
Create("ImageLabel", {Parent = MainIcon, BackgroundTransparency = 1, Position = UDim2.new(0.1,0,0.1,0), Size = UDim2.new(0.8,0,0.8,0), Image = ICON_ASSET})

-- Main Frame (Clean & Large)
local MainMenu = Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(10, 10, 10), Position = UDim2.new(0.5, -325, 0.5, -200), Size = UDim2.new(0, 650, 0, 400), Visible = false, ClipsDescendants = true, BorderSizePixel = 0})
Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0, 10)

local TopBar = Create("Frame", {Parent = MainMenu, BackgroundColor3 = Color3.fromRGB(15, 15, 15), Size = UDim2.new(1, 0, 0, 42)})
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

-- Text Effect
local txt = {Parent = TopBar, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0, 300, 1, 0), Text = "YUUKIWARE", TextColor3 = Color3.fromRGB(255, 50, 50), TextSize = 19, Font = Enum.Font.Michroma, TextXAlignment = "Left"}
Create("TextLabel", txt).TextTransparency = 0.6
Create("TextLabel", txt).ZIndex = 2

-- Functional Buttons
local MinBtn = Create("TextButton", {Parent = TopBar, BackgroundTransparency = 1, Position = UDim2.new(1, -80, 0, 0), Size = UDim2.new(0, 35, 1, 0), Text = "-", TextColor3 = Color3.new(1,1,1), TextSize = 20, Font = "GothamMedium"})
local KillBtn = Create("TextButton", {Parent = TopBar, BackgroundTransparency = 1, Position = UDim2.new(1, -40, 0, 0), Size = UDim2.new(0, 35, 1, 0), Text = "x", TextColor3 = Color3.fromRGB(255, 50, 50), TextSize = 20, Font = "GothamMedium"})

-- Logic
local min = false
MainIcon.MouseButton1Click:Connect(function() MainMenu.Visible = not MainMenu.Visible end)
KillBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
MinBtn.MouseButton1Click:Connect(function()
    min = not min
    TweenService:Create(MainMenu, TweenInfo.new(0.3), {Size = min and UDim2.new(0, 650, 0, 42) or UDim2.new(0, 650, 0, 400)}):Play()
    MinBtn.Text = min and "+" or "-"
end)

-- Dragging
task.spawn(function()
    local _, Drag = pcall(function() return loadstring(game:HttpGet(DRAG_URL))() end)
    if Drag then 
        local d = (type(Drag) == "table" and Drag.MakeDraggable or Drag)
        d(MainIcon) d(MainMenu, TopBar) 
    end
end)
