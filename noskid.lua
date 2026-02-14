-####################################################################
--##  ULTRA FIX LAG / FPS BOOST - FULL GRAPHICS COMBAT STABILIZER   ##
--##  Authoring Level: Advanced Client Optimization                ##
--####################################################################

repeat task.wait() until game:IsLoaded()

-------------------- SERVICES --------------------
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting   = game:GetService("Lighting")
local Workspace  = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-------------------- NOTIFY --------------------
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "ULTRA FIX LAG",
        Text  = "Full Graphics Stabilizer Active",
        Duration = 6
    })
end)

local hint = Instance.new("Hint")
hint.Text = "🔵 Fix Lag = ACTIVE (ULTRA MODE)"
hint.Parent = Workspace
task.delay(7, function() hint:Destroy() end)

-------------------- SKY / FOG --------------------
for _,v in ipairs(Lighting:GetChildren()) do
    if v:IsA("Sky") then v:Destroy() end
end
Lighting.FogStart = 1e9
Lighting.FogEnd   = 1e9

-------------------- BASE RENDER --------------------
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level08
end)
Camera.FieldOfView = 70

-------------------- STATE --------------------
local STATE = {
    fps = 60,
    load = "IDLE", -- IDLE | LIGHT | HEAVY | EXTREME
}

-------------------- FPS METER (STABLE) --------------------
local frameCount = 0
local last = os.clock()

RunService.RenderStepped:Connect(function()
    frameCount += 1
    local now = os.clock()
    if now - last >= 1 then
        STATE.fps = frameCount
        frameCount = 0
        last = now
    end
end)

-------------------- LOAD CLASSIFIER --------------------
local function classifyLoad()
    if STATE.fps >= 58 then
        return "IDLE"
    elseif STATE.fps >= 48 then
        return "LIGHT"
    elseif STATE.fps >= 38 then
        return "HEAVY"
    else
        return "EXTREME"
    end
end

-------------------- EFFECT BUDGET SYSTEM --------------------
local EFFECT_LIMIT = {
    IDLE    = 1.0,
    LIGHT   = 0.7,
    HEAVY   = 0.45,
    EXTREME = 0.25
}

local function optimizeEffect(obj)
    if obj:IsA("ParticleEmitter") then
        obj.Rate = math.floor(obj.Rate * EFFECT_LIMIT[STATE.load])
        obj.LightEmission = 0
        obj.LightInfluence = 0

    elseif obj:IsA("Trail") or obj:IsA("Beam") then
        if STATE.load == "EXTREME" then
            obj.Enabled = false
        end
    end
end

-------------------- APPLY PASS --------------------
local function fullOptimize()
    for _,obj in ipairs(Workspace:GetDescendants()) do
        optimizeEffect(obj)
        if obj:IsA("BasePart") then
            obj.CastShadow = false
            obj.Reflectance = 0
        end
    end
end

fullOptimize()

-------------------- DYNAMIC CONTROLLER --------------------
task.spawn(function()
    while task.wait(0.5) do
        local newState = classifyLoad()
        if newState ~= STATE.load then
            STATE.load = newState
            fullOptimize()
        end
    end
end)

-------------------- SPAWN CONTROL --------------------
Workspace.DescendantAdded:Connect(function(obj)
    optimizeEffect(obj)
end)

-------------------- TERRAIN --------------------
local terrain = Workspace:FindFirstChildOfClass("Terrain")
if terrain then
    terrain.WaterWaveSize = 0
    terrain.WaterWaveSpeed = 0
    terrain.WaterReflectance = 0
    terrain.WaterTransparency = 1
end

-------------------- MEMORY STABILIZER --------------------
task.spawn(function()
    while task.wait(20) do
        collectgarbage("step", 300)
    end
end)

-------------------- CHARACTER SAFE --------------------
Player.CharacterAdded:Connect(function(char)
    task.wait(1)
    for _,obj in ipairs(char:GetDescendants()) do
        optimizeEffect(obj)
    end
end)

print(">> ULTRA FIX LAG ACTIVE | MODE: ADAPTIVE | PLAYER:", Player.Name)
