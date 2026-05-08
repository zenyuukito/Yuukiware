local DragModule = {}
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

function DragModule.MakeDraggable(frame, handle)
    local dragToggle, dragStart, startPos
    handle = handle or frame

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position

            -- One-time connection to detect release
            local releaseConn
            releaseConn = UIS.InputEnded:Connect(function(endInput)
                if endInput == input then
                    dragToggle = false
                    releaseConn:Disconnect()
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X, 
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            
            -- Optional: Use a very fast Tween for "Smooth Dragging"
            TS:Create(frame, TweenInfo.new(0.08, Enum.EasingStyle.Linear), {Position = targetPos}):Play()
        end
    end)
end

return DragModule
