local Keybind = {}
local UIS = game:GetService("UserInputService")

local function Cr(cl, p) 
    local i = Instance.new(cl) 
    for k, v in pairs(p) do i[k] = v end 
    return i 
end

function Keybind:Add(Parent, Default, Callback)
    local Crimson = Color3.fromRGB(150, 0, 0)
    local CurrentKey = Default
    local Binding = false

    -- UI Setup (Matches your Toggle/Main Menu style)
    local BindBtn = Cr("TextButton", {
        Parent = Parent,
        Size = UDim2.new(0, 60, 0, 22),
        Position = UDim2.new(1, -65, 0.5, -11),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Text = Default.Name,
        TextColor3 = Color3.new(1, 1, 1),
        Font = 17,
        TextSize = 12,
        AutoButtonColor = false
    })
    Cr("UICorner", {Parent = BindBtn, CornerRadius = UDim.new(0, 4)})
    local Stroke = Cr("UIStroke", {Parent = BindBtn, Color = Crimson, Thickness = 1, Transparency = 0.8})

    -- 1. Listening for the "Rebind"
    BindBtn.MouseButton1Click:Connect(function()
        if Binding then return end
        Binding = true
        BindBtn.Text = "..."
        Stroke.Transparency = 0 -- Highlight when binding
        
        local Connection; Connection = UIS.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                CurrentKey = input.KeyCode
                BindBtn.Text = input.KeyCode.Name
                Stroke.Transparency = 0.8
                Binding = false
                Connection:Disconnect()
            end
        end)
    end)

    -- 2. The Trigger (Memory Safe)
    local Trigger = UIS.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == CurrentKey and not Binding then
            task.spawn(Callback)
        end
    end)

    -- Cleanup logic: If the button is destroyed, the keybind stops listening
    BindBtn.Destroying:Connect(function()
        Trigger:Disconnect()
    end)

    return BindBtn
end

return Keybind
