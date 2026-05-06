local UIS = game:GetService("UserInputService")
local KeybindSystem = {Binds = {}, Lookup = {}}

local function refreshLookup()
	KeybindSystem.Lookup = {}
	for _, data in pairs(KeybindSystem.Binds) do
		KeybindSystem.Lookup[data.Key] = KeybindSystem.Lookup[data.Key] or {}
		table.insert(KeybindSystem.Lookup[data.Key], data.Callback)
	end
end

function KeybindSystem:Bind(actionName, callback)
	local connection
	connection = UIS.InputBegan:Connect(function(input, processed)
		if processed then return end
		local key = (input.KeyCode ~= Enum.KeyCode.Unknown) and input.KeyCode or input.UserInputType
		if key == Enum.UserInputType.MouseButton1 then return end
		connection:Disconnect()
		self.Binds[actionName] = {Key = key, Callback = callback}
		refreshLookup()
	end)
end

UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	local key = (input.KeyCode ~= Enum.KeyCode.Unknown) and input.KeyCode or input.UserInputType
	local targets = KeybindSystem.Lookup[key]
	if targets then
		for _, callback in ipairs(targets) do
			task.spawn(callback)
		end
	end
end)

return KeybindSystem
