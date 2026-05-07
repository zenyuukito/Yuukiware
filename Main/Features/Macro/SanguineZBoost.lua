return function(Page)
    -- Load Core once (contains Globals, Keybind, Toggle, Draggable)
    local Core = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Functions.lua"))()
    
    local lp = game:GetService("Players").LocalPlayer
    local enabled = false
    local frozen = false
    local floatingBtn = nil
    
    -- Logic
    local function action()
        if not enabled then return end
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if root then
            frozen = not frozen
            root.Anchored = frozen
        end
    end
    
    -- 1. Toggle row (Oxford Blue by default when enabled)
    local row, toggleCtrl = Core.Toggle:Create(Page, "Sanguine Z Boost", false, function(state)
        enabled = state
        if not state and frozen then
            local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if root then root.Anchored = false end
            frozen = false
        end
    end)
    
    -- 2. "ADD BTN" - creates/destroys floating draggable button
    local addBtn = Instance.new("TextButton")
    addBtn.Parent = row
    addBtn.Size = UDim2.new(0, 65, 0, 22)
    addBtn.Position = UDim2.new(1, -195, 0.5, -11)
    addBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    addBtn.Text = "ADD BTN"
    addBtn.TextColor3 = Color3.new(1, 1, 1)
    addBtn.Font = Enum.Font.GothamSemibold
    addBtn.TextSize = 10
    addBtn.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = addBtn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 33, 71) -- Oxford Blue
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = addBtn
    
    local function toggleFloating()
        if floatingBtn then
            floatingBtn:Destroy()
            floatingBtn = nil
            stroke.Color = Color3.fromRGB(0, 33, 71)
        else
            floatingBtn = Core.Draggable:CreateButton("Z", action)
            stroke.Color = Color3.new(1, 1, 1) -- white highlight
        end
    end
    
    addBtn.MouseButton1Click:Connect(toggleFloating)
    addBtn.TouchTap:Connect(toggleFloating)
    
    -- 3. Keybind (press Q to toggle freeze)
    Core.Keybind:Add(row, Enum.KeyCode.Q, action, { allowTouch = true })
    
    -- 4. (Optional) Ensure toggle starts disabled (already false by default)
    -- No need to manually set switch color; Core.Toggle handles it.
end    -- 2. "Add Button" (Mobile Floating Button Creator)
    local AddBtn = Instance.new("TextButton", Row)
    AddBtn.Size = UDim2.new(0, 65, 0, 22)
    AddBtn.Position = UDim2.new(1, -195, 0.5, -11) -- Shifted left to fit everyone
    AddBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    AddBtn.Text = "ADD BTN"
    AddBtn.TextColor3 = Color3.new(1, 1, 1)
    AddBtn.Font = 17
    AddBtn.TextSize = 10
    Instance.new("UICorner", AddBtn).CornerRadius = UDim.new(0, 4)
    local Stroke = Instance.new("UIStroke", AddBtn)
    Stroke.Color, Stroke.Thickness, Stroke.Transparency = OxfordBlue, 1, 0.5

    AddBtn.MouseButton1Click:Connect(function()
        if FloatingBtn then
            FloatingBtn:Destroy()
            FloatingBtn = nil
            Stroke.Color = OxfordBlue
        else
            -- Spawns the draggable button
            FloatingBtn = MobileMod:CreateButton("Z", runAction)
            Stroke.Color = Color3.new(1, 1, 1) -- Highlight when active
        end
    end)

    -- 3. Keybind (Between Toggle and Add Button)
    KeybindMod:Add(Row, Enum.KeyCode.Q, runAction)
    
    -- 4. Apply Oxford Blue to the Toggle Switch
    -- This assumes your ToggleMod:Create returns the Row frame
    local Switch = Row:FindFirstChildWhichIsA("TextButton", true)
    if Switch then
        Switch.BackgroundColor3 = OxfordBlue
    end
end
