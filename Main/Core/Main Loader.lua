-- YUUKIWARE MAIN LOADER
local Config = {
    -- Change these if you rename your repo or folders
    RepoBase = "https://raw.githubusercontent.com/zenyuukito/Yuukiware/main/",
    IconID = "111918789930704"
}

local CG, TS, C = game:GetService("CoreGui"), game:GetService("TweenService"), workspace.CurrentCamera

-- 1. Clean Environment
if CG:FindFirstChild("YuukiWare") then CG.YuukiWare:Destroy() end

local SG = Instance.new("ScreenGui", CG) 
SG.Name, SG.IgnoreGuiInset = "YuukiWare", true

local US = Instance.new("UIScale", SG)
local function UpS() US.Scale = math.clamp(C.ViewportSize.X / 1920, 0.75, 1.25) end
UpS() C:GetPropertyChangedSignal("ViewportSize"):Connect(UpS)

local function Cr(cl, p) local i = Instance.new(cl) for k, v in pairs(p) do i[k] = v end return i end

-- 2. Build the Draggable Icon (Merged Properties)
local IC = Cr("ImageButton", {Parent = SG, BackgroundColor3 = Color3.fromRGB(0,0,0), Position = UDim2.new(0.05, 0, 0.1, 0), Size = UDim2.new(0, 42, 0, 42), ClipsDescendants = true, AutoButtonColor = false})
Cr("UICorner", {Parent = IC, CornerRadius = UDim.new(0, 12)})
Cr("ImageLabel", {Parent = IC, BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5,0,0.5,0), Size = UDim2.new(0.85,0,0.85,0), Image = "rbxthumb://type=Asset&id="..Config.IconID.."&w=420&h=420", ScaleType = Enum.ScaleType.Fit})

-- 3. Build the Main Menu Container
local M = Cr("Frame", {Parent = SG, BackgroundColor3 = Color3.fromRGB(10, 10, 10), Position = UDim2.new(0.5, -325, 0.5, -200), Size = UDim2.new(0, 650, 0, 400), Visible = false, ClipsDescendants = true, Active = true})
Cr("UICorner", {Parent = M, CornerRadius = UDim.new(0, 10)})
Cr("TextButton", {Parent = M, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "", Modal = true})

local TB = Cr("Frame", {Parent = M, BackgroundColor3 = Color3.fromRGB(15, 15, 15), Size = UDim2.new(1, 0, 0, 42)})
Cr("UICorner", {Parent = TB, CornerRadius = UDim.new(0, 10)})
Cr("TextLabel", {Parent = TB, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0, 300, 1, 0), Text = "YUUKIWARE", TextColor3 = Color3.fromRGB(255, 50, 50), TextSize = 19, Font = 19, TextXAlignment = 0, TextTransparency = 0.6, ZIndex = 2})

local Mn = Cr("TextButton", {Parent = TB, BackgroundTransparency = 1, Position = UDim2.new(1, -80, 0, 0), Size = UDim2.new(0, 35, 1, 0), Text = "-", TextColor3 = Color3.new(1,1,1), TextSize = 20, Font = 17})
local Kl = Cr("TextButton", {Parent = TB, BackgroundTransparency = 1, Position = UDim2.new(1, -40, 0, 0), Size = UDim2.new(0, 35, 1, 0), Text = "x", TextColor3 = Color3.fromRGB(255, 50, 50), TextSize = 20, Font = 17})

local TC = Cr("Frame", {Parent = M, BackgroundColor3 = Color3.fromRGB(12, 12, 12), Position = UDim2.new(0, 0, 0, 42), Size = UDim2.new(1, 0, 0, 35)})
local PC = Cr("Frame", {Parent = M, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 85), Size = UDim2.new(1, -20, 1, -95)})
local L = Instance.new("UIListLayout", TC) L.FillDirection, L.Padding = 0, UDim.new(0, 5)
local Pad = Instance.new("UIPadding", TC) Pad.PaddingLeft, Pad.PaddingRight, Pad.PaddingTop, Pad.PaddingBottom = UDim.new(0,5), UDim.new(0,5), UDim.new(0,5), UDim.new(0,5)

-- 4. Tab Logic & Feature Auto-Loader
local Tabs, Pg, mi = {"Macro", "FastFlags", "Misc"}, {}, false

for i, v in ipairs(Tabs) do
    local B = Cr("TextButton", {Parent = TC, BackgroundColor3 = Color3.fromRGB(20, 20, 20), Size = UDim2.new(1/#Tabs, -5, 1, 0), Text = v:upper(), TextColor3 = (i==1 and Color3.new(1, 0.2, 0.2) or Color3.new(0.6, 0.6, 0.6)), Font = 17, TextSize = 12, LayoutOrder = i})
    Cr("UICorner", {Parent = B, CornerRadius = UDim.new(0, 4)})
    
    local S = Cr("ScrollingFrame", {Parent = PC, Name = v, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = (i==1), ScrollBarThickness = 2, ScrollBarImageColor3 = Color3.new(1, 0.2, 0.2), AutomaticCanvasSize = 2, CanvasSize = UDim2.new(0,0,0,0)})
    Pg[v] = S
    
    -- Dynamically loads from the /Features folder based on your Config
    task.spawn(function()
        local s, func = pcall(function() return loadstring(game:HttpGet(Config.RepoBase .. "Modules/" .. v .. ".lua"))() end)
        if s and type(func) == "function" then func(S) end
    end)

    B.MouseButton1Click:Connect(function()
        for n, p in pairs(Pg) do p.Visible = (n == v) end
        for _, b in pairs(TC:GetChildren()) do if b:IsA("TextButton") then TS:Create(b, TweenInfo.new(0.2), {TextColor3 = (b == B and Color3.new(1, 0.2, 0.2) or Color3.new(0.6, 0.6, 0.6))}):Play() end end
    end)
end

-- 5. Global Button Connections
IC.MouseButton1Click:Connect(function() M.Visible = not M.Visible end)
Kl.MouseButton1Click:Connect(function() SG:Destroy() end)
Mn.MouseButton1Click:Connect(function() 
    mi = not mi 
    TS:Create(M, TweenInfo.new(0.3), {Size = mi and UDim2.new(0, 650, 0, 42) or UDim2.new(0, 650, 0, 400)}):Play() 
    Mn.Text = mi and "+" or "-" 
end)

-- 6. Attach Dragging Module
task.spawn(function() 
    local s, d = pcall(function() return loadstring(game:HttpGet(Config.RepoBase .. "Core/Dragging.lua"))() end)
    if s and d then 
        d.MakeDraggable(IC)     -- Icon is draggable anywhere
        d.MakeDraggable(M, TB)  -- Menu is dragged via the TopBar (TB)
    end 
end)
