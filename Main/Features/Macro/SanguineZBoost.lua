-- YUUKIWARE: Sanguine Z Boost (Standalone)
return function(Page)
    -- =============================================
    -- 1. SERVICES & VARIABLES
    -- =============================================
    local Players = game:GetService("Players")
    local UIS = game:GetService("UserInputService")
    local TS = game:GetService("TweenService")
    local CG = game:GetService("CoreGui")
    
    local lp = Players.LocalPlayer
    local enabled = false
    local frozen = false
    local floatingBtn = nil
    
    -- Oxford Blue color
    local OxfordBlue = Color3.fromRGB(0, 33, 71)
    local Crimson = Color3.fromRGB(150, 0, 0)
    
    -- Helper to create instances quickly
    local function Cr(cl, props)
        local i = Instance.new(cl)
        for k, v in pairs(props) do
            i[k] = v
        end
        return i
    end
    
    -- =============================================
    -- 2. THE ACTION (Freeze/Unfreeze)
    -- =============================================
    local function action()
        if not enabled then return end
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if root then
            frozen = not frozen
            root.Anchored = frozen
        end
    end
    
    -- =============================================
    -- 3. TOGGLE SWITCH
    -- =============================================
    local row = Cr("Frame", {
        Parent = Page,
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1
    })
    
    -- Label
    Cr("TextLabel", {
        Parent = row,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Text = "SANGUINE Z BOOST",
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        TextXAlignment = 0,
        Font = Enum.Font.GothamSemibold,
        TextSize = 13
    })
    
    -- Switch background
    local switch = Cr("TextButton", {
        Parent = row,
        Position = UDim2.new(1, -45, 0.5, -9),
        Size = UDim2.new(0, 35, 0, 18),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Text = "",
        AutoButtonColor = false
    })
    Cr("UICorner", {Parent = switch, CornerRadius = UDim.new(1, 0)})
    
    -- Knob (the circle that slides)
    local knob = Cr("Frame", {
        Parent = switch,
        Position = UDim2.new(0, 2, 0.5, -7),
        Size = UDim2.new(0, 14, 0, 14),
        BackgroundColor3 = Color3.new(1, 1, 1)
    })
    Cr("UICorner", {Parent = knob, CornerRadius = UDim.new(1, 0)})
    
    -- Toggle logic
    local function setToggle(state)
        if enabled == state then return end
        enabled = state
        
        -- Animate knob
        TS:Create(knob, TweenInfo.new(0.2), {
            Position = enabled 
                and UDim2.new(1, -16, 0.5, -7) 
                or UDim2.new(0, 2, 0.5, -7)
        }):Play()
        
        -- Animate switch color
        TS:Create(switch, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and OxfordBlue or Color3.fromRGB(30, 30, 30)
        }):Play()
        
        -- If toggled off while frozen, unfreeze
        if not enabled and frozen then
            local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.Anchored = false
                frozen = false
            end
        end
    end
    
    -- Click handlers for toggle
    switch.MouseButton1Click:Connect(function()
        setToggle(not enabled)
    end)
    switch.TouchTap:Connect(function()
        setToggle(not enabled)
    end)
    
    -- =============================================
    -- 4. ADD BTN (Floating Button Creator)
    -- =============================================
    local addBtn = Cr("TextButton", {
        Parent = row,
        Size = UDim2.new(0, 65, 0, 22),
        Position = UDim2.new(1, -120, 0.5, -11),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        Text = "ADD BTN",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamSemibold,
        TextSize = 10,
        AutoButtonColor = false
    })
    Cr("UICorner", {Parent = addBtn, CornerRadius = UDim.new(0, 4)})
    
    local addBtnStroke = Cr("UIStroke", {
        Parent = addBtn,
        Color = OxfordBlue,
        Thickness = 1,
        Transparency = 0.5
    })
    
    -- Drag system for floating button
    local dragging = false
    local dragStart, startPos
    local moveConn, releaseConn
    
    local function createFloatingButton()
        local btn = Cr("ImageButton", {
            Name = "ZBoostFloatingBtn",
            Parent = CG,
            Size = UDim2.new(0, 50, 0, 50),
            Position = UDim2.new(0.8, 0, 0.7, 0),
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            Image = "",
            AutoButtonColor = false
        })
        Cr("UICorner", {Parent = btn, CornerRadius = UDim.new(1, 0)})
        
        Cr("UIStroke", {
            Parent = btn,
            Color = OxfordBlue,
            Thickness = 2
        })
        
        Cr("TextLabel", {
            Parent = btn,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "Z",
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 22,
            Font = Enum.Font.GothamBold
        })
        
        -- Drag handling
        local btnDragging = false
        local btnStart, btnStartPos
        local btnMove, btnRelease
        
        UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 
                or input.UserInputType == Enum.UserInputType.Touch then
                -- Check if input is on our button
                local pos = input.Position
                local absPos = btn.AbsolutePosition
                local absSize = btn.AbsoluteSize
                if pos.X >= absPos.X and pos.X <= absPos.X + absSize.X 
                    and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y then
                    btnDragging = true
                    btnStart = input.Position
                    btnStartPos = btn.Position
                    
                    btnMove = UIS.InputChanged:Connect(function(ic)
                        if ic.UserInputType == input.UserInputType and btnDragging then
                            local delta = ic.Position - btnStart
                            btn.Position = UDim2.new(
                                btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X,
                                btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y
                            )
                        end
                    end)
                    
                    btnRelease = UIS.InputEnded:Connect(function(ie)
                        if ie.UserInputType == input.UserInputType then
                            local dist = (ie.Position - btnStart).Magnitude
                            if dist < 5 then
                                -- It was a tap, not a drag – do the action
                                action()
                            end
                            btnDragging = false
                            if btnMove then btnMove:Disconnect() end
                            if btnRelease then btnRelease:Disconnect() end
                        end
                    end)
                end
            end
        end)
        
        return btn
    end
    
    local function toggleFloating()
        if floatingBtn then
            floatingBtn:Destroy()
            floatingBtn = nil
            addBtnStroke.Color = OxfordBlue
        else
            floatingBtn = createFloatingButton()
            addBtnStroke.Color = Color3.new(1, 1, 1) -- white highlight
        end
    end
    
    -- Use Activated to prevent double-firing
    addBtn.Activated:Connect(function()
        task.defer(toggleFloating)
    end)
    
    -- =============================================
    -- 5. KEYBIND (Q)
    -- =============================================
    local currentKey = Enum.KeyCode.Q
    local binding = false
    local rebindConn, triggerConn
    
    local keybindBtn = Cr("TextButton", {
        Parent = row,
        Size = UDim2.new(0, 70, 0, 24),
        Position = UDim2.new(1, -75, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Text = currentKey.Name,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        AutoButtonColor = false
    })
    Cr("UICorner", {Parent = keybindBtn, CornerRadius = UDim.new(0, 4)})
    
    local kbStroke = Cr("UIStroke", {
        Parent = keybindBtn,
        Color = Crimson,
        Thickness = 1,
        Transparency = 0.8
    })
    
    local function startRebind()
        if binding then return end
        binding = true
        keybindBtn.Text = "..."
        kbStroke.Transparency = 0
        
        if rebindConn then rebindConn:Disconnect() end
        rebindConn = UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                keybindBtn.Text = currentKey.Name
                kbStroke.Transparency = 0.8
                binding = false
                rebindConn:Disconnect()
                rebindConn = nil
            end
        end)
    end
    
    keybindBtn.MouseButton1Click:Connect(startRebind)
    keybindBtn.TouchTap:Connect(startRebind)
    
    -- Trigger the action when the bound key is pressed
    triggerConn = UIS.InputBegan:Connect(function(input, gpe)
        if gpe or binding then return end
        if input.UserInputType == Enum.UserInputType.Keyboard 
            and input.KeyCode == currentKey then
            action()
        end
    end)
    
    -- =============================================
    -- 6. CLEANUP (when row is destroyed)
    -- =============================================
    row.Destroying:Connect(function()
        if rebindConn then rebindConn:Disconnect() end
        if triggerConn then triggerConn:Disconnect() end
        if floatingBtn then
            floatingBtn:Destroy()
            floatingBtn = nil
        end
    end)
end
