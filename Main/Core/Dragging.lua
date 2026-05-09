local DragModule = {}
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

function DragModule.MakeDraggable(frame, handle)
    local dragToggle = false
    local dragStart, startPos, activeInput
    local startTime = 0 -- Tracks when the press began
    handle = handle or frame

    handle.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not dragToggle then
            activeInput = input
            dragStart = input.Position
            startPos = frame.Position
            startTime = tick() -- Start the clock
            
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
        if input == activeInput then
            -- Only switch to 'Dragging' state if held for more than 0.15 seconds
            if not dragToggle and (tick() - startTime) >= 0.15 then
                dragToggle = true
                
                -- Reset start points to current mouse position 
                -- This prevents the UI from "snapping" to where the mouse was 0.15s ago
                dragStart = input.Position
                startPos = frame.Position
            end

            -- Run the movement logic only if the delay has passed
            if dragToggle then
                local delta = input.Position - dragStart
                local targetPos = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X, 
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
                TS:Create(frame, TweenInfo.new(0.06, Enum.EasingStyle.Linear), {Position = targetPos}):Play()
            end
        end
    end)
end

return DragModule
