-- Grow a Garden: Auto-Buy GUI (Seeds + Gear)
-- Includes fast buy, multiple select, resizable/minimizable GUI, Grow a Garden styling
-- Made by @Dimension_GD :)

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

print("[AutoBuyGUI] Services loaded.")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
print("[AutoBuyGUI] PlayerGui found.")

local buySeedRemote = ReplicatedStorage.GameEvents.BuySeedStock
local buyGearRemote = ReplicatedStorage.GameEvents.BuyGearStock
print("[AutoBuyGUI] Remotes located.")

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

print("[AutoBuyGUI] Seed and gear lists initialized.")

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AutoBuyGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui
print("[AutoBuyGUI] ScreenGui created and parented.")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 260)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
print("[AutoBuyGUI] Main frame initialized.")

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame
print("[AutoBuyGUI] Frame corners rounded.")

-- Tabs UI
local tabHolder = Instance.new("Frame")
tabHolder.Size = UDim2.new(1, -20, 0, 30)
tabHolder.Position = UDim2.new(0, 10, 0, 40)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = frame

local tabs = { "Seeds", "Gear" }
local activeTab = "Seeds"
local tabButtons = {}

for i, name in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 80, 0, 25)
    tabBtn.Position = UDim2.new(0, (i - 1) * 90, 0, 0)
    tabBtn.Text = name
    tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 16
    tabBtn.Parent = tabHolder
    tabButtons[name] = tabBtn

    tabBtn.MouseButton1Click:Connect(function()
        activeTab = name
        print("[AutoBuyGUI] Switched to tab:", name)
        -- Add tab switching logic when needed
    end)
end

-- Icons (Placeholder labels for now)
local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, 20, 0, 20)
icon.Position = UDim2.new(0, 10, 0, 10)
icon.Text = "🌱"
icon.TextColor3 = Color3.new(1, 1, 1)
icon.Font = Enum.Font.SourceSansBold
icon.TextSize = 20
icon.BackgroundTransparency = 1
icon.Parent = frame

-- Credit Label
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, -20, 0, 20)
credit.Position = UDim2.new(0, 10, 1, -20)
credit.BackgroundTransparency = 1
credit.Text = "Made by @Dimension_GD :)"
credit.TextColor3 = Color3.fromRGB(120, 255, 120)
credit.Font = Enum.Font.SourceSansItalic
credit.TextSize = 14
credit.TextXAlignment = Enum.TextXAlignment.Right
credit.Parent = frame
print("[AutoBuyGUI] Credit label added.")

print("[AutoBuyGUI] Tabs and icons added.")

-- Add more menus/structure later as needed...

-- Keep existing UI below...
print("[AutoBuyGUI] Initialization complete.")
