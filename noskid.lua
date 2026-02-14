--=====================================================
--  FIX LAG / FPS BOOST PRO
--  Stable FPS | Smooth PvP | Safe Client
--=====================================================

repeat task.wait() until game:IsLoaded()

--================ SERVICES =================
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--================ NOTIFICATION =================
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Tho FIX LAG",
        Text = "FPS Boost is acctive",
        Duration = 5
    })
end)

-- Text xanh dương trên màn hình
local Hint = Instance.new("Hint")
Hint.Text = "🔵 Fix Lag = Active"
Hint.Parent = Workspace

task.delay(6, function()
    Hint:Destroy()
end)

--================ SKY + FOG =================
-- Xóa sky nhưng KHÔNG làm xám màu
for _, v in ipairs(Lighting:GetChildren()) do
    if v:IsA("Sky") then
        v:Destroy()
    end
end

Lighting.FogStart = 1e9
Lighting.FogEnd   = 1e9

--================ EFFECT OPTIMIZATION =================
local function optimizeEffects(obj)
    if obj:IsA("ParticleEmitter") then
        obj.LightEmission = 0
        obj.LightInfluence = 0
        obj.Rate = math.clamp(obj.Rate, 0, 25)
    elseif obj:IsA("Trail") then
        obj.Enabled = false
    elseif obj:IsA("Beam") then
        obj.Enabled = false
    end
end

-- Áp dụng cho effect hiện tại
for _, obj in ipairs(Workspace:GetDescendants()) do
    optimizeEffects(obj)
end

-- Áp dụng cho effect sinh ra sau này
Workspace.DescendantAdded:Connect(optimizeEffects)

--================ PART OPTIMIZATION =================
for _, obj in ipairs(Workspace:GetDescendants()) do
    if obj:IsA("BasePart") then
        obj.CastShadow = false
        obj.Reflectance = 0
        if obj.Material ~= Enum.Material.Plastic then
            obj.Material = Enum.Material.Plastic
        end
    end
end

--================ TERRAIN =================
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
end

--================ RENDER PIPELINE =================
-- Set render 1 lần (KHÔNG spam mỗi frame)
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level02
end)

Camera.FieldOfView = 70

--================ MEMORY CLEAN =================
-- Dọn rác client khi chơi lâu (không gây lag spike)
task.spawn(function()
    while task.wait(30) do
        pcall(function()
            collectgarbage("collect")
        end)
    end
end)

--================ CHARACTER RESET SAFE =================
Player.CharacterAdded:Connect(function(char)
    task.wait(1)
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj.Enabled = false
        end
    end
end)

print(">> FIX LAG PRO ACTIVE | PLAYER:", Player.Name)
