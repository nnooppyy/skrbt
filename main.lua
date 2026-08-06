local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- إنشاء القائمة الأساسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Wafi_Hub"
ScreenGui.ResetOnSpawn = false

local success, err = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- الإطار الرئيسي للقائمة (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 180)
MainFrame.Position = UDim2.new(0.5, -110, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- عنوان القائمة
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "Wafi Script Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- 1. زر رقم 2 (نفس الزر الأول)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 200, 0, 35)
ToggleBtn.Position = UDim2.new(0.5, -100, 0, 45)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "Auto Key 2: OFF"
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

-- 2. خانة كتابة اسم اللاعب (TextBox)
local PlayerBox = Instance.new("TextBox")
PlayerBox.Size = UDim2.new(0, 200, 0, 30)
PlayerBox.Position = UDim2.new(0.5, -100, 0, 90)
PlayerBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerBox.PlaceholderText = "اكتب اسم اللاعب هنا..."
PlayerBox.Text = ""
PlayerBox.TextSize = 13
PlayerBox.Font = Enum.Font.SourceSans
PlayerBox.Parent = MainFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 6)
BoxCorner.Parent = PlayerBox

-- 3. زر الذهاب للاعب (Go to Player)
local GoBtn = Instance.new("TextButton")
GoBtn.Size = UDim2.new(0, 200, 0, 35)
GoBtn.Position = UDim2.new(0.5, -100, 0, 130)
GoBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
GoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GoBtn.Text = "Go to Player: OFF"
GoBtn.TextSize = 14
GoBtn.Font = Enum.Font.SourceSansBold
GoBtn.Parent = MainFrame

local GoCorner = Instance.new("UICorner")
GoCorner.CornerRadius = UDim.new(0, 6)
GoCorner.Parent = GoBtn

-- المتغيرات والوظائف
local isRunning = false
local isFollowing = false
local targetPlayer = nil

-- تشغيل/إيقاف زر رقم 2
ToggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        ToggleBtn.Text = "Auto Key 2: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        ToggleBtn.Text = "Auto Key 2: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

-- نظام ضغط رقم 2 كل ثانيتين
task.spawn(function()
    while task.wait(2) do
        if isRunning then
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
            end)
        end
    end
end)

-- البحث عن اللاعب المستهدف بالاسم (يدعم كتابة جزء من الاسم)
local function findPlayer(name)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if plr.Name:lower():sub(1, #name) == name:lower() or plr.DisplayName:lower():sub(1, #name) == name:lower() then
                return plr
            end
        end
    end
    return nil
end

-- زر التتبع والذهاب
GoBtn.MouseButton1Click:Connect(function()
    isFollowing = not isFollowing
    if isFollowing then
        targetPlayer = findPlayer(PlayerBox.Text)
        if targetPlayer then
            GoBtn.Text = "Stop Following"
            GoBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        else
            isFollowing = false
            GoBtn.Text = "Player Not Found!"
            task.wait(1.5)
            GoBtn.Text = "Go to Player: OFF"
        end
    else
        GoBtn.Text = "Go to Player: OFF"
        GoBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        targetPlayer = nil
    end
end)

-- تنفيذ المشي نحو اللاعب باستمرار
RunService.RenderStepped:Connect(function()
    if isFollowing and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("Humanoid") and myChar:FindFirstChild("HumanoidRootPart") then
            myChar.Humanoid:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
        end
    end
end)
