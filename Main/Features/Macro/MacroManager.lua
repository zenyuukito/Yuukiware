-- YUUKIWARE: MACRO CATEGORY MANAGER
local Path = "https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Features/Macro/"

-- List your macro feature files here (e.g., "AutoFarm.lua", "AutoBus.lua")
local Files = {
    -- Add macro filenames as you create them
}

return function(Page)
    for _, fileName in ipairs(Files) do
        task.spawn(function()
            local success, result = pcall(function()
                local raw = game:HttpGet(Path .. fileName)
                -- 404 detection (GitHub raw returns 404 page content)
                if raw:match("404: Not Found") then
                    error("File not found: " .. fileName)
                end
                return loadstring(raw)()
            end)

            if success and type(result) == "function" then
                result(Page)
            elseif not success then
                warn("[Yuukiware MacroManager] Failed to load " .. fileName .. ": " .. tostring(result))
            end
        end)
    end
end
