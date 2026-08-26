local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Touch then
        local touchPos = input.Position
        print("إحداثيات اللمس هي -> X: " .. touchPos.X .. " | Y: " .. touchPos.Y)
    end
end)
