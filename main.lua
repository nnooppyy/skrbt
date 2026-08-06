local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- تنظيف الواجهات واللوب القديم
if CoreGui:FindFirstChild("Wafi_UltimateHub") then
    CoreGui:FindFirstChild("Wafi_UltimateHub"):Destroy()
end
if getgenv().Wafi_MainLoop then
    task.cancel(getgenv().Wafi_MainLoop)
    getgenv().Wafi_MainLoop = nil
end

-- إيقاف حركة الشخصية فوراً
local function stopMovement()
    local myChar = LocalPlayer.Character
    if myChar then
        local myHum = myChar:FindFirstChild("Humanoid")
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if myHum and myRoot then
            myHum:MoveTo(myRoot.Position)
        end
    end
end

-- إنشاء الواجهة الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Wafi_UltimateHub"
ScreenGui.ResetOnSpawn = false

local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 230, 0, 185)
MainFrame.Position = UDim2.new(0.5, -115, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- العنوان
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "Wafi Script Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- 1. زر AFK
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 210, 0, 26)
ToggleBtn.Position = UDim2.new(0.5, -105, 0, 42)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "AFK: OFF"
ToggleBtn.TextSize = 12
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

-- 2. مربع اسم اللاعب
local PlayerBox = Instance.new("TextBox")
PlayerBox.Size = UDim2.new(0, 210, 0, 28)
PlayerBox.Position = UDim2.new(0.5, -105, 0, 73)
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

-- 3. زر الانتحار عند الوصول
local GoBtn = Instance.new("TextButton")
GoBtn.Size = UDim2.new(0, 210, 0, 30)
GoBtn.Position = UDim2.new(0.5, -105, 0, 107)
GoBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
GoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GoBtn.Text = "انتحار عند الوصول: OFF"
GoBtn.TextSize = 12
GoBtn.Font = Enum.Font.SourceSansBold
GoBtn.Parent = MainFrame

local GoCorner = Instance.new("UICorner")
GoCorner.CornerRadius = UDim.new(0, 6)
GoCorner.Parent = GoBtn

-- 4. زر الذبح بالسكين
local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.new(0, 210, 0, 30)
KillBtn.Position = UDim2.new(0.5, -105, 0, 142)
KillBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
KillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KillBtn.Text = "ذبح بالسكين: OFF"
KillBtn.TextSize = 12
KillBtn.Font = Enum.Font.SourceSansBold
KillBtn.Parent = MainFrame

local KillCorner = Instance.new("UICorner")
KillCorner.CornerRadius = UDim.new(0, 6)
KillCorner.Parent = KillBtn

-- المتغيرات
local isAFK = false
local isSuicideMode = false
local isKillMode = false
local targetName = ""
local justSpawned = false

-- إعادة ضبط الركض عند الرسبن
LocalPlayer.CharacterAdded:Connect(function(char)
    justSpawned = true
    local myHum = char:WaitForChild("Humanoid", 5)
    if myHum then
        myHum.WalkSpeed = 16
    end
    task.wait(0.2)
    justSpawned = false
end)

-- AFK
ToggleBtn.MouseButton1Click:Connect(function()
    isAFK = not isAFK
    ToggleBtn.Text = isAFK and "AFK: ON" or "AFK: OFF"
    ToggleBtn.BackgroundColor3 = isAFK and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(180, 0, 0)
end)

task.spawn(function()
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

-- البحث عن اسم اللاعب
local function findPlayer(name)
    if name == "" then return nil end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and (plr.Name:lower():sub(1, #name) == name:lower() or plr.DisplayName:lower():sub(1, #name) == name:lower()) then
            return plr
        end
    end
    return nil
end

-- البحث عن السكينة
local function getKnifeTool(char)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local allTools = {}
    
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then table.insert(allTools, item) end
        end
    end
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then table.insert(allTools, item) end
        end
    end

    for _, tool in ipairs(allTools) do
        local name = tool.Name:lower()
        if name:find("knife") or name:find("سكين") or name:find("blade") or name:find("dagger") or name:find("sword") then
            return tool
        end
    end
    
    for _, tool in ipairs(allTools) do
        local name = tool.Name:lower()
        if not (name:find("fist") or name:find("punch") or name:find("box") or name:find("combat") or name:find("mele")) then
            return tool
        end
    end
    
    return allTools[1]
end

-- زر الانتحار عند الوصول
GoBtn.MouseButton1Click:Connect(function()
    isSuicideMode = not isSuicideMode
    if isSuicideMode then
        isKillMode = false
        KillBtn.Text = "ذبح بالسكين: OFF"
        KillBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
        
        targetName = PlayerBox.Text
        local targetPlr = findPlayer(targetName)
        if targetPlr then
            GoBtn.Text = "انتحار عند الوصول: ON"
            GoBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            isSuicideMode = false
            GoBtn.Text = "لم يتم العثور عليه!"
            task.wait(1)
            GoBtn.Text = "انتحار عند الوصول: OFF"
        end
    else
        GoBtn.Text = "انتحار عند الوصول: OFF"
        GoBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        stopMovement() -- إيقاف الحركة فورياً
    end
end)

-- زر الذبح بالسكين
KillBtn.MouseButton1Click:Connect(function()
    isKillMode = not isKillMode
    if isKillMode then
        isSuicideMode = false
        GoBtn.Text = "انتحار عند الوصول: OFF"
        GoBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        
        targetName = PlayerBox.Text
        local targetPlr = findPlayer(targetName)
        if targetPlr then
            KillBtn.Text = "ذبح بالسكين: ON"
            KillBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            isKillMode = false
            KillBtn.Text = "لم يتم العثور عليه!"
            task.wait(1)
            KillBtn.Text = "ذبح بالسكين: OFF"
        end
    else
        KillBtn.Text = "ذبح بالسكين: OFF"
        KillBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
        stopMovement() -- إيقاف الحركة فورياً
    end
end)

-- اللوب التشغيلي
local lastMoveTick = 0
local wasMoving = false

getgenv().Wafi_MainLoop = task.spawn(function()
    while task.wait(0.01) do
        if (isSuicideMode or isKillMode) and targetName ~= "" then
            local targetPlr = findPlayer(targetName)
            local myChar = LocalPlayer.Character
            
            if myChar and targetPlr and targetPlr.Character then
                local myHum = myChar:FindFirstChild("Humanoid")
                local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                local tHum = targetPlr.Character:FindFirstChild("Humanoid")
                local tRoot = targetPlr.Character:FindFirstChild("HumanoidRootPart")
                
                if myHum and myRoot and tHum and tRoot and myHum.Health > 0 and tHum.Health > 0 then
                    wasMoving = true
                    local dist = (Vector3.new(myRoot.Position.X, 0, myRoot.Position.Z) - Vector3.new(tRoot.Position.X, 0, tRoot.Position.Z)).Magnitude
                    
                    -- تحريك الشخصية فقط عند تفعيل أحد الوضعين
                    if os.clock() - lastMoveTick >= 0.1 then
                        myHum:MoveTo(tRoot.Position)
                        lastMoveTick = os.clock()
                    end

                    -- وضع الانتحار اللحظي
                    if isSuicideMode then
                        if dist <= 4 and not justSpawned then
                            myHum.Health = 0
                        end
                    
                    -- وضع الذبح بالسكين (ضرب متواصل وسريع جداً)
                    elseif isKillMode then
                        if dist <= 7 then
                            local knife = getKnifeTool(myChar)
                            if knife then
                                if knife.Parent ~= myChar then
                                    myHum:EquipTool(knife)
                                end
                                
                                knife:Activate()
                                knife:Activate()
                                
                                local handle = knife:FindFirstChild("Handle") or knife:FindFirstChildOfClass("BasePart")
                                if handle and firetouchinterest then
                                    pcall(function()
                                        for _, part in ipairs(targetPlr.Character:GetChildren()) do
                                            if part:IsA("BasePart") then
                                                firetouchinterest(handle, part, 0)
                                                firetouchinterest(handle, part, 1)
                                            end
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        else
            -- إيقاف التتبع تماماً إذا تم إطفاء الوضعين
            if wasMoving then
                wasMoving = false
                stopMovement()
            end
        end
    end
end)
