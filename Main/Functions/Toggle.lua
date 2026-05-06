local Toggle = {}

function Toggle:Create(Page, Text, Callback)
    local function Cr(cl, p) local i = Instance.new(cl) for k, v in pairs(p) do i[k] = v end return i end
    
    -- Create the Row
    local Row = Cr("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1})
    
    -- The Checkbox UI
    local Box = Cr("TextButton", {Parent = Row, Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 5, 0, 6), BackgroundColor3 = Color3.fromRGB(25, 25, 25), Text = ""})
    local Check = Cr("Frame", {Parent = Box, Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0.5, -6, 0.5, -6), BackgroundColor3 = Color3.fromRGB(255, 50, 50), Visible = false})
    Cr("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 4)})
    Cr("TextLabel", {Parent = Row, Position = UDim2.new(0, 35, 0, 0), Size = UDim2.new(0, 150, 1, 0), Text = Text:upper(), TextColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, TextXAlignment = 0, Font = 17, TextSize = 13})

    local Enabled = false
    Box.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        Check.Visible = Enabled
        Callback(Enabled)
    end)

    return Row -- This allows Keybinds to attach to this specific row!
end

return Toggle -- CRITICAL: This is what sends the "Create" function back to Macro.lua
