-- YUUKIWARE: MACRO CATEGORY MANAGER  
local Path = "https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Features/Macro/"
local Files = {
    "SanguineZBoost.lua"  -- ← Add your macro files here
}

return function(Page)
    for _, fileName in ipairs(Files) do
        task.spawn(function()
            local success, result = pcall(function()
                local raw = game:HttpGet(Path .. fileName)
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
