local UIS = game:GetService("UserInputService")
local MobileUI = {}

function MobileUI:CreateButton(name, callback)
    if not UIS.TouchEnabled then return end
    
    local sg = game:GetService("CoreGui"):FindFirstChild("MC") or Instance.new("ScreenGui", game:GetService("CoreGui"))
    sg.Name = "MC"

    -- Using a minimal property setter
    local function Cr(cl, p) local i = Instance.new(cl) for k,v in pairs(p) do i[k]=v end return i end

    local btn = Cr("TextButton", {
        Parent = sg, Name = name, Size = UDim2.new(0,50,0,50), Position = UDim2.new(0.1,0,0.5,0),
        Text = name, BackgroundColor3 = Color3.fromRGB(15,15,15), TextColor3 = Color3.new(1,1,1),
        Font = 17, TextSize = 14, AutoButtonColor = false
    })
    Cr("UICorner", {Parent = btn, CornerRadius = UDim.new(1,0)})
    Cr("UIStroke", {Parent = btn, Color = Color3.fromRGB(255,50,50), Thickness = 1.5, Transparency = 0.5})

    -- Self-Contained Dragging Logic
    local dragStart, startPos
    
    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            dragStart, startPos = i.Position, btn.Position
        end
    end)

    btn.InputChanged:Connect(function(i)
        if dragStart and i.UserInputType == Enum.UserInputType.Touch then
            local delta = i.Position - dragStart
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    btn.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then dragStart = nil end
    end)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

return MobileUI
