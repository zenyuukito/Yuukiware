local Container, G = ...

-- Colors & Constants
local OXFORD_BLUE = Color3.fromRGB(0, 33, 71)
local OFF_COLOR = Color3.fromRGB(25, 25, 25)
local TEXT_COLOR = Color3.fromRGB(200, 200, 200)

-- Helper for quick Instance creation
local function Cr(cl, p, props)
    local i = Instance.new(cl)
    i.Parent = p
    for k, v in pairs(props) do i[k] = v end
    return i
end

-- 1. Main Row Frame
local Row = Cr("Frame", Container, {
    Name = "SanguineZBoost",
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    Size = UDim2.new(1, 0, 0, 45),
    BorderSizePixel = 0
})
Cr("UICorner", Row, {CornerRadius = UDim.new(0, 6)})
Cr("UIPadding", Row, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})

local Title = Cr("TextLabel", Row, {
    Text = "Sanguine Z Boost",
    Size = UDim2.new(0.5, 0, 1, 0),
    BackgroundTransparency = 1,
    TextColor3 = TEXT_COLOR,
    TextSize = 14,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- 2. Toggle Button
local Toggled = false
local ToggleBtn = Cr("TextButton", Row, {
    Text = "OFF",
    Size = UDim2.new(0, 80, 0, 28),
    Position = UDim2.new(1, -150, 0.5, -14),
    BackgroundColor3 = OFF_COLOR,
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 11
})
Cr("UICorner", ToggleBtn, {CornerRadius = UDim.new(0, 4)})

-- 3. Keybind Button
local CurrentKey = Enum.KeyCode.Z
local BindBtn = Cr("TextButton", Row, {
    Text = "[ Z ]",
    Size = UDim2.new(0, 60, 0, 28),
    Position = UDim2.new(1, -60, 0.5, -14),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    TextColor3 = Color3.fromRGB(150, 150, 150),
    Font = Enum.Font.Code,
    TextSize = 12
})
Cr("UICorner", BindBtn, {CornerRadius = UDim.new(0, 4)})

-- 4. Mobile Floating Button
local MobileBtn = Cr("ImageButton", G.CG:FindFirstChild("YuukiWare"), {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0.8, 0, 0.5, 0),
    BackgroundColor3 = OXFORD_BLUE,
    Visible = G.UIS.TouchEnabled, -- Only visible if on mobile/touch device
    ZIndex = 10
})
Cr("UICorner", MobileBtn, {CornerRadius = UDim.new(1, 0)})
Cr("UIStroke", MobileBtn, {Color = Color3.new(1,1,1), Thickness = 2, Transparency = 0.8})

-- UI Visual Logic
ToggleBtn.MouseButton1Click:Connect(function()
    Toggled = not Toggled
    G.TS:Create(ToggleBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Toggled and OXFORD_BLUE or OFF_COLOR,
        Text = Toggled and "ON" or "OFF"
    }):Play()
end)

-- Note: No functionality added yet as requested. 
-- Logic for Keybinding and the Boost loop goes here later.

return true
