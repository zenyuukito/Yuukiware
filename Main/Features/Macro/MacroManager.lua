-- YUUKIWARE: MACRO CATEGORY MANAGER
local Path = "https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Features/Macro/"
local Files = {
    "SanguineZBoost.lua", -- Add new macro filenames here as you create them!
}

return function(Page)
    for _, FileName in pairs(Files) do
        task.spawn(function()
            local Success, Result = pcall(function()
                local RawCode = game:HttpGet(Path .. FileName)
                
                -- Anti-404 Shield: Stops the "Incomplete Statement" error
                if RawCode:find("404: Not Found") then 
                    return nil 
                end
                
                return loadstring(RawCode)()
            end)

            -- If the file loaded a valid function, run it and give it the Page
            if Success and type(Result) == "function" then
                Result(Page)
            elseif not Success then
                warn("YuukiWare: Failed to load " .. FileName .. " | Error: " .. tostring(Result))
            end
        end)
    end
end
