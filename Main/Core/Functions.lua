local Functions = {}
local G = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Globals.lua"))()

function Functions.CreateFloating(name, callback)
    local Drag = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Dragging.lua"))()
    
    local Btn = Instance.new("TextButton")
    Btn.Name = name .. "_Float"
    Btn.Parent = G.CG:FindFirstChild("YuukiWare")
    Btn.Size = UDim2.new(0, 50, 0, 50)
    Btn.Position = UDim2.new(0.1, 0, 0.5, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(0, 33, 71) -- Oxford Blue
    Btn.Text = name:sub(1,1) -- First letter
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Font = Enum.Font.GothamBold
    
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
    Drag.MakeDraggable(Btn)
    
    Btn.MouseButton1Click:Connect(callback)
    
    return Btn
end

return Functions
