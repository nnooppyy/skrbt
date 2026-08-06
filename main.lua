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

-- 1. زر الـ AFK ورقم 2
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 200, 0, 35)
ToggleBtn.Position = UDim2.new(0.5, -100, 0, 45)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "AFK: OFF"
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

-- 3. زر الذهاب والتتبع المستمر
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
local isAFK = false
local isFollowing = false
local targetName = ""
local hasKilledCurrentLife = false

-- تشغيل/إيقاف زر الـ AFK (رقم 2 كل ثانيتين)
ToggleBtn.MouseButton1Click:Connect(function()
    isAFK = not isAFK
    if isAFK then
        ToggleBtn.Text = "AFK: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        ToggleBtn.Text = "AFK: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

-- نظام ضغط رقم 2 كل ثانيتين
task.spawn(function()
    while task.wait(2) do
        if isAFK then
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

-- البحث عن اللاعب بالاسم
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

-- زر التتبع (يشتغل وما يوقف إلا لما تطق الزر بنفسك)
GoBtn.MouseButton1Click:Connect(function()
    isFollowing = not isFollowing
    if isFollowing then
        targetName = PlayerBox.Text
        local checkPlr = findPlayer(targetName)
        if checkPlr then
            hasKilledCurrentLife = false
            GoBtn.Text = "Go to Player: ON"
            GoBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            isFollowing = false
            GoBtn.Text = "Player Not Found!"
            task.wait(1.5)
            GoBtn.Text = "Go to Player: OFF"
            GoBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        end
    else
        GoBtn.Text = "Go to Player: OFF"
        GoBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        targetName = ""
        hasKilledCurrentLife = false
    end
end)

-- نظام التتبع المستمر (يركض وراه، إذا مات ورجع يعيد الكرة تلقائياً بدون توقف)
RunService.RenderStepped:Connect(function()
    if isFollowing and targetName ~= "" then
        local targetPlr = findPlayer(targetName)
        if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("Humanoid") and myChar:FindFirstChild("HumanoidRootPart") then
                
                -- إعادة ضبط حالة الموت إذا اللاعب مات ورجع ظهر من جديد (Respawn)
                if myChar.Humanoid.Health > 0 then
                    -- إذا كان حي، نتابع عملية الركض نحوه
                    local targetPos = targetPlr.Character.HumanoidRootPart.Position
                    local myPos = myChar.HumanoidRootPart.Position
                    local distance = (targetPos - myPos).Magnitude
                    
                    if distance <= 5 and not hasKilledCurrentLife then
                        hasKilledCurrentLife = true
                        myChar.Humanoid.Health = 0 -- يذبح نفسه لما يوصل
                    elseif not hasKilledCurrentLife then
                        myChar.Humanoid:MoveTo(targetPos)
                    end
                else
                    -- أول ما يموت، نصفر الحالة عشان أول ما يرجع يعيش يكمل يروح له من جديد تلقائي
                    hasKilledCurrentLife = false
                end
            end
        end
    end
end)
