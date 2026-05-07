return function(Page)
    local lp = game.Players.LocalPlayer
    local ModURL = "https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Modules/"
    
    -- Load Modules (Updated to your new folder structure)
    local ToggleMod = loadstring(game:HttpGet(ModURL .. "Toggle.lua"))()
    local KeybindMod = loadstring(game:HttpGet(ModURL .. "Keybind.lua"))()
    local MobileMod = loadstring(game:HttpGet(ModURL .. "Draggablebtn.lua"))()

    local IsEnabled = false
    local IsFrozen = false
    local FloatingBtn = nil
    
    -- Oxford Blue Theme
    local OxfordBlue = Color3.fromRGB(0, 33, 71)

    -- The Logic Function
    local function runAction()
        if not IsEnabled then return end
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if root then
            IsFrozen = not IsFrozen
            root.Anchored = IsFrozen
        end
    end

    -- 1. Create the Row (Main Toggle)
    local Row = ToggleMod:Create(Page, "Sanguine Z Boost", function(state)
        IsEnabled = state
        if not state and IsFrozen then 
            local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if root then root.Anchored = false end
            IsFrozen = false 
        end
    end)

    -- 2. "Add Button" (Mobile Floating Button Creator)
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
