-- 📦 Servizi
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- 🧍‍♂️ Aspetta il personaggio
local function waitForCharacter()
    local char = Player.Character or Player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- 🖥️ GUI Setup
local hrp = waitForCharacter()
local gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
gui.Name = "ArbixTPGui"
gui.ResetOnSpawn = false

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
title.Text = "Arbix TP – Physics Drop"
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

-- 🚀 Platform TP con Fisica
local function platformTP_Physics(targetPos)
    -- 1. Prepara piattaforma e weld
    local platform = Instance.new("Part")
    platform.Size = Vector3.new(4, 0.2, 4)
    platform.CanCollide = false
    platform.Transparency = 1
    platform.Position = hrp.Position - Vector3.new(0, 2, 0)
    platform.Anchored = false
    platform.Name = "GhostPlatform"
    platform.Parent = workspace

    local weld = Instance.new("WeldConstraint", platform)
    weld.Part0 = platform
    weld.Part1 = hrp

    -- 2. Effetti visivi e sonori
    local trail = Instance.new("Trail", hrp)
    trail.Attachment0 = Instance.new("Attachment", hrp)
    trail.Attachment1 = Instance.new("Attachment", hrp)
    trail.Lifetime = 0.5
    trail.Color = ColorSequence.new(Color3.fromRGB(0,255,255), Color3.fromRGB(255,0,255))

    local sound = Instance.new("Sound", hrp)
    sound.SoundId = "rbxassetid://911882310"
    sound.Volume = 1
    sound:Play()

    -- 3. Calcola velocità fisica
    local startPos = platform.Position
    local distance = (targetPos - startPos).Magnitude
    local totalTime = math.clamp(distance / 50, 0.5, 5)  -- velocità ~50 stud/sec

    platform.AssemblyLinearVelocity = (targetPos - startPos) / totalTime

    -- 4. Attendi arrivo e pulisci
    task.wait(totalTime + 0.1)
    weld:Destroy()
    platform:Destroy()
    trail:Destroy()
    sound:Destroy()
end

-- 🧠 TP finale sicuro
local function tpToDeliverySafe()
    local target = getDeliveryPosition()
    if target then
        platformTP_Physics(target)
    else
        warn("DeliveryHitbox not found")
    end
end

-- 🎯 Bottone GUI
tpButton.MouseButton1Click:Connect(tpToDeliverySafe)
