return function(Page)
    -- 1. Setup Variables & Local Player
    local lp = game.Players.LocalPlayer
    local UIS = game:GetService("UserInputService")
    
    -- Base URLs for your Functions (using your provided links)
    local FuncURL = "https://raw.githubusercontent.com/zenyuukito/Yuukiware/main/Main/Functions/"
    
    -- 2. Load the Modular "Brains"
    -- We use pcall to ensure the menu doesn't crash if GitHub is down
    local success, ToggleMod = pcall(function() return loadstring(game:HttpGet(FuncURL .. "Toggle.lua"))() end)
    local _, KeybindMod = pcall(function() return loadstring(game:HttpGet(FuncURL .. "Keybind.lua"))() end)
    local _, MobileMod = pcall(function() return loadstring(game:HttpGet(FuncURL .. "Draggablebtn.lua"))() end)

    if not success then warn("YuukiWare: Failed to load Toggle Module") return end

    ---------------------------------------------------------
    -- FEATURE 1: FREEZE CHARACTER
    ---------------------------------------------------------
    local IsEnabled = false
    local IsFrozen = false
    local MobileBtn = nil

    -- The actual logic function
    local function runFreeze()
        if not IsEnabled then return end
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if root then
            IsFrozen = not IsFrozen
            root.Anchored = IsFrozen
        end
    end

    -- Create the UI Row using your Toggle.lua
    -- This assumes ToggleMod:Create(Parent, Text, Callback)
    local Row = ToggleMod:Create(Page, "Freeze Character", function(state)
        IsEnabled = state
        -- Force unfreeze if the toggle is turned off
        if not state and IsFrozen then
            local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if root then root.Anchored = false end
            IsFrozen = false
        end
    end)

    -- Attach Keybind (assuming KeybindMod:Add(Row, Default, Callback))
    if KeybindMod then
        KeybindMod:Add(Row, Enum.KeyCode.Q, function()
            runFreeze()
        end)
    end

    -- Attach Mobile Button (assuming MobileMod:Add(Row, Callback))
    if MobileMod then
        local MobToggle = Instance.new("TextButton") -- Placeholder for your Mob Toggle UI
        -- This logic allows users to spawn a floating button for the macro
        MobToggle.MouseButton1Click:Connect(function()
            if MobileBtn then
                MobileBtn:Destroy()
                MobileBtn = nil
            else
                MobileBtn = MobileMod:Create("Freeze", runFreeze)
            end
        end)
    end
end
