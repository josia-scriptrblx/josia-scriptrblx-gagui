-- Grow a Garden: Auto-Buy + Hacks GUI
-- Made by @Dimension_GD :)

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local buySeedRemote = ReplicatedStorage.GameEvents.BuySeedStock
local buyGearRemote = ReplicatedStorage.GameEvents.BuyGearStock

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

-- Helper: create UI corner
local function addUICorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

-- Create main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AutoBuyHacksGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 280)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
addUICorner(frame, 12)

-- Left tabs panel
local tabPanel = Instance.new("Frame", frame)
tabPanel.Size = UDim2.new(0, 90, 1, -60)
tabPanel.Position = UDim2.new(0, 10, 0, 50)
tabPanel.BackgroundTransparency = 1

-- Title label
local titleLabel = Instance.new("TextLabel", frame)
titleLabel.Size = UDim2.new(1, -20, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.fromRGB(120, 255, 120)
titleLabel.Text = "Grow A Garden Helper"
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Credit
local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1, -20, 0, 20)
credit.Position = UDim2.new(0, 10, 1, -25)
credit.BackgroundTransparency = 1
credit.Text = "Made by @Dimension_GD :)"
credit.TextColor3 = Color3.fromRGB(120, 255, 120)
credit.Font = Enum.Font.SourceSansItalic
credit.TextSize = 14
credit.TextXAlignment = Enum.TextXAlignment.Right

-- Tabs & content
local tabs = {"Seeds", "Gear", "Hacks"}
local activeTab = "Seeds"
local tabButtons = {}
local contentFrames = {}

local selectedItems = { Seeds = {}, Gear = {} }

-- Function to create a checkbox item
local function createCheckbox(parent, text, onToggle)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 24)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.AutoButtonColor = false
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Text = "[ ] " .. text
    btn.Parent = parent

    local checked = false
    btn.MouseButton1Click:Connect(function()
        checked = not checked
        btn.Text = (checked and "[✔] " or "[ ] ") .. text
        if onToggle then
            onToggle(checked)
        end
    end)
    return btn
end

-- Create tab buttons vertically
for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton", tabPanel)
    tabBtn.Size = UDim2.new(1, 0, 0, 30)
    tabBtn.Position = UDim2.new(0, 0, 0, (i-1)*35)
    tabBtn.BackgroundColor3 = (tabName == activeTab) and Color3.fromRGB(80,80,80) or Color3.fromRGB(50,50,50)
    tabBtn.TextColor3 = Color3.new(1,1,1)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 16
    tabBtn.Text = tabName
    tabButtons[tabName] = tabBtn

    local content = Instance.new("ScrollingFrame", frame)
    content.Name = tabName .. "Content"
    content.Size = UDim2.new(1, -120, 1, -60)
    content.Position = UDim2.new(0, 110, 0, 50)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 6
    content.Visible = (tabName == activeTab)
    content.CanvasSize = UDim2.new(0,0,0,0)
    contentFrames[tabName] = content

    tabBtn.MouseButton1Click:Connect(function()
        if activeTab ~= tabName then
            tabButtons[activeTab].BackgroundColor3 = Color3.fromRGB(50,50,50)
            tabBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
            contentFrames[activeTab].Visible = false
            content.Visible = true
            activeTab = tabName
        end
    end)
end

-- Populate Seeds tab
do
    local scroll = contentFrames["Seeds"]
    local y = 0
    for _, seed in ipairs(seeds) do
        createCheckbox(scroll, seed, function(checked)
            selectedItems.Seeds[seed] = checked
        end).Position = UDim2.new(0, 5, 0, y)
        y = y + 28
    end
    contentFrames["Seeds"].CanvasSize = UDim2.new(0, 0, 0, y)
end

-- Populate Gear tab
do
    local scroll = contentFrames["Gear"]
    local y = 0
    for _, gear in ipairs(gearItems) do
        createCheckbox(scroll, gear, function(checked)
            selectedItems.Gear[gear] = checked
        end).Position = UDim2.new(0, 5, 0, y)
        y = y + 28
    end
    contentFrames["Gear"].CanvasSize = UDim2.new(0, 0, 0, y)
end

-- Hacks tab UI elements
local hacksContent = contentFrames["Hacks"]
local hacks = {}

-- Helper to create toggle with label
local function createToggle(parent, text, callback)
    local toggleBtn = Instance.new("TextButton", parent)
    toggleBtn.Size = UDim2.new(0, 120, 0, 30)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    toggleBtn.Font = Enum.Font.SourceSans
    toggleBtn.TextSize = 14
    toggleBtn.Text = "[ OFF ] "..text
    toggleBtn.AutoButtonColor = false

    local toggled = false
    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggleBtn.Text = (toggled and "[ ON  ] " or "[ OFF ] ")..text
        if callback then callback(toggled) end
    end)

    return toggleBtn
end

-- Helper to create slider
local function createSlider(parent, text, min, max, default, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -10, 0, 50)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Text = text .. ": " .. default
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBg = Instance.new("Frame", container)
    sliderBg.Size = UDim2.new(1, 0, 0, 20)
    sliderBg.Position = UDim2.new(0, 0, 0, 25)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50,50,50)
    sliderBg.BorderSizePixel = 0
    addUICorner(sliderBg, 5)

    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(120, 255, 120)
    sliderFill.BorderSizePixel = 0
    addUICorner(sliderFill, 5)

    local dragging = false

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    sliderBg.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            local pct = relativeX / sliderBg.AbsoluteSize.X
            sliderFill.Size = UDim2.new(pct, 0, 1, 0)
            local value = math.floor(min + pct * (max - min) + 0.5)
            label.Text = text .. ": " .. value
            if callback then callback(value) end
        end
    end)

    return container
end

-- Hacks logic variables
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Fly Implementation
local flyEnabled = false
local flySpeed = 50
local flyBodyVelocity

local function toggleFly(on)
    flyEnabled = on
    if on then
        flyBodyVelocity = Instance.new("BodyVelocity", character.HumanoidRootPart)
        flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        print("[Fly] Enabled")
    else
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        print("[Fly] Disabled")
    end
end

-- Swim Implementation (simple swim toggle using platform stand)
local swimEnabled = false
local function toggleSwim(on)
    swimEnabled = on
    if humanoid then
        humanoid.PlatformStand = on
    end
    print("[Swim] " .. (on and "Enabled" or "Disabled"))
end

-- Noclip Implementation (remove collisions)
local noclipEnabled = false
local function toggleNoclip(on)
    noclipEnabled = on
    if on then
        RunService.Stepped:Connect(function()
            if noclipEnabled and character then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
    print("[Noclip] " .. (on and "Enabled" or "Disabled"))
end

-- Speed changer
local walkSpeed = humanoid.WalkSpeed
local function changeSpeed(val)
    if humanoid then
        humanoid.WalkSpeed = val
    end
end

-- Jump height changer
local jumpPower = humanoid.JumpPower
local function changeJump(val)
    if humanoid then
        humanoid.JumpPower = val
    end
end

-- Create Hack Controls
local yOffset = 0
local flyToggle = createToggle(hacksContent, "Fly", toggleFly)
flyToggle.Position = UDim2.new(0, 5, 0, yOffset)
yOffset = yOffset + 35

local swimToggle = createToggle(hacksContent, "Swim", toggleSwim)
swimToggle.Position = UDim2.new(0, 5, 0, yOffset)
yOffset = yOffset + 35

local noclipToggle = createToggle(hacksContent, "Noclip", toggleNoclip)
noclipToggle.Position = UDim2.new(0, 5, 0, yOffset)
yOffset = yOffset + 35

local speedSlider = createSlider(hacksContent, "Speed", 8, 250, humanoid.WalkSpeed, changeSpeed)
speedSlider.Position = UDim2.new(0, 5, 0, yOffset)
yOffset = yOffset + 60

local jumpSlider = createSlider(hacksContent, "Jump", 30, 250, humanoid.JumpPower, changeJump)
jumpSlider.Position = UDim2.new(0, 5, 0, yOffset)
yOffset = yOffset + 60

hacksContent.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)

-- Selected items
local selectedSeeds = {}
local selectedGear = {}

-- AutoBuy toggle button
local autoBuyToggle = Instance.new("TextButton", frame)
autoBuyToggle.Size = UDim2.new(0, 140, 0, 28)
autoBuyToggle.Position = UDim2.new(0, 110, 1, -55)
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

-- Buy all selected button
local buyAllBtn = Instance.new("TextButton", frame)
buyAllBtn.Size = UDim2.new(0, 140, 0, 28)
buyAllBtn.Position = UDim2.new(0, 110, 1, -25)
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

-- Auto-buy loop
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

-- Icon on top-left
local icon = Instance.new("TextLabel", frame)
icon.Size = UDim2.new(0, 24, 0, 24)
icon.Position = UDim2.new(0, 10, 0, 10)
icon.Text = "🌱"
icon.TextColor3 = Color3.new(1, 1, 1)
icon.Font = Enum.Font.SourceSansBold
icon.TextSize = 24
icon.BackgroundTransparency = 1

-- X button to close
local xBtn = Instance.new("TextButton", frame)
xBtn.Size = UDim2.new(0, 30, 0, 28)
xBtn.Position = UDim2.new(1, -40, 0, 10)
xBtn.Text = "✖"
xBtn.Font = Enum.Font.SourceSansBold
xBtn.TextSize = 20
xBtn.BackgroundColor3 = Color3.fromRGB(140, 40, 40)
xBtn.TextColor3 = Color3.new(1, 1, 1)

xBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Minimize button to toggle content visibility and resize frame properly
local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 28)
minimizeBtn.Position = UDim2.new(1, -80, 0, 10)
minimizeBtn.Text = "➖"
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 20
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        -- Hide content frames and controls except tabs, title, credit, buttons, and icons
        for _, v in pairs(frame:GetChildren()) do
            if v ~= tabPanel and v ~= titleLabel and v ~= credit and v ~= minimizeBtn and v ~= xBtn and v ~= icon then
                v.Visible = false
            end
        end
        -- Shrink frame height (leave room for tabs and title)
        frame.Size = UDim2.new(0, 350, 0, 90)
    else
        for _, v in pairs(frame:GetChildren()) do
            v.Visible = true
        end
        frame.Size = UDim2.new(0, 350, 0, 280)
        -- Keep tabPanel visible explicitly
        tabPanel.Visible = true
        titleLabel.Visible = true
        credit.Visible = true
        minimizeBtn.Visible = true
        xBtn.Visible = true
        icon.Visible = true
    end
end)

-- Resizable corner
local resizer = Instance.new("Frame", frame)
resizer.Size = UDim2.new(0, 20, 0, 20)
resizer.Position = UDim2.new(1, -20, 1, -20)
resizer.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
resizer.BorderSizePixel = 0
addUICorner(resizer, 5)

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
        local newWidth = math.clamp(startSize.X.Offset + delta.X, 300, 600)
        local newHeight = math.clamp(startSize.Y.Offset + delta.Y, 90, 400)
        frame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)
