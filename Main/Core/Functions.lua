function Functions.CreateKeybind(parent, position, callback)
    local UIS = game:GetService("UserInputService")
    
    local BindBox = Instance.new("TextButton")
    BindBox.Name = "KeybindBox"
    BindBox.Parent = parent
    BindBox.Size = UDim2.new(0, 35, 0, 20)
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
    local isBinding = false

    BindBox.MouseButton1Click:Connect(function()
        if isBinding then return end
        isBinding = true
        BindBox.Text = "..."
        BindBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        Stroke.Color = Color3.fromRGB(255, 50, 50)

        -- THE FIX: Wait a fraction of a second so your current click/tap doesn't instantly cancel the bind
        task.wait(0.15)

        local connection
        connection = UIS.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                
                -- Added Feature: Pressing Backspace or Escape clears the bind
                if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Escape then
                    currentKey = nil
                    BindBox.Text = ". . ."
                    BindBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Stroke.Color = Color3.fromRGB(40, 40, 40)
                    isBinding = false
                    connection:Disconnect()
                    return
                end

                -- Normal Bind
                if input.KeyCode ~= Enum.KeyCode.Unknown then
                    currentKey = input.KeyCode
                    BindBox.Text = currentKey.Name:upper()
                    BindBox.TextColor3 = Color3.fromRGB(255, 50, 50)
                    Stroke.Color = Color3.fromRGB(40, 40, 40)
                    isBinding = false
                    connection:Disconnect()
                end

            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                -- Clicked away, cancel bind and revert to previous state
                isBinding = false
                BindBox.Text = currentKey and currentKey.Name:upper() or ". . ."
                BindBox.TextColor3 = currentKey and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
                Stroke.Color = Color3.fromRGB(40, 40, 40)
                connection:Disconnect()
            end
        end)
    end)

    UIS.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and not isBinding and currentKey and input.KeyCode == currentKey then
            callback()
        end
    end)

    return BindBox
end
