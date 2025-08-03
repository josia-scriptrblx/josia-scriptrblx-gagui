-- Grow a Garden: Auto-Buy GUI (Seeds + Gear)
-- Includes fast buy, multiple select, resizable/minimizable GUI, Grow a Garden styling
-- Made by @Dimension_GD :)

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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

-- Buy All Button
local buyAllBtn = Instance.new("TextButton", frame)
buyAllBtn.Size = UDim2.new(0, 120, 0, 25)
buyAllBtn.Position = UDim2.new(0, 150, 1, -55)
buyAllBtn.Text = "Buy All Selected"
buyAllBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
buyAllBtn.TextColor3 = Color3.new(1, 1, 1)
buyAllBtn.Font = Enum.Font.SourceSansBold
buyAllBtn.TextSize = 14

buyAllBtn.MouseButton1Click:Connect(function()
    for item, sel in pairs(selectedItems.Seeds) do
        if sel then buySeedRemote:FireServer(item) end
    end
    for item, sel in pairs(selectedItems.Gear) do
        if sel then buyGearRemote:FireServer(item) end
    end
end)

-- Buy loop for AutoBuy
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

-- Minimize Button
local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 25)
minimizeBtn.Position = UDim2.new(1, -70, 0, 10)
minimizeBtn.Text = "➖"
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 20
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        for _, obj in pairs(frame:GetChildren()) do
            if obj ~= minimizeBtn and obj ~= xBtn then
                obj.Visible = false
            end
        end
        frame.Size = UDim2.new(0, 120, 0, 40)
    else
        for _, obj in pairs(frame:GetChildren()) do
            obj.Visible = true
        end
        frame.Size = UDim2.new(0, 320, 0, 260)
    end
end)

-- X Button (Close)
local xBtn = Instance.new("TextButton", frame)
xBtn.Size = UDim2.new(0, 30, 0, 25)
xBtn.Position = UDim2.new(1, -35, 0, 10)
xBtn.Text = "✖"
xBtn.Font = Enum.Font.SourceSansBold
xBtn.TextSize = 20
xBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
xBtn.TextColor3 = Color3.new(1, 1, 1)

xBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Resizable Corner
local resizer = Instance.new("Frame", frame)
resizer.Size = UDim2.new(0, 20, 0, 20)
resizer.Position = UDim2.new(1, -20, 1, -20)
resizer.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
resizer.BorderSizePixel = 0
Instance.new("UICorner", resizer).CornerRadius = UDim.new(0, 5)

local dragging = false
local dragStart = Vector2.new()
local startSize = UDim2.new()

resizer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startSize = frame.Size
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

resizer.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        local newWidth = math.clamp(startSize.X.Offset + delta.X, 200, 600)
        local newHeight = math.clamp(startSize.Y.Offset + delta.Y, 150, 400)
        frame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

print("[AutoBuyGUI] Ready with full features including X, minimize, buy all, and resizable corner!")
