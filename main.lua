local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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
MainFrame.Size = UDim2.new(0, 230, 0, 225)
MainFrame.Position = UDim2.new(0.5, -115, 0.2, 0)
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
ToggleBtn.Size = UDim2.new(0, 210, 0, 30)
ToggleBtn.Position = UDim2.new(0.5, -105, 0, 45)
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
PlayerBox.Size = UDim2.new(0, 210, 0, 28)
PlayerBox.Position = UDim2.new(0.5, -105, 0, 80)
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

-- 3. شريط السرعة (Slider) المباشر
local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(0, 210, 0, 14)
SliderBar.Position = UDim2.new(0.5, -105, 0, 120)
SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderBar.BorderSizePixel = 0
SliderBar.Parent = MainFrame

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(0, 7)
BarCorner.Parent = SliderBar

-- جزء التعبئة داخل الشريط
local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBar

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(0, 7)
FillCorner.Parent = SliderFill

-- زر السحب (Knob) وعرض رقم السرعة
local SliderKnob = Instance.new("TextButton")
SliderKnob.Size = UDim2.new(0, 30, 0, 22)
SliderKnob.Position = UDim2.new(0, -15, 0.5, -11)
SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderKnob.Text = "16"
SliderKnob.TextColor3 = Color3.fromRGB(0, 0, 0)
SliderKnob.TextSize = 10
SliderKnob.Font = Enum.Font.SourceSansBold
SliderKnob.Parent = SliderBar

local KnobCorner = Instance.new("UICorner")
KnobCorner.CornerRadius = UDim.new(0, 4)
KnobCorner.Parent = SliderKnob

-- 4. زر الذهاب والتتبع المستمر
local GoBtn = Instance.new("TextButton")
GoBtn.Size = UDim2.new(0, 210, 0, 32)
GoBtn.Position = UDim2.new(0.5, -105, 0, 155)
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
local currentSpeed = 16
local isFollowing = false
local targetName = ""
local hasKilledCurrentLife = false
local startTime = 0

-- منطق سحب الشريط (Slider Logic)
local minSpeed, maxSpeed = 16, 250
local dragging = false

SliderKnob.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = UserInputService:GetMouseLocation().X
        local barPos = SliderBar.AbsolutePosition.X
        local barSize = SliderBar.AbsoluteSize.X
        
        local p = math.clamp((mousePos - barPos) / barSize, 0, 1)
        SliderFill.Size = UDim2.new(p, 0, 1, 0)
        SliderKnob.Position = UDim2.new(p, -15, 0.5, -11)
        
        currentSpeed = math.floor(minSpeed + (maxSpeed - minSpeed) * p)
        SliderKnob.Text = tostring(currentSpeed)
    end
end)

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
            startTime = tick() -- تسجيل وقت التشغيل لمنع الانتحار الفوري
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

-- تطبيق السرعة والتتبع الآمن مع حماية وقتية
RunService.RenderStepped:Connect(function()
    local myChar = LocalPlayer.Character
    if myChar and myChar:FindFirstChild("Humanoid") then
        myChar.Humanoid.WalkSpeed = currentSpeed
        
        if isFollowing and targetName ~= "" and myChar:FindFirstChild("HumanoidRootPart") then
            local targetPlr = findPlayer(targetName)
            if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
                if myChar.Humanoid.Health > 0 then
                    local targetPos = targetPlr.Character.HumanoidRootPart.Position
                    local myPos = myChar.HumanoidRootPart.Position
                    local distance = (targetPos - myPos).Magnitude
                    
                    -- حماية: يجب أن تمر على الأقل ثانيتين من تشغيل التتبع قبل السماح بالانتحار (لمنع الموت الفوري)
                    local timePassed = tick() - startTime
                    
                    if distance <= 4 and timePassed > 2 and not hasKilledCurrentLife then
                        hasKilledCurrentLife = true
                        myChar.Humanoid.Health = 0
                    elseif not hasKilledCurrentLife then
                        myChar.Humanoid:MoveTo(targetPos)
                    end
                else
                    hasKilledCurrentLife = false
                    startTime = tick() -- إعادة ضبط الوقت عند الـ Respawn
                end
            end
        end
    end
end)
