local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- إنشاء الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Wafi_AFK"
ScreenGui.ResetOnSpawn = false

-- إجبار الواجهة على الظهور (تجنباً لمشاكل دلتا)
local success, err = pcall(function()
    ScreenGui.Parent = CoreGui
end)

if not success then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- تصميم الزر
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 150, 0, 50)
Button.Position = UDim2.new(0.5, -75, 0.2, 0)
Button.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- أحمر (معطل)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Text = "AFK: OFF"
Button.TextSize = 25
Button.Font = Enum.Font.SourceSansBold
Button.Draggable = true
Button.Active = true
Button.Parent = ScreenGui

-- حواف دائرية للزر
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Button

local isAFK = false

-- نظام التشغيل والإيقاف
Button.MouseButton1Click:Connect(function()
    isAFK = not isAFK
    if isAFK then
        Button.Text = "AFK: ON"
        Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- أخضر (شغال)
    else
        Button.Text = "AFK: OFF"
        Button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

-- نظام محاكاة ضغطة زر النط (كل ثانيتين)
task.spawn(function()
    while task.wait(2) do
        if isAFK then
            pcall(function()
                -- محاكاة الضغط على زر المسافة (Space)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end)
        end
    end
end)
