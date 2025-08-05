local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local function waitForCharacter()
    local char = Player.Character or Player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local hrp = waitForCharacter()

-- GUI Setup
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
title.Text = "Arbix TP - Safe Mode"
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

-- 🌀 Micro-Teleport trapassante
local function microTeleport(targetPos)
    local start = hrp.Position
    local steps = 60

    for i = 1, steps do
        local alpha = i / steps
        local pos = start:Lerp(targetPos, alpha)
        pos += Vector3.new(
            math.random(-1, 1) * 0.0003,
            math.random(-1, 1) * 0.0003,
            math.random(-1, 1) * 0.0003
        )
        hrp.CFrame = CFrame.new(pos)
        task.wait(math.random(5, 10) / 1000)
    end
end

-- 🎯 Trova la tua DeliveryHitbox
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

-- 🧠 TP finale
local function tpToDeliverySafe()
    local target = getDeliveryPosition()
    if target then
        microTeleport(target)
    else
        warn("DeliveryHitbox not found")
    end
end

tpButton.MouseButton1Click:Connect(tpToDeliverySafe)
