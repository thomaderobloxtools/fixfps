repeat task.wait() until game:IsLoaded()

-------------------- SERVICES --------------------
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local Lighting           = game:GetService("Lighting")
local Workspace          = game:GetService("Workspace")
local StarterGui         = game:GetService("StarterGui")
local Stats              = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-------------------- NOTIFY --------------------
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "ULTRA FIX LAG",
        Text  = "FINAL BUILD • Stable Graphics Mode",
        Duration = 6
    })
end)

local hint = Instance.new("Hint")
hint.Text = "🔵 Fix Lag = ACTIVE (PREMIUM)"
hint.Parent = Workspace
task.delay(7, hint.Destroy, hint)

-------------------- SKY / FOG --------------------
for _,v in ipairs(Lighting:GetChildren()) do
    if v:IsA("Sky") then v:Destroy() end
end
Lighting.FogStart = 1e9
Lighting.FogEnd   = 1e9

-------------------- CAMERA --------------------
Camera.FieldOfView = 70

-------------------- STATE --------------------
local STATE = {
    fps   = 60,
    load  = "IDLE",
    burst = false
}

-------------------- FPS METER --------------------
local frames, last = 0, os.clock()
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

-------------------- EFFECT CACHE (ANTI DECAY) --------------------
local EffectCache = {}

local EFFECT_SCALE = {
    IDLE    = 1.0,
    LIGHT   = 0.85,
    HEAVY   = 0.65,
    EXTREME = 0.45
}

local function cacheEmitter(em)
    if not EffectCache[em] then
        EffectCache[em] = {
            Rate = em.Rate
        }
    end
end

-------------------- EFFECT OPTIMIZER --------------------
local function optimizeEffect(obj)
    if obj:IsA("ParticleEmitter") then
        local parent = obj.Parent
        if not parent or not parent:IsA("BasePart") then return end

        cacheEmitter(obj)

        local dist = distanceFromCamera(parent.Position)
        local distFactor =
            dist <= BUBBLE_RADIUS and 1 or
            dist <= 120 and 0.75 or
            0.45

        local loadFactor  = EFFECT_SCALE[STATE.load]
        local burstFactor = STATE.burst and 0.6 or 1

        obj.Rate = math.floor(
            EffectCache[obj].Rate *
            distFactor *
            loadFactor *
            burstFactor
        )

        obj.LightEmission  = 0
        obj.LightInfluence = 0

    elseif obj:IsA("Trail") or obj:IsA("Beam") then
        if STATE.burst then
            obj.Enabled = false
            task.delay(0.35, function()
                if obj then obj.Enabled = true end
            end)
        end
    elseif obj:IsA("BasePart") then
        obj.CastShadow = false
        obj.Reflectance = 0
    end
end

-------------------- INITIAL PASS --------------------
for _,obj in ipairs(Workspace:GetDescendants()) do
    optimizeEffect(obj)
end

-------------------- DYNAMIC CONTROLLER --------------------
task.spawn(function()
    while task.wait(0.5) do
        local newState = classifyLoad()
        if newState ~= STATE.load then
            STATE.load = newState
            for _,obj in ipairs(Workspace:GetDescendants()) do
                optimizeEffect(obj)
            end
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
    terrain.WaterWaveSize        = 0
    terrain.WaterWaveSpeed       = 0
    terrain.WaterReflectance     = 0
    terrain.WaterTransparency   = 1
end

-------------------- MEMORY STABILIZER --------------------
task.spawn(function()
    while task.wait(25) do
        collectgarbage("step", 200)
    end
end)

-------------------- CHARACTER SAFE --------------------
Player.CharacterAdded:Connect(function(char)
    task.wait(1)
    for _,obj in ipairs(char:GetDescendants()) do
        optimizeEffect(obj)
    end
end)

--==================== INFO MENU (ONE TIME) ====================
if not getgenv()._ULTRA_FINAL_INFO then
    getgenv()._ULTRA_FINAL_INFO = true

    local gameName = "Unknown Game"
    pcall(function()
        gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
    end)

    local gui = Instance.new("ScreenGui")
    gui.ResetOnSpawn = false
    gui.Parent = Player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.fromScale(0.36, 0.3)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -40, 0, 36)
    title.Position = UDim2.new(0, 15, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "ULTRA FIX LAG • FINAL"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Left
    title.TextColor3 = Color3.fromRGB(120,170,255)

    local close = Instance.new("TextButton", frame)
    close.Size = UDim2.fromOffset(30,30)
    close.Position = UDim2.new(1,-35,0,10)
    close.Text = "✕"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 18
    close.TextColor3 = Color3.fromRGB(255,90,90)
    close.BackgroundTransparency = 1

    local info = Instance.new("TextLabel", frame)
    info.Position = UDim2.new(0,15,0,55)
    info.Size = UDim2.new(1,-30,1,-90)
    info.BackgroundTransparency = 1
    info.TextWrapped = true
    info.TextYAlignment = Top
    info.Font = Enum.Font.Gotham
    info.TextSize = 15
    info.TextColor3 = Color3.fromRGB(235,235,240)

    local function getPing()
        local p = Stats:FindFirstChild("PerformanceStats")
        local ping = p and p:FindFirstChild("Ping")
        if ping then
            local v = tonumber(ping:GetValueString():match("%d+"))
            if v then
                return v < 80 and v.." ms (Good)"
                    or v < 150 and v.." ms (Normal)"
                    or v.." ms (High)"
            end
        end
        return "Unknown"
    end

    local timeLeft = 20
    task.spawn(function()
        while timeLeft > 0 do
            info.Text =
                "👤 Player: "..Player.Name..
                "\n🌐 Server Players: "..#Players:GetPlayers()..
                "\n📡 Ping: "..getPing()..
                "\n🎮 Game: "..gameName..
                "\n\n⏳ Auto close in "..timeLeft.."s"
            timeLeft -= 1
            task.wait(1)
        end
        gui:Destroy()
    end)

    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
end

print(">> FIX LAG PREMIUM MODE | PLAYER:", Player.Name)
