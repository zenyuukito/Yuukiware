-- YUUKIWARE: MACRO MANAGER
local Container = ... -- Passed from the main loader
local G = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Globals.lua"))()

local MacroConfig = {
    BaseUrl = "https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Features/Macro/",
    -- ONLY touch this list when adding new files to the Macro folder
    Registry = {
        "SanguineZBoost",
        -- "AutoFarm", 
        -- "ChestCollector",
    }
}

-- UI Layout for the Macros
local Layout = Instance.new("UIListLayout")
Layout.Parent = Container
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- The Loader Loop
for _, fileName in ipairs(MacroConfig.Registry) do
    task.spawn(function()
        local fullPath = MacroConfig.BaseUrl .. fileName .. ".lua"
        local success, code = pcall(game.HttpGet, game, fullPath)
        
        if success then
            local func, err = loadstring(code)
            if func then
                -- Execute the macro and pass the Container and Globals
                -- This allows the macro file to create its own Buttons/Toggles
                local execSuccess, execErr = pcall(func, Container, G)
                
                if not execSuccess then
                    warn("[YuukiWare] Execution error in " .. fileName .. ": " .. execErr)
                end
            else
                warn("[YuukiWare] Syntax error in " .. fileName .. ": " .. err)
            end
        else
            warn("[YuukiWare] Failed to fetch macro: " .. fileName)
        end
    end)
end

return true
