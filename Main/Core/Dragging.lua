local DragModule = {}
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

function DragModule.MakeDraggable(frame, handle)
    local dragToggle = false
    local draggingStarted = false -- New state to track the 1s threshold
    local dragStart, startPos, activeInput, startTime

    handle = handle or frame

    handle.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not dragToggle then
            dragToggle = true
            activeInput = input
            startTime = os.clock() -- Record the exact moment the hold started
            draggingStarted = false -- Reset threshold for this new touch
            
            -- Multi-Touch Release Guard
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                    draggingStarted = false
                    activeInput = nil
                    connection:Disconnect()
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        -- 1. Ensure this is the correct finger (Joystick Fix)
        if input == activeInput and dragToggle then
            
            -- 2. Smart Fix: Only start moving if held for > 1 second
            if not draggingStarted then
                if (os.clock() - startTime) >= 1 then
                    draggingStarted = true
                    -- RESET the starting points at the 1s mark so it doesn't "jump" or "snap"
                    dragStart = input.Position
                    startPos = frame.Position
                end
            end

            -- 3. Actual Movement Logic
            if draggingStarted then
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
