-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = game.Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- Variables
local aimbotEnabled = false
local highlightEnabled = false
local hitboxEnabled = false
local menuVisible = true

-- Create a GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AimbotMenu"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.BorderSizePixel = 0
Frame.Visible = menuVisible

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Frame)
Title.Text = "Aimbot Menu"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold

local ToggleAimbot = Instance.new("TextButton", Frame)
ToggleAimbot.Text = "Aimbot: OFF"
ToggleAimbot.Size = UDim2.new(1, -20, 0, 40)
ToggleAimbot.Position = UDim2.new(0, 10, 0, 50)
ToggleAimbot.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
ToggleAimbot.TextColor3 = Color3.new(1, 1, 1)
ToggleAimbot.Font = Enum.Font.Gotham
ToggleAimbot.TextScaled = true

local ToggleHighlight = Instance.new("TextButton", Frame)
ToggleHighlight.Text = "Highlights: OFF"
ToggleHighlight.Size = UDim2.new(1, -20, 0, 40)
ToggleHighlight.Position = UDim2.new(0, 10, 0, 100)
ToggleHighlight.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
ToggleHighlight.TextColor3 = Color3.new(1, 1, 1)
ToggleHighlight.Font = Enum.Font.Gotham
ToggleHighlight.TextScaled = true

local ToggleHitbox = Instance.new("TextButton", Frame)
ToggleHitbox.Text = "Hitbox: OFF"
ToggleHitbox.Size = UDim2.new(1, -20, 0, 40)
ToggleHitbox.Position = UDim2.new(0, 10, 0, 150)
ToggleHitbox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
ToggleHitbox.TextColor3 = Color3.new(1, 1, 1)
ToggleHitbox.Font = Enum.Font.Gotham
ToggleHitbox.TextScaled = true

local MinimizeButton = Instance.new("TextButton", ScreenGui)
MinimizeButton.Text = "-"
MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
MinimizeButton.Position = Frame.Position + UDim2.new(0, 260, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.Font = Enum.Font.Gotham
MinimizeButton.TextScaled = true

-- Functions
local function getClosestEnemy()
    local closestPlayer, closestDistance = nil, math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local distance = (Camera.CFrame.Position - player.Character.Head.Position).Magnitude
            if distance < closestDistance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end

    return closestPlayer
end

local function aimbot()
    RunService.RenderStepped:Connect(function()
        if aimbotEnabled then
            local target = getClosestEnemy()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            end
        end
    end)
end

local function highlightPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and not player.Character:FindFirstChildOfClass("Highlight") then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = player.Character
            highlight.FillColor = Color3.new(1, 1, 0)
            highlight.OutlineColor = Color3.new(1, 0, 0)
            highlight.Parent = player.Character
        end
    end
end

local function expandHitboxes()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Size = Vector3.new(5, 5, 5)
            player.Character.HumanoidRootPart.Transparency = 0.5
        end
    end
end

-- Button Actions
ToggleAimbot.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    ToggleAimbot.Text = aimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
end)

ToggleHighlight.MouseButton1Click:Connect(function()
    highlightEnabled = not highlightEnabled
    ToggleHighlight.Text = highlightEnabled and "Highlights: ON" or "Highlights: OFF"
    if highlightEnabled then
        highlightPlayers()
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChildOfClass("Highlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end)

ToggleHitbox.MouseButton1Click:Connect(function()
    hitboxEnabled = not hitboxEnabled
    ToggleHitbox.Text = hitboxEnabled and "Hitbox: ON" or "Hitbox: OFF"
    if hitboxEnabled then
        expandHitboxes()
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                player.Character.HumanoidRootPart.Transparency = 0
            end
        end
    end
end)

MinimizeButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    Frame.Visible = menuVisible
    MinimizeButton.Text = menuVisible and "-" or "+"
end)

-- Start Aimbot
aimbot()