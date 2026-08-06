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

-- إيقاف حركة الشخصية
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

-- زر دائم على شكل دائرة لإظهار وإخفاء القائمة
local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleMenuBtn.Position = UDim2.new(0, 15, 0.4, 0)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuBtn.Text = "HUB"
ToggleMenuBtn.TextSize = 13
ToggleMenuBtn.Font = Enum.Font.SourceSansBold
ToggleMenuBtn.Draggable = true
ToggleMenuBtn.Active = true
ToggleMenuBtn.Parent = ScreenGui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = ToggleMenuBtn

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = Color3.fromRGB(0, 120, 200)
CircleStroke.Thickness = 2
CircleStroke.Parent = ToggleMenuBtn

-- الإطار الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 310, 0, 190)
MainFrame.Position = UDim2.new(0.5, -155, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- وظيفة الزر الدائري لإظهار/إخفاء القائمة
ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- العنوان
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 32)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Text = "Wafi Script Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- الشريط الجانبي الأيسر (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 75, 1, -32)
Sidebar.Position = UDim2.new(0, 0, 0, 32)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

-- زر تبويب Farm
local FarmTabBtn = Instance.new("TextButton")
FarmTabBtn.Size = UDim2.new(0, 65, 0, 30)
FarmTabBtn.Position = UDim2.new(0, 5, 0, 10)
FarmTabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
FarmTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmTabBtn.Text = "Farm"
FarmTabBtn.TextSize = 13
FarmTabBtn.Font = Enum.Font.SourceSansBold
FarmTabBtn.Parent = Sidebar

local FarmTabCorner = Instance.new("UICorner")
FarmTabCorner.CornerRadius = UDim.new(0, 6)
FarmTabCorner.Parent = FarmTabBtn

-- زر تبويب View
local ViewTabBtn = Instance.new("TextButton")
ViewTabBtn.Size = UDim2.new(0, 65, 0, 30)
ViewTabBtn.Position = UDim2.new(0, 5, 0, 46)
ViewTabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ViewTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
ViewTabBtn.Text = "View"
ViewTabBtn.TextSize = 13
ViewTabBtn.Font = Enum.Font.SourceSansBold
ViewTabBtn.Parent = Sidebar

local ViewTabCorner = Instance.new("UICorner")
ViewTabCorner.CornerRadius = UDim.new(0, 6)
ViewTabCorner.Parent = ViewTabBtn

-- إطار محتوى صفحة Farm
local FarmPage = Instance.new("Frame")
FarmPage.Size = UDim2.new(1, -75, 1, -32)
FarmPage.Position = UDim2.new(0, 75, 0, 32)
FarmPage.BackgroundTransparency = 1
FarmPage.Visible = true
FarmPage.Parent = MainFrame

-- إطار محتوى صفحة View
local ViewPage = Instance.new("Frame")
ViewPage.Size = UDim2.new(1, -75, 1, -32)
ViewPage.Position = UDim2.new(0, 75, 0, 32)
ViewPage.BackgroundTransparency = 1
ViewPage.Visible = false
ViewPage.Parent = MainFrame

---------------------------------------------------------
-- عناصر صفحة FARM
---------------------------------------------------------

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 215, 0, 26)
ToggleBtn.Position = UDim2.new(0, 10, 0, 8)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "AFK: OFF"
ToggleBtn.TextSize = 12
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Parent = FarmPage

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleBtn

local PlayerBox = Instance.new("TextBox")
PlayerBox.Size = UDim2.new(0, 215, 0, 26)
PlayerBox.Position = UDim2.new(0, 10, 0, 40)
PlayerBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerBox.PlaceholderText = "اسم اللاعب للمطاردة..."
PlayerBox.Text = ""
PlayerBox.TextSize = 12
PlayerBox.Font = Enum.Font.SourceSans
PlayerBox.Parent = FarmPage

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 6)
BoxCorner.Parent = PlayerBox

local GoBtn = Instance.new("TextButton")
GoBtn.Size = UDim2.new(0, 215, 0, 28)
GoBtn.Position = UDim2.new(0, 10, 0, 72)
GoBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
GoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GoBtn.Text = "انتحار عند الوصول: OFF"
GoBtn.TextSize = 12
GoBtn.Font = Enum.Font.SourceSansBold
GoBtn.Parent = FarmPage

local GoCorner = Instance.new("UICorner")
GoCorner.CornerRadius = UDim.new(0, 6)
GoCorner.Parent = GoBtn

local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.new(0, 215, 0, 28)
KillBtn.Position = UDim2.new(0, 10, 0, 106)
KillBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
KillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KillBtn.Text = "ذبح بالسكين: OFF"
KillBtn.TextSize = 12
KillBtn.Font = Enum.Font.SourceSansBold
KillBtn.Parent = FarmPage

local KillCorner = Instance.new("UICorner")
KillCorner.CornerRadius = UDim.new(0, 6)
KillCorner.Parent = KillBtn

---------------------------------------------------------
-- عناصر صفحة VIEW
---------------------------------------------------------

local ViewPlayerBox = Instance.new("TextBox")
ViewPlayerBox.Size = UDim2.new(0, 215, 0, 28)
ViewPlayerBox.Position = UDim2.new(0, 10, 0, 15)
ViewPlayerBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ViewPlayerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ViewPlayerBox.PlaceholderText = "اكتب اسم اللاعب للمعاينة..."
ViewPlayerBox.Text = ""
ViewPlayerBox.TextSize = 12
ViewPlayerBox.Font = Enum.Font.SourceSans
ViewPlayerBox.Parent = ViewPage

local ViewBoxCorner = Instance.new("UICorner")
ViewBoxCorner.CornerRadius = UDim.new(0, 6)
ViewBoxCorner.Parent = ViewPlayerBox

local RedHighlightBtn = Instance.new("TextButton")
RedHighlightBtn.Size = UDim2.new(0, 215, 0, 32)
RedHighlightBtn.Position = UDim2.new(0, 10, 0, 52)
RedHighlightBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
RedHighlightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RedHighlightBtn.Text = "تحديد باللون الأحمر: OFF"
RedHighlightBtn.TextSize = 12
RedHighlightBtn.Font = Enum.Font.SourceSansBold
RedHighlightBtn.Parent = ViewPage

local RedHighlightCorner = Instance.new("UICorner")
RedHighlightCorner.CornerRadius = UDim.new(0, 6)
RedHighlightCorner.Parent = RedHighlightBtn

---------------------------------------------------------
-- التنقل بين التبويبات (Tabs Switching)
---------------------------------------------------------

FarmTabBtn.MouseButton1Click:Connect(function()
    FarmPage.Visible = true
    ViewPage.Visible = false
    FarmTabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    FarmTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ViewTabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ViewTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

ViewTabBtn.MouseButton1Click:Connect(function()
    FarmPage.Visible = false
    ViewPage.Visible = true
    ViewTabBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    ViewTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    FarmTabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    FarmTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

---------------------------------------------------------
-- المنطق والأوامر (Logic)
---------------------------------------------------------

local isAFK = false
local isSuicideMode = false
local isKillMode = false
local isHighlightMode = false
local targetName = ""
local viewTargetName = ""
local justSpawned = false
local currentHighlight = nil

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
        stopMovement()
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
        stopMovement()
    end
end)

-- إدارة التحديد باللون الأحمر (Red Highlight)
local function removeHighlight()
    if currentHighlight then
        currentHighlight:Destroy()
        currentHighlight = nil
    end
end

RedHighlightBtn.MouseButton1Click:Connect(function()
    isHighlightMode = not isHighlightMode
    if isHighlightMode then
        viewTargetName = ViewPlayerBox.Text
        local targetPlr = findPlayer(viewTargetName)
        if targetPlr then
            RedHighlightBtn.Text = "تحديد باللون الأحمر: ON"
            RedHighlightBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            isHighlightMode = false
            RedHighlightBtn.Text = "لم يتم العثور عليه!"
            task.wait(1)
            RedHighlightBtn.Text = "تحديد باللون الأحمر: OFF"
        end
    else
        RedHighlightBtn.Text = "تحديد باللون الأحمر: OFF"
        RedHighlightBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
        removeHighlight()
    end
end)

-- لوب التحديد باللون الأحمر
task.spawn(function()
    while task.wait(0.5) do
        if isHighlightMode and viewTargetName ~= "" then
            local targetPlr = findPlayer(viewTargetName)
            if targetPlr and targetPlr.Character then
                if not targetPlr.Character:FindFirstChild("Wafi_RedHighlight") then
                    removeHighlight()
                    local hl = Instance.new("Highlight")
                    hl.Name = "Wafi_RedHighlight"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.4
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = targetPlr.Character
                    currentHighlight = hl
                end
            else
                removeHighlight()
            end
        else
            removeHighlight()
        end
    end
end)

-- اللوب التشغيلي الرئيسي (المطاردة والقتال)
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
                    
                    if os.clock() - lastMoveTick >= 0.1 then
                        myHum:MoveTo(tRoot.Position)
                        lastMoveTick = os.clock()
                    end

                    if isSuicideMode then
                        if dist <= 4 and not justSpawned then
                            myHum.Health = 0
                        end
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
            if wasMoving then
                wasMoving = false
                stopMovement()
            end
        end
    end
end)
