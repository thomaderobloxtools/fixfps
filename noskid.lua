--####################################################################
--##  V3 EXTREME POTATO MODE - ULTIMATE FPS BOOST                   ##
--##  Warning: Game đồ họa sẽ trông như cục đất sét nhưng FPS MAX   ##
--####################################################################

if not game:IsLoaded() then game.Loaded:Wait() end

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local MaterialService = game:GetService("MaterialService")
local NetworkClient = game:GetService("NetworkClient")

-- 1. UNLOCK FPS (Chỉ hoạt động trên các executor hỗ trợ)
pcall(function()
    if setfpscap then
        setfpscap(999) -- Gỡ bỏ giới hạn 60 FPS mặc định của Roblox
    end
end)

-- 2. ÉP RENDER XUỐNG ĐÁY & TẮT TÍNH TOÁN VẬT LÝ THỪA
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
    settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.DefaultAuto
    settings().Network.IncomingReplicationLag = 0
end)

-- 3. HỦY DIỆT TOÀN BỘ ÁNH SÁNG & SƯƠNG MÙ VĨNH VIỄN
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.FogStart = 9e9
Lighting.Brightness = 0
Lighting.ClockTime = 12
Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
Lighting.Ambient = Color3.fromRGB(120, 120, 120)
Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)

for _, v in pairs(Lighting:GetDescendants()) do
    if v:IsA("PostEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then
        v:Destroy()
    end
end

-- 4. TẮT CÔNG NGHỆ VẬT LIỆU MỚI TỐN RAM (PBR)
pcall(function()
    MaterialService.Use2022Materials = false
end)

-- 5. XÓA BỎ MÔI TRƯỜNG NƯỚC VÀ CỎ 3D
local terrain = Workspace:FindFirstChildOfClass("Terrain")
if terrain then
    terrain.WaterWaveSize = 0
    terrain.WaterWaveSpeed = 0
    terrain.WaterReflectance = 0
    terrain.WaterTransparency = 1
    terrain.Decoration = false
    terrain.CastShadow = false
end

-- 6. HÀM GỌT GIŨA VẬT THỂ (XÓA TEXTURE, ÉP NHỰA TRƠN)
local function potatoOptimize(obj)
    if obj:IsA("BasePart") and not obj:IsA("Terrain") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        obj.CastShadow = false
    elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceAppearance") then
        -- Xóa sạch các lớp vân bề mặt, áo quần dán lên tường/đất
        obj:Destroy()
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
        -- Xóa vĩnh viễn hiệu ứng thay vì chỉ tắt (Enabled = false) để giải phóng RAM
        obj:Destroy()
    elseif obj:IsA("SpotLight") or obj:IsA("SurfaceLight") or obj:IsA("PointLight") then
        obj:Destroy()
    elseif obj:IsA("MeshPart") then
        -- Giảm độ chi tiết của lưới 3D
        obj.CastShadow = false
        obj.RenderFidelity = Enum.RenderFidelity.Performance
        obj.TextureID = ""
    end
end

-- 7. QUÉT TOÀN BỘ MAP (CÓ CHỐNG ĐƠ GAME)
task.spawn(function()
    local descendants = Workspace:GetDescendants()
    local count = 0
    for _, obj in pairs(descendants) do
        potatoOptimize(obj)
        count = count + 1
        if count >= 300 then
            task.wait() -- Nghỉ một chút để CPU không bị quá tải lúc quét
            count = 0
        end
    end
    print(">> V3 POTATO MODE: Đã dọn dẹp xong toàn bộ map!")
end)

-- 8. TỰ ĐỘNG XÓA HIỆU ỨNG CHIÊU THỨC KHI VỪA SINH RA
Workspace.DescendantAdded:Connect(function(obj)
    -- Dùng task.delay nhẹ để đảm bảo vật thể đã load hẳn trước khi gọt giũa
    task.delay(0.01, function()
        potatoOptimize(obj)
    end)
end)

-- 9. DỌN RÁC RAM TỰ ĐỘNG (GARBAGE COLLECTION)
task.spawn(function()
    while task.wait(30) do
        -- Cứ 30 giây dọn dẹp bộ nhớ đệm một lần
        collectgarbage("collect")
    end
end)

-- Hiển thị thông báo
local StarterGui = game:GetService("StarterGui")
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "POTATO MODE ON",
        Text  = "Đã hủy diệt đồ họa. Tận hưởng Max FPS!",
        Duration = 5
    })
end)
