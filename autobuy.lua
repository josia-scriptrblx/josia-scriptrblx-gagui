-- Grow a Garden: Auto-Buy GUI (Seeds + Gear)
-- Includes fast buy, multiple select, resizable/minimizable GUI, Grow a Garden styling
-- Made by @Dimension_GD :)

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

print("[AutoBuyGUI] Services loaded.")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
print("[AutoBuyGUI] PlayerGui found.")

local buySeedRemote = ReplicatedStorage.GameEvents.BuySeedStock
local buyGearRemote = ReplicatedStorage.GameEvents.BuyGearStock
print("[AutoBuyGUI] Remotes located.")

-- Item Lists
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

print("[AutoBuyGUI] Item lists initialized.")

-- GUI Setup
local gui = Instance.new("ScreenGui", playerGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 260)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Tabs
local tabs = { "Seeds", "Gear" }
local activeTab = "Seeds"
local tabButtons = {}
local contentFrames = {}
local selectedItems = { Seeds = {}, Gear = {} }

local tabHolder = Instance.new("Frame", frame)
tabHolder.Size = UDim2.new(1, -20, 0, 30)
tabHolder.Position = UDim2.new(0, 10, 0, 40)
tabHolder.BackgroundTransparency = 1

for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabHolder)
    btn.Size = UDim2.new(0, 80, 0, 25)
    btn.Position = UDim2.new(0, (i - 1) * 90, 0, 0)
    btn.Text = tab
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16

    local scroll = Instance.new("ScrollingFrame", frame)
    scroll.Name = tab .. "Content"
    scroll.Size = UDim2.new(1, -20, 1, -130)
    scroll.Position = UDim2.new(0, 10, 0, 80)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 6
    scroll.Visible = (tab == activeTab)
    contentFrames[tab] = scroll

    local list = (tab == "Seeds") and seeds or gearItems
    local y = 0
    for _, item in ipairs(list) do
        local check = Instance.new("TextButton", scroll)
        check.Size = UDim2.new(1, -10, 0, 20)
        check.Position = UDim2.new(0, 0, 0, y)
        check.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        check.TextColor3 = Color3.new(1, 1, 1)
        check.TextSize = 14
        check.Font = Enum.Font.SourceSans
        check.Text = "[ ] " .. item
        y = y + 24

        check.MouseButton1Click:Connect(function()
            local selected = selectedItems[tab][item]
            selectedItems[tab][item] = not selected
            check.Text = (not selected and "[✔] " or "[ ] ") .. item
        end)
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, y)

    btn.MouseButton1Click:Connect(function()
        activeTab = tab
        for t, f in pairs(contentFrames) do
            f.Visible = (t == tab)
        end
    end)
end

-- AutoBuy Toggle
local autoBuyToggle = Instance.new("TextButton", frame)
autoBuyToggle.Size = UDim2.new(0, 120, 0, 25)
autoBuyToggle.Position = UDim2.new(0, 10, 1, -55)
autoBuyToggle.Text = "[ OFF ] Auto Buy"
autoBuyToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
autoBuyToggle.TextColor3 = Color3.new(1, 1, 1)
autoBuyToggle.Font = Enum.Font.SourceSansBold
autoBuyToggle.TextSize = 14

local autoBuying = false
autoBuyToggle.MouseButton1Click:Connect(function()
    autoBuying = not autoBuying
    autoBuyToggle.Text = (autoBuying and "[ ON  ]" or "[ OFF ]") .. " Auto Buy"
end)

-- Buy loop
RunService.Heartbeat:Connect(function()
    if autoBuying then
        for item, sel in pairs(selectedItems.Seeds) do
            if sel then buySeedRemote:FireServer(item) end
        end
        for item, sel in pairs(selectedItems.Gear) do
            if sel then buyGearRemote:FireServer(item) end
        end
    end
end)

-- Icon
local icon = Instance.new("TextLabel", frame)
icon.Size = UDim2.new(0, 20, 0, 20)
icon.Position = UDim2.new(0, 10, 0, 10)
icon.Text = "🌱"
icon.TextColor3 = Color3.new(1, 1, 1)
icon.Font = Enum.Font.SourceSansBold
icon.TextSize = 20
icon.BackgroundTransparency = 1

-- Credit
local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1, -20, 0, 20)
credit.Position = UDim2.new(0, 10, 1, -20)
credit.BackgroundTransparency = 1
credit.Text = "Made by @Dimension_GD :)"
credit.TextColor3 = Color3.fromRGB(120, 255, 120)
credit.Font = Enum.Font.SourceSansItalic
credit.TextSize = 14
credit.TextXAlignment = Enum.TextXAlignment.Right

print("[AutoBuyGUI] Ready with tabs, checkboxes, and auto-buy!")
