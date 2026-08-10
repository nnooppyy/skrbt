-- ==========================================================
--        WAFI ULTIMATE HUB - FULL VERSION (BUG FREE)
-- ==========================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("Wafi_UltimateHub") then
    CoreGui:FindFirstChild("Wafi_UltimateHub"):Destroy()
end
if getgenv().Wafi_MainLoop then
    task.cancel(getgenv().Wafi_MainLoop)
    getgenv().Wafi_MainLoop = nil
end

local Theme = {
    Background = Color3.fromRGB(18, 22, 32), Sidebar = Color3.fromRGB(12, 15, 23),
    Card = Color3.fromRGB(25, 32, 48), Border = Color3.fromRGB(40, 60, 95),
    Accent = Color3.fromRGB(0, 122, 255), Text = Color3.fromRGB(245, 245, 247),
    SubText = Color3.fromRGB(140, 160, 195), ON = Color3.fromRGB(16, 185, 129), OFF = Color3.fromRGB(0, 122, 255)
}

local function stopMovement()
    local myChar = LocalPlayer.Character
    if myChar then
        local myHum = myChar:FindFirstChild("Humanoid")
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if myHum and myRoot then myHum:MoveTo(myRoot.Position) end
    end
end

-- ==================== UI SETUP ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Wafi_UltimateHub"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local ToggleMenuBtn = Instance.new("TextButton", ScreenGui)
ToggleMenuBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleMenuBtn.Position = UDim2.new(0, 15, 0.4, 0)
ToggleMenuBtn.BackgroundColor3 = Theme.Sidebar
ToggleMenuBtn.TextColor3 = Theme.Accent
ToggleMenuBtn.Text = "WAFI"
ToggleMenuBtn.Font = Enum.Font.GothamBold
ToggleMenuBtn.Draggable = true
Instance.new("UICorner", ToggleMenuBtn).CornerRadius = UDim.new(1, 0)
local Stroke = Instance.new("UIStroke", ToggleMenuBtn) Stroke.Color = Theme.Accent Stroke.Thickness = 2

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 330, 0, 245)
MainFrame.Position = UDim2.new(0.5, -165, 0.25, 0)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.Draggable = true
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame).Color = Theme.Border

ToggleMenuBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 36)
Title.BackgroundColor3 = Theme.Sidebar
Title.Text = "  WAFI HUB - FULL"
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 85, 1, -36)
Sidebar.Position = UDim2.new(0, 0, 0, 36)
Sidebar.BackgroundColor3 = Theme.Sidebar
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local FarmPage = Instance.new("Frame", MainFrame) FarmPage.Size, FarmPage.Position = UDim2.new(1, -85, 1, -36), UDim2.new(0, 85, 0, 36) FarmPage.BackgroundTransparency = 1
local ViewPage = Instance.new("Frame", MainFrame) ViewPage.Size, ViewPage.Position = UDim2.new(1, -85, 1, -36), UDim2.new(0, 85, 0, 36) ViewPage.BackgroundTransparency, ViewPage.Visible = 1, false
local MiscPage = Instance.new("ScrollingFrame", MainFrame) MiscPage.Size, MiscPage.Position = UDim2.new(1, -85, 1, -36), UDim2.new(0, 85, 0, 36) MiscPage.BackgroundTransparency, MiscPage.Visible = 1, false
MiscPage.ScrollBarThickness = 3 MiscPage.CanvasSize = UDim2.new(0, 0, 0, 200)
local MiscLayout = Instance.new("UIListLayout", MiscPage) MiscLayout.HorizontalAlignment, MiscLayout.Padding = Enum.HorizontalAlignment.Center, UDim.new(0, 8)

local function createTabBtn(txt, pos, frame)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size, btn.Position = UDim2.new(0, 73, 0, 28), pos
    btn.BackgroundColor3, btn.TextColor3 = Theme.Card, Theme.SubText
    btn.Text, btn.TextSize, btn.Font = txt, 11, Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function()
        FarmPage.Visible, ViewPage.Visible, MiscPage.Visible = false, false, false
        frame.Visible = true
        for _, c in ipairs(Sidebar:GetChildren()) do
            if c:IsA("TextButton") then c.BackgroundColor3, c.TextColor3 = Theme.Card, Theme.SubText end
        end
        btn.BackgroundColor3, btn.TextColor3 = Theme.Accent, Theme.Text
    end)
    return btn
end

local FarmTabBtn = createTabBtn("Farm", UDim2.new(0, 6, 0, 8), FarmPage)
local ViewTabBtn = createTabBtn("View", UDim2.new(0, 6, 0, 40), ViewPage)
local MiscTabBtn = createTabBtn("Misc", UDim2.new(0, 6, 0, 72), MiscPage)
FarmTabBtn.BackgroundColor3, FarmTabBtn.TextColor3 = Theme.Accent, Theme.Text FarmPage.Visible = true

local function createDropdown(parent, pos, placeholder)
    local Container = Instance.new("Frame", parent)
    Container.Size, Container.Position, Container.BackgroundTransparency = UDim2.new(0, 225, 0, 26), pos, 1
    local Box = Instance.new("TextBox", Container)
    Box.Size, Box.BackgroundColor3, Box.TextColor3 = UDim2.new(1, -26, 1, 0), Theme.Card, Theme.Text
    Box.PlaceholderText, Box.TextSize, Box.Font = placeholder, 11, Enum.Font.Gotham
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", Box).Color = Theme.Border
    local DropBtn = Instance.new("TextButton", Container)
    DropBtn.Size, DropBtn.Position = UDim2.new(0, 22, 1, 0), UDim2.new(1, -22, 0, 0)
    DropBtn.BackgroundColor3, DropBtn.TextColor3 = Theme.Card, Theme.Accent
    DropBtn.Text, DropBtn.Font = "▼", Enum.Font.GothamBold
    Instance.new("UICorner", DropBtn).CornerRadius = UDim.new(0, 8)
    local Scroll = Instance.new("ScrollingFrame", Container)
    Scroll.Size, Scroll.Position, Scroll.Visible = UDim2.new(1, 0, 0, 100), UDim2.new(0, 0, 1, 4), false
    Scroll.BackgroundColor3, Scroll.ZIndex = Theme.Sidebar, 15
    Instance.new("UICorner", Scroll).CornerRadius = UDim.new(0, 8)
    local layout = Instance.new("UIListLayout", Scroll) layout.Padding = UDim.new(0, 3)
    
    DropBtn.MouseButton1Click:Connect(function()
        Scroll.Visible = not Scroll.Visible
        DropBtn.Text = Scroll.Visible and "▲" or "▼"
        if Scroll.Visible then
            for _, c in ipairs(Scroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
            local y = 0
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local b = Instance.new("TextButton", Scroll)
                    b.Size, b.BackgroundColor3, b.TextColor3 = UDim2.new(1, -8, 0, 22), Theme.Card, Theme.Text
                    b.Text, b.TextSize, b.ZIndex = plr.DisplayName, 10, 16
                    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
                    b.MouseButton1Click:Connect(function()
                        Box.Text = plr.Name
                        Scroll.Visible = false DropBtn.Text = "▼"
                    end)
                    y = y + 25
                end
            end
            Scroll.CanvasSize = UDim2.new(0, 0, 0, y)
        end
    end)
    return Box
end

local function createToggle(parent, pos, text)
    local btn = Instance.new("TextButton", parent)
    btn.Size, btn.Position = UDim2.new(0, 225, 0, 26), pos
    btn.BackgroundColor3, btn.TextColor3 = Theme.Card, Theme.OFF
    btn.Text, btn.Font, btn.TextSize = text .. "  [ OFF ]", Enum.Font.GothamBold, 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn) stroke.Color = Theme.Border
    return btn, stroke
end

-- ==================== FARM PAGE ====================
local PlayerBox = createDropdown(FarmPage, UDim2.new(0, 10, 0, 36), "اختر اللاعب...")
local ToggleBtn, ToggleStroke = createToggle(FarmPage, UDim2.new(0, 10, 0, 6), "AFK Mode")
local GoBtn, GoStroke = createToggle(FarmPage, UDim2.new(0, 10, 0, 66), "انتحار عند الوصول")
local KillBtn, KillStroke = createToggle(FarmPage, UDim2.new(0, 10, 0, 96), "ذبح بالسكين")
local InvisBtn, InvisStroke = createToggle(FarmPage, UDim2.new(0, 10, 0, 126), "الاختفاء (FE)")

-- ==================== VIEW PAGE ====================
local ViewBox = createDropdown(ViewPage, UDim2.new(0, 10, 0, 8), "اختر اللاعب...")
local HighlightBtn, HighStroke = createToggle(ViewPage, UDim2.new(0, 10, 0, 42), "تحديد أزرق")
local SpectateBtn, SpecStroke = createToggle(ViewPage, UDim2.new(0, 10, 0, 72), "مراقبة الكاميرا")
local EspBtn, EspStroke = createToggle(ViewPage, UDim2.new(0, 10, 0, 102), "إظهار الاسم")

-- ==================== MISC PAGE ====================
local CopyBtn = Instance.new("TextButton", MiscPage) CopyBtn.Size = UDim2.new(0, 225, 0, 28) CopyBtn.BackgroundColor3, CopyBtn.TextColor3, CopyBtn.Text, CopyBtn.Font, CopyBtn.TextSize = Theme.Card, Theme.Accent, "نسخ (الماب + السيرفر)", Enum.Font.GothamBold, 11 Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 8) Instance.new("UIStroke", CopyBtn).Color = Theme.Border
local IdBox = Instance.new("TextBox", MiscPage) IdBox.Size = UDim2.new(0, 225, 0, 28) IdBox.BackgroundColor3, IdBox.TextColor3, IdBox.PlaceholderText, IdBox.Font, IdBox.TextSize = Theme.Card, Theme.Text, "الصق الكود هنا...", Enum.Font.Gotham, 11 Instance.new("UICorner", IdBox).CornerRadius = UDim.new(0, 8) Instance.new("UIStroke", IdBox).Color = Theme.Border
local JoinBtn = Instance.new("TextButton", MiscPage) JoinBtn.Size = UDim2.new(0, 225, 0, 28) JoinBtn.BackgroundColor3, JoinBtn.TextColor3, JoinBtn.Text, JoinBtn.Font, JoinBtn.TextSize = Theme.Card, Theme.OFF, "انتقال لنفس السيرفر", Enum.Font.GothamBold, 11 Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 8) Instance.new("UIStroke", JoinBtn).Color = Theme.Border
local RejoinBtn = Instance.new("TextButton", MiscPage) RejoinBtn.Size = UDim2.new(0, 225, 0, 28) RejoinBtn.BackgroundColor3, RejoinBtn.TextColor3, RejoinBtn.Text, RejoinBtn.Font, RejoinBtn.TextSize = Theme.Card, Theme.OFF, "Rejoin", Enum.Font.GothamBold, 11 Instance.new("UICorner", RejoinBtn).CornerRadius = UDim.new(0, 8) Instance.new("UIStroke", RejoinBtn).Color = Theme.Border

-- ==================== LOGIC & VARIABLES ====================
local isAFK, isSuicide, isKill, isInvis, isHighlight, isSpec, isEsp = false, false, false, false, false, false, false
local curHighlight, curEsp, invisConn = nil, nil, nil

local function toggleState(btn, stroke, state, txt)
    btn.Text = txt .. (state and "  [ ON ]" or "  [ OFF ]")
    btn.TextColor3 = state and Theme.ON or Theme.OFF
    stroke.Color = state and Theme.ON or Theme.Border
end

local function getPlayer(name)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():match("^"..name:lower()) or p.DisplayName:lower():match("^"..name:lower()) then return p end
    end
end

-- Misc Logic
CopyBtn.MouseButton1Click:Connect(function()
    local str = tostring(game.PlaceId)..","..tostring(game.JobId)
    if setclipboard then setclipboard(str) elseif toclipboard then toclipboard(str) end
    CopyBtn.Text = "تم النسخ! ✓" task.wait(1.5) CopyBtn.Text = "نسخ (الماب + السيرفر)"
end)

JoinBtn.MouseButton1Click:Connect(function()
    local pId, jId = IdBox.Text:match("^(%d+),(.+)$")
    JoinBtn.Text = "جاري النقل..." JoinBtn.TextColor3 = Theme.ON
    if pId and jId then TeleportService:TeleportToPlaceInstance(tonumber(pId), jId, LocalPlayer)
    else 
        local sId = IdBox.Text:match("^(%d+)$")
        if sId then TeleportService:Teleport(tonumber(sId), LocalPlayer)
        else JoinBtn.Text = "خطأ بالكود!" JoinBtn.TextColor3 = Color3.fromRGB(255,50,50) task.wait(2) JoinBtn.Text = "انتقال لنفس السيرفر" JoinBtn.TextColor3 = Theme.OFF end
    end
end)
RejoinBtn.MouseButton1Click:Connect(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)

-- Toggles
ToggleBtn.MouseButton1Click:Connect(function() isAFK = not isAFK toggleState(ToggleBtn, ToggleStroke, isAFK, "AFK Mode") end)

GoBtn.MouseButton1Click:Connect(function() 
    isSuicide = not isSuicide isKill = false toggleState(GoBtn, GoStroke, isSuicide, "انتحار عند الوصول") toggleState(KillBtn, KillStroke, isKill, "ذبح بالسكين")
    if not isSuicide then stopMovement() end
end)

KillBtn.MouseButton1Click:Connect(function() 
    isKill = not isKill isSuicide = false toggleState(KillBtn, KillStroke, isKill, "ذبح بالسكين") toggleState(GoBtn, GoStroke, isSuicide, "انتحار عند الوصول")
    if not isKill then stopMovement() end
end)

InvisBtn.MouseButton1Click:Connect(function()
    isInvis = not isInvis toggleState(InvisBtn, InvisStroke, isInvis, "الاختفاء (FE)")
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if isInvis and root then
        root.CFrame = root.CFrame + Vector3.new(0, 9999, 0)
    end
end)

HighlightBtn.MouseButton1Click:Connect(function() isHighlight = not isHighlight toggleState(HighlightBtn, HighStroke, isHighlight, "تحديد أزرق") end)
SpectateBtn.MouseButton1Click:Connect(function()
    isSpec = not isSpec toggleState(SpectateBtn, SpecStroke, isSpec, "مراقبة الكاميرا")
    if not isSpec then workspace.CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") end
end)
EspBtn.MouseButton1Click:Connect(function() isEsp = not isEsp toggleState(EspBtn, EspStroke, isEsp, "إظهار الاسم") end)

-- Main Loop
getgenv().Wafi_MainLoop = task.spawn(function()
    while task.wait(0.1) do
        -- AFK Anti-Disconnect
        if isAFK then pcall(function() VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game) task.wait(0.05) VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game) end) end
        
        -- Farm Logic
        if (isSuicide or isKill) and PlayerBox.Text ~= "" then
            local t = getPlayer(PlayerBox.Text)
            local me = LocalPlayer.Character
            if t and t.Character and me and me:FindFirstChild("Humanoid") and me:FindFirstChild("HumanoidRootPart") then
                local trt = t.Character:FindFirstChild("HumanoidRootPart")
                if trt then
                    me.Humanoid:MoveTo(trt.Position)
                    local dist = (me.HumanoidRootPart.Position - trt.Position).Magnitude
                    if isSuicide and dist < 4 then me.Humanoid.Health = 0 end
                    if isKill and dist < 5 then
                        for _, tool in ipairs(me:GetChildren()) do
                            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                                tool:Activate()
                                if firetouchinterest then
                                    for _, p in ipairs(t.Character:GetChildren()) do
                                        if p:IsA("BasePart") then firetouchinterest(tool.Handle, p, 0) firetouchinterest(tool.Handle, p, 1) end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        -- View Logic
        local vt = getPlayer(ViewBox.Text)
        if vt and vt.Character then
            if isHighlight then
                if not vt.Character:FindFirstChild("WafiHL") then
                    if curHighlight then curHighlight:Destroy() end
                    curHighlight = Instance.new("Highlight", vt.Character) curHighlight.Name = "WafiHL" curHighlight.FillColor = Color3.fromRGB(0, 122, 255)
                end
            elseif curHighlight then curHighlight:Destroy() end

            if isSpec and vt.Character:FindFirstChild("Humanoid") then
                workspace.CurrentCamera.CameraSubject = vt.Character.Humanoid
            end

            if isEsp and vt.Character:FindFirstChild("Head") then
                if not vt.Character.Head:FindFirstChild("WafiESP") then
                    if curEsp then curEsp:Destroy() end
                    local bg = Instance.new("BillboardGui", vt.Character.Head) bg.Name = "WafiESP" bg.Size = UDim2.new(0, 150, 0, 30) bg.StudsOffset = Vector3.new(0, 2, 0) bg.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", bg) txt.Size = UDim2.new(1,0,1,0) txt.BackgroundTransparency = 1 txt.Text = vt.Name txt.TextColor3 = Color3.new(1,1,1) txt.TextStrokeTransparency = 0 txt.Font = Enum.Font.GothamBold
                    curEsp = bg
                end
            elseif curEsp then curEsp:Destroy() end
        else
            if curHighlight then curHighlight:Destroy() end
            if curEsp then curEsp:Destroy() end
        end
    end
end)
