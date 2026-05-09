local Container, G = ...
local Funcs = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Functions.lua"))()

local FloatBtn = nil
local IsProcessing = false 

local Row = Instance.new("Frame", Container)
Row.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Row.Size = UDim2.new(1, 0, 0, 45)
Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

-- Local Checkbox State
local FeatureState = Funcs.CreateMasterToggle(Row)

local Title = Instance.new("TextLabel", Row)
Title.Text = "Sanguine Z Boost"
Title.Position = UDim2.new(0, 40, 0, 0) -- Adjusted for small checkbox
Title.Size = UDim2.new(0.4, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 14
Title.TextXAlignment = 0

local SubBtn = Instance.new("TextButton", Row)
SubBtn.Text = "Add floating button"
SubBtn.Position = UDim2.new(0.5, 0, 0, 0)
SubBtn.Size = UDim2.new(0.5, -12, 1, 0)
SubBtn.BackgroundTransparency = 1
SubBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
SubBtn.TextSize = 12
SubBtn.Font = Enum.Font.Gotham
SubBtn.TextXAlignment = 1

local function SetAnchor(state)
    local Root = G.GetRoot()
    if Root then Root.Anchored = state end
    if FloatBtn then
        FloatBtn.TextColor3 = state and Color3.new(1, 1, 1) or Color3.fromRGB(255, 50, 50)
        FloatBtn.UIStroke.Color = state and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(150, 0, 0)
    end
end

local function RunPulse()
    if not FeatureState.Enabled or IsProcessing then return end
    IsProcessing = true
    SetAnchor(true)
    task.wait(0.15)
    SetAnchor(false)
    IsProcessing = false
end

SubBtn.MouseButton1Click:Connect(function()
    if not FloatBtn then
        FloatBtn = Funcs.CreateFloating("Sanguine", {
            Text = "BOOST",
            TextColor = Color3.fromRGB(255, 50, 50),
            BgColor = Color3.new(0, 0, 0)
        })
        SubBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        FloatBtn.MouseButton1Down:Connect(RunPulse)
    else
        FloatBtn:Destroy()
        FloatBtn = nil
        SubBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

Funcs.CreateKeybind(Row, UDim2.new(1, -165, 0.5, -11), RunPulse, FeatureState)

return true
