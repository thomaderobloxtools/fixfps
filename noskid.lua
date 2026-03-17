--####################################################################
--##  GOD TIER FIX LAG - MAX FPS UNLOCKER                           ##
--##  Authoring Level: Extreme Engine Optimization                  ##
--####################################################################

if not game:IsLoaded() then game.Loaded:Wait() end

-------------------- SERVICES --------------------
local RunService = game:GetService("RunService")
local Lighting   = game:GetService("Lighting")
local Workspace  = game:GetService("Workspace")
local Players    = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-------------------- ENGINE SETTINGS --------------------
-- Ép render về mức thấp nhất thực sự thay vì mức 08
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
end)

-------------------- LIGHTING & ENVIRONMENT --------------------
-- Tắt toàn bộ đổ bóng và sương mù
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.FogStart = 9e9
Lighting.Brightness = 1

-- Diệt tận gốc các hiệu ứng Post-Processing gây tụt FPS
for _, effect in pairs(Lighting:GetDescendants()) do
    if effect:IsA("PostEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") or effect:IsA("Sky") then
        effect:Destroy()
    end
end

-------------------- TERRAIN REDUCTION --------------------
local terrain = Workspace:FindFirstChildOfClass("Terrain")
if terrain then
    terrain.WaterWaveSize = 0
    terrain.WaterWaveSpeed = 0
    terrain.WaterReflectance = 0
    terrain.WaterTransparency = 1
    terrain.Decoration = false -- Tắt cỏ 3D (cực kỳ nặng)
    pcall(function()
        terrain:SetMaterialColor(Enum.Material.Grass, Color3.fromRGB(100, 100, 100))
    end)
end

-------------------- DEEP OPTIMIZER FUNCTION --------------------
local function optimizeObject(obj)
    -- Chuyển mọi thứ thành SmoothPlastic và tắt bóng
    if obj:IsA("BasePart") and not obj:IsA("Terrain") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        obj.CastShadow = false
    -- Vô hiệu hóa hiệu ứng hạt và tia sáng
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
        obj.Enabled = false
    -- Tắt hiển thị decal/texture không cần thiết
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
    -- Xóa các hiệu ứng cháy nổ, lấp lánh dính trên part
    elseif obj:IsA("Fire") or obj:IsA("SpotLight") or obj:IsA("PointLight") or obj:IsA("SurfaceLight") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
        obj.Enabled = false
    end
end

-------------------- BATCH PROCESSING (ANTI-FREEZE) --------------------
-- Chạy quét một lần duy nhất với task.wait() để không làm treo game khi mới bật
task.spawn(function()
    local allObjects = Workspace:GetDescendants()
    for i, obj in pairs(allObjects) do
        optimizeObject(obj)
        -- Cứ quét xong 500 vật thể sẽ nghỉ 1 frame để CPU thở
        if i % 500 == 0 then
            task.wait()
        end
    end
    print(">> GOD TIER FIX LAG: Hoàn tất dọn dẹp môi trường ban đầu!")
end)

-------------------- DYNAMIC LISTENER --------------------
-- Tự động tối ưu các vật thể mới được sinh ra (chiêu thức, quái vật mới, v.v.)
Workspace.DescendantAdded:Connect(function(obj)
    optimizeObject(obj)
end)

-------------------- NOTIFICATION --------------------
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "GOD TIER ACTIVE",
        Text  = "Đồ họa đã được nén tối đa. Siêu mượt!",
        Duration = 6
    })
end)

local hint = Instance.new("Hint")
hint.Text = "🟢 FPS UNLOCKED & MAXIMIZED!"
hint.Parent = Workspace
task.delay(5, function() hint:Destroy() end)
