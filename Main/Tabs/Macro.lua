return function(Page)
    local lp = game.Players.LocalPlayer
    local FuncURL = "https://raw.githubusercontent.com/zenyuukito/Yuukiware/main/Main/Functions/"
    
    -- Load Modules
    local ToggleMod = loadstring(game:HttpGet(FuncURL .. "Toggle.lua"))()
    local KeybindMod = loadstring(game:HttpGet(FuncURL .. "Keybind.lua"))()
    local MobileMod = loadstring(game:HttpGet(FuncURL .. "Draggablebtn.lua"))()

    local IsEnabled = false
    local IsFrozen = false
    local FloatingBtn = nil

    -- The Logic Function
    local function runAction()
        if not IsEnabled then return end
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if root then
            IsFrozen = not IsFrozen
            root.Anchored = IsFrozen
        end
    end

    -- 1. Create the Row with the new name
    local Row = ToggleMod:Create(Page, "Long range sanguine", function(state)
        IsEnabled = state
        if not state and IsFrozen then 
            local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if root then root.Anchored = false end
            IsFrozen = false 
        end
    end)

    -- 2. Add Mobile Floating Button Toggle (Next to the Toggle)
    local MobIcon = Instance.new("TextButton", Row)
    MobIcon.Size = UDim2.new(0, 50, 0, 22)
    MobIcon.Position = UDim2.new(1, -165, 0.5, -11) -- Placed left of Keybind
    MobIcon.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MobIcon.Text = "MOBILE"
    MobIcon.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    MobIcon.Font = 17
    MobIcon.TextSize = 10
    Instance.new("UICorner", MobIcon).CornerRadius = UDim.new(0, 4)

    MobIcon.MouseButton1Click:Connect(function()
        if FloatingBtn then
            FloatingBtn:Destroy()
            FloatingBtn = nil
            MobIcon.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        else
            -- Spawns the draggable button using your Draggablebtn.lua
            FloatingBtn = MobileMod:Create("Sanguine", runAction)
            MobIcon.TextColor3 = Color3.fromRGB(130, 0, 0) -- Turn crimson when active
        end
    end)

    -- 3. Add Keybind (Next to the Toggle)
    KeybindMod:Add(Row, Enum.KeyCode.Q, runAction)
end
