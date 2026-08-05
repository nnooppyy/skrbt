local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- إنشاء الواجهة الأساسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AFKGui"
ScreenGui.ResetOnSpawn = false

-- وضع الواجهة في PlayerGui أو CoreGui
local parent = LocalPlayer:FindFirstChild("PlayerGui") or CoreGui
ScreenGui.Parent = parent

-- إنشاء زر AFK
local Button = Instance.new("TextButton")
Button.Name = "AFKButton"
Button.Size = UDim2.new(0, 150, 0, 50)
Button.Position = UDim2.new(0.05, 0, 0.4, 0)
Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Text = "AFK Jump: OFF"
Button.TextSize = 18
Button.Font = Enum.Font.SourceSansBold
Button.Active = true
Button.Draggable = true -- يمكنك سحب الزر لأي مكان بالشاشة
Button.Parent = ScreenGui

-- إضافة حواف دائرية للزر
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Button

-- متغير التحكم بالحالة
local isAFK = false

-- عند الضغط على الزر
Button.MouseButton1Click:Connect(function()
    isAFK = not isAFK
    if isAFK then
        Button.Text = "AFK Jump: ON"
        Button.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
    else
        Button.Text = "AFK Jump: OFF"
        Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end
end)

-- حلقة القفز كل ثانية عند تفعيل الخيار
task.spawn(function()
    while true do
        task.wait(1)
        if isAFK then
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end
end)

