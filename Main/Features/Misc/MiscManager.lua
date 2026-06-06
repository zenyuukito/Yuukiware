return function(TabParent)
    Instance.new("UIListLayout", TabParent).Padding = UDim.new(0, 5)

    local function AddFeature(name, scriptUrl)
        local C = Instance.new("Frame", TabParent)
        C.Size, C.BackgroundTransparency = UDim2.new(1, 0, 0, 30), 1
        
        local L = Instance.new("TextLabel", C)
        L.Text, L.Size, L.Position = name, UDim2.new(1, -40, 1, 0), UDim2.new(0, 40, 0, 0)
        L.BackgroundTransparency, L.TextColor3, L.Font, L.TextSize, L.TextXAlignment = 1, Color3.new(1, 1, 1), 17, 14, 0
        
        task.spawn(function()
            local f = loadstring(game:HttpGet(scriptUrl))
            if f then f(C) end
        end)
    end

    AddFeature("Sanguine Z Boost", "https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Features/Misc/SanguineZBoost.lua")
end
