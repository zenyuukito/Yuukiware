local Container, G = ...

-- 1. Main Row Frame
local Row = Instance.new("Frame")
Row.Name = "SanguineZBoost_Row"
Row.Parent = Container
Row.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Row.Size = UDim2.new(1, 0, 0, 40) -- Slimmer profile since it's just text
Row.BorderSizePixel = 0

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 6)
Corner.Parent = Row

-- 2. Simple Text Label
local Title = Instance.new("TextLabel")
Title.Parent = Row
Title.Text = "Sanguine Z Boost"
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(1, -12, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255) -- Pure white as requested
Title.TextSize = 14
Title.Font = Enum.Font.Gotham -- Standard clean font
Title.TextXAlignment = Enum.TextXAlignment.Left

return true
