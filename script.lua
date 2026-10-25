local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local bestScriptFolder = PlayerGui:FindFirstChild("best-script-for-mm2")
if bestScriptFolder then
    bestScriptFolder:Destroy()
end

bestScriptFolder = Instance.new("Folder")
bestScriptFolder.Name = "best-script-for-mm2"
bestScriptFolder.Parent = PlayerGui

local espData = {}

local function hasTool(container, toolName)
    if not container then
        return false
    end
    return container:FindFirstChild(toolName) ~= nil
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

    local roleAttribute = player:GetAttribute("Role")
    if not roleAttribute and character then
        roleAttribute = character:GetAttribute("Role")
    end

    if roleAttribute then
        local roleText = string.lower(tostring(roleAttribute))
        if string.find(roleText, "murder", 1, true) then
            return "Murderer", Color3.fromRGB(255, 0, 0)
        elseif string.find(roleText, "sheriff", 1, true) or string.find(roleText, "gun", 1, true) then
            return "Sheriff", Color3.fromRGB(0, 150, 255)
        elseif string.find(roleText, "innocent", 1, true) then
            return "Innocent", Color3.fromRGB(0, 255, 0)
        end
    end

    return "Innocent", Color3.fromRGB(0, 255, 0)
end

local function createESP(player)
    if player == LocalPlayer or espData[player] then
        return
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "best-script-for-mm2_" .. player.Name
    billboard.Size = UDim2.new(0, 220, 0, 48)
    billboard.StudsOffset = Vector3.new(0, 3.2, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 2000
    billboard.LightInfluence = 0
    billboard.Enabled = false
    billboard.Parent = bestScriptFolder

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

    espData[player] = {
        billboard = billboard,
        label = label,
        highlight = nil
    }
end

local function updateHighlight(player, character, color)
    local data = espData[player]
    if not data then
        return
    end

    if not character then
        if data.highlight then
            data.highlight:Destroy()
            data.highlight = nil
        end
        return
    end

    if data.highlight and data.highlight.Parent == character then
        data.highlight.OutlineColor = color
        data.highlight.FillColor = color
        return
    end

    if data.highlight then
        data.highlight:Destroy()
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "best-script-for-mm2_highlight"
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.OutlineColor = color
    highlight.FillColor = color
    highlight.FillTransparency = 0.75
    highlight.OutlineTransparency = 0
    highlight.Parent = character

    data.highlight = highlight
end

local function updateESP()
    for player, data in pairs(espData) do
        if player.Parent == nil then
            data.billboard:Destroy()
            if data.highlight then
                data.highlight:Destroy()
            end
            espData[player] = nil
        else
            local character = player.Character
            local head = character and character:FindFirstChild("Head")

            if head then
                local role, color = getRole(player)
                local distance = 0

                local myCharacter = LocalPlayer.Character
                local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
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

for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(createESP)

Players.PlayerRemoving:Connect(function(player)
    local data = espData[player]
    if data then
        data.billboard:Destroy()
        if data.highlight then
            data.highlight:Destroy()
        end
        espData[player] = nil
    end
end)

RunService.RenderStepped:Connect(updateESP)
