local Functions = {}
local G = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Globals.lua"))()

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

function Functions.CreateKeybind(parent, position, callback)
    local UIS = game:GetService("UserInputService")
    
    local BindBox = Instance.new("TextButton")
    BindBox.Name = "KeybindBox"
    BindBox.Parent = parent
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

    local currentKey = nil
    local currentMouse = nil
    local isBinding = false

    BindBox.MouseButton1Click:Connect(function()
        if isBinding then return end
        isBinding = true
        BindBox.Text = "..."
        Stroke.Color = Color3.fromRGB(255, 50, 50)
        
        task.wait(0.2)
        
        local connection
        connection = UIS.InputBegan:Connect(function(input)
            local itype = input.UserInputType
            
            -- KEYBOARD
            if itype == Enum.UserInputType.Keyboard then
                local code = input.KeyCode
                if code == Enum.KeyCode.Backspace or code == Enum.KeyCode.Escape then
                    currentKey, currentMouse = nil, nil
                    BindBox.Text = ". . ."
                    BindBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    currentKey = code
                    currentMouse = nil
                    BindBox.Text = code.Name:upper()
                    BindBox.TextColor3 = Color3.fromRGB(255, 50, 50)
                end
                isBinding = false
                Stroke.Color = Color3.fromRGB(40, 40, 40)
                connection:Disconnect()
            
            -- MOUSE BUTTONS (MB4, MB5, MB6, etc.)
            elseif itype.Name:find("MouseButton") and itype ~= Enum.UserInputType.MouseButton1 then
                currentMouse = itype
                currentKey = nil
                -- Shortens "MouseButton4" to "MB4"
                BindBox.Text = itype.Name:gsub("MouseButton", "MB")
                BindBox.TextColor3 = Color3.fromRGB(255, 50, 50)
                isBinding = false
                Stroke.Color = Color3.fromRGB(40, 40, 40)
                connection:Disconnect()

            -- CLICK AWAY (If not clicking with a bindable button)
            elseif itype == Enum.UserInputType.MouseButton1 or itype == Enum.UserInputType.Touch then
                isBinding = false
                Stroke.Color = Color3.fromRGB(40, 40, 40)
                connection:Disconnect()
            end
        end)
    end)

    -- UNIVERSAL TRIGGER
    UIS.InputBegan:Connect(function(input, gp)
        if not gp and not isBinding then
            if currentKey and input.KeyCode == currentKey then
                callback()
            elseif currentMouse and input.UserInputType == currentMouse then
                callback()
            end
        end
    end)

    return BindBox
end

return Functions
