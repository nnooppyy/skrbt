local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- تنظيف الواجهات واللوب القديم
if CoreGui:FindFirstChild("Wafi_UltimateHub") then
    CoreGui:FindFirstChild("Wafi_UltimateHub"):Destroy()
end
if getgenv().Wafi_MainLoop then
    task.cancel(getgenv().Wafi_MainLoop)
    getgenv().Wafi_MainLoop = nil
end

local Theme = {
    Background = Color3.fromRGB(18, 22, 32),
    Sidebar = Color3.fromRGB(12, 15, 23),
    Card = Color3.fromRGB(25, 32, 48),
    Border = Color3.fromRGB(40, 60, 95),
    Accent = Color3.fromRGB(0, 122, 255),
    Text = Color3.fromRGB(245, 245, 247),
    SubText = Color3.fromRGB(140, 160, 195),
    ON = Color3.fromRGB(16, 185, 129),
    OFF = Color3.fromRGB(0, 122, 255)
}

local savedPlaceIds = {}
local fileName = "WafiHub_SavedIDs.json"

local function loadIDsFromFile()
    if readfile and isfile and isfile(fileName) then
        local success, result = pcall(function() return HttpService:JSONDecode(readfile(fileName)) end)
        if success and type(result) == "table" then
            savedPlaceIds = result
        end
    end
end

local function saveIDsToFile()
    if writefile then
        pcall(function()
            writefile(fileName, HttpService:JSONEncode(savedPlaceIds))
        end)
    end
end

loadIDsFromFile()

local function copyToClipboard(str)
    if setclipboard then setclipboard(str) elseif toclipboard then toclipboard(str) end
end

local function stopMovement()
    local myChar = LocalPlayer.Character
    if myChar then
        local myHum = myChar:FindFirstChild("Humanoid")
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if myHum and myRoot then myHum:MoveTo(myRoot.Position) end
    end
end

local function parsePlaceAndJob(text)
    if not text or text == "" then return nil, nil end
    text = text:gsub("[;|/]", ",")
    local pId, jId = text:match("(%d+),(%S+)")
    if pId and jId then
        return tonumber(pId), jId
    end
    local singleId = text:match("(%d+)")
    return tonumber(singleId), nil
end

-- إنشاء الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Wafi_UltimateHub"
ScreenGui.ResetOnSpawn = false

local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

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

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 330, 0, 245)
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

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

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

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 85, 1, -36)
Sidebar.Position = UDim2.new(0, 0, 0, 36)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

local FarmTabBtn = Instance.new("TextButton")
FarmTabBtn.Size = UDim2.new(0, 73, 0, 28)
FarmTabBtn.Position = UDim2.new(0, 6, 0, 8)
FarmTabBtn.BackgroundColor3 = Theme.Accent
FarmTabBtn.TextColor3 = Theme.Text
FarmTabBtn.Text = "Farm"
FarmTabBtn.TextSize = 11
FarmTabBtn.Font = Enum.Font.GothamBold
FarmTabBtn.Parent = Sidebar

local FarmTabCorner = Instance.new("UICorner")
FarmTabCorner.CornerRadius = UDim.new(0, 8)
FarmTabCorner.Parent = FarmTabBtn

local ViewTabBtn = Instance.new("TextButton")
ViewTabBtn.Size = UDim2.new(0, 73, 0, 28)
ViewTabBtn.Position = UDim2.new(0, 6, 0, 40)
ViewTabBtn.BackgroundColor3 = Theme.Card
ViewTabBtn.TextColor3 = Theme.SubText
ViewTabBtn.Text = "View"
ViewTabBtn.TextSize = 11
ViewTabBtn.Font = Enum.Font.GothamBold
ViewTabBtn.Parent = Sidebar

local ViewTabCorner = Instance.new("UICorner")
ViewTabCorner.CornerRadius = UDim.new(0, 8)
ViewTabCorner.Parent = ViewTabBtn

local MiscTabBtn = Instance.new("TextButton")
MiscTabBtn.Size = UDim2.new(0, 73, 0, 28)
MiscTabBtn.Position = UDim2.new(0, 6, 0, 72)
MiscTabBtn.BackgroundColor3 = Theme.Card
MiscTabBtn.TextColor3 = Theme.SubText
MiscTabBtn.Text = "Misc"
MiscTabBtn.TextSize = 11
MiscTabBtn.Font = Enum.Font.GothamBold
MiscTabBtn.Parent = Sidebar

local MiscTabCorner = Instance.new("UICorner")
MiscTabCorner.CornerRadius = UDim.new(0, 8)
MiscTabCorner.Parent = MiscTabBtn

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

local MiscPage = Instance.new("ScrollingFrame")
MiscPage.Size = UDim2.new(1, -85, 1, -36)
MiscPage.Position = UDim2.new(0, 85, 0, 36)
MiscPage.BackgroundTransparency = 1
MiscPage.Visible = false
MiscPage.ScrollBarThickness = 3
MiscPage.CanvasSize = UDim2.new(0, 0, 0, 380)
MiscPage.Parent = MainFrame

local MiscLayout = Instance.new("UIListLayout")
MiscLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
MiscLayout.SortOrder = Enum.SortOrder.LayoutOrder
MiscLayout.Padding = UDim.new(0, 6)
MiscLayout.Parent = MiscPage

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 225, 0, 26)
ToggleBtn.Position = UDim2.new(0, 10, 0, 6)
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
PlayerBox.Size = UDim2.new(0, 225, 0, 26)
PlayerBox.Position = UDim2.new(0, 10, 0, 36)
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
GoBtn.Size = UDim2.new(0, 225, 0, 26)
GoBtn.Position = UDim2.new(0, 10, 0, 66)
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
KillBtn.Size = UDim2.new(0, 225, 0, 26)
KillBtn.Position = UDim2.new(0, 10, 0, 96)
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

local InvisBtn = Instance.new("TextButton")
InvisBtn.Size = UDim2.new(0, 225, 0, 26)
InvisBtn.Position = UDim2.new(0, 10, 0, 126)
InvisBtn.BackgroundColor3 = Theme.Card
InvisBtn.TextColor3 = Theme.OFF
InvisBtn.Text = "نمط الاختفاء (FE)  [ OFF ]"
InvisBtn.TextSize = 11
InvisBtn.Font = Enum.Font.GothamBold
InvisBtn.Parent = FarmPage

local InvisCorner = Instance.new("UICorner")
InvisCorner.CornerRadius = UDim.new(0, 8)
InvisCorner.Parent = InvisBtn

local InvisStroke = Instance.new("UIStroke")
InvisStroke.Color = Theme.Border
InvisStroke.Thickness = 1
InvisStroke.Parent = InvisBtn

-- صفحة VIEW
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

-- عناصر MISC
local CopyCurrentBtn = Instance.new("TextButton")
CopyCurrentBtn.LayoutOrder = 1
CopyCurrentBtn.Size = UDim2.new(0, 225, 0, 28)
CopyCurrentBtn.BackgroundColor3 = Theme.Card
CopyCurrentBtn.TextColor3 = Theme.Accent
CopyCurrentBtn.Text = "نسخ وتخزين ID الماب الحالي"
CopyCurrentBtn.TextSize = 11
CopyCurrentBtn.Font = Enum.Font.GothamBold
CopyCurrentBtn.Parent = MiscPage

local CopyCorner = Instance.new("UICorner")
CopyCorner.CornerRadius = UDim.new(0, 8)
CopyCorner.Parent = CopyCurrentBtn

local CopyStroke = Instance.new("UIStroke")
CopyStroke.Color = Theme.Border
CopyStroke.Thickness = 1
CopyStroke.Parent = CopyCurrentBtn

local DirectIdBox = Instance.new("TextBox")
DirectIdBox.LayoutOrder = 2
DirectIdBox.Size = UDim2.new(0, 225, 0, 28)
DirectIdBox.BackgroundColor3 = Theme.Card
DirectIdBox.TextColor3 = Theme.Text
DirectIdBox.PlaceholderColor3 = Theme.SubText
DirectIdBox.PlaceholderText = "أدخل Place ID أو مع السيرفر..."
DirectIdBox.Text = ""
DirectIdBox.TextSize = 11
DirectIdBox.Font = Enum.Font.Gotham
DirectIdBox.Parent = MiscPage

local DirectIdCorner = Instance.new("UICorner")
DirectIdCorner.CornerRadius = UDim.new(0, 8)
DirectIdCorner.Parent = DirectIdBox

local DirectIdStroke = Instance.new("UIStroke")
DirectIdStroke.Color = Theme.Border
DirectIdStroke.Thickness = 1
DirectIdStroke.Parent = DirectIdBox

local JoinIdBtn = Instance.new("TextButton")
JoinIdBtn.LayoutOrder = 3
JoinIdBtn.Size = UDim2.new(0, 225, 0, 28)
JoinIdBtn.BackgroundColor3 = Theme.Card
JoinIdBtn.TextColor3 = Theme.OFF
JoinIdBtn.Text = "انتقال إلى الـ Place ID"
JoinIdBtn.TextSize = 11
JoinIdBtn.Font = Enum.Font.GothamBold
JoinIdBtn.Parent = MiscPage

local JoinCorner = Instance.new("UICorner")
JoinCorner.CornerRadius = UDim.new(0, 8)
JoinCorner.Parent = JoinIdBtn

local JoinStroke = Instance.new("UIStroke")
JoinStroke.Color = Theme.Border
JoinStroke.Thickness = 1
JoinStroke.Parent = JoinIdBtn

local SavedHeader = Instance.new("TextLabel")
SavedHeader.LayoutOrder = 4
SavedHeader.Size = UDim2.new(0, 225, 0, 18)
SavedHeader.BackgroundTransparency = 1
SavedHeader.Text = "قائمة الـ IDs المحفوظة:"
SavedHeader.TextColor3 = Theme.SubText
SavedHeader.TextSize = 10
SavedHeader.Font = Enum.Font.GothamBold
SavedHeader.TextXAlignment = Enum.TextXAlignment.Left
SavedHeader.Parent = MiscPage

local SavedContainer = Instance.new("Frame")
SavedContainer.LayoutOrder = 5
SavedContainer.Size = UDim2.new(0, 225, 0, 0)
SavedContainer.BackgroundTransparency = 1
SavedContainer.Parent = MiscPage

local SavedContainerLayout = Instance.new("UIListLayout")
SavedContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
SavedContainerLayout.Padding = UDim.new(0, 4)
SavedContainerLayout.Parent = SavedContainer

local ServerHopBtn = Instance.new("TextButton")
ServerHopBtn.LayoutOrder = 6
ServerHopBtn.Size = UDim2.new(0, 225, 0, 28)
ServerHopBtn.BackgroundColor3 = Theme.Card
ServerHopBtn.TextColor3 = Theme.OFF
ServerHopBtn.Text = "دخول سيرفر قليل (عشوائي)"
ServerHopBtn.TextSize = 11
ServerHopBtn.Font = Enum.Font.GothamBold
ServerHopBtn.Parent = MiscPage

local HopCorner = Instance.new("UICorner")
HopCorner.CornerRadius = UDim.new(0, 8)
HopCorner.Parent = ServerHopBtn

local HopStroke = Instance.new("UIStroke")
HopStroke.Color = Theme.Border
HopStroke.Thickness = 1
HopStroke.Parent = ServerHopBtn

local RejoinBtn = Instance.new("TextButton")
RejoinBtn.LayoutOrder = 7
RejoinBtn.Size = UDim2.new(0, 225, 0, 28)
RejoinBtn.BackgroundColor3 = Theme.Card
RejoinBtn.TextColor3 = Theme.OFF
RejoinBtn.Text = "إعادة الاتصال بنفس السيرفر (Rejoin)"
RejoinBtn.TextSize = 11
RejoinBtn.Font = Enum.Font.GothamBold
RejoinBtn.Parent = MiscPage

local RejoinCorner = Instance.new("UICorner")
RejoinCorner.CornerRadius = UDim.new(0, 8)
RejoinCorner.Parent = RejoinBtn

local RejoinStroke = Instance.new("UIStroke")
RejoinStroke.Color = Theme.Border
RejoinStroke.Thickness = 1
RejoinStroke.Parent = RejoinBtn

local function refreshSavedUI()
    for _, child in ipairs(SavedContainer:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local totalHeight = 0
    for i, data in ipairs(savedPlaceIds) do
        local ItemFrame = Instance.new("Frame")
        ItemFrame.Size = UDim2.new(1, 0, 0, 26)
        ItemFrame.BackgroundColor3 = Theme.Card
        ItemFrame.Parent = SavedContainer

        local ItemCorner = Instance.new("UICorner")
        ItemCorner.CornerRadius = UDim.new(0, 6)
        ItemCorner.Parent = ItemFrame

        local ItemStroke = Instance.new("UIStroke")
        ItemStroke.Color = Theme.Border
        ItemStroke.Thickness = 1
        ItemStroke.Parent = ItemFrame

        local displayText = type(data) == "table" and tostring(data.placeId) or tostring(data)
        local IdLabel = Instance.new("TextLabel")
        IdLabel.Size = UDim2.new(0, 110, 1, 0)
        IdLabel.Position = UDim2.new(0, 8, 0, 0)
        IdLabel.BackgroundTransparency = 1
        IdLabel.Text = displayText
        IdLabel.TextColor3 = Theme.Text
        IdLabel.TextSize = 10
        IdLabel.Font = Enum.Font.GothamBold
        IdLabel.TextXAlignment = Enum.TextXAlignment.Left
        IdLabel.Parent = ItemFrame

        local GoItemBtn = Instance.new("TextButton")
        GoItemBtn.Size = UDim2.new(0, 42, 0, 18)
        GoItemBtn.Position = UDim2.new(1, -92, 0.5, -9)
        GoItemBtn.BackgroundColor3 = Theme.Accent
        GoItemBtn.TextColor3 = Theme.Text
        GoItemBtn.Text = "دخول"
        GoItemBtn.TextSize = 9
        GoItemBtn.Font = Enum.Font.GothamBold
        GoItemBtn.Parent = ItemFrame

        local GoItemCorner = Instance.new("UICorner")
        GoItemCorner.CornerRadius = UDim.new(0, 4)
        GoItemCorner.Parent = GoItemBtn

        local DelItemBtn = Instance.new("TextButton")
        DelItemBtn.Size = UDim2.new(0, 40, 0, 18)
        DelItemBtn.Position = UDim2.new(1, -45, 0.5, -9)
        DelItemBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        DelItemBtn.TextColor3 = Theme.Text
        DelItemBtn.Text = "حذف"
        DelItemBtn.TextSize = 9
        DelItemBtn.Font = Enum.Font.GothamBold
        DelItemBtn.Parent = ItemFrame

        local DelItemCorner = Instance.new("UICorner")
        DelItemCorner.CornerRadius = UDim.new(0, 4)
        DelItemCorner.Parent = DelItemBtn

        GoItemBtn.MouseButton1Click:Connect(function()
            if type(data) == "table" then
                pcall(function()
                    if data.jobId and data.jobId ~= "" then
                        TeleportService:TeleportToPlaceInstance(data.placeId, data.jobId, LocalPlayer)
                    else
                        TeleportService:Teleport(data.placeId, LocalPlayer)
                    end
                end)
            else
                TeleportService:Teleport(tonumber(data), LocalPlayer)
            end
        end)

        DelItemBtn.MouseButton1Click:Connect(function()
            table.remove(savedPlaceIds, i)
            saveIDsToFile()
            refreshSavedUI()
        end)

        totalHeight = totalHeight + 30
    end

    SavedContainer.Size = UDim2.new(0, 225, 0, totalHeight)
end

local function addSavedID(pId, jId)
    local numId = tonumber(pId)
    if not numId then return end
    
    for _, v in ipairs(savedPlaceIds) do
        if type(v) == "table" and v.placeId == numId then
            v.jobId = jId
            saveIDsToFile()
            refreshSavedUI()
            return
        elseif type(v) == "number" and v == numId then
            return
        end
    end
    
    table.insert(savedPlaceIds, {placeId = numId, jobId = jId})
    saveIDsToFile()
    refreshSavedUI()
end

refreshSavedUI()

CopyCurrentBtn.MouseButton1Click:Connect(function()
    local placeId = game.PlaceId
    local jobId = game.JobId
    
    local fullId = tostring(placeId) .. "," .. tostring(jobId)
    copyToClipboard(fullId)
    addSavedID(placeId, jobId)
    
    CopyCurrentBtn.Text = "تم النسخ بنجاح (مع السيرفر)! ✓"
    CopyCurrentBtn.TextColor3 = Theme.ON
    task.wait(1.5)
    CopyCurrentBtn.Text = "نسخ وتخزين ID الماب الحالي"
    CopyCurrentBtn.TextColor3 = Theme.Accent
end)

JoinIdBtn.MouseButton1Click:Connect(function()
    local pId, jId = parsePlaceAndJob(DirectIdBox.Text)
    if pId then
        addSavedID(pId, jId)
        JoinIdBtn.Text = "جاري النقل..."
        pcall(function()
            if jId and jId ~= "" then
                TeleportService:TeleportToPlaceInstance(pId, jId, LocalPlayer)
            else
                TeleportService:Teleport(pId, LocalPlayer)
            end
        end)
    else
        JoinIdBtn.Text = "يرجى كتابة ID صحيح!"
        task.wait(1.5)
        JoinIdBtn.Text = "انتقال إلى الـ Place ID"
    end
end)

FarmTabBtn.MouseButton1Click:Connect(function()
    FarmPage.Visible = true
    ViewPage.Visible = false
    MiscPage.Visible = false
    TweenService:Create(FarmTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Text}):Play()
    TweenService:Create(ViewTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Card, TextColor3 = Theme.SubText}):Play()
    TweenService:Create(MiscTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Card, TextColor3 = Theme.SubText}):Play()
end)

ViewTabBtn.MouseButton1Click:Connect(function()
    FarmPage.Visible = false
    ViewPage.Visible = true
    MiscPage.Visible = false
    TweenService:Create(ViewTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Text}):Play()
    TweenService:Create(FarmTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Card, TextColor3 = Theme.SubText}):Play()
    TweenService:Create(MiscTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Card, TextColor3 = Theme.SubText}):Play()
end)

MiscTabBtn.MouseButton1Click:Connect(function()
    FarmPage.Visible = false
    ViewPage.Visible = false
    MiscPage.Visible = true
    TweenService:Create(MiscTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Text}):Play()
    TweenService:Create(FarmTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Card, TextColor3 = Theme.SubText}):Play()
    TweenService:Create(ViewTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Card, TextColor3 = Theme.SubText}):Play()
end)

RejoinBtn.MouseButton1Click:Connect(function()
    RejoinBtn.Text = "جاري إعادة الاتصال..."
    local pId = game.PlaceId
    local jId = game.JobId
    local success, err = pcall(function()
        if #Players:GetPlayers() <= 1 then
            TeleportService:Teleport(pId, LocalPlayer)
        else
            TeleportService:TeleportToPlaceInstance(pId, jId, LocalPlayer)
        end
    end)
    if not success then TeleportService:Teleport(pId, LocalPlayer) end
end)

ServerHopBtn.MouseButton1Click:Connect(function()
    ServerHopBtn.Text = "جاري البحث عن سيرفر..."
    task.spawn(function()
        local placeId = game.PlaceId
        local req = (syn and syn.request) or (http and http.request) or http_request or request or httprequest
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
        local success, result = pcall(function()
            if req then
                local res = req({Url = url, Method = "GET"})
                return HttpService:JSONDecode(res.Body)
            else
                return HttpService:JSONDecode(game:HttpGet(url))
            end
        end)

        if success and result and result.data then
            local candidateServers = {}
            for _, server in ipairs(result.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers and server.playing > 0 then
                    table.insert(candidateServers, server)
                end
            end

            if #candidateServers > 0 then
                table.sort(candidateServers, function(a, b) return a.playing < b.playing end)
                local chosenServer = candidateServers[math.random(1, math.min(#candidateServers, 5))]
                ServerHopBtn.Text = "تم العثور! جاري النقل..."
                TeleportService:TeleportToPlaceInstance(placeId, chosenServer.id, LocalPlayer)
            else
                ServerHopBtn.Text = "لم يتم العثور على سيرفر!"
                task.wait(1.5)
                ServerHopBtn.Text = "دخول سيرفر قليل (عشوائي)"
            end
        end
    end)
end)

local isAFK = false
local isSuicideMode = false
local isKillMode = false
local isInvisMode = false
local isHighlightMode = false
local isSpectateMode = false
local isNameEspMode = false

local targetName = ""
local viewTargetName = ""
local justSpawned = false

local currentHighlight = nil
local currentNameEsp = nil
local lastKnifeJumpTick = os.clock()

local function forceJump(humanoid)
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end)
    end
end

-- آلية الاختفاء المحسنة والمعدلة بالكامل (FE Invis System)
local invisLoopConn = nil

local function toggleFEInvisibility(state)
    local char = LocalPlayer.Character
    if not char then return end
    
    if state then
        if invisLoopConn then invisLoopConn:Disconnect() end
        
        -- تطبيق ثغرة فصل المفاصل لجعل الشخصية غير مرئية بالنسبة للسيرفر
        invisLoopConn = RunService.Stepped:Connect(function()
            if isInvisMode and LocalPlayer.Character == char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
                
                local lowerTorso = char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso")
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                
                if rootPart and lowerTorso then
                    local rootJoint = rootPart:FindFirstChild("RootJoint") or lowerTorso:FindFirstChild("Root")
                    if rootJoint then
                        rootJoint.C0 = CFrame.new(0, -10000, 0)
                    end
                end
            end
        end)
    else
        if invisLoopConn then
            invisLoopConn:Disconnect()
            invisLoopConn = nil
        end
        
        -- إرجاع المفاصل لوضعها الطبيعي
        local lowerTorso = char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso")
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart and lowerTorso then
            local rootJoint = rootPart:FindFirstChild("RootJoint") or lowerTorso:FindFirstChild("Root")
            if rootJoint then
                rootJoint.C0 = CFrame.new(0, 0, 0)
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    justSpawned = true
    local myHum = char:WaitForChild("Humanoid", 5)
    if myHum then myHum.WalkSpeed = 16 end
    if isSpectateMode then workspace.CurrentCamera.CameraSubject = myHum end
    
    task.wait(0.5)
    if isInvisMode then
        toggleFEInvisibility(true)
    end
    justSpawned = false
end)

ToggleBtn.MouseButton1Click:Connect(function()
    isAFK = not isAFK
    ToggleBtn.Text = isAFK and "AFK Mode  [ ON ]" or "AFK Mode  [ OFF ]"
    ToggleBtn.TextColor3 = isAFK and Theme.ON or Theme.OFF
    ToggleStroke.Color = isAFK and Theme.ON or Theme.Border
end)

InvisBtn.MouseButton1Click:Connect(function()
    isInvisMode = not isInvisMode
    InvisBtn.Text = isInvisMode and "نمط الاختفاء (FE)  [ ON ]" or "نمط الاختفاء (FE)  [ OFF ]"
    InvisBtn.TextColor3 = isInvisMode and Theme.ON or Theme.OFF
    InvisStroke.Color = isInvisMode and Theme.ON or Theme.Border
    
    toggleFEInvisibility(isInvisMode)
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

local function findPlayer(name)
    if name == "" then return nil end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and (plr.Name:lower():sub(1, #name) == name:lower() or plr.DisplayName:lower():sub(1, #name) == name:lower()) then
            return plr
        end
    end
    return nil
end

local function getKnifeTool(char)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local allTools = {}
    if char then for _, item in ipairs(char:GetChildren()) do if item:IsA("Tool") then table.insert(allTools, item) end end end
    if backpack then for _, item in ipairs(backpack:GetChildren()) do if item:IsA("Tool") then table.insert(allTools, item) end end end

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

KillBtn.MouseButton1Click:Connect(function()
    isKillMode = not isKillMode
    if isKillMode then
        isSuicideMode = false
        GoBtn.Text = "انتحار عند الوصول  [ OFF ]"
        GoBtn.TextColor3 = Theme.OFF
        GoStroke.Color = Theme.Border
        
        lastKnifeJumpTick = os.clock()
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

local function removeHighlight()
    if currentHighlight then currentHighlight:Destroy() currentHighlight = nil end
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
            else removeHighlight() end
        else removeHighlight() end
    end
end)

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

local function removeNameEsp()
    if currentNameEsp then currentNameEsp:Destroy() currentNameEsp = nil end
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
            else removeNameEsp() end
        else removeNameEsp() end
    end
end)

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
                        if os.clock() - lastKnifeJumpTick >= 300 then
                            forceJump(myHum)
                            lastKnifeJumpTick = os.clock()
                        end

                        if dist <= 4 then
                            local targetFacePos = Vector3.new(tRoot.Position.X, myRoot.Position.Y, tRoot.Position.Z)
                            myRoot.CFrame = CFrame.lookAt(myRoot.Position, targetFacePos)

                            local knife = getKnifeTool(myChar)
                            if knife then
                                if knife.Parent ~= myChar then myHum:EquipTool(knife) end
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
                                me
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
