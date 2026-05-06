local UserInputService = game:GetService("UserInputService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()

local KeybindSystem = {}
KeybindSystem.Binds = {} -- Stores {ActionName = {Key = Enum, MobileButton = Instance}}

-- List of inputs we don't want to bind (Optional)
local Blacklist = {
	[Enum.UserInputType.MouseButton1] = true, -- Usually reserved for clicking the UI itself
	[Enum.UserInputType.Focus] = true
}

-- Function to start "Listening" for a new key
function KeybindSystem:RecordBind(actionName, callback)
	print("Recording bind for: " .. actionName)
	
	local connection
	connection = UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		
		local inputType = input.UserInputType
		local keyCode = input.KeyCode
		
		-- Identify if it's a Key or a Mouse button (excluding Left Click)
		local finalBind = (keyCode ~= Enum.KeyCode.Unknown) and keyCode or inputType
		
		if not Blacklist[finalBind] then
			connection:Disconnect()
			
			self.Binds[actionName] = {
				Input = finalBind,
				Callback = callback
			}
			
			print("Bound " .. actionName .. " to: " .. tostring(finalBind))
		end
	end)
end

-- Global Listener to trigger bound actions
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	
	local inputType = input.UserInputType
	local keyCode = input.KeyCode
	local currentInput = (keyCode ~= Enum.KeyCode.Unknown) and keyCode or inputType
	
	for name, data in pairs(KeybindSystem.Binds) do
		if data.Input == currentInput then
			data.Callback() -- Run the logic assigned to this bind
		end
	end
end)

-- MOBILE FALLBACK: Create a toggle button if the user is on mobile
function KeybindSystem:CreateMobileButton(actionName, callback)
	if UserInputService.TouchEnabled then
		local screenGui = game:GetService("CoreGui"):FindFirstChild("YuukiwareMobileBinds") or Instance.new("ScreenGui", game:GetService("CoreGui"))
		screenGui.Name = "YuukiwareMobileBinds"
		
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 50, 0, 50)
		btn.Position = UDim2.new(0.8, 0, 0.5, 0)
		btn.Text = actionName
		btn.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
		btn.Parent = screenGui
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0) -- Circle button
		corner.Parent = btn
		
		btn.MouseButton1Click:Connect(callback)
		return btn
	end
end

return KeybindSystem
