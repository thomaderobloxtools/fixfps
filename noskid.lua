--========================================================
--  FIX LAG / FPS BOOST - FULL GRAPHICS STABLE
--  Dynamic Load Control | Combat Smooth | Client Safe
--========================================================

repeat task.wait() until game:IsLoaded()

--================ SERVICES =================
local Players     = game:GetService("Players")
local Lighting    = game:GetService("Lighting")
local RunService  = game:GetService("RunService")
local Workspace   = game:GetService("Workspace")
local StarterGui  = game:GetService("StarterGui")
local Stats       = game:GetService("Stats")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--================ NOTIFY =================
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "FIX LAG (beta)",
        Text = "Full Graphics FPS Boost Activated",
        Duration = 5
    })
end)

local Hint = Instance.new("Hint")
Hint.Text = "🔵 Fix Lag = Active"
Hint.Parent = Workspace
task.delay(6, function() Hint:Destroy() end)

--================ SKY + FOG =================
for _, v in ipairs(Lighting:GetChildren()) do
    if v:IsA("Sky") then v:Destroy() end
end
Lighting.FogStart = 1e9
Lighting.FogEnd   = 1e9

--================ BASE SAFE SETTINGS =================
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level05
end)

Camera.FieldOfView = 70

--================ EFFECT CONTROLLER =================
local function optimizeEffect(obj, aggressive)
    if obj:IsA("ParticleEmitter") then
        if aggressive then
            obj.Rate = math.clamp(obj.Rate, 0, 15)
            obj.LightEmission = 0
        else
            obj.Rate = math.clamp(obj.Rate, 0, 35)
        end
    elseif obj:IsA("Trail") or obj:IsA("Beam") then
        if aggressive then
            obj.Enabled = false
        end
    end
end

--================ INITIAL PASS =================
for _, obj in ipairs(Workspace:GetDescendants()) do
    optimizeEffect(obj, false)
end

--================ DYNAMIC FPS MONITOR =================
local aggressiveMode = false
local lastCheck = tick()

task.spawn(function()
    while task.wait(1) do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())

        -- Khi FPS tụt mạnh → bật chế độ combat/load cao
        if fps < 45 and not aggressiveMode then
            aggressiveMode = true
            for _, obj in ipairs(Workspace:GetDescendants()) do
                optimizeEffect(obj, true)
            end

        -- Khi FPS ổn định lại → trả hiệu ứng
        elseif fps > 58 and aggressiveMode then
            aggressiveMode = false
            for _, obj in ipairs(Workspace:GetDescendants()) do
                optimizeEffect(obj, false)
            end
        end
    end
end)

--================ NEW EFFECT SPAWN CONTROL =================
Workspace.DescendantAdded:Connect(function(obj)
    optimizeEffect(obj, aggressiveMode)
end)

--================ PART OPTIMIZATION (SAFE) =================
for _, obj in ipairs(Workspace:GetDescendants()) do
    if obj:IsA("BasePart") then
        obj.CastShadow = false
        obj.Reflectance = 0
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

--================ MEMORY STABILIZER =================
task.spawn(function()
    while task.wait(25) do
        pcall(function()
            collectgarbage("step", 200)
        end)
    end
end)

--================ CHARACTER SAFE RESET =================
Player.CharacterAdded:Connect(function(char)
    task.wait(1)
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            optimizeEffect(obj, aggressiveMode)
        end
    end
end)

print(">> FIX LAG FULL GRAPHICS ACTIVE | PLAYER:", Player.Name)
