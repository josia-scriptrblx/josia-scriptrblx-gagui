-- Grow a Garden: Auto-Buy GUI (Seeds + Gear)
-- Includes fast buy, multiple select, resizable/minimizable GUI, Grow a Garden styling

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local buySeedRemote = ReplicatedStorage.GameEvents.BuySeedStock
local buyGearRemote = ReplicatedStorage.GameEvents.BuyGearStock

-- Seed and Gear Lists
local seeds = {
    "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Daffodil", "Watermelon",
    "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape",
    "Mushroom", "Pepper", "Cacao", "Beanstalk", "Ember Lily", "Sugar Apple", "Burning Bud",
    "Giant Pinecone", "Elder Strawberry"
}

local gearItems = {
    "Watering Can", "Trading Ticket", "Trowel", "Recall Wrench", "Basic Sprinkler",
    "Advanced Sprinkler", "Godly Sprinkler", "Master Sprinkler", "Grandmaster Sprinkler",
    "Medium Toy", "Medium Treat", "Levelup Lollipop", "Magnifying Glass",
    "Cleaning Spray", "Favorite Tool", "Harvest Tool"
}

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AutoBuyGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 260)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Resize Icon
local resizeCorner = Instance.new("Frame")
resizeCorner.Size = UDim2.new(0, 20, 0, 20)
resizeCorner.Position = UDim2.new(1, -20, 1, -20)
resizeCorner.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
resizeCorner.BorderSizePixel = 0
resizeCorner.Parent = frame
Instance.new("UICorner", resizeCorner).CornerRadius = UDim.new(0, 4)

local resizing = false
resizeCorner.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
    end
end)

resizeCorner.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = input.Position
        local newX = math.clamp(mousePos.X - frame.AbsolutePosition.X, 200, 600)
        local newY = math.clamp(mousePos.Y - frame.AbsolutePosition.Y, 200, 600)
        frame.Size = UDim2.new(0, newX, 0, newY)
    end
end)

-- Minimize Icon
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -60, 0, 5)
minimizeBtn.Text = "_"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 18
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 5)
minimizeBtn.Parent = frame

local minimized = false

-- Declare closeBtn early to avoid reference error
local closeBtn

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, child in pairs(frame:GetChildren()) do
        if child ~= minimizeBtn and child ~= closeBtn and child ~= resizeCorner and child:IsA("GuiObject") then
            child.Visible = not minimized
        end
    end
    frame.Size = minimized and UDim2.new(0, 160, 0, 40) or UDim2.new(0, 320, 0, 260)
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Auto-Buy Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Close Button
closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Create ScrollingFrame container
local scrollContainer = Instance.new("Frame")
scrollContainer.Size = UDim2.new(1, -20, 1, -110)
scrollContainer.Position = UDim2.new(0, 10, 0, 40)
scrollContainer.BackgroundTransparency = 1
scrollContainer.Parent = frame

local seedScroll = Instance.new("ScrollingFrame")
seedScroll.Size = UDim2.new(0.5, -5, 1, 0)
seedScroll.Position = UDim2.new(0, 0, 0, 0)
seedScroll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
seedScroll.BorderSizePixel = 0
seedScroll.ScrollBarThickness = 4
seedScroll.CanvasSize = UDim2.new(0, 0, 0, #seeds * 30)
seedScroll.Parent = scrollContainer

local gearScroll = Instance.new("ScrollingFrame")
gearScroll.Size = UDim2.new(0.5, -5, 1, 0)
gearScroll.Position = UDim2.new(0.5, 10, 0, 0)
gearScroll.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
gearScroll.BorderSizePixel = 0
gearScroll.ScrollBarThickness = 4
gearScroll.CanvasSize = UDim2.new(0, 0, 0, #gearItems * 30)
gearScroll.Parent = scrollContainer

local seedLayout = Instance.new("UIListLayout")
seedLayout.Padding = UDim.new(0, 5)
seedLayout.Parent = seedScroll

local gearLayout = Instance.new("UIListLayout")
gearLayout.Padding = UDim.new(0, 5)
gearLayout.Parent = gearScroll

local selectedSeeds = {}
local selectedGear = {}

local function createCheckItem(parent, nameTable, label, selectionTable)
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, -10, 0, 25)
    item.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    item.TextColor3 = Color3.new(1, 1, 1)
    item.Font = Enum.Font.SourceSans
    item.TextSize = 18
    item.Text = label
    item.Parent = parent

    local box = Instance.new("TextLabel")
    box.Size = UDim2.new(0, 20, 0, 20)
    box.Position = UDim2.new(1, -25, 0, 2)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Text = "☐"
    box.Font = Enum.Font.SourceSansBold
    box.TextSize = 18
    box.Parent = item

    local checked = false
    local function update()
        checked = not checked
        box.Text = checked and "☑" or "☐"
        selectionTable[label] = checked or nil
    end

    item.MouseButton1Click:Connect(update)
end

for _, seed in ipairs(seeds) do
    createCheckItem(seedScroll, seeds, seed, selectedSeeds)
end

for _, gear in ipairs(gearItems) do
    createCheckItem(gearScroll, gearItems, gear, selectedGear)
end

-- Auto-buy toggle
local autoBuy = false
local autoBuyBtn = Instance.new("TextButton")
autoBuyBtn.Size = UDim2.new(0, 120, 0, 30)
autoBuyBtn.Position = UDim2.new(0, 10, 1, -40)
autoBuyBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 60)
autoBuyBtn.TextColor3 = Color3.new(1, 1, 1)
autoBuyBtn.Font = Enum.Font.SourceSansBold
autoBuyBtn.TextSize = 18
autoBuyBtn.Text = "Auto-Buy: OFF"
autoBuyBtn.Parent = frame

autoBuyBtn.MouseButton1Click:Connect(function()
    autoBuy = not autoBuy
    autoBuyBtn.Text = autoBuy and "Auto-Buy: ON" or "Auto-Buy: OFF"
    if autoBuy then
        spawn(function()
            while autoBuy do
                for seed, _ in pairs(selectedSeeds) do
                    pcall(function()
                        buySeedRemote:FireServer(seed)
                    end)
                end
                for gear, _ in pairs(selectedGear) do
                    pcall(function()
                        buyGearRemote:FireServer(gear)
                    end)
                end
                wait(0.35)
            end
        end)
    end
end)
