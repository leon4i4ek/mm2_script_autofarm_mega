local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Clean up old
local old = PlayerGui:FindFirstChild("best-script-for-mm2")
if old then old:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "best-script-for-mm2"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = PlayerGui

-- Colors
local BG = Color3.fromRGB(25, 25, 30)
local BG2 = Color3.fromRGB(35, 35, 42)
local ACCENT = Color3.fromRGB(0, 170, 255)
local TEXT = Color3.fromRGB(240, 240, 240)
local RED = Color3.fromRGB(255, 70, 70)

-- Toggle button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0, 100)
toggleBtn.BackgroundColor3 = BG
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "A"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 22
toggleBtn.TextColor3 = ACCENT
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = ACCENT
toggleStroke.Thickness = 1.5
toggleStroke.Parent = toggleBtn

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 260, 0, 380)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -190)
mainFrame.BackgroundColor3 = BG
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = ACCENT
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = BG2
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Fix bottom corners of title bar (add a small frame to square bottom)
-- Actually use UICorner trick: parent it then a sibling covers... skip, minor visual

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "best-script-for-mm2"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 15
titleLabel.TextColor3 = ACCENT
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = RED
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Content holder
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 1, -50)
content.Position = UDim2.new(0, 10, 0, 45)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = content

-- Helper to make an option row
local function makeToggleRow(name, order, callback)
    local row = Instance.new("Frame")
    row.Name = name
    row.Size = UDim2.new(1, 0, 0, 50)
    row.BackgroundColor3 = BG2
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = content

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextColor3 = TEXT
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local state = false

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 26)
    toggle.Position = UDim2.new(1, -62, 0.5, -13)
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    toggle.BorderSizePixel = 0
    toggle.Text = "OFF"
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 12
    toggle.TextColor3 = TEXT
    toggle.Parent = row

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 13)
    tCorner.Parent = toggle

    toggle.MouseButton1Click:Connect(function()
        state = not state
        if state then
            toggle.BackgroundColor3 = ACCENT
            toggle.Text = "ON"
        else
            toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            toggle.Text = "OFF"
        end
        callback(state)
    end)
end

local function makeButtonRow(name, order, callback)
    local row = Instance.new("Frame")
    row.Name = name
    row.Size = UDim2.new(1, 0, 0, 50)
    row.BackgroundColor3 = BG2
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = content

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -100, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextColor3 = TEXT
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 0, 30)
    btn.Position = UDim2.new(1, -92, 0.5, -15)
    btn.BackgroundColor3 = ACCENT
    btn.BorderSizePixel = 0
    btn.Text = "RUN"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = row

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 6)
    bCorner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

-- ESP state
local espData = {}
local espEnabled = false

-- ESP functions
local function hasTool(container, toolName)
    return container and container:FindFirstChild(toolName) ~= nil
end

local function getRole(player)
    if player == LocalPlayer then
        return "You", Color3.fromRGB(255, 255, 255)
    end
    local character = player.Character
    local backpack = player:FindFirstChildOfClass("Backpack")
    if hasTool(backpack, "Knife") or hasTool(character, "Knife") then
        return "Murderer", Color3.fromRGB(255, 0, 0)
    end
    if hasTool(backpack, "Gun") or hasTool(character, "Gun") then
        return "Sheriff", Color3.fromRGB(0, 150, 255)
    end
    return "Innocent", Color3.fromRGB(0, 255, 0)
end

local function createESP(player)
    if player == LocalPlayer or espData[player] then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "bsmm2_esp_" .. player.Name
    billboard.Size = UDim2.new(0, 220, 0, 48)
    billboard.StudsOffset = Vector3.new(0, 3.2, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 2000
    billboard.LightInfluence = 0
    billboard.Enabled = false
    billboard.Parent = screenGui

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Text = ""
    label.Parent = billboard

    espData[player] = { billboard = billboard, label = label, highlight = nil }
end

local function updateHighlight(player, character, color)
    local data = espData[player]
    if not data then return end
    if not character then
        if data.highlight then data.highlight:Destroy(); data.highlight = nil end
        return
    end
    if data.highlight and data.highlight.Parent == character then
        data.highlight.OutlineColor = color
        data.highlight.FillColor = color
        return
    end
    if data.highlight then data.highlight:Destroy() end
    local h = Instance.new("Highlight")
    h.Name = "bsmm2_highlight"
    h.Adornee = character
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.OutlineColor = color
    h.FillColor = color
    h.FillTransparency = 0.75
    h.OutlineTransparency = 0
    h.Parent = character
    data.highlight = h
end

local function updateESP()
    if not espEnabled then return end
    for player, data in pairs(espData) do
        if player.Parent == nil then
            data.billboard:Destroy()
            if data.highlight then data.highlight:Destroy() end
            espData[player] = nil
        else
            local character = player.Character
            local head = character and character:FindFirstChild("Head")
            if head then
                local role, color = getRole(player)
                local distance = 0
                local myChar = LocalPlayer.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local theirRoot = character:FindFirstChild("HumanoidRootPart")
                if myRoot and theirRoot then
                    distance = math.floor((myRoot.Position - theirRoot.Position).Magnitude)
                end
                data.billboard.Adornee = head
                data.billboard.Enabled = true
                data.label.Text = string.format("%s | %s | %dm", player.Name, role, distance)
                data.label.TextColor3 = color
                updateHighlight(player, character, color)
            else
                data.billboard.Adornee = nil
                data.billboard.Enabled = false
                updateHighlight(player, nil, Color3.fromRGB(255, 255, 255))
            end
        end
    end
end

local function setESP(enabled)
    espEnabled = enabled
    if enabled then
        for _, player in ipairs(Players:GetPlayers()) do createESP(player) end
    else
        for player, data in pairs(espData) do
            data.billboard:Destroy()
            if data.highlight then data.highlight:Destroy() end
            espData[player] = nil
        end
    end
end

Players.PlayerAdded:Connect(function(player) if espEnabled then createESP(player) end end)
Players.PlayerRemoving:Connect(function(player)
    local data = espData[player]
    if data then
        data.billboard:Destroy()
        if data.highlight then data.highlight:Destroy() end
        espData[player] = nil
    end
end)

-- Autofarm
local autofarmEnabled = false
local autofarmThread = nil

local function findCoins()
    local coins = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = string.lower(obj.Name)
            if string.find(name, "coin", 1, true) then
                table.insert(coins, obj)
            end
        end
    end
    return coins
end

local function autofarmLoop()
    while autofarmEnabled do
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local coins = findCoins()
            if #coins > 0 then
                local nearest, nearestDist = nil, math.huge
                for _, coin in ipairs(coins) do
                    local d = (hrp.Position - coin.Position).Magnitude
                    if d < nearestDist then
                        nearest, nearestDist = coin, d
                    end
                end
                if nearest then
                    hrp.CFrame = nearest.CFrame + Vector3.new(0, 3, 0)
                end
            end
        end
        task.wait(0.15)
    end
end

local function setAutofarm(enabled)
    autofarmEnabled = enabled
    if enabled then
        if autofarmThread then task.cancel(autofarmThread) end
        autofarmThread = task.spawn(autofarmLoop)
    end
end

-- Server hop
local function serverHop()
    local placeId = game.PlaceId
    local success, response = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")
    end)
    if success then
        local ok, data = pcall(function() return HttpService:JSONDecode(response) end)
        if ok and data and data.data then
            for _, server in ipairs(data.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                    return
                end
            end
        end
    end
    TeleportService:Teleport(placeId, LocalPlayer)
end

-- Build options
makeToggleRow("ESP", 1, setESP)
makeToggleRow("Autofarm", 2, setAutofarm)
makeButtonRow("Server Hop", 3, serverHop)

-- Toggle button logic
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Dragging
local function makeDraggable(frame, dragHandle)
    local dragging = false
    local dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(mainFrame, titleBar)

-- ESP update loop
RunService.RenderStepped:Connect(updateESP)
