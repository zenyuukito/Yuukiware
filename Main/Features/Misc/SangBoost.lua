local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Functions.lua"))()
local G = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Globals.lua"))()

local MiscFrame = G.CG:WaitForChild("YuukiWare") -- Adjust this path if your Misc tab is nested deeper
local State = Functions.CreateMasterToggle(MiscFrame)

local function listen(char)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end
    
    hrp.ChildAdded:Connect(function(c)
        if not State.Enabled then return end

        local isBV = c:IsA("BodyVelocity")
        if (isBV or c:IsA("LinearVelocity")) and not c:GetAttribute("S") then
            local p = isBV and "Velocity" or "VectorVelocity"
            local orig = c[p]
            
            if orig.Magnitude < 20 then return end
            
            local cl = c:Clone()
            cl:SetAttribute("S", true)
            cl.Parent = hrp
            
            local start = os.clock()
            task.spawn(function()
                while os.clock() - start < 0.05 do
                    if not c.Parent or c[p].Magnitude < 5 then break end
                    if cl.Parent then cl[p] = orig end
                    RunService.PreSimulation:Wait()
                end
                if cl.Parent then cl:Destroy() end
            end)
        end
    end)
end

Players.LocalPlayer.CharacterAdded:Connect(listen)
if Players.LocalPlayer.Character then listen(Players.LocalPlayer.Character) end
