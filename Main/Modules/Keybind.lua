local Keybind = {}
local UIS = game:GetService("UserInputService")

function Keybind:Add(Parent, Default, Callback)
    local BindBtn = Instance.new("TextButton", Parent)
    BindBtn.Size = UDim2.new(0, 55, 0, 24)
    BindBtn.Position = UDim2.new(1, -60, 0, 4)
    BindBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    BindBtn.Text = tostring(Default):gsub("Enum.KeyCode.", "")
    BindBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)

    local CurrentKey = Default
    
    BindBtn.MouseButton1Click:Connect(function()
        BindBtn.Text = "..."
        local Connection; Connection = UIS.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                CurrentKey = input.KeyCode
                BindBtn.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                Connection:Disconnect()
            end
        end)
    end)

    UIS.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == CurrentKey then
            Callback()
        end
    end)
end

return Keybind -- CRITICAL: Sends the "Add" function back
