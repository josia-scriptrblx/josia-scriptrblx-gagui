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

-- [Scroll section + logic continues as before... no changes needed below]

-- (Retain seed/gear lists, auto-buy logic, and buttons below unchanged)
-- The minimize and resize additions are now included above.
