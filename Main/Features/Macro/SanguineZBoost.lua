local Container, G = ...
local Funcs = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Functions.lua"))()

local Active = false
local FloatBtn = nil

-- 1. UI Row
local Row = Instance.new("Frame", Container)
Row.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Row.Size = UDim2.new(1, 0, 0, 50)
Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", Row)
Title.Text = "Sanguine Z Boost"
Title.Position = UDim2.new(0, 12, 0, 5)
Title.Size = UDim2.new(0.5, 0, 0, 20)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamMedium
Title.TextXAlignment = 0

-- 2. The "Add floating button" Sub-text/Toggle
local SubText = Instance.new("TextButton", Row)
SubText.Text = "Add floating button"
SubText.Position = UDim2.new(0, 12, 0, 25)
SubText.Size = UDim2.new(0.5, 0, 0, 15)
SubText.BackgroundTransparency = 1
SubText.TextColor3 = Color3.fromRGB(180, 180, 180) -- Dimmer white
SubText.TextSize = 10
SubText.Font = Enum.Font.Gotham
SubText.TextXAlignment = 0

-- 3. The Functionality
local function ToggleBoost()
    Active = not Active
    local Root = G.GetRoot()
    if Root then
        Root.Anchored = Active
    end
    -- Visual feedback on the floating button if it exists
    if FloatBtn then
        FloatBtn.BackgroundColor3 = Active and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(0, 33, 71)
    end
end

SubText.MouseButton1Click:Connect(function()
    if not FloatBtn then
        -- Create it
        FloatBtn = Funcs.CreateFloating("Sanguine", ToggleBoost)
        SubText.TextColor3 = Color3.fromRGB(0, 255, 120) -- Set text green when button is active
    else
        -- Remove it
        FloatBtn:Destroy()
        FloatBtn = nil
        SubText.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
end)

return true
