-- تحميل مكتبة الواجهات المخصصة للمحقنات
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- إنشاء النافذة الرئيسية
local Window = OrionLib:MakeWindow({
    Name = "AFK Script - nnooppyy", 
    HidePremium = false, 
    SaveConfig = false, 
    ConfigFolder = "AFKConfig"
})

-- إنشاء التبويب الأول
local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local isAFK = false

-- إضافة زر التشغيل والإيقاف (Toggle)
Tab:AddToggle({
    Name = "AFK Auto Jump (قفز تلقائي)",
    Default = false,
    Callback = function(Value)
        isAFK = Value
    end    
})

-- حلقة القفز التلقائي
task.spawn(function()
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    while true do
        task.wait(1)
        if isAFK then
            -- محاكاة ضغط زِر المسافة (Space)
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end)

            -- طريقة احتياطية للقفز المباشر
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Jump = true
                end
            end)
        end
    end
end)

-- تشغيل الواجهة
OrionLib:Init()
