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
    BindBox.Size = UDim2.new(0, 35, 0, 20)
    BindBox.Position = position
    BindBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    BindBox.Text = ". . ."
    BindBox.TextColor3 = Color3.fromRGB(255, 255, 255) -- White default
    BindBox.Font = Enum.Font.GothamBold
    BindBox.TextSize = 10
    BindBox.AutoButtonColor = false
    
    Instance.new("UICorner", BindBox).CornerRadius = UDim.new(0, 4)
    local Stroke = Instance.new("UIStroke", BindBox)
    Stroke.Color = Color3.fromRGB(40, 40, 40)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local currentKey = nil
    local isBinding = false

    -- Clicking the box to bind
    BindBox.MouseButton1Click:Connect(function()
        if isBinding then return end
        isBinding = true
        BindBox.Text = "..."
        BindBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        Stroke.Color = Color3.fromRGB(255, 50, 50) -- Highlight border while listening

        local connection
        connection = UIS.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                -- Key pressed, save it
                currentKey = input.KeyCode
                BindBox.Text = currentKey.Name:upper()
                BindBox.TextColor3 = Color3.fromRGB(255, 50, 50) -- Turn Crimson
                Stroke.Color = Color3.fromRGB(40, 40, 40)
                isBinding = false
                connection:Disconnect()
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                -- Clicked away, cancel bind
                isBinding = false
                BindBox.Text = currentKey and currentKey.Name:upper() or ". . ."
                BindBox.TextColor3 = currentKey and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
                Stroke.Color = Color3.fromRGB(40, 40, 40)
                connection:Disconnect()
            end
        end)
    end)

    -- Listening for the actual bound key press
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and not isBinding and currentKey and input.KeyCode == currentKey then
            callback()
        end
    end)

    return BindBox
end

return Functions
