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

-- جدول الألوان الرئيسي (Blue Theme Palette)
local Theme = {
    Background = Color3.fromRGB(18, 22, 32),
    Sidebar = Color3.fromRGB(12, 15, 23),
    Card = Color3.fromRGB(25, 32, 48),
    CardHover = Color3.fromRGB(35, 45, 65),
    Border = Color3.fromRGB(40, 60, 95),
    Accent = Color3.fromRGB(0, 122, 255),        -- أزرق ملكي
    Text = Color3.fromRGB(245, 245, 247),
    SubText = Color3.fromRGB(140, 160, 195),
    ON = Color3.fromRGB(16, 185, 129),           -- أخضر زمردي للتشغيل
    OFF = Color3.fromRGB(0, 122, 255)            -- أزرق للإيقاف
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

-- إنشاء الواجهة الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Wafi_UltimateHub"
ScreenGui.ResetOnSpawn = false

local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- الزر الدائري العائم (WAFI Circle Logo)
local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleMenuBtn.Position = UDim2.new(0, 15, 0.4, 0)
ToggleMenuBtn.BackgroundColor3 = Theme.Sidebar
ToggleMenuBtn.TextColor3 = Theme.Accent
ToggleMenuBtn.Text = "WAFI"
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
MainFrame.Size = UDim2.new(0, 330, 0, 215)
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
Title.Text = "  WAFI HUB"
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

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 225, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 8)
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

local PlayerBox = Instance.new("TextBox")
PlayerBox.Size = UDim2.new(0, 225, 0, 30)
PlayerBox.Position = UDim2.new(0, 10, 0, 44)
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

local GoBtn = Instance.new("TextButton")
GoBtn.Size = UDim2.new(0, 225, 0, 30)
GoBtn.Position = UDim2.new(0, 10, 0, 80)
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

local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.new(0, 225, 0, 30)
KillBtn.Position = UDim2.new(0, 10, 0, 116)
KillBtn.BackgroundColor3 = Theme.Card
KillBtn.TextColor3 = Theme.OFF
KillBtn.Text = "ذبح بالسكين  [ OFF ]"
KillBtn.TextSize = 11
KillBtn.Font = Enum.Font.GothamBold
KillBtn.Parent = FarmPage

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
ViewPlayerBox.Size = UDim2.new(0, 225, 0, 28)
ViewPlayerBox.Position = UDim2.new(0, 10, 0, 8)
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

-- 1. زر التحديد باللون الأزرق
local BlueHighlightBtn = Instance.new("TextButton")
BlueHighlightBtn.Size = UDim2.new(0, 225, 0, 28)
BlueHighlightBtn.Position = UDim2.new(0, 10, 0, 42)
BlueHighlightBtn.BackgroundColor3 = Theme.Card
BlueHighlightBtn.TextColor3 = Theme.OFF
BlueHighlightBtn.Text = "تحديد باللون الأزرق  [ OFF ]"
BlueHighlightBtn.TextSize = 11
BlueHighlightBtn.Font = Enum.Font.GothamBold
BlueHighlightBtn.Parent = ViewPage

local BlueHighlightCorner = Instance.new("UICorner")
BlueHighlightCorner.CornerRadius = UDim.new(0, 8)
BlueHighlightCorner.Parent = BlueHighlightBtn

local BlueHighlightStroke = Instance.new("UIStroke")
BlueHighlightStroke.Color = Theme.Border
BlueHighlightStroke.Thickness = 1
BlueHighlightStroke.Parent = BlueHighlightBtn

-- 2. زر مراقبة الكاميرا
local SpectateBtn = Instance.new("TextButton")
SpectateBtn.Size = UDim2.new(0, 225, 0, 28)
SpectateBtn.Position = UDim2.new(0, 10, 0, 76)
SpectateBtn.BackgroundColor3 = Theme.Card
SpectateBtn.TextColor3 = Theme.OFF
SpectateBtn.Text = "مراقبة الكاميرا  [ OFF ]"
SpectateBtn.TextSize = 11
SpectateBtn.Font = Enum.Font.GothamBold
SpectateBtn.Parent = ViewPage

local SpectateCorner = Instance.new("UICorner")
SpectateCorner.CornerRadius = UDim.new(0, 8)
SpectateCorner.Parent = SpectateBtn

local SpectateStroke = Instance.new("UIStroke")
SpectateStroke.Color = Theme.Border
SpectateStroke.Thickness = 1
SpectateStroke.Parent = SpectateBtn

-- 3. زر إظهار الاسم
local NameEspBtn = Instance.new("TextButton")
NameEspBtn.Size = UDim2.new(0, 225, 0, 28)
NameEspBtn.Position = UDim2.new(0, 10, 0, 110)
NameEspBtn.BackgroundColor3 = Theme.Card
NameEspBtn.TextColor3 = Theme.OFF
NameEspBtn.Text = "إظهار الاسم  [ OFF ]"
NameEspBtn.TextSize = 11
NameEspBtn.Font = Enum.Font.GothamBold
NameEspBtn.Parent = ViewPage

local NameEspCorner = Instance.new("UICorner")
NameEspCorner.CornerRadius = UDim.new(0, 8)
NameEspCorner.Parent = NameEspBtn

local NameEspStroke = Instance.new("UIStroke")
NameEspStroke.Color = Theme.Border
NameEspStroke.Thickness = 1
NameEspStroke.Parent = NameEspBtn

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
local isSpectateMode = false
local isNameEspMode = false

local targetName = ""
local viewTargetName = ""
local justSpawned = false

local currentHighlight = nil
local currentNameEsp = nil

LocalPlayer.CharacterAdded:Connect(function(char)
    justSpawned = true
    local myHum = char:WaitForChild("Humanoid", 5)
    if myHum then
        myHum.WalkSpeed = 16
    end
    -- إعادة الكاميرا لشخصيتك عند الرسبن
    if isSpectateMode then
        workspace.CurrentCamera.CameraSubject = myHum
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

---------------------------------------------------------
-- منطق صفحة VIEW (التحديد - المراقبة - الاسم)
---------------------------------------------------------

-- 1. إدارة التحديد باللون الأزرق (Blue Highlight)
local function removeHighlight()
    if currentHighlight then
        currentHighlight:Destroy()
        currentHighlight = nil
    end
end

BlueHighlightBtn.MouseButton1Click:Connect(function()
    isHighlightMode = not isHighlightMode
    if isHighlightMode then
        viewTargetName = ViewPlayerBox.Text
        local targetPlr = findPlayer(viewTargetName)
        if targetPlr then
            BlueHighlightBtn.Text = "تحديد باللون الأزرق  [ ON ]"
            BlueHighlightBtn.TextColor3 = Theme.ON
            BlueHighlightStroke.Color = Theme.ON
        else
            isHighlightMode = false
            BlueHighlightBtn.Text = "لم يتم العثور عليه!"
            BlueHighlightBtn.TextColor3 = Theme.OFF
            task.wait(1)
            BlueHighlightBtn.Text = "تحديد باللون الأزرق  [ OFF ]"
        end
    else
        BlueHighlightBtn.Text = "تحديد باللون الأزرق  [ OFF ]"
        BlueHighlightBtn.TextColor3 = Theme.OFF
        BlueHighlightStroke.Color = Theme.Border
        removeHighlight()
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if isHighlightMode and viewTargetName ~= "" then
            local targetPlr = findPlayer(viewTargetName)
            if targetPlr and targetPlr.Character then
                if not targetPlr.Character:FindFirstChild("Wafi_BlueHighlight") then
                    removeHighlight()
                    local hl = Instance.new("Highlight")
                    hl.Name = "Wafi_BlueHighlight"
                    hl.FillColor = Color3.fromRGB(0, 122, 255)
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

-- 2. إدارة مراقبة الكاميرا (Spectate Camera)
SpectateBtn.MouseButton1Click:Connect(function()
    isSpectateMode = not isSpectateMode
    if isSpectateMode then
        viewTargetName = ViewPlayerBox.Text
        local targetPlr = findPlayer(viewTargetName)
        if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("Humanoid") then
            workspace.CurrentCamera.CameraSubject = targetPlr.Character.Humanoid
            SpectateBtn.Text = "مراقبة الكاميرا  [ ON ]"
            SpectateBtn.TextColor3 = Theme.ON
            SpectateStroke.Color = Theme.ON
        else
            isSpectateMode = false
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
            end
            SpectateBtn.Text = "لم يتم العثور عليه!"
            SpectateBtn.TextColor3 = Theme.OFF
            task.wait(1)
            SpectateBtn.Text = "مراقبة الكاميرا  [ OFF ]"
        end
    else
        isSpectateMode = false
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
        end
        SpectateBtn.Text = "مراقبة الكاميرا  [ OFF ]"
        SpectateBtn.TextColor3 = Theme.OFF
        SpectateStroke.Color = Theme.Border
    end
end)

-- 3. إدارة إظهار الاسم فوق رأس اللاعب (Name ESP)
local function removeNameEsp()
    if currentNameEsp then
        currentNameEsp:Destroy()
        currentNameEsp = nil
    end
end

NameEspBtn.MouseButton1Click:Connect(function()
    isNameEspMode = not isNameEspMode
    if isNameEspMode then
        viewTargetName = ViewPlayerBox.Text
        local targetPlr = findPlayer(viewTargetName)
        if targetPlr then
            NameEspBtn.Text = "إظهار الاسم  [ ON ]"
            NameEspBtn.TextColor3 = Theme.ON
            NameEspStroke.Color = Theme.ON
        else
            isNameEspMode = false
            NameEspBtn.Text = "لم يتم العثور عليه!"
            NameEspBtn.TextColor3 = Theme.OFF
            task.wait(1)
            NameEspBtn.Text = "إظهار الاسم  [ OFF ]"
        end
    else
        NameEspBtn.Text = "إظهار الاسم  [ OFF ]"
        NameEspBtn.TextColor3 = Theme.OFF
        NameEspStroke.Color = Theme.Border
        removeNameEsp()
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if isNameEspMode and viewTargetName ~= "" then
            local targetPlr = findPlayer(viewTargetName)
            if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("Head") then
                if not targetPlr.Character.Head:FindFirstChild("Wafi_NameESP") then
                    removeNameEsp()
                    local bg = Instance.new("BillboardGui")
                    bg.Name = "Wafi_NameESP"
                    bg.Adornee = targetPlr.Character.Head
                    bg.Size = UDim2.new(0, 160, 0, 30)
                    bg.StudsOffset = Vector3.new(0, 2.5, 0)
                    bg.AlwaysOnTop = true
                    
                    local lbl = Instance.new("TextLabel")
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = targetPlr.DisplayName .. " (@" .. targetPlr.Name .. ")"
                    lbl.TextColor3 = Color3.fromRGB(0, 150, 255)
                    lbl.TextStrokeTransparency = 0
                    lbl.TextSize = 12
                    lbl.Font = Enum.Font.GothamBold
                    lbl.Parent = bg
                    
                    bg.Parent = targetPlr.Character.Head
                    currentNameEsp = bg
                end
            else
                removeNameEsp()
            end
        else
            removeNameEsp()
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
