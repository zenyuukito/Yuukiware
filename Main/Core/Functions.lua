local Functions = {}
local G = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Globals.lua"))()

-- Master Switch State
Functions.Enabled = false 

function Functions.CreateMasterToggle(parent)
    local Toggle = Instance.new("TextButton", parent)
    Toggle.Name = "MasterToggle"
    Toggle.Size = UDim2.new(0, 25, 0, 25)
    Toggle.Position = UDim2.new(0, 10, 0.5, -12)
    Toggle.BackgroundColor3 = Color3.fromRGB(31, 35, 49) -- Oxford Blue
    Toggle.Text = ""
    Toggle.AutoButtonColor = false
    
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 4)
    local Stroke = Instance.new("UIStroke", Toggle)
    Stroke.Color = Color3.fromRGB(50, 50, 50)
    Stroke.Thickness = 2
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    Toggle.MouseButton1Click:Connect(function()
        Functions.Enabled = not Functions.Enabled
        if Functions.Enabled then
            Stroke.Color = Color3.fromRGB(255, 255, 255)
            Toggle.BackgroundColor3 = Color3.fromRGB(0, 33, 71)
        else
            Stroke.Color = Color3.fromRGB(50, 50, 50)
            Toggle.BackgroundColor3 = Color3.fromRGB(31, 35, 49)
        end
    end)
    return Toggle
end

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
    Drag.MakeDraggable(Btn)
    return Btn
end

function Functions.CreateKeybind(parent, position, callback)
    local UIS = game:GetService("UserInputService")
    local BindBox = Instance.new("TextButton", parent)
    BindBox.Size = UDim2.new(0, 40, 0, 22)
    BindBox.Position = position
    BindBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    BindBox.Text = ". . ."
    BindBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    BindBox.Font = Enum.Font.GothamBold
    BindBox.TextSize = 10
    Instance.new("UICorner", BindBox).CornerRadius = UDim.new(0, 4)
    local Stroke = Instance.new("UIStroke", BindBox)
    Stroke.Color = Color3.fromRGB(40, 40, 40)

    local currentKey, currentMouse, isBinding = nil, nil, false

    BindBox.MouseButton1Click:Connect(function()
        if isBinding then return end
        isBinding, BindBox.Text = true, "..."
        Stroke.Color = Color3.fromRGB(255, 50, 50)
        task.wait(0.2)
        local connection
        connection = UIS.InputBegan:Connect(function(input)
            local itype = input.UserInputType
            if itype == Enum.UserInputType.Keyboard then
                local code = input.KeyCode
                if code == Enum.KeyCode.Backspace or code == Enum.KeyCode.Escape then
                    currentKey, currentMouse = nil, nil
                    BindBox.Text = ". . ."
                else
                    currentKey, currentMouse = code, nil
                    BindBox.Text = code.Name:upper()
                end
                isBinding = false
                Stroke.Color = Color3.fromRGB(40, 40, 40)
                connection:Disconnect()
            elseif itype.Name:find("MouseButton") and itype ~= Enum.UserInputType.MouseButton1 then
                currentMouse, currentKey = itype, nil
                BindBox.Text = itype.Name:gsub("MouseButton", "MB")
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
        -- ADDED THE MASTER CHECK HERE DIRECTLY
        if not gp and not isBinding and Functions.Enabled then
            if (currentKey and input.KeyCode == currentKey) or (currentMouse and input.UserInputType == currentMouse) then
                callback()
            end
        end
    end)
    return BindBox
end

return Functions
