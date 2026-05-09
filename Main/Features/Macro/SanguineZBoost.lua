local Container, G = ...
local Funcs = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Functions.lua"))()

local FloatBtn = nil
local IsProcessing = false 

local Row = Instance.new("Frame", Container)
Row.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Row.Size = UDim2.new(1, 0, 0, 45)
Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

-- Create Master Toggle from Functions
Funcs.CreateMasterToggle(Row)

local Title = Instance.new("TextLabel", Row)
Title.Text = "Sanguine Z Boost"
Title.Position = UDim2.new(0, 45, 0, 0) -- Pushed right for the toggle
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
SubBtn.TextXAlignment = 1

local function RunPulse()
    -- Floating button still needs manual check since it's not a bind
    if not Funcs.Enabled or IsProcessing then return end
    IsProcessing = true
    local Root = G.GetRoot()
    if Root then Root.Anchored = true end
    task.wait(0.15)
    if Root then Root.Anchored = false end
    IsProcessing = false
end

SubBtn.MouseButton1Click:Connect(function()
    if not FloatBtn then
        FloatBtn = Funcs.CreateFloating("Sanguine", {Text = "BOOST", TextColor = Color3.fromRGB(255, 50, 50)})
        FloatBtn.MouseButton1Down:Connect(RunPulse)
    else
        FloatBtn:Destroy()
        FloatBtn = nil
    end
end)

Funcs.CreateKeybind(Row, UDim2.new(1, -165, 0.5, -11), RunPulse)

return true
