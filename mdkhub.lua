-- 📦 Servizi
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- 🧍‍♂️ Aspetta il personaggio
local function waitForCharacter()
    local char = Player.Character or Player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local hrp = waitForCharacter()

-- 🖥️ GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "ArbixTPGui"
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 150)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Arbix TP - Platform Drop"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1

local tpButton = Instance.new("TextButton", frame)
tpButton.Size = UDim2.new(0.8, 0, 0, 40)
tpButton.Position = UDim2.new(0.1, 0, 0.5, 0)
tpButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpButton.Font = Enum.Font.GothamSemibold
tpButton.TextSize = 16
tpButton.Text = "TP to Delivery"
Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 8)

-- 🚀 Platform TP Invisibile con Segmenti
local function platformTP(targetPos)
    local hrp = waitForCharacter()

    -- Piattaforma invisibile
    local platform = Instance.new("Part")
    platform.Size = Vector3.new(4, 0.2, 4)
    platform.Anchored = true
    platform.CanCollide = false
    platform.Transparency = 1
    platform.Position = hrp.Position - Vector3.new(0, 2, 0)
    platform.Name = "GhostPlatform"
    platform.Parent = workspace

    -- Scia magica
    local trail = Instance.new("Trail")
    trail.Attachment0 = Instance.new("Attachment", hrp)
    trail.Attachment1 = Instance.new("Attachment", hrp)
    trail.Lifetime = 0.5
    trail.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 0, 255))
    trail.Enabled = true
    trail.Parent = hrp

    -- Suono
    local sound = Instance.new("Sound", hrp)
    sound.SoundId = "rbxassetid://911882310"
    sound.Volume = 1
    sound:Play()

    -- Segmentazione automatica
    local startPos = platform.Position
    local distance = (targetPos - startPos).Magnitude
    local maxStep = 10
    local steps = math.ceil(distance / maxStep)

    for i = 1, steps do
        local alpha = i / steps
        local nextPos = startPos:Lerp(targetPos - Vector3.new(0, 2, 0), alpha)
        platform.Position = nextPos
        hrp.CFrame = CFrame.new(nextPos + Vector3.new(0, 2.5, 0))
        task.wait(0.03)
    end

    hrp.CFrame = CFrame.new(targetPos)

    -- Cleanup
    platform:Destroy()
    trail:Destroy()
    sound:Destroy()
end

-- 📦 Trova la DeliveryHitbox
local function getDeliveryPosition()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end

    for _, plot in pairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if sign and sign:FindFirstChild("YourBase") and sign.YourBase.Enabled then
            local hitbox = plot:FindFirstChild("DeliveryHitbox")
            if hitbox then
                return hitbox.Position + Vector3.new(0, 2, 0)
            end
        end
    end
end

-- 🧠 TP finale sicuro
local function tpToDeliverySafe()
    local target = getDeliveryPosition()
    if target then
        platformTP(target)
    else
        warn("DeliveryHitbox not found")
    end
end

-- 🎯 Bottone GUI
tpButton.MouseButton1Click:Connect(tpToDeliverySafe)
