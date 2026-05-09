local Container, G = ...
local Funcs = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Functions.lua"))()

local FloatBtn = nil
local IsProcessing = false 

-- 1. UI Row Setup
local Row = Instance.new("Frame")
Row.Name = "SanguineRow"
Row.Parent = Container
Row.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Row.Size = UDim2.new(1, 0, 0, 45)
Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

-- 2. Title Label (Left)
local Title = Instance.new("TextLabel", Row)
Title.Text = "Sanguine Z Boost"
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0.4, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- 3. Add Floating Button Label (Right)
local SubBtn = Instance.new("TextButton", Row)
SubBtn.Text = "Add floating button"
SubBtn.Position = UDim2.new(0.5, 0, 0, 0)
SubBtn.Size = UDim2.new(0.5, -12, 1, 0)
SubBtn.BackgroundTransparency = 1
SubBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
SubBtn.TextSize = 12
SubBtn.Font = Enum.Font.Gotham
SubBtn.TextXAlignment = Enum.TextXAlignment.Right

-- 4. The Action Function
local function RunBoost()
    if IsProcessing then return end 
    IsProcessing = true
    
    local Root = G.GetRoot()
    if Root then Root.Anchored = true end
    
    if FloatBtn then
        FloatBtn.TextColor3 = Color3.new(1, 1, 1)
        FloatBtn.UIStroke.Color = Color3.fromRGB(255, 50, 50)
    end
    
    task.wait(0.15) -- THE DURATION
    
    if Root then Root.Anchored = false end
    
    if FloatBtn then
        FloatBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        FloatBtn.UIStroke.Color = Color3.fromRGB(150, 0, 0)
    end
    IsProcessing = false
end

-- 5. Logic for the Floating Button Toggle
SubBtn.MouseButton1Click:Connect(function()
    if not FloatBtn then
        FloatBtn = Funcs.CreateFloating("Sanguine", {
            Text = "BOOST",
            TextColor = Color3.fromRGB(255, 50, 50),
            BgColor = Color3.new(0, 0, 0),
            Size = UDim2.new(0, 100, 0, 40)
        })
        SubBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        FloatBtn.MouseButton1Down:Connect(RunBoost)
    else
        FloatBtn:Destroy()
        FloatBtn = nil
        SubBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end)

-- 6. The Keybind Box (Fixed placement)
-- Wrapping this in a pcall so if Functions.lua fails, the menu still shows up!
pcall(function()
    Funcs.CreateKeybind(Row, UDim2.new(1, -165, 0.5, -10), RunBoost)
end)

return true
