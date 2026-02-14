--####################################################################
--##  ULTRA FIX LAG / FPS BOOST - FULL GRAPHICS COMBAT STABILIZER   ##
--##  UPGRADED: Bubble + Distance Priority + PvP Burst Optimizer  ##
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
        Text  = "Combat Optimizer Active",
        Duration = 6
    })
end)

local hint = Instance.new("Hint")
hint.Text = "🔵 Fix Lag = ACTIVE (PREMIUM MODE)"
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
    load = "IDLE",
    burst = false
}

-------------------- FPS METER --------------------
local frames = 0
local last = os.clock()

RunService.RenderStepped:Connect(function()
    frames += 1
    local now = os.clock()
    if now - last >= 1 then
        STATE.fps = frames
        frames = 0
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

-------------------- COMBAT BUBBLE --------------------
local BUBBLE_RADIUS = 55

local function distanceFromCamera(pos)
    return (Camera.CFrame.Position - pos).Magnitude
end

-------------------- EFFECT OPTIMIZER --------------------
local EFFECT_SCALE = {
    IDLE    = 1.0,
    LIGHT   = 0.85,
    HEAVY   = 0.65,
    EXTREME = 0.45
}

local function optimizeEffect(obj)
    if not obj:IsA("ParticleEmitter") then
        if obj:IsA("Trail") or obj:IsA("Beam") then
            if STATE.burst then
                obj.Enabled = false
            end
        end
        return
    end

    local parent = obj.Parent
    if not parent or not parent:IsA("BasePart") then return end

    local dist = distanceFromCamera(parent.Position)

    local distFactor
    if dist <= BUBBLE_RADIUS then
        distFactor = 1
    elseif dist <= 120 then
        distFactor = 0.75
    else
        distFactor = 0.45
    end

    local loadFactor = EFFECT_SCALE[STATE.load]
    local burstFactor = STATE.burst and 0.6 or 1

    obj.Rate = math.floor(obj.Rate * distFactor * loadFactor * burstFactor)
    obj.LightEmission = 0
    obj.LightInfluence = 0
end

-------------------- INITIAL PASS --------------------
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

-------------------- PvP BURST DETECTOR --------------------
local burstCounter = 0

Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ParticleEmitter") then
        burstCounter += 1
        optimizeEffect(obj)
    end
end)

task.spawn(function()
    while task.wait(0.25) do
        if burstCounter >= 8 then
            STATE.burst = true
            task.delay(0.4, function()
                STATE.burst = false
            end)
        end
        burstCounter = 0
    end
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
        collectgarbage("step", 250)
    end
end)

-------------------- CHARACTER SAFE --------------------
Player.CharacterAdded:Connect(function(char)
    task.wait(1)
    for _,obj in ipairs(char:GetDescendants()) do
        optimizeEffect(obj)
    end
end)

print(">> FIX LAG (BETA) ACTIVE | MODE: PREMIUM")
