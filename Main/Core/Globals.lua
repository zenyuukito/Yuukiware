-- YUUKIWARE: GLOBALS CACHE
local Globals = {}

-- Core Services
Globals.Players = game:GetService("Players")
Globals.LP = Globals.Players.LocalPlayer
Globals.TS = game:GetService("TweenService")
Globals.UIS = game:GetService("UserInputService")
Globals.RS = game:GetService("RunService")
Globals.CG = game:GetService("CoreGui")
Globals.VP = game:GetService("VirtualUser")
Globals.HTTP = game:GetService("HttpService")
Globals.ReplicatedStorage = game:GetService("ReplicatedStorage")
Globals.Lighting = game:GetService("Lighting")

-- Delta-safe VirtualUser
local vuSuccess, vu = pcall(function() return game:GetService("VirtualUser") end)
Globals.VirtualUser = vuSuccess and vu or nil

-- World/Character
Globals.Cam = workspace.CurrentCamera
Globals.Workspace = workspace

function Globals.GetChar()
    return Globals.LP.Character or Globals.Workspace:FindFirstChild(Globals.LP.Name)
end

-- Quick access to commonly used folders (Blox Fruits specific)
Globals.Knockback = Globals.ReplicatedStorage:FindFirstChild("Knockback") -- For combat macros

-- Cleanup hook (will be set by loader)
Globals.Cleanup = {}

return Globals
