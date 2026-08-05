local VirtualInputManager = game:GetService("VirtualInputManager")

-- حلقة القفز التلقائي كل ثانية في الخلفية بدون واجهة
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            -- محاكاة ضغط زِر المسافة (Space)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end)
    end
end)
