local Container, G = ...
local Funcs = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Functions.lua"))()

local FloatBtn = nil
local IsProcessing = false 

-- UI Row Setup
local Row = Instance.new("Frame", Container)
Row.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Row.Size = UDim2.new(1, 0, 0, 45)
Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", Row)
Title.Text = "Sanguine Z Boost"
Title.Position = UDim2.new(0, 12, 0, 0)
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

-- The Action
local function SetAnchor(state)
    local Root = G.GetRoot()
    if Root then Root.Anchored = state end
    if FloatBtn then
        -- Bright crimson/white flicker so you know the tap registered
        FloatBtn.TextColor3 = state and Color3.new(1, 1, 1) or Color3.fromRGB(255, 50, 50)
        FloatBtn.UIStroke.Color = state and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(150, 0, 0)
    end
end

SubBtn.MouseButton1Click:Connect(function()
    if not FloatBtn then
        FloatBtn = Funcs.CreateFloating("Sanguine", {
            Text = "BOOST",
            TextColor = Color3.fromRGB(255, 50, 50),
            BgColor = Color3.new(0, 0, 0),
            Size = UDim2.new(0, 100, 0, 40)
        })
        SubBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        
        -- THE FIX: Instant Trigger, Auto Release
        FloatBtn.MouseButton1Down:Connect(function()
            if IsProcessing then return end -- Don't overlap pulses
            IsProcessing = true
            
            SetAnchor(true) -- ANCHOR INSTANTLY
            
            task.wait(0.18) -- THE DURATION OF THE "HOLD"
            
            SetAnchor(false) -- RELEASE AUTOMATICALLY
            IsProcessing = false
        end)
    else
        FloatBtn:Destroy()
        FloatBtn = nil
        SubBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        SetAnchor(false)
    end
end)

return true
