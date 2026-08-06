local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- تنظيف جذري لأي سكريبت قديم عشان ما يتداخل ويذبحك لحاله
if CoreGui:FindFirstChild("Wafi_Hub") then
    CoreGui:FindFirstChild("Wafi_Hub"):Destroy()
end
if getgenv().Wafi_Connection then
    getgenv().Wafi_Connection:Disconnect()
    getgenv().Wafi_Connection = nil
end
if getgenv().Wafi_AFK_Loop then
    task.cancel(getgenv().Wafi_AFK_Loop)
    getgenv().Wafi_AFK_Loop = nil
end

-- إنشاء الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Wafi_Hub"
ScreenGui.ResetOnSpawn = false

local success, err = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

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

-- الأزرار
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

local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(0, 210, 0, 14)
SliderBar.Position = UDim2.new(0.5, -105, 0, 120)
SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderBar.BorderSizePixel = 0
SliderBar.Parent = MainFrame
local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(0, 7)
BarCorner.Parent = SliderBar

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBar
local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(0, 7)
FillCorner.Parent = SliderFill

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

-- المتغيرات المحفوظة عالمياً عشان ما تخرب
getgenv().Wafi_IsFollowing = false
getgenv().Wafi_TargetName = ""
local currentSpeed = 16
local isAFK = false

-- منطق السرعة
local minSpeed, maxSpeed = 16, 250
local dragging = false
SliderKnob.MouseButton1Down:Connect(function() dragging = true end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local p = math.clamp((UserInputService:GetMouseLocation().X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(p, 0, 1, 0)
        SliderKnob.Position = UDim2.new(p, -15, 0.5, -11)
        currentSpeed = math.floor(minSpeed + (maxSpeed - minSpeed) * p)
        SliderKnob.Text = tostring(currentSpeed)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = currentSpeed
        end
    end
end)

-- AFK
ToggleBtn.MouseButton1Click:Connect(function()
    isAFK = not isAFK
    ToggleBtn.Text = isAFK and "AFK: ON" or "AFK: OFF"
    ToggleBtn.BackgroundColor3 = isAFK and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

getgenv().Wafi_AFK_Loop = task.spawn(function()
    while task.wait(2) do
        if isAFK then
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
            end)
        end
    end
end)

local function findPlayer(name)
    if name == "" then return nil end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and (plr.Name:lower():sub(1, #name) == name:lower() or plr.DisplayName:lower():sub(1, #name) == name:lower()) then
            return plr
        end
    end
    return nil
end

-- التتبع
GoBtn.MouseButton1Click:Connect(function()
    getgenv().Wafi_IsFollowing = not getgenv().Wafi_IsFollowing
    if getgenv().Wafi_IsFollowing then
        getgenv().Wafi_TargetName = PlayerBox.Text
        local targetPlr = findPlayer(getgenv().Wafi_TargetName)
        if targetPlr then
            GoBtn.Text = "Go to Player: ON"
            GoBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            getgenv().Wafi_IsFollowing = false
            GoBtn.Text = "Not Found!"
            task.wait(1)
            GoBtn.Text = "Go to Player: OFF"
        end
    else
        GoBtn.Text = "Go to Player: OFF"
        GoBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    end
end)

-- اللوب الجذري الجديد (مستحيل يشتغل من نفسه)
getgenv().Wafi_Connection = RunService.Heartbeat:Connect(function()
    if getgenv().Wafi_IsFollowing and getgenv().Wafi_TargetName ~= "" then
        local myChar = LocalPlayer.Character
        local targetPlr = findPlayer(getgenv().Wafi_TargetName)
        
        if myChar and targetPlr and targetPlr.Character then
            local myHum = myChar:FindFirstChild("Humanoid")
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            local tHum = targetPlr.Character:FindFirstChild("Humanoid")
            local tRoot = targetPlr.Character:FindFirstChild("HumanoidRootPart")
            
            if myHum and myRoot and tHum and tRoot and myHum.Health > 0 and tHum.Health > 0 then
                myHum.WalkSpeed = currentSpeed
                local dist = (myRoot.Position - tRoot.Position).Magnitude
                
                -- إذا المسافة 3 وأقل (يعني لازق فيه)، يذبح نفسه
                if dist <= 3 then
                    myHum.Health = 0
                else
                    myHum:MoveTo(tRoot.Position)
                end
            end
        end
    end
end)
