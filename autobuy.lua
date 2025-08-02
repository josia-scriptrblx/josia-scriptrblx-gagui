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

-- Main Frame
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 240, 0, 170)
frame.Position = UDim2.new(0, 10, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

-- Rounded corners
local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 12)

-- Title Label
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Seed Auto Buyer"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22

-- Close "X" Button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 22
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 6)

-- Minimize "-" Button
local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 28
local minimizeCorner = Instance.new("UICorner", minimizeBtn)
minimizeCorner.CornerRadius = UDim.new(0, 6)

-- Toggle Button
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -20, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 110)
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 160, 80)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20
toggleBtn.Text = "Start Auto-Buy All"
local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(0, 8)

-- Status Label
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 155)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Text = "Click start to buy all seeds"
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.SourceSansItalic
statusLabel.TextSize = 14

-- Draggable Minimize Icon (shown when frame minimized)
local minimizeIcon = Instance.new("TextButton", screenGui)
minimizeIcon.Size = UDim2.new(0, 40, 0, 40)
minimizeIcon.Position = UDim2.new(0, 10, 0, 100)
minimizeIcon.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeIcon.TextColor3 = Color3.new(1, 1, 1)
minimizeIcon.Text = "☰"
minimizeIcon.Font = Enum.Font.SourceSansBold
minimizeIcon.TextSize = 24
minimizeIcon.Visible = false
minimizeIcon.AutoButtonColor = false
local iconCorner = Instance.new("UICorner", minimizeIcon)
iconCorner.CornerRadius = UDim.new(0, 10)

-- Make minimizeIcon draggable
local dragging = false
local dragInput, mousePos, framePos

minimizeIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = minimizeIcon.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

minimizeIcon.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        minimizeIcon.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- Click on minimize icon shows main UI again
minimizeIcon.MouseButton1Click:Connect(function()
    frame.Visible = true
    minimizeIcon.Visible = false
end)

-- Minimize button hides main UI and shows minimize icon
minimizeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    minimizeIcon.Visible = true
end)

-- Close button destroys everything
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local autoBuyEnabled = false
local buyThread = nil

local function autoBuyAllLoop()
    while autoBuyEnabled do
        for _, seedName in pairs(seeds) do
            local success, err = pcall(function()
                buySeedRemote:FireServer(seedName)
            end)
            if not success then
                statusLabel.Text = "Error: "..tostring(err)
                autoBuyEnabled = false
                toggleBtn.Text = "Start Auto-Buy All"
                break
            end
            wait(0.05)
        end
        wait(0.1)
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    autoBuyEnabled = not autoBuyEnabled
    if autoBuyEnabled then
        toggleBtn.Text = "Stop Auto-Buy All"
        statusLabel.Text = "Auto-buying ALL seeds..."
        buyThread = coroutine.create(autoBuyAllLoop)
        coroutine.resume(buyThread)
    else
        toggleBtn.Text = "Start Auto-Buy All"
        statusLabel.Text = "Auto-buy stopped."
    end
end)
