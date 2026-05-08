-- YUUKIWARE: MACRO CATEGORY MANAGER (DEBUG)
return function(Page)
    -- Force a red label so we know the manager itself ran
    local test = Instance.new("TextLabel")
    test.Size = UDim2.new(1, 0, 0, 30)
    test.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    test.Text = "MACRO MANAGER ACTIVE"
    test.TextColor3 = Color3.new(1, 1, 1)
    test.TextScaled = true
    test.Parent = Page

    -- Now also try to load a simple macro to confirm path works
    local Path = "https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Features/Macro/"
    local fileName = "SanguineZBoost.lua"
    
    local ok, raw = pcall(game.HttpGet, game, Path .. fileName)
    if not ok then
        test.Text = "FAILED TO FETCH MACRO: " .. tostring(raw)
        return
    end
    
    -- Try to loadstring
    local fn, err = loadstring(raw)
    if not fn then
        test.Text = "LOADSTRING ERROR: " .. tostring(err)
        return
    end
    
    -- Execute
    local success, result = pcall(fn)
    if success and type(result) == "function" then
        result(Page)
        test.Text = "MACRO LOADED SUCCESSFULLY"
    else
        test.Text = "MACRO EXEC ERROR: " .. tostring(result)
    end
end
