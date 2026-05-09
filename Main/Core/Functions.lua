local Functions = {}
local G = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Globals.lua"))()

function Functions.CreateFloating(name)
    local Drag = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Dragging.lua"))()
    
    local Btn = Instance.new("TextButton")
    Btn.Name = name .. "_Float"
    Btn.Parent = G.CG:FindFirstChild("YuukiWare")
    Btn.Size = UDim2.new(0, 80, 0, 32) -- Rectangular shape like your screenshot
    Btn.Position = UDim2.new(0.1, 0, 0.5, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(80, 0, 0) -- Dark Crimson
    Btn.Text = name:upper()
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.Gotham -- Clean, less bold
    Btn.TextSize = 12
    Btn.AutoButtonColor = false
    
    local Corner = Instance.new("UICorner", Btn)
    Corner.CornerRadius = UDim.new(0, 6)
    
    -- Outline to make it "pop"
    local Stroke = Instance.new("UIStroke", Btn)
    Stroke.Color = Color3.fromRGB(120, 0, 0)
    Stroke.Thickness = 1
    
    Drag.MakeDraggable(Btn)
    
    return Btn
end

return Functions
