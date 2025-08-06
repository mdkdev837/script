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
frame.Size = UDim2.new(0, 280, 0, 180)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Arbix TP – Physics Drop + Micro TP"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1

-- Bottone TP Delivery
local tpButton = Instance.new("TextButton", frame)
tpButton.Size = UDim2.new(0.8, 0, 0, 40)
tpButton.Position = UDim2.new(0.1, 0, 0.45, 0)
tpButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpButton.Font = Enum.Font.GothamSemibold
tpButton.TextSize = 16
tpButton.Text = "TP to Delivery"
Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 8)

-- Bottone Micro TP Jitter
local jitterButton = Instance.new("TextButton", frame)
jitterButton.Size = UDim2.new(0.8, 0, 0, 40)
jitterButton.Position = UDim2.new(0.1, 0, 0.75, 0)
jitterButton.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
jitterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
jitterButton.Font = Enum.Font.GothamSemibold
jitterButton.TextSize = 16
jitterButton.Text = "Micro TP Jitter"
Instance.new("UICorner", jitterButton).CornerRadius = UDim.new(0, 8)

-- Trova DeliveryHitbox
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

-- Physics TP
local function platformTP_Physics(targetPos)
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

    local trail = Instance.new("Trail", hrp)
    trail.Attachment0 = Instance.new("Attachment", hrp)
    trail.Attachment1 = Instance.new("Attachment", hrp)
    trail.Lifetime = 0.5
    trail.Color = ColorSequence.new(Color3.fromRGB(0,255,255), Color3.fromRGB(255,0,255))

    local sound = Instance.new("Sound", hrp)
    sound.SoundId = "rbxassetid://911882310"
    sound.Volume = 1
    sound:Play()

    local startPos = platform.Position
    local distance = (targetPos - startPos).Magnitude
    local totalTime = math.clamp(distance / 50, 0.5, 5)

    platform.AssemblyLinearVelocity = (targetPos - startPos) / totalTime

    task.wait(totalTime + 0.1)
    weld:Destroy()
    platform:Destroy()
    trail:Destroy()
    sound:Destroy()
end

-- TP sicuro
local function tpToDeliverySafe()
    local target = getDeliveryPosition()
    if target then
        platformTP_Physics(target)
    else
        warn("DeliveryHitbox not found")
    end
end

-- Micro TP jitterato
local function microJitterStep()
    local camera = workspace.CurrentCamera
    local forward = camera.CFrame.LookVector.Unit * 2.3
    local jitter = Vector3.new(
        math.random(-1,1)*0.2,
        0,
        math.random(-1,1)*0.2
    )
    hrp.CFrame = hrp.CFrame + forward + jitter
end

-- Bottone GUI
tpButton.MouseButton1Click:Connect(tpToDeliverySafe)
jitterButton.MouseButton1Click:Connect(microJitterStep)
