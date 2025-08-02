local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local buySeedRemote = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock")

local seeds = {
    "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato",
    "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus",
    "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk",
    "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone", "Elder Strawberry"
}

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "SeedBuyGUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 350)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 10)

local resizer = Instance.new("Frame", frame)
resizer.Size = UDim2.new(0, 20, 0, 20)
resizer.Position = UDim2.new(1, -20, 1, -20)
resizer.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
resizer.BorderSizePixel = 0
Instance.new("UICorner", resizer).CornerRadius = UDim.new(1, 0)
resizer.Name = "Resizer"
resizer.Active = true

-- Resizing logic
resizer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local startSize = frame.Size
        local startPos = input.Position

        local conn
        conn = UserInputService.InputChanged:Connect(function(moveInput)
            if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = moveInput.Position - startPos
                frame.Size = UDim2.new(0, math.max(200, startSize.X.Offset + delta.X), 0, math.max(200, startSize.Y.Offset + delta.Y))
            end
        end)

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                conn:Disconnect()
            end
        end)
    end
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -70, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Auto-Buy Seeds"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.TextSize = 20
title.Font = Enum.Font.SourceSansBold
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -20, 1, -110)
scroll.Position = UDim2.new(0, 10, 0, 40)
scroll.CanvasSize = UDim2.new(0, 0, 0, #seeds * 30)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 0.1
scroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)

local selectedSeeds = {}

local function createCheckbox(seedName)
    local holder = Instance.new("Frame", scroll)
    holder.Size = UDim2.new(1, -5, 0, 25)
    holder.BackgroundTransparency = 1

    local box = Instance.new("TextButton", holder)
    box.Size = UDim2.new(0, 25, 1, 0)
    box.Text = ""
    box.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    local bcorner = Instance.new("UICorner", box)
    bcorner.CornerRadius = UDim.new(0, 4)

    local label = Instance.new("TextLabel", holder)
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Position = UDim2.new(0, 30, 0, 0)
    label.Text = seedName
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local checked = false
    box.MouseButton1Click:Connect(function()
        checked = not checked
        box.Text = checked and "✔" or ""
        if checked then
            selectedSeeds[seedName] = true
        else
            selectedSeeds[seedName] = nil
        end
    end)
end

for _, seed in ipairs(seeds) do
    createCheckbox(seed)
end

local buyBtn = Instance.new("TextButton", frame)
buyBtn.Size = UDim2.new(1, -20, 0, 40)
buyBtn.Position = UDim2.new(0, 10, 1, -60)
buyBtn.Text = "Start Auto-Buy Selected"
buyBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
buyBtn.TextColor3 = Color3.new(1, 1, 1)
buyBtn.Font = Enum.Font.SourceSansBold
buyBtn.TextSize = 18
Instance.new("UICorner", buyBtn).CornerRadius = UDim.new(0, 8)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.new(0, 10, 1, -20)
status.Text = "Idle"
status.TextColor3 = Color3.new(1, 1, 1)
status.TextSize = 14
status.Font = Enum.Font.SourceSansItalic
status.BackgroundTransparency = 1
status.TextXAlignment = Enum.TextXAlignment.Left

-- Auto-buy logic
local running = false

local function autoBuy()
    while running do
        for seedName, _ in pairs(selectedSeeds) do
            pcall(function()
                buySeedRemote:FireServer(seedName)
            end)
            wait(0.01) -- fast buy
        end
        wait(0.03)
    end
end

buyBtn.MouseButton1Click:Connect(function()
    if not running then
        running = true
        buyBtn.Text = "Stop Auto-Buy"
        status.Text = "Auto-buying..."
        coroutine.wrap(autoBuy)()
    else
        running = false
        buyBtn.Text = "Start Auto-Buy Selected"
        status.Text = "Idle"
    end
end)
