-- YUUKIWARE: GLOBALS CACHE
local Globals = {
    Players = game:GetService("Players"),
    TS = game:GetService("TweenService"),
    UIS = game:GetService("UserInputService"),
    RS = game:GetService("RunService"),
    CG = game:GetService("CoreGui"),
    HTTP = game:GetService("HttpService"),
    Storage = game:GetService("ReplicatedStorage"),
    Lighting = game:GetService("Lighting"),
    Workspace = workspace,
    Cam = workspace.CurrentCamera,
    Cleanup = {}
}

Globals.LP = Globals.Players.LocalPlayer

-- Safe VirtualUser
local vuS, vu = pcall(game.GetService, game, "VirtualUser")
Globals.VU = vuS and vu

function Globals.GetChar()
    return Globals.LP.Character or Globals.Workspace:FindFirstChild(Globals.LP.Name)
end

function Globals.GetRoot()
    local c = Globals.GetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

return Globals
