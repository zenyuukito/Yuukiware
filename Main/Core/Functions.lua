-- YUUKIWARE: CORE MODULE (Globals + Keybind + Toggle)
-- Single file to reduce HTTP requests and ensure dependency order

local Core = {}

-- ===============================
-- 1. HELPER FUNCTION
-- ===============================
local function Cr(cl, p)
    local i = Instance.new(cl)
    for k, v in pairs(p) do i[k] = v end
    return i
end

-- ===============================
-- 2. GLOBALS (Cached Services)
-- ===============================
local Globals = {}

Globals.Players = game:GetService("Players")
Globals.LP = Globals.Players.LocalPlayer
Globals.TS = game:GetService("TweenService")
Globals.UIS = game:GetService("UserInputService")
Globals.RS = game:GetService("RunService")
Globals.CG = game:GetService("CoreGui")
Globals.VP = game:GetService("VirtualUser")
Globals.HTTP = game:GetService("HttpService")
Globals.ReplicatedStorage = game:GetService("ReplicatedStorage")
Globals.Lighting = game:GetService("Lighting")

-- Delta-safe VirtualUser
local vuSuccess, vu = pcall(function() return game:GetService("VirtualUser") end)
Globals.VirtualUser = vuSuccess and vu or nil

-- World/Character
Globals.Cam = workspace.CurrentCamera
Globals.Workspace = workspace

function Globals.GetChar()
    return Globals.LP.Character or Globals.Workspace:FindFirstChild(Globals.LP.Name)
end

-- Blox Fruits specific
Globals.Knockback = Globals.ReplicatedStorage:FindFirstChild("Knockback")

-- Cleanup hook (to be filled by loader)
Globals.Cleanup = {}

Core.Globals = Globals

-- ===============================
-- 3. KEYBIND SYSTEM (Mobile + PC)
-- ===============================
local Keybind = {}
local UIS = Globals.UIS

local function GetInputName(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        return input.KeyCode.Name
    elseif input.UserInputType == Enum.UserInputType.Touch then
        return "Touch"
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        return "Mouse"
    end
    return "?"
end

function Keybind:Add(Parent, DefaultKey, Callback, options)
    options = options or {}
    local allowTouch = options.allowTouch ~= false
    local Crimson = Color3.fromRGB(150, 0, 0)
    
    local CurrentInput = { Type = DefaultKey, Name = (type(DefaultKey) == "string" and DefaultKey) or DefaultKey.Name }
    local Binding = false
    local RebindConnection = nil
    local TriggerConnection = nil

    local BindBtn = Cr("TextButton", {
        Parent = Parent,
        Size = UDim2.new(0, 70, 0, 24),
        Position = UDim2.new(1, -75, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Text = CurrentInput.Name,
        TextColor3 = Color3.new(1, 1, 1),
        Font = 17,
        TextSize = 12,
        AutoButtonColor = false
    })
    Cr("UICorner", {Parent = BindBtn, CornerRadius = UDim.new(0, 4)})
    local Stroke = Cr("UIStroke", {Parent = BindBtn, Color = Crimson, Thickness = 1, Transparency = 0.8})

    local function StartRebind()
        if Binding then return end
        Binding = true
        BindBtn.Text = "..."
        Stroke.Transparency = 0
        if RebindConnection then RebindConnection:Disconnect() end
        RebindConnection = UIS.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            local accepted = false
            if input.UserInputType == Enum.UserInputType.Keyboard then
                CurrentInput = { Type = input.KeyCode, Name = input.KeyCode.Name }
                accepted = true
            elseif allowTouch and input.UserInputType == Enum.UserInputType.Touch then
                CurrentInput = { Type = "Touch", Name = "Touch" }
                accepted = true
            elseif allowTouch and input.UserInputType == Enum.UserInputType.MouseButton1 then
                CurrentInput = { Type = "Mouse", Name = "Mouse" }
                accepted = true
            end
            if accepted then
                BindBtn.Text = CurrentInput.Name
                Stroke.Transparency = 0.8
                Binding = false
                RebindConnection:Disconnect()
                RebindConnection = nil
            end
        end)
    end

    BindBtn.MouseButton1Click:Connect(StartRebind)
    if allowTouch then
        BindBtn.TouchTap:Connect(StartRebind)
    end

    local function HandleInput(input, gameProcessed)
        if gameProcessed or Binding then return end
        local matches = false
        if CurrentInput.Type == "Touch" and input.UserInputType == Enum.UserInputType.Touch then
            matches = true
        elseif CurrentInput.Type == "Mouse" and input.UserInputType == Enum.UserInputType.MouseButton1 then
            matches = true
        elseif type(CurrentInput.Type) == "EnumItem" and input.KeyCode == CurrentInput.Type then
            matches = true
        end
        if matches then
            local success, err = pcall(Callback)
            if not success then warn("[Keybind] Callback error: " .. tostring(err)) end
        end
    end

    TriggerConnection = UIS.InputBegan:Connect(HandleInput)

    local function Cleanup()
        if RebindConnection then RebindConnection:Disconnect() end
        if TriggerConnection then TriggerConnection:Disconnect() end
    end
    BindBtn.Destroying:Connect(Cleanup)

    local Public = {
        GetKey = function() return CurrentInput.Name end,
        SetKey = function(newKey)
            if type(newKey) == "string" then
                CurrentInput = { Type = newKey, Name = newKey }
            elseif newKey.KeyCode then
                CurrentInput = { Type = newKey.KeyCode, Name = newKey.KeyCode.Name }
            end
            BindBtn.Text = CurrentInput.Name
        end,
        Destroy = Cleanup
    }
    return BindBtn, Public
end

Core.Keybind = Keybind

-- ===============================
-- 4. TOGGLE SYSTEM (Oxford Blue)
-- ===============================
local Toggle = {}
local TS = Globals.TS

-- Oxford Blue (#002147)
local OxfordBlue = Color3.fromRGB(0, 33, 71)

function Toggle:Create(Page, Text, InitialState, Callback)
    local Enabled = InitialState or false
    local Connections = {}

    local Row = Cr("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1})
    local Lbl = Cr("TextLabel", {
        Parent = Row, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(0.5, 0, 1, 0),
        Text = Text:upper(), TextColor3 = Color3.new(1,1,1), BackgroundTransparency = 1,
        TextXAlignment = 0, Font = 17, TextSize = 13
    })
    local Switch = Cr("TextButton", {
        Parent = Row, Position = UDim2.new(1, -45, 0.5, -9), Size = UDim2.new(0, 35, 0, 18),
        BackgroundColor3 = Enabled and OxfordBlue or Color3.fromRGB(30, 30, 30), Text = "", AutoButtonColor = false
    })
    Cr("UICorner", {Parent = Switch, CornerRadius = UDim.new(1, 0)})
    local Knob = Cr("Frame", {
        Parent = Switch, Position = Enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
        Size = UDim2.new(0, 14, 0, 14), BackgroundColor3 = Color3.new(1,1,1)
    })
    Cr("UICorner", {Parent = Knob, CornerRadius = UDim.new(1, 0)})

    local function SetToggle(state)
        if Enabled == state then return end
        Enabled = state
        TS:Create(Knob, TweenInfo.new(0.2), {
            Position = Enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        }):Play()
        TS:Create(Switch, TweenInfo.new(0.2), {
            BackgroundColor3 = Enabled and OxfordBlue or Color3.fromRGB(30, 30, 30)
        }):Play()
        pcall(Callback, Enabled)
    end

    local function OnClick() SetToggle(not Enabled) end
    local clickConn = Switch.MouseButton1Click:Connect(OnClick)
    table.insert(Connections, clickConn)
    local touchConn = Switch.TouchTap:Connect(OnClick)
    table.insert(Connections, touchConn)

    local Public = {
        Get = function() return Enabled end,
        Set = SetToggle,
        Destroy = function()
            for _, conn in ipairs(Connections) do pcall(function() conn:Disconnect() end) end
            Row:Destroy()
        end
    }

    Row.AncestryChanged:Connect(function()
        if not Row.Parent then
            for _, conn in ipairs(Connections) do pcall(function() conn:Disconnect() end) end
        end
    end)

    return Row, Public
end

Core.Toggle = Toggle

-- ===============================
-- RETURN EVERYTHING
-- ===============================
return Core
