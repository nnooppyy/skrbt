local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- تنظيف الواجهات واللوب القديم
if CoreGui:FindFirstChild("Wafi_UltimateHub") then
    CoreGui:FindFirstChild("Wafi_UltimateHub"):Destroy()
end
if getgenv().Wafi_MainLoop then
    task.cancel(getgenv().Wafi_MainLoop)
    getgenv().Wafi_MainLoop = nil
end

-- جدول الألوان الرئيسي (Theme Palette)
local Theme = {
    Background = Color3.fromRGB(20, 20, 24),
    Sidebar = Color3.fromRGB(13, 13, 16),
    Card = Color3.fromRGB(30, 30, 36),
    CardHover = Color3.fromRGB(40, 40, 48),
    Border = Color3.fromRGB(45, 45, 55),
    Accent = Color3.fromRGB(99, 102, 241),     -- أزرق بنفسجي
    AccentHover = Color3.fromRGB(129, 140, 248),
    Text = Color3.fromRGB(245, 245, 247),
    SubText = Color3.fromRGB(160, 160, 175),
    ON = Color3.fromRGB(16, 185, 129),        -- أخضر زمردي
    OFF = Color3.fromRGB(239, 68, 68)         -- أحمر ياقوتي
}

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

-- إضافة تأثير Hover للأزرار
local function addHoverEffect(btn, normalColor, hoverColor)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = normalColor}):Play()
    end)
end

-- إنشاء الواجهة الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Wafi_UltimateHub"
ScreenGui.ResetOnSpawn = false

local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- الزر الدائري العائم (HUB Logo)
local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleMenuBtn.Position = UDim2.new(0, 15, 0.4, 0)
ToggleMenuBtn.BackgroundColor3 = Theme.Sidebar
ToggleMenuBtn.TextColor3 = Theme.Accent
ToggleMenuBtn.Text = "HUB"
ToggleMenuBtn.TextSize = 13
ToggleMenuBtn.Font = Enum.Font.GothamBold
ToggleMenuBtn.Draggable = true
ToggleMenuBtn.Active = true
ToggleMenuBtn.Parent = ScreenGui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = ToggleMenuBtn

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = Theme.Accent
CircleStroke.Thickness = 2
CircleStroke.Parent = ToggleMenuBtn

-- الإطار الرئيسي (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 330, 0, 210)
MainFrame.Position = UDim2.new(0.5, -165, 0.25, 0)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Border
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- فتح وإغلاق القائمة بالزر الدائري
ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- العنوان الرئيسي
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 36)
Title.BackgroundColor3 = Theme.Sidebar
Title.Text = "  WAFI SCRIPT HUB"
Title.TextColor3 = Theme.Text
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- الشريط الجانبي (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 85, 1, -36)
Sidebar.Position = UDim2.new(0, 0, 0, 36)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

-- أزرار التبويب (Tabs)
local FarmTabBtn = Instance.new("TextButton")
FarmTabBtn.Size = UDim2.new(0, 73, 0, 32)
FarmTabBtn.Position = UDim2.new(0, 6, 0, 10)
FarmTabBtn.BackgroundColor3 = Theme.Accent
FarmTabBtn.TextColor3 = Theme.Text
FarmTabBtn.Text = "Farm"
FarmTabBtn.TextSize = 12
FarmTabBtn.Font = Enum.Font.GothamBold
FarmTabBtn.Parent = Sidebar

local FarmTabCorner = Instance.new("UICorner")
FarmTabCorner.CornerRadius = UDim.new(0, 8)
FarmTabCorner.Parent = FarmTabBtn

local ViewTabBtn = Instance.new("TextButton")
ViewTabBtn.Size = UDim2.new(0, 73, 0, 32)
ViewTabBtn.Position = UDim2.new(0, 6, 0, 48)
ViewTabBtn.BackgroundColor3 = Theme.Card
ViewTabBtn.TextColor3 = Theme.SubText
ViewTabBtn.Text = "View"
ViewTabBtn.TextSize = 12
ViewTabBtn.Font = Enum.Font.GothamBold
ViewTabBtn.Parent = Sidebar

local ViewTabCorner = Instance.new("UICorner")
ViewTabCorner.CornerRadius = UDim.new(0, 8)
ViewTabCorner.Parent = ViewTabBtn

-- الصفحات (Pages)
local FarmPage = Instance.new("Frame")
FarmPage.Size = UDim2.new(1, -85, 1, -36)
FarmPage.Position = UDim2.new(0, 85, 0, 36)
FarmPage.BackgroundTransparency = 1
FarmPage.Visible = true
FarmPage.Parent = MainFrame

local ViewPage = Instance.new("Frame")
ViewPage.Size = UDim2.new(1, -85, 1, -36)
ViewPage.Position = UDim2.new(0, 85, 0, 36)
ViewPage.BackgroundTransparency = 1
ViewPage.Visible = false
ViewPage.Parent = MainFrame

---------------------------------------------------------
-- عناصر صفحة FARM
---------------------------------------------------------

-- 1. زر AFK
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 225, 0, 32)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Theme.Card
ToggleBtn.TextColor3 = Theme.OFF
ToggleBtn.Text = "AFK Mode  [ OFF ]"
ToggleBtn.TextSize = 11
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = FarmPage

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Theme.Border
ToggleStroke.Thickness = 1
ToggleStroke.Parent = ToggleBtn

-- 2. مربع النص للمطاردة
local PlayerBox = Instance.new("TextBox")
PlayerBox.Size = UDim2.new(0, 225, 0, 32)
PlayerBox.Position = UDim2.new(0, 10, 0, 48)
PlayerBox.BackgroundColor3 = Theme.Card
PlayerBox.TextColor3 = Theme.Text
PlayerBox.PlaceholderColor3 = Theme.SubText
PlayerBox.PlaceholderText = "اسم اللاعب للمطاردة..."
PlayerBox.Text = ""
PlayerBox.TextSize = 11
PlayerBox.Font = Enum.Font.Gotham
PlayerBox.Parent = FarmPage

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 8)
BoxCorner.Parent = PlayerBox

local BoxStroke = Instance.new("UIStroke")
BoxStroke.Color = Theme.Border
BoxStroke.Thickness = 1
BoxStroke.Parent = PlayerBox

-- 3. زر الانتحار عند الوصول
local GoBtn = Instance.new("TextButton")
GoBtn.Size = UDim2.new(0, 225, 0, 32)
GoBtn.Position = UDim2.new(0, 10, 0, 86)
GoBtn.BackgroundColor3 = Theme.Card
GoBtn.TextColor3 = Theme.OFF
GoBtn.Text = "انتحار عند الوصول  [ OFF ]"
GoBtn.TextSize = 11
GoBtn.Font = Enum.Font.GothamBold
GoBtn.Parent = FarmPage

local GoCorner = Instance.new("UICorner")
GoCorner.CornerRadius = UDim.new(0, 8)
GoCorner.Parent = GoBtn

local GoStroke = Instance.new("UIStroke")
GoStroke.Color = Theme.Border
GoStroke.Thickness = 1
GoStroke.Parent = GoBtn

-- 4. زر الذبح بالسكين
local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.new(0, 225, 0, 32)
KillBtn.Position = UDim2.new(0, 10, 0, 124)
KillBtn.BackgroundColor3 = Theme.Card
KillBtn.TextColor3 = Theme.OFF
KillBtn.Text = "ذبح بالسكين  [ OFF ]"
KillBtn.TextSize = 11
KillBtn.Font = Enum.Font.GothamBold
KillBtn.Parent = KillBtn and FarmPage or FarmPage

local KillCorner = Instance.new("UICorner")
KillCorner.CornerRadius = UDim.new(0, 8)
KillCorner.Parent = KillBtn

local KillStroke = Instance.new("UIStroke")
KillStroke.Color = Theme.Border
KillStroke.Thickness = 1
KillStroke.Parent = KillBtn

---------------------------------------------------------
-- عناصر صفحة VIEW
---------------------------------------------------------

local ViewPlayerBox = Instance.new("TextBox")
ViewPlayerBox.Size = UDim2.new(0, 225, 0, 34)
ViewPlayerBox.Position = UDim2.new(0, 10, 0, 15)
ViewPlayerBox.BackgroundColor3 = Theme.Card
ViewPlayerBox.TextColor3 = Theme.Text
ViewPlayerBox.PlaceholderColor3 = Theme.SubText
ViewPlayerBox.PlaceholderText = "اسم اللاعب للمعاينة..."
ViewPlayerBox.Text = ""
ViewPlayerBox.TextSize = 11
ViewPlayerBox.Font = Enum.Font.Gotham
ViewPlayerBox.Parent = ViewPage

local ViewBoxCorner = Instance.new("UICorner")
ViewBoxCorner.CornerRadius = UDim.new(0, 8)
ViewBoxCorner.Parent = ViewPlayerBox

local ViewBoxStroke = Instance.new("UIStroke")
ViewBoxStroke.Color = Theme.Border
ViewBoxStroke.Thickness = 1
ViewBoxStroke.Parent = ViewPlayerBox

local RedHighlightBtn = Instance.new("TextButton")
RedHighlightBtn.Size = UDim2.new(0, 225, 0, 34)
RedHighlightBtn.Position = UDim2.new(0, 10, 0, 56)
RedHighlightBtn.BackgroundColor3 = Theme.Card
RedHighlightBtn.TextColor3 = Theme.OFF
RedHighlightBtn.Text = "تحديد باللون الأحمر  [ OFF ]"
RedHighlightBtn.TextSize = 11
RedHighlightBtn.Font = Enum.Font.GothamBold
RedHighlightBtn.Parent = ViewPage

local RedHighlightCorner = Instance.new("UICorner")
RedHighlightCorner.CornerRadius = UDim.new(0, 8)
RedHighlightCorner.Parent = RedHighlightBtn

local RedHighlightStroke = Instance.new("UIStroke")
RedHighlightStroke.Color = Theme.Border
RedHighlightStroke.Thickness = 1
RedHighlightStroke.Parent = RedHighlightBtn

---------------------------------------------------------
-- التنقل بين التبويبات (Tabs Switching)
---------------------------------------------------------

FarmTabBtn.MouseButton1Click:Connect(function()
    FarmPage.Visible = true
    ViewPage.Visible = false
    TweenService:Create(FarmTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Text}):Play()
    TweenService:Create(ViewTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Card, TextColor3 = Theme.SubText}):Play()
end)

ViewTabBtn.MouseButton1Click:Connect(function()
    FarmPage.Visible = false
    ViewPage.Visible = true
    TweenService:Create(ViewTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Text}):Play()
    TweenService:Create(FarmTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Card, TextColor3 = Theme.SubText}):Play()
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
    ToggleBtn.Text = isAFK and "AFK Mode  [ ON ]" or "AFK Mode  [ OFF ]"
    ToggleBtn.TextColor3 = isAFK and Theme.ON or Theme.OFF
    ToggleStroke.Color = isAFK and Theme.ON or Theme.Border
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
        KillBtn.Text = "ذبح بالسكين  [ OFF ]"
        KillBtn.TextColor3 = Theme.OFF
        KillStroke.Color = Theme.Border
        
        targetName = PlayerBox.Text
        local targetPlr = findPlayer(targetName)
        if targetPlr then
            GoBtn.Text = "انتحار عند الوصول  [ ON ]"
            GoBtn.TextColor3 = Theme.ON
            GoStroke.Color = Theme.ON
        else
            isSuicideMode = false
            GoBtn.Text = "لم يتم العثور عليه!"
            GoBtn.TextColor3 = Theme.OFF
            task.wait(1)
            GoBtn.Text = "انتحار عند الوصول  [ OFF ]"
        end
    else
        GoBtn.Text = "انتحار عند الوصول  [ OFF ]"
        GoBtn.TextColor3 = Theme.OFF
        GoStroke.Color = Theme.Border
        stopMovement()
    end
end)

-- زر الذبح بالسكين
KillBtn.MouseButton1Click:Connect(function()
    isKillMode = not isKillMode
    if isKillMode then
        isSuicideMode = false
        GoBtn.Text = "انتحار عند الوصول  [ OFF ]"
        GoBtn.TextColor3 = Theme.OFF
        GoStroke.Color = Theme.Border
        
        targetName = PlayerBox.Text
        local targetPlr = findPlayer(targetName)
        if targetPlr then
            KillBtn.Text = "ذبح بالسكين  [ ON ]"
            KillBtn.TextColor3 = Theme.ON
            KillStroke.Color = Theme.ON
        else
            isKillMode = false
            KillBtn.Text = "لم يتم العثور عليه!"
            KillBtn.TextColor3 = Theme.OFF
            task.wait(1)
            KillBtn.Text = "ذبح بالسكين  [ OFF ]"
        end
    else
        KillBtn.Text = "ذبح بالسكين  [ OFF ]"
        KillBtn.TextColor3 = Theme.OFF
        KillStroke.Color = Theme.Border
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
            RedHighlightBtn.Text = "تحديد باللون الأحمر  [ ON ]"
            RedHighlightBtn.TextColor3 = Theme.ON
            RedHighlightStroke.Color = Theme.ON
        else
            isHighlightMode = false
            RedHighlightBtn.Text = "لم يتم العثور عليه!"
            RedHighlightBtn.TextColor3 = Theme.OFF
            task.wait(1)
            RedHighlightBtn.Text = "تحديد باللون الأحمر  [ OFF ]"
        end
    else
        RedHighlightBtn.Text = "تحديد باللون الأحمر  [ OFF ]"
        RedHighlightBtn.TextColor3 = Theme.OFF
        RedHighlightStroke.Color = Theme.Border
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
