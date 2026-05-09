local Container, G = ...

-- 1. UI Row (Minimalist)
local Row = Instance.new("Frame")
Row.Name = "SanguineZBoost_Row"
Row.Parent = Container
Row.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Row.Size = UDim2.new(1, 0, 0, 40)
Row.BorderSizePixel = 0
Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel")
Title.Parent = Row
Title.Text = "Sanguine Z Boost (Always ON)"
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(1, -12, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Left

-- 2. Logic: Always ON Functionality
-- We use task.spawn so the loop doesn't "freeze" your UI loading
task.spawn(function()
    while task.wait(0.1) do
        local root = G.GetRoot()
        if root and not root.Anchored then
            root.Anchored = true
        end
    end
end)

-- 3. Optional: Keeping your 'G' Keybind as a manual override
G.UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.G then
        local root = G.GetRoot()
        if root then
            -- This toggles the state if you press G
            root.Anchored = not root.Anchored
        end
    end
end)

return true
