return function(Parent)
    local RS, P = game:GetService("RunService"), game:GetService("Players").LocalPlayer
    local F = loadstring(game:HttpGet("https://raw.githubusercontent.com/zenyuukito/Yuukiware/refs/heads/main/Main/Core/Functions.lua"))()
    local State = F.CreateMasterToggle(Parent)

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
                        RS.PreSimulation:Wait()
                    end
                    if cl.Parent then cl:Destroy() end
                end)
            end
        end)
    end

    P.CharacterAdded:Connect(listen)
    if P.Character then listen(P.Character) end
end
