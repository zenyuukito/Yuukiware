local Container, G = ...

-- Colors
local OXFORD_BLUE = Color3.fromRGB(0, 33, 71)
local DARK_BG = Color3.fromRGB(15, 15, 15)
local MENU_GREEN = Color3.fromRGB(0, 255, 120)

local function Cr(cl, p, props)
    local i = Instance.new(cl)
    i.Parent = p
    for k, v in pairs(props) do i[k] = v end
    return i
end

-- 1. Main Row
local Row = Cr("Frame", Container, {
    Name = "SanguineZBoost",
    BackgroundColor3 = DARK_BG,
    Size = UDim2.new(1, 0, 0, 50),
    BorderSizePixel = 0
})
Cr("UICorner", Row, {CornerRadius = UDim.new(0, 8)})

local Title = Cr("TextLabel", Row, {
    Text = "Sanguine Z Boost",
    Position = UDim2.new(0, 12, 0, 0),
    Size = UDim2.new(0.4, 0, 1, 0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 14,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = 0
})

-- 2. Pill Toggle (Matches Screenshot 1)
local ToggleBase = Cr("TextButton", Row, {
    Text = "",
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    Position = UDim2.new(1, -110, 0.5, -12),
    Size = UDim2.new(0, 45, 0, 24),
    AutoButtonColor = false
})
Cr("UICorner", ToggleBase, {CornerRadius = UDim.new(1, 0)})

local Knob = Cr("Frame", ToggleBase, {
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    Position = UDim2.new(0, 2, 0.5, -10),
    Size = UDim2.new(0, 20, 0, 20)
})
Cr("UICorner", Knob, {CornerRadius = UDim.new(1, 0)})

-- 3. Keybind (Matches Oxford Blue requirement)
local BindBtn = Cr("TextButton", Row, {
    Text = "Z",
    Size = UDim2.new(0, 40, 0, 24),
    Position = UDim2.new(1, -50, 0.5, -12),
    BackgroundColor3 = OXFORD_BLUE,
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 12
})
Cr("UICorner", BindBtn, {CornerRadius = UDim.new(0, 4)})

-- 4. Floating Menu Button (Matches Screenshot 2)
local FloatingMenu = Cr("TextButton", G.CG:FindFirstChild("YuukiWare"), {
    Text = "MENU",
    Size = UDim2.new(0, 60, 0, 30),
    Position = UDim2.new(0, 100, 0, 5), -- Positioned near top-bar
    BackgroundColor3 = Color3.fromRGB(10, 10, 10),
    TextColor3 = MENU_GREEN,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    Visible = G.UIS.TouchEnabled
})
Cr("UICorner", FloatingMenu, {CornerRadius = UDim.new(0, 6)})
Cr("UIStroke", FloatingMenu, {Color = Color3.new(1,1,1), Thickness = 1, Transparency = 0.8})

-- Toggle Logic
local active = false
ToggleBase.MouseButton1Click:Connect(function()
    active = not active
    G.TS:Create(ToggleBase, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(30, 30, 30)}):Play()
    G.TS:Create(Knob, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}):Play()
end)

return true
