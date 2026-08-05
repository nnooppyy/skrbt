local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- إنشاء الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Wafi_Keypress"
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
Button.Text = "Auto: OFF"
Button.TextSize = 25
Button.Font = Enum.Font.SourceSansBold
Button.Draggable = true
Button.Active = true
Button.Parent = ScreenGui

-- حواف دائرية للزر
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Button

local isRunning = false

-- نظام التشغيل والإيقاف
Button.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        Button.Text = "Auto: ON"
        Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- أخضر (شغال)
    else
        Button.Text = "Auto: OFF"
        Button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

-- نظام محاكاة ضغط رقم 2 مرتين كل ثانيتين
task.spawn(function()
    while task.wait(2) do
        if isRunning then
            pcall(function()
                -- الضغطة الأولى لرقم 2 (One)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
                
                --انتظار بسيط جداً بين الضغطة الأولى والثانية
                task.wait(0.1)

                -- الضغطة الثانية لرقم 2 (Two)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
            end)
        end
    end
end)
