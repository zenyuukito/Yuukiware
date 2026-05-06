return function(Page)
	local UIS = game:GetService("UserInputService")
	local TS = game:GetService("TweenService")
	local lp = game.Players.LocalPlayer

	-- Load dependencies directly from your GitHub repo
	local BaseURL = "https://raw.githubusercontent.com/zenyuukito/Yuukiware/main/Main/Functions/"
	local KeybindSystem = loadstring(game:HttpGet(BaseURL .. "Keybind.lua"))()
	local MobileUI = loadstring(game:HttpGet(BaseURL .. "Draggablebtn.lua"))()

	local function Cr(cl, p) local i = Instance.new(cl) for k, v in pairs(p) do i[k] = v end return i end

	-- Macro Logic: Freeze
	local FreezeEnabled = false
	local IsFrozen = false
	local MobBtn = nil

	local function toggleFreeze()
		if not FreezeEnabled then return end
		local char = lp.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root then
			IsFrozen = not IsFrozen
			root.Anchored = IsFrozen
		end
	end

	-- UI Construction
	local Row = Cr("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1})
	
	local Box = Cr("TextButton", {Parent = Row, Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 5, 0, 6), BackgroundColor3 = Color3.fromRGB(25, 25, 25), Text = ""})
	Cr("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 4)})
	
	local Check = Cr("Frame", {Parent = Box, Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0.5, -6, 0.5, -6), BackgroundColor3 = Color3.fromRGB(255, 50, 50), Visible = false})
	Cr("UICorner", {Parent = Check, CornerRadius = UDim.new(0, 2)})
	
	Cr("TextLabel", {Parent = Row, Position = UDim2.new(0, 35, 0, 0), Size = UDim2.new(1, -150, 1, 0), Text = "FREEZE CHARACTER", TextColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, TextXAlignment = 0, Font = 17, TextSize = 13})

	local MobToggle = Cr("TextButton", {Parent = Row, Position = UDim2.new(1, -110, 0, 4), Size = UDim2.new(0, 45, 0, 24), Text = "MOB", BackgroundColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.new(1,1,1), Font = 17, TextSize = 12})
	Cr("UICorner", {Parent = MobToggle, CornerRadius = UDim.new(0, 4)})

	local BindBtn = Cr("TextButton", {Parent = Row, Position = UDim2.new(1, -60, 0, 4), Size = UDim2.new(0, 55, 0, 24), Text = "NONE", BackgroundColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.new(1,1,1), Font = 17, TextSize = 12})
	Cr("UICorner", {Parent = BindBtn, CornerRadius = UDim.new(0, 4)})

	-- Connections
	Box.MouseButton1Click:Connect(function()
		FreezeEnabled = not FreezeEnabled
		Check.Visible = FreezeEnabled
		TS:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = FreezeEnabled and Color3.fromRGB(35, 35, 35) or Color3.fromRGB(25, 25, 25)}):Play()
		if not FreezeEnabled and IsFrozen then toggleFreeze() end
	end)

	MobToggle.MouseButton1Click:Connect(function()
		if MobBtn then
			MobBtn:Destroy()
			MobBtn = nil
			TS:Create(MobToggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
		else
			MobBtn = MobileUI:CreateButton("Freeze", toggleFreeze)
			TS:Create(MobToggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
		end
	end)

	BindBtn.MouseButton1Click:Connect(function()
		BindBtn.Text = "..."
		KeybindSystem:Bind("FreezeMacro", toggleFreeze)
		
		local c; c = UIS.InputBegan:Connect(function(input)
			local key = (input.KeyCode ~= Enum.KeyCode.Unknown) and input.KeyCode or input.UserInputType
			if key == Enum.UserInputType.MouseButton1 then return end
			BindBtn.Text = tostring(key):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
			c:Disconnect()
		end)
	end)
end
