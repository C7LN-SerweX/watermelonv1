-- WATERMELON v1 - Murder Mystery 2 Script
-- Features: ESP, Kill Aura, Teleport, Fly
-- UI: Rayfield with Neon Pink & Neon Cyan Background
-- loadstring(game:HttpGet('https://raw.githubusercontent.com/C7LN-SerweX/watermelonv1/main/main.lua', true))()
-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Create custom theme with neon pink & cyan
local CustomTheme = {
    Background = Color3.fromRGB(255, 20, 147), -- Deep Pink base
    BackgroundAlt = Color3.fromRGB(0, 255, 255), -- Cyan accent
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(255, 105, 180), -- Hot Pink
    AccentAlt = Color3.fromRGB(0, 206, 209), -- Dark Cyan
    Border = Color3.fromRGB(255, 20, 147),
    Error = Color3.fromRGB(255, 69, 0)
}

-- Apply custom theme to Rayfield
Rayfield:ApplyTheme(CustomTheme)

-- Create Window with custom name
local Window = Rayfield:CreateWindow({
    Name = "WATERMELON v1",
    Icon = 0,
    LoadingTitle = "Loading WATERMELON v1...",
    LoadingSubtitle = "Neon Edition",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "WATERMELON",
        FileName = "Settings"
    }
})

-- Create neon gradient background effect
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WATERMELON_GUI"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Neon Pink Background Frame
local pinkBg = Instance.new("Frame")
pinkBg.Size = UDim2.new(1, 0, 1, 0)
pinkBg.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
pinkBg.BackgroundTransparency = 0.85
pinkBg.Parent = screenGui

-- Neon Cyan Gradient Overlay
local cyanGradient = Instance.new("Frame")
cyanGradient.Size = UDim2.new(1, 0, 0.5, 0)
cyanGradient.Position = UDim2.new(0, 0, 0.5, 0)
cyanGradient.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
cyanGradient.BackgroundTransparency = 0.7
cyanGradient.Parent = screenGui

-- Animated neon glow effect (pulses between pink and cyan)
local glowEffect = Instance.new("ImageLabel")
glowEffect.Size = UDim2.new(1, 0, 1, 0)
glowEffect.BackgroundTransparency = 1
glowEffect.Image = "rbxassetid://5028857082" -- Round glow texture
glowEffect.ImageColor3 = Color3.fromRGB(255, 20, 147)
glowEffect.ImageTransparency = 0.6
glowEffect.Parent = screenGui

-- Animation for color cycling
local colorCycle = 0
game:GetService("RunService").RenderStepped:Connect(function()
    colorCycle = colorCycle + 0.01
    -- Smooth transition between pink and cyan
    local t = (math.sin(colorCycle) + 1) / 2
    local r = 255 * (1 - t) + 0 * t
    local g = 20 * (1 - t) + 255 * t
    local b = 147 * (1 - t) + 255 * t
    glowEffect.ImageColor3 = Color3.fromRGB(r, g, b)
end)

-- Main Tab (Neon styled)
local MainTab = Window:CreateTab("🔪 MAIN", 0)

-- ESP Section with custom styling
local ESPEnabled = false
local ESPColor = Color3.fromRGB(255, 20, 147) -- Neon Pink for ESP

local ESPToggle = MainTab:CreateToggle({
    Name = "✨ ESP (Neon Vision)",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        ESPEnabled = Value
        if ESPEnabled then
            for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
                if plr ~= game:GetService("Players").LocalPlayer then
                    createESP(plr)
                end
            end
        else
            for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
                if plr.Character then
                    for _, v in pairs(plr.Character:GetChildren()) do
                        if v:IsA("Highlight") or v:IsA("BillboardGui") then
                            v:Destroy()
                        end
                    end
                end
            end
        end
    end
})

local ESPColorPicker = MainTab:CreateColorPicker({
    Name = "🎨 ESP Color",
    Color = Color3.fromRGB(255, 20, 147),
    Flag = "ESPColor",
    Callback = function(Color)
        ESPColor = Color
        if ESPEnabled then
            for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
                if plr ~= game:GetService("Players").LocalPlayer and plr.Character then
                    local highlight = plr.Character:FindFirstChildWhichIsA("Highlight")
                    if highlight then
                        highlight.FillColor = ESPColor
                    end
                end
            end
        end
    end
})

-- Kill Aura Section
local KillAuraEnabled = false
local KillAuraRange = 30
local KillAuraDelay = 0.1

local KillAuraToggle = MainTab:CreateToggle({
    Name = "💀 Kill Aura (Neon Death)",
    CurrentValue = false,
    Flag = "KillAura",
    Callback = function(Value)
        KillAuraEnabled = Value
        if KillAuraEnabled then
            coroutine.wrap(function()
                while KillAuraEnabled and task.wait() do
                    killAuraLoop()
                end
            end)()
        end
    end
})

local RangeSlider = MainTab:CreateSlider({
    Name = "📏 Kill Aura Range",
    Range = {10, 100},
    Increment = 5,
    CurrentValue = 30,
    Flag = "Range",
    Callback = function(Value)
        KillAuraRange = Value
    end
})

local DelaySlider = MainTab:CreateSlider({
    Name = "⏱️ Kill Aura Delay",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = 0.1,
    Flag = "Delay",
    Callback = function(Value)
        KillAuraDelay = Value
    end
})

-- Teleport Tab
local TeleportTab = Window:CreateTab("🌀 TELEPORT", 1)

local TeleportToMurderer = TeleportTab:CreateButton({
    Name = "🔪 Teleport to Murderer",
    Callback = function()
        for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
            if plr ~= game:GetService("Players").LocalPlayer then
                if plr.Character and plr.Character:FindFirstChild("Knife") then
                    teleportTo(plr.Character.HumanoidRootPart.Position)
                    break
                end
            end
        end
    end
})

local TeleportToSheriff = TeleportTab:CreateButton({
    Name = "🔫 Teleport to Sheriff",
    Callback = function()
        for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
            if plr ~= game:GetService("Players").LocalPlayer then
                if plr.Character and plr.Character:FindFirstChild("Gun") then
                    teleportTo(plr.Character.HumanoidRootPart.Position)
                    break
                end
            end
        end
    end
})

local TeleportToHero = TeleportTab:CreateButton({
    Name = "🦸 Teleport to Hero",
    Callback = function()
        for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
            if plr ~= game:GetService("Players").LocalPlayer then
                if plr.Character and plr.Character:FindFirstChild("Hero") then
                    teleportTo(plr.Character.HumanoidRootPart.Position)
                    break
                end
            end
        end
    end
})

-- Movement Tab (Fly)
local FlyTab = Window:CreateTab("🕊️ MOVEMENT", 2)

local Flying = false
local FlySpeed = 50

local FlyToggle = FlyTab:CreateToggle({
    Name = "🌈 Neon Flight",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        if Value then
            startFly()
        else
            stopFly()
        end
    end
})

local FlySpeedSlider = FlyTab:CreateSlider({
    Name = "💨 Flight Speed",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        FlySpeed = Value
    end
})

-- ESP Functions
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function createESP(plr)
    if plr == LocalPlayer then return end
    local character = plr.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.FillColor = ESPColor
    highlight.OutlineColor = Color3.fromRGB(0, 255, 255) -- Neon cyan outline
    highlight.Adornee = character
    highlight.Parent = character
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = character
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "💖 " .. plr.Name .. " 💙"
    textLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
    textLabel.TextStrokeTransparency = 0.3
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 255, 255)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 14
    textLabel.Parent = billboard
end

-- Kill Aura Loop
local function killAuraLoop()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
            local distance = (plr.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance <= KillAuraRange then
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("KnifeHit")
                if remote then
                    remote:FireServer(plr.Character)
                end
                task.wait(KillAuraDelay)
            end
        end
    end
end

-- Teleport Function
local function teleportTo(position)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- Fly Functions
local bodyVelocity = nil
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local function startFly()
    if not LocalPlayer.Character then return end
    local char = LocalPlayer.Character
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Parent = char.HumanoidRootPart
    
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.Parent = char.HumanoidRootPart
    
    Flying = true
    
    local flyConnection
    flyConnection = RunService.RenderStepped:Connect(function()
        if not Flying or not LocalPlayer.Character then
            flyConnection:Disconnect()
            return
        end
        local moveDirection = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Vector3.new(0, 0, -FlySpeed) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection + Vector3.new(0, 0, FlySpeed) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection + Vector3.new(-FlySpeed, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Vector3.new(FlySpeed, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, FlySpeed, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection + Vector3.new(0, -FlySpeed, 0) end
        
        local cameraCFrame = workspace.CurrentCamera.CFrame
        bodyVelocity.Velocity = cameraCFrame:VectorToWorldSpace(moveDirection)
        bg.CFrame = cameraCFrame
    end)
end

local function stopFly()
    Flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        for _, v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                v:Destroy()
            end
        end
    end
end

-- Auto-update ESP
Players.PlayerAdded:Connect(function(plr)
    if ESPEnabled then
        plr.CharacterAdded:Connect(function()
            task.wait(1)
            createESP(plr)
        end)
    end
end)

-- Initial ESP setup
for _, plr in pairs(Players:GetPlayers()) do
    if ESPEnabled and plr ~= LocalPlayer then
        createESP(plr)
    end
end

-- Watermelon splash notification
Rayfield:Notify({
    Title = "🍉 WATERMELON v1",
    Content = "Neon Edition Loaded! 💖💙",
    Duration = 3
})

print("🍉 WATERMELON v1 - Neon Pink & Cyan Edition Loaded!")
