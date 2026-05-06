local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local MobileUI = {}

function MobileUI:CreateButton(name, callback)
	if not UIS.TouchEnabled then return end
	
	local sg = CoreGui:FindFirstChild("MobileControls") or Instance.new("ScreenGui", CoreGui)
	sg.Name = "MobileControls"
	
	local btn = Instance.new("TextButton", sg)
	btn.Size = UDim2.new(0, 50, 0, 50)
	btn.Position = UDim2.new(0.1, 0, 0.5, 0)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

	local dragStart, startPos
	
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			dragStart = input.Position
			startPos = btn.Position
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragStart and input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - dragStart
			btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			dragStart = nil
		end
	end)

	btn.MouseButton1Click:Connect(callback)
	return btn
end

return MobileUI
