local DragModule = {}
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

function DragModule.MakeDraggable(frame, handle)
    local dragToggle = false
    local dragStart, startPos, activeInput 
    handle = handle or frame

    handle.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not dragToggle then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            activeInput = input -- Multi-touch lock
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                    activeInput = nil
                    connection:Disconnect()
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == activeInput and dragToggle then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X, 
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            TS:Create(frame, TweenInfo.new(0.06, Enum.EasingStyle.Linear), {Position = targetPos}):Play()
        end
    end)
end

return DragModule
