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
MainFrame.Size = UDim2.new(0, 220, 0, 220)
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
ToggleBtn.Size = UDim2.new(0, 200, 0, 30)
ToggleBtn.Position = UDim2.new(0.5, -100, 0, 45)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "AFK: OFF"
ToggleBtn.TextSize = 13
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

-- 2. خانة كتابة اسم اللاعب
local PlayerBox = Instance.new("TextBox")
PlayerBox.Size = UDim2.new(0, 200, 0, 28)
PlayerBox.Position = UDim2.new(0.5, -100, 0, 80)
PlayerBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerBox.PlaceholderText = "اكتب اسم اللاعب هنا..."
PlayerBox.Text = ""
PlayerBox.TextSize = 12
PlayerBox.Font = Enum.Font.SourceSans
PlayerBox.Parent = MainFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 6)
BoxCorner.Parent = PlayerBox

-- 3. خانة كتابة السرعة (Speed TextBox)
local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0, 200, 0, 28)
SpeedBox.Position = UDim2.new(0.5, -100, 0, 115)
SpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.PlaceholderText = "اكتب السرعة (مثال: 50)..."
SpeedBox.Text = ""
SpeedBox.TextSize = 12
SpeedBox.Font = Enum.Font.SourceSans
SpeedBox.Parent = MainFrame

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 6)
SpeedCorner.Parent = SpeedBox

-- 4. زر الذهاب والتتبع المستمر
local GoBtn = Instance.new("TextButton")
GoBtn.Size = UDim2.new(0, 200, 0, 32)
GoBtn.Position = UDim2.new(0.5, -100, 0, 150)
GoBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
GoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GoBtn.Text = "Go to Player: OFF"
GoBtn.TextSize = 13
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

-- زر التتبع
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

-- نظام التتبع المستمر وتطبيق السرعة والانتحار المتكرر
RunService.RenderStepped:Connect(function()
    local myChar = LocalPlayer.Character
    if myChar and myChar:FindFirstChild("Humanoid") then
        -- تطبيق السرعة المكتوبة في الخانة باستمرار
        local customSpeed = tonumber(SpeedBox.Text)
        if customSpeed then
            myChar.Humanoid.WalkSpeed = customSpeed
        end
        
        -- التتبع والمشي نحو اللاعب
        if isFollowing and targetName ~= "" and myChar:FindFirstChild("HumanoidRootPart") then
            local targetPlr = findPlayer(targetName)
            if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
                if myChar.Humanoid.Health > 0 then
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
                    hasKilledCurrentLife = false
                end
            end
        end
    end
end)
