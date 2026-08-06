local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- مسح أي واجهة قديمة عشان ما يصير تداخل
if CoreGui:FindFirstChild("Wafi_CleanHub") then
    CoreGui:FindFirstChild("Wafi_CleanHub"):Destroy()
end

-- إنشاء الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Wafi_CleanHub"
ScreenGui.ResetOnSpawn = false

local success = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- الإطار الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Position = UDim2.new(0.5, -110, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- العنوان
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "Wafi Target Kill"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- خانة كتابة اسم اللاعب
local PlayerBox = Instance.new("TextBox")
PlayerBox.Size = UDim2.new(0, 190, 0, 35)
PlayerBox.Position = UDim2.new(0.5, -95, 0, 45)
PlayerBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
PlayerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerBox.PlaceholderText = "اكتب اسم اللاعب هنا..."
PlayerBox.Text = ""
PlayerBox.TextSize = 13
PlayerBox.Font = Enum.Font.SourceSans
PlayerBox.Parent = MainFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 6)
BoxCorner.Parent = PlayerBox

-- زر التتبع (Go to Player)
local GoBtn = Instance.new("TextButton")
GoBtn.Size = UDim2.new(0, 190, 0, 35)
GoBtn.Position = UDim2.new(0.5, -95, 0, 90)
GoBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
GoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GoBtn.Text = "Go to Player: OFF"
GoBtn.TextSize = 13
GoBtn.Font = Enum.Font.SourceSansBold
GoBtn.Parent = MainFrame

local GoCorner = Instance.new("UICorner")
GoCorner.CornerRadius = UDim.new(0, 6)
GoCorner.Parent = GoBtn

-- متغيرات التحكم
local isRunning = false
local targetName = ""

-- وظيفة البحث عن اللاعب بالاسم أو أول الحروف
local function findPlayer(name)
    if name == "" then return nil end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if plr.Name:lower():sub(1, #name) == name:lower() or plr.DisplayName:lower():sub(1, #name) == name:lower() then
                return plr
            end
        end
    end
    return nil
end

-- ضغطة الزر
GoBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        targetName = PlayerBox.Text
        local target = findPlayer(targetName)
        if target then
            GoBtn.Text = "Go to Player: ON"
            GoBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            isRunning = false
            GoBtn.Text = "Player Not Found!"
            task.wait(1.5)
            GoBtn.Text = "Go to Player: OFF"
        end
    else
        GoBtn.Text = "Go to Player: OFF"
        GoBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    end
end)

-- حلقة التتبع الآمنة
RunService.Heartbeat:Connect(function()
    if isRunning and targetName ~= "" then
        local myChar = LocalPlayer.Character
        local targetPlr = findPlayer(targetName)
        
        if myChar and targetPlr and targetPlr.Character then
            local myHum = myChar:FindFirstChild("Humanoid")
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            local tHum = targetPlr.Character:FindFirstChild("Humanoid")
            local tRoot = targetPlr.Character:FindFirstChild("HumanoidRootPart")
            
            if myHum and myRoot and tHum and tRoot and myHum.Health > 0 and tHum.Health > 0 then
                -- زيادة السرعة أثناء الركض نحو الهدف
                myHum.WalkSpeed = 50 
                
                local distance = (myRoot.Position - tRoot.Position).Magnitude
                
                -- إذا وصل عنده ولصق فيه (أقل من أو يساوي 3 أمتار) يذبح نفسه ويطفي الزر
                if distance <= 3 then
                    isRunning = false
                    GoBtn.Text = "Go to Player: OFF"
                    GoBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
                    myHum.Health = 0
                else
                    myHum:MoveTo(tRoot.Position)
                end
            end
        end
    end
end)
