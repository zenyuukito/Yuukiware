local Functions = {}
local G = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Globals.lua"))()

-- 1. LOCAL CHECKBOX TOGGLE (With Literal Checkmark)
function Functions.CreateMasterToggle(parent)
    local State = {Enabled = false} -- This makes it local to the specific feature
    
    -- The Outer Box
    local Box = Instance.new("TextButton", parent)
    Box.Name = "Checkbox_Base"
    Box.Size = UDim2.new(0, 18, 0, 18)
    Box.Position = UDim2.new(0, 12, 0.5, -9)
    Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Box.Text = ""
    Box.AutoButtonColor = false
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
    
    local Stroke = Instance.new("UIStroke", Box)
    Stroke.Color = Color3.fromRGB(40, 40, 40)
    Stroke.Thickness = 1
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- The Literal Checkmark (✓)
    local CheckSymbol = Instance.new("TextLabel", Box)
    CheckSymbol.Name = "Checkmark"
    CheckSymbol.Text = "✓" 
    CheckSymbol.Size = UDim2.new(1, 0, 1, 0)
    CheckSymbol.BackgroundTransparency = 1
    CheckSymbol.TextColor3 = Color3.fromRGB(180, 0, 0) -- Crimson Red
    CheckSymbol.Font = Enum.Font.GothamBold
    CheckSymbol.TextSize = 16
    CheckSymbol.Visible = false -- Hidden by default

    Box.MouseButton1Click:Connect(function()
        State.Enabled = not State.Enabled
        CheckSymbol.Visible = State.Enabled
        
        -- Visual feedback on the border
        Stroke.Color = State.Enabled and Color3.fromRGB(120, 0, 0) or Color3.fromRGB(40, 40, 40)
    end)
    
    return State
end

-- 2. FLOATING BUTTON GENERATOR
function Functions.CreateFloating(name, config)
    local Drag = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Dragging.lua"))()
    config = config or {}
    
    local Btn = Instance.new("TextButton")
    Btn.Name = name .. "_Float"
    Btn.Parent = G.CG:FindFirstChild("YuukiWare")
    Btn.Size = config.Size or UDim2.new(0, 100, 0, 40)
    Btn.Position = UDim2.new(0.1, 0, 0.5, 0)
    Btn.BackgroundColor3 = config.BgColor or Color3.fromRGB(0, 0, 0)
    Btn.Text = config.Text or name:upper()
    Btn.TextColor3 = config.TextColor or Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.AutoButtonColor = false
    
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color = config.StrokeColor or Color3.fromRGB(150, 0, 0)
    Stroke.Thickness = 1.5
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    Drag.MakeDraggable(Btn)
    return Btn
end

-- 3. KEYBIND SYSTEM (Supports Mouse 4-9 + Local State)
function Functions.CreateKeybind(parent, position, callback, stateObject)
    local UIS = game:GetService("UserInputService")
    
    local BindBox = Instance.new("TextButton", parent)
    BindBox.Name = "KeybindBox"
    BindBox.Size = UDim2.new(0, 40, 0, 22)
    BindBox.Position = position
    BindBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    BindBox.Text = ". . ."
    BindBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    BindBox.Font = Enum.Font.GothamBold
    BindBox.TextSize = 10
    BindBox.AutoButtonColor = false
    
    Instance.new("UICorner", BindBox).CornerRadius = UDim.new(0, 4)
    local Stroke = Instance.new("UIStroke", BindBox)
    Stroke.Color = Color3.fromRGB(40, 40, 40)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local currentKey, currentMouse, isBinding = nil, nil, false

    BindBox.MouseButton1Click:Connect(function()
        if isBinding then return end
        isBinding = true
        BindBox.Text = "..."
        Stroke.Color = Color3.fromRGB(150, 0, 0)
        
        task.wait(0.2)
        
        local connection
        connection = UIS.InputBegan:Connect(function(input)
            local itype = input.UserInputType
            
            if itype == Enum.UserInputType.Keyboard then
                local code = input.KeyCode
                if code == Enum.KeyCode.Backspace or code == Enum.KeyCode.Escape then
                    currentKey, currentMouse = nil, nil
                    BindBox.Text = ". . ."
                    BindBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    currentKey, currentMouse = code, nil
                    BindBox.Text = code.Name:upper()
                    BindBox.TextColor3 = Color3.fromRGB(150, 0, 0)
                end
                isBinding = false
                Stroke.Color = Color3.fromRGB(40, 40, 40)
                connection:Disconnect()
            
            elseif itype.Name:find("MouseButton") and itype ~= Enum.UserInputType.MouseButton1 then
                currentMouse, currentKey = itype, nil
                BindBox.Text = itype.Name:gsub("MouseButton", "MB")
                BindBox.TextColor3 = Color3.fromRGB(150, 0, 0)
                isBinding = false
                Stroke.Color = Color3.fromRGB(40, 40, 40)
                connection:Disconnect()

            elseif itype == Enum.UserInputType.MouseButton1 or itype == Enum.UserInputType.Touch then
                isBinding = false
                Stroke.Color = Color3.fromRGB(40, 40, 40)
                connection:Disconnect()
            end
        end)
    end)

    UIS.InputBegan:Connect(function(input, gp)
        local isEnabled = (not stateObject) or (stateObject.Enabled)
        if not gp and not isBinding and isEnabled then
            if (currentKey and input.KeyCode == currentKey) or (currentMouse and input.UserInputType == currentMouse) then
                callback()
            end
        end
    end)

    return BindBox
end

return Functions
