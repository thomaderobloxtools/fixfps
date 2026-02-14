-- =====================================
-- FPS BOOST / FIX LAG (SAFE CLIENT)
-- Có Player - Character - Humanoid
-- =====================================

repeat task.wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Notification
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "FPS BOOST",
        Text = "Fix Lag + Tăng FPS đã bật!",
        Duration = 5
    })
end)

-- ===== Lighting Optimization =====
Lighting.GlobalShadows = false
Lighting.FogEnd = 1e9
Lighting.Brightness = math.clamp(Lighting.Brightness, 1, 3)

for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("BloomEffect")
    or v:IsA("BlurEffect")
    or v:IsA("SunRaysEffect")
    or v:IsA("DepthOfFieldEffect")
    or v:IsA("ColorCorrectionEffect") then
        v.Enabled = false
    end
end

-- ===== Terrain =====
local Terrain = workspace:FindFirstChildOfClass("Terrain")
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
end

-- ===== Workspace Optimize (KHÔNG xóa) =====
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.Plastic
        obj.Reflectance = 0
    elseif obj:IsA("ParticleEmitter")
    or obj:IsA("Trail") then
        obj.Enabled = false
    elseif obj:IsA("Decal")
    or obj:IsA("Texture") then
        obj.Transparency = math.clamp(obj.Transparency, 0.3, 1)
    end
end

-- ===== Render Optimize =====
RunService.RenderStepped:Connect(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

print("FPS BOOST ACTIVE | Player:", Player.Name)
