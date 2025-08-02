local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local buySeedRemote = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("BuySeedStock")

local seeds = {
    "Carrot",
    "Strawberry",
    "Blueberry",
    "Orange Tulip",
    "Tomato",
    "Daffodil",
    "Watermelon",
    "Pumpkin",
    "Apple",
    "Bamboo",
    "Coconut",
    "Cactus",
    "Dragon Fruit",
    "Mango",
    "Grape",
    "Mushroom",
    "Pepper",
    "Cacao",
    "Beanstalk",
    "Ember Lily",
    "Sugar Apple",
    "Burning Bud",
    "Giant Pinecone",
    "Elder Strawberry"
}

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "AutoSeedBuyerGui"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 220, 0, 300)
frame.Position = UDim2.new(0, 10, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Seed Auto Buyer"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 24

local seedList = Instance.new("ScrollingFrame", frame)
seedList.Size = UDim2.new(1, -20, 0, 220)
seedList.Position = UDim2.new(0, 10, 0, 40)
seedList.CanvasSize = UDim2.new(0, 0, 0, #seeds * 35)
seedList.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
seedList.BorderSizePixel = 0
seedList.ScrollBarThickness = 5

local uiLayout = Instance.new("UIListLayout", seedList)
uiLayout.Padding = UDim.new(0, 5)

local selectedSeed = nil
local autoBuyEnabled = false
local buyThread = nil

for _, seedName in pairs(seeds) do
    local btn = Instance.new("TextButton", seedList)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = seedName
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18

    btn.MouseButton1Click:Connect(function()
        selectedSeed = seedName
        statusLabel.Text = "Selected seed: "..seedName
    end)
end

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -20, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 270)
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20
toggleBtn.Text = "Start Auto-Buy"

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 315)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Text = "Select a seed to begin"
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.SourceSansItalic
statusLabel.TextSize = 14

local showBtn = Instance.new("TextButton", screenGui)
showBtn.Size = UDim2.new(0, 60, 0, 30)
showBtn.Position = UDim2.new(0, 10, 0, 100)
showBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
showBtn.BorderSizePixel = 0
showBtn.TextColor3 = Color3.new(1, 1, 1)
showBtn.Text = "Show"
showBtn.Font = Enum.Font.SourceSansBold
showBtn.TextSize = 18
showBtn.Visible = false

local function autoBuyLoop()
    while autoBuyEnabled and selectedSeed do
        local success, err = pcall(function()
            buySeedRemote:FireServer(selectedSeed)
        end)
        if not success then
            statusLabel.Text = "Error: "..tostring(err)
            autoBuyEnabled = false
            toggleBtn.Text = "Start Auto-Buy"
            break
        end
        wait(0.05)
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    if not selectedSeed then
        statusLabel.Text = "Please select a seed first!"
        return
    end

    autoBuyEnabled = not autoBuyEnabled
    if autoBuyEnabled then
        toggleBtn.Text = "Stop Auto-Buy"
        statusLabel.Text = "Auto-buying "..selectedSeed.."..."
        buyThread = coroutine.create(autoBuyLoop)
        coroutine.resume(buyThread)
    else
        toggleBtn.Text = "Start Auto-Buy"
        statusLabel.Text = "Auto-buy stopped."
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    showBtn.Visible = true
end)

showBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    showBtn.Visible = false
end)
