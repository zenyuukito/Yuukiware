local function CreateToggle(parent, text, default, callback)
	local state = default or false
	local row = Cr("Frame", {Parent = parent, Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1})
	
	local box = Cr("TextButton", {
		Parent = row, 
		Size = UDim2.new(0, 20, 0, 20), 
		Position = UDim2.new(0, 5, 0, 6), 
		BackgroundColor3 = Color3.fromRGB(25, 25, 25), 
		Text = ""
	})
	Cr("UICorner", {Parent = box, CornerRadius = UDim.new(0, 4)})
	
	local check = Cr("Frame", {
		Parent = box, 
		Size = UDim2.new(0, 12, 0, 12), 
		Position = UDim2.new(0.5, -6, 0.5, -6), 
		BackgroundColor3 = Color3.fromRGB(255, 50, 50), 
		Visible = state
	})
	Cr("UICorner", {Parent = check, CornerRadius = UDim.new(0, 2)})
	
	Cr("TextLabel", {
		Parent = row, 
		Position = UDim2.new(0, 35, 0, 0), 
		Size = UDim2.new(1, -40, 1, 0), 
		Text = text:upper(), 
		TextColor3 = Color3.new(1, 1, 1), 
		BackgroundTransparency = 1, 
		TextXAlignment = 0, 
		Font = 17, 
		TextSize = 13
	})

	box.MouseButton1Click:Connect(function()
		state = not state
		check.Visible = state
		callback(state)
		TS:Create(box, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(35, 35, 35) or Color3.fromRGB(25, 25, 25)}):Play()
	end)
end
