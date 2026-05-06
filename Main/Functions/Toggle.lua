local Toggle = {}

function Toggle:Create(Page, Text, Callback)
    local function Cr(cl, p) local i = Instance.new(cl) for k, v in pairs(p) do i[k] = v end return i end
    local TS = game:GetService("TweenService")
    
    -- The Row Container
    local Row = Cr("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1})
    
    -- The Label (Left Side)
    local Lbl = Cr("TextLabel", {
        Parent = Row, 
        Position = UDim2.new(0, 10, 0, 0), 
        Size = UDim2.new(0.5, 0, 1, 0), 
        Text = Text:upper(), 
        TextColor3 = Color3.new(1, 1, 1), 
        BackgroundTransparency = 1, 
        TextXAlignment = 0, 
        Font = 17, 
        TextSize = 13
    })

    -- The Toggle Background (Right Side)
    local Switch = Cr("TextButton", {
        Parent = Row, 
        Position = UDim2.new(1, -45, 0.5, -9), 
        Size = UDim2.new(0, 35, 0, 18), 
        BackgroundColor3 = Color3.fromRGB(30, 30, 30), 
        Text = ""
    })
    Cr("UICorner", {Parent = Switch, CornerRadius = UDim.new(1, 0)})

    -- The Sliding Knob
    local Knob = Cr("Frame", {
        Parent = Switch, 
        Position = UDim2.new(0, 2, 0.5, -7), 
        Size = UDim2.new(0, 14, 0, 14), 
        BackgroundColor3 = Color3.new(0.6, 0.6, 0.6)
    })
    Cr("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 0)})

    -- Dark Crimson Theme
    local Crimson = Color3.fromRGB(130, 0, 0)
    local Enabled = false

    Switch.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        TS:Create(Knob, TweenInfo.new(0.2), {
            Position = Enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
            BackgroundColor3 = Enabled and Color3.new(1, 1, 1) or Color3.new(0.6, 0.6, 0.6)
        }):Play()
        TS:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Enabled and Crimson or Color3.fromRGB(30, 30, 30)}):Play()
        Callback(Enabled)
    end)

    return Row -- Return the row so we can attach Keybinds/Mobile buttons to it
end

return Toggle
