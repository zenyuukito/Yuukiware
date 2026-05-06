return function(Page)
	local UIS = game:GetService("UserInputService")
	local TS = game:GetService("TweenService")
	local lp = game.Players.LocalPlayer

	-- 1. Setup local utilities
	local function Cr(cl, p) local i = Instance.new(cl) for k, v in pairs(p) do i[k] = v end return i end
	local FuncURL = "https://raw.githubusercontent.com/zenyuukito/Yuukiware/main/Main/Functions/"
	
	-- Load the "Tools"
	local Keybind = loadstring(game:HttpGet(FuncURL .. "Keybind.lua"))()
	local Mobile = loadstring(game:HttpGet(FuncURL .. "Draggablebtn.lua"))()

	-- 2. Define the Macro State
	local Enabled = false
	local Frozen = false
	local MobBtn = nil

	-- The Action
	local function toggleFreeze()
		if not Enabled then return end
		local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		if root then
			Frozen = not Frozen
			root.Anchored = Frozen
		end
	end

	-- 3. Create the UI Row
	local Row = Cr("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1})
	
	-- Toggle Checkbox
	local Box = Cr("TextButton", {Parent = Row, Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 5, 0, 6), BackgroundColor3 = Color3.fromRGB(25, 25, 25), Text = ""})
	local Check = Cr("Frame", {Parent = Box, Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0.5, -6, 0.5, -6), BackgroundColor3 = Color3.fromRGB(255, 50, 50), Visible = false})
	Cr("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 4)})
	Cr("UICorner", {Parent = Check, CornerRadius = UDim.new(0, 2)})

	-- Label
	Cr("TextLabel", {Parent = Row, Position = UDim2.new(0, 35, 0, 0), Size = UDim2.new(0, 150, 1, 0), Text = "FREEZE CHARACTER", TextColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, TextXAlignment = 0, Font = 17, TextSize = 13})

	-- Mobile Button Toggle
	local MobToggle = Cr("TextButton", {Parent = Row, Position = UDim2.new(1, -110, 0, 4), Size = UDim2.new(0, 45, 0, 24), Text = "MOB", BackgroundColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.new(1,1,1), Font = 17, TextSize = 12})
	Cr("UICorner", {Parent = MobToggle, CornerRadius = UDim.new(0, 4)})

	-- Keybind Button
	local BindBtn = Cr("TextButton", {Parent = Row, Position = UDim2.new(1, -60, 0, 4), Size = UDim2.new(0, 55, 0, 24), Text = "NONE", BackgroundColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.new(1,1,1), Font = 17, TextSize = 12})
	Cr("UICorner", {Parent = BindBtn, CornerRadius = UDim.new(0, 4)})

	-- 4. Logic Connections
	Box.MouseButton1Click:Connect(function()
		Enabled = not Enabled
		Check.Visible = Enabled
		if not Enabled and Frozen then toggleFreeze() end
	end)

	MobToggle.MouseButton1Click:Connect(function()
		if MobBtn then
			MobBtn:Destroy()
			MobBtn = nil
			MobToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		else
			MobBtn = Mobile:CreateButton("Freeze", toggleFreeze)
			MobToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		end
	end)

	BindBtn.MouseButton1Click:Connect(function()
		BindBtn.Text = "..."
		Keybind:Bind("FreezeMacro", toggleFreeze)
		local c; c = UIS.InputBegan:Connect(function(input)
			local key = (input.KeyCode ~= Enum.KeyCode.Unknown) and input.KeyCode or input.UserInputType
			if key == Enum.UserInputType.MouseButton1 then return end
			BindBtn.Text = tostring(key):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
			c:Disconnect()
		end)
	end)
end
