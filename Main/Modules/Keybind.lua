local Keybind = {}
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function Cr(cl, p)
    local i = Instance.new(cl)
    for k, v in pairs(p) do i[k] = v end
    return i
end

-- Helper: Convert input to readable name
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
    local allowTouch = options.allowTouch ~= false  -- Default true for mobile
    local Crimson = Color3.fromRGB(150, 0, 0)
    
    -- DefaultKey can be KeyCode or "Touch" string
    local CurrentInput = { Type = DefaultKey, Name = (type(DefaultKey) == "string" and DefaultKey) or DefaultKey.Name }
    local Binding = false
    local RebindConnection = nil
    local TriggerConnection = nil

    -- UI Setup
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

    -- Rebind logic (supports both keyboard and touch)
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

    -- Trigger logic
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
            if not success then
                warn("[Keybind] Callback error: " .. tostring(err))
            end
        end
    end

    TriggerConnection = UIS.InputBegan:Connect(HandleInput)

    -- Cleanup on button destroy
    local function Cleanup()
        if RebindConnection then RebindConnection:Disconnect() end
        if TriggerConnection then TriggerConnection:Disconnect() end
    end
    BindBtn.Destroying:Connect(Cleanup)
    -- Also if parent is removed
    if Parent then
        local ancestryConn
        ancestryConn = BindBtn.AncestryChanged:Connect(function()
            if not BindBtn.Parent then
                Cleanup()
                if ancestryConn then ancestryConn:Disconnect() end
            end
        end)
    end

    -- Public methods
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

return Keybind
