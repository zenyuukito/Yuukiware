local Container, G = ...
local Funcs = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Functions.lua"))()

local FloatBtn = nil

-- 1. UI Row
local Row = Instance.new("Frame", Container)
Row.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Row.Size = UDim2.new(1, 0, 0, 45)
Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

-- Main Title (Left)
local Title = Instance.new("TextLabel", Row)
Title.Text = "Sanguine Z Boost"
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Add Button Label (Right Side)
local SubBtn = Instance.new("TextButton", Row)
SubBtn.Text = "Add floating button"
SubBtn.Position = UDim2.new(0.5, -12, 0, 0) -- Positioned to the right
SubBtn.Size = UDim2.new(0.5, 0, 1, 0)
SubBtn.BackgroundTransparency = 1
SubBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
SubBtn.TextSize = 12
SubBtn.Font = Enum.Font.Gotham
SubBtn.TextXAlignment = Enum.TextXAlignment.Right

-- 2. The Functional Logic (Hold to Anchor)
local function SetAnchor(state)
    local Root = G.GetRoot()
    if Root then
        Root.Anchored = state
    end
    if FloatBtn then
        -- Visual feedback: Bright crimson when active
        FloatBtn.BackgroundColor3 = state and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(80, 0, 0)
    end
end

SubBtn.MouseButton1Click:Connect(function()
    if not FloatBtn then
        -- Create the button
        FloatBtn = Funcs.CreateFloating("Sanguine")
        SubBtn.TextColor3 = Color3.fromRGB(255, 50, 50) -- Highlight text when active
        
        -- HOLD LOGIC
        FloatBtn.MouseButton1Down:Connect(function()
            SetAnchor(true)
        end)
        
        FloatBtn.MouseButton1Up:Connect(function()
            SetAnchor(false)
        end)
        
        -- Safety: if the mouse leaves the button while holding, unanchor
        FloatBtn.MouseLeave:Connect(function()
            SetAnchor(false)
        end)
    else
        -- Remove the button
        FloatBtn:Destroy()
        FloatBtn = nil
        SubBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        SetAnchor(false) -- Safety unanchor
    end
end)

return true
