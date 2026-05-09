local Container, G = ...
local Funcs = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Functions.lua"))()

local FloatBtn = nil
local isHolding = false -- Tracks if the button is currently pressed

-- UI Row Setup (Left: Name | Right: Option)
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

-- Anchor Function
local function SetAnchor(state)
    local Root = G.GetRoot()
    if Root then Root.Anchored = state end
    if FloatBtn then
        -- Visual feedback: Pure white text when boost is active
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
        
        -- Logic: 0.5s Safety Hold
        FloatBtn.MouseButton1Down:Connect(function()
            isHolding = true
            task.delay(0.5, function()
                -- Only anchor if they are STILL holding after 0.5s
                if isHolding then
                    SetAnchor(true)
                end
            end)
        end)
        
        local function EndHold()
            isHolding = false
            SetAnchor(false)
        end
        
        FloatBtn.MouseButton1Up:Connect(EndHold)
        FloatBtn.MouseLeave:Connect(EndHold)
    else
        FloatBtn:Destroy()
        FloatBtn = nil
        SubBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        SetAnchor(false)
    end
end)

return true
