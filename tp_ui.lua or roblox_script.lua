local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Anti-cheat bypass
task.spawn(function()
	for _, v in pairs(game:GetDescendants()) do
		if v:IsA("LocalScript") and v.Name:lower():find("anticheat") then
			v:Destroy()
		end
	end
end)

-- GUI setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "TeleportUI"
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 300)
frame.Position = UDim2.new(0.5, -140, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = true
frame.Parent = gui
Instance.new("UICorner", frame)

-- Scrollable Content
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1
scroll.Parent = frame

-- Centered Content Holder (Fixed alignment)
local content = Instance.new("Frame")
content.Size = UDim2.new(0.92, 0, 0, 0)
content.Position = UDim2.new(0.5, 0, 0, 0)
content.AnchorPoint = Vector2.new(0.5, 0)
content.BackgroundTransparency = 1
content.Parent = scroll

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)
layout.Parent = content

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	content.Size = UDim2.new(0.92, 0, 0, layout.AbsoluteContentSize.Y + 20)
end)

-- Toggle TP Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "TP"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 18
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.Parent = gui
Instance.new("UICorner", toggleButton)

-- Function to create a centered UI element
local function addUIElement(name, class, sizeY, text, color)
	local element = Instance.new(class)
	element.Name = name
	element.Size = UDim2.new(1, 0, 0, sizeY)
	element.Position = UDim2.new(0.5, 0, 0, 0)
	element.AnchorPoint = Vector2.new(0.5, 0)
	if class == "TextButton" or class == "TextLabel" or class == "TextBox" then
		element.Text = text or ""
		element.TextColor3 = Color3.new(1, 1, 1)
		element.Font = Enum.Font.Gotham
		element.TextSize = 16
	end
	element.BackgroundColor3 = color or Color3.fromRGB(40, 40, 40)
	element.Parent = content
	Instance.new("UICorner", element)
	return element
end

-- UI Elements
local title = addUIElement("Title", "TextLabel", 30, "ហោះទៅអ្នកលេង", Color3.fromRGB(25, 25, 25))
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.BackgroundTransparency = 1

local input = addUIElement("UsernameBox", "TextBox", 30, "", Color3.fromRGB(40, 40, 40))
input.PlaceholderText = "វៃឈ្មោះមនុស្ស"
input.ClearTextOnFocus = false

local tpButton = addUIElement("TeleportBtn", "TextButton", 30, "ចុចទៅ", Color3.fromRGB(0, 170, 255))
tpButton.Font = Enum.Font.GothamBold

local speedLabel = addUIElement("SpeedLabel", "TextLabel", 20, "ល្បឿនដើរ", Color3.fromRGB(25, 25, 25))
speedLabel.TextSize = 14
speedLabel.BackgroundTransparency = 1

local speedBox = addUIElement("SpeedBox", "TextBox", 25, "", Color3.fromRGB(40, 40, 40))
speedBox.PlaceholderText = "Default: 16"
speedBox.ClearTextOnFocus = false
speedBox.TextSize = 14

local jumpLabel = addUIElement("JumpLabel", "TextLabel", 20, "កម្ពស់លោត", Color3.fromRGB(25, 25, 25))
jumpLabel.TextSize = 14
jumpLabel.BackgroundTransparency = 1

local jumpBox = addUIElement("JumpBox", "TextBox", 25, "", Color3.fromRGB(40, 40, 40))
jumpBox.PlaceholderText = "Default: 50"
jumpBox.ClearTextOnFocus = false
jumpBox.TextSize = 14

local invisButton = addUIElement("InvisBtn", "TextButton", 30, "បំបាំងកាយ: បិទ", Color3.fromRGB(150, 50, 255))
invisButton.Font = Enum.Font.GothamBold

local highlightButton = addUIElement("HighlightBtn", "TextButton", 30, "បង្ហាញពន្លឺ: បិទ", Color3.fromRGB(255, 140, 0))
highlightButton.Font = Enum.Font.GothamBold

-- Speed/Jump Logic
speedBox.FocusLost:Connect(function()
	local val = tonumber(speedBox.Text)
	if val and val >= 1 and val <= 100 then
		humanoid.WalkSpeed = val
	else
		speedBox.Text = ""
	end
end)

jumpBox.FocusLost:Connect(function()
	local val = tonumber(jumpBox.Text)
	if val and val >= 1 and val <= 100 then
		humanoid.JumpPower = val
	else
		jumpBox.Text = ""
	end
end)

-- Teleport Logic
tpButton.MouseButton1Click:Connect(function()
	local target = Players:FindFirstChild(input.Text)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		local myChar = LocalPlayer.Character
		if myChar and myChar:FindFirstChild("HumanoidRootPart") then
			myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
		end
	else
		tpButton.Text = "រកមិនឃើញ"
		task.wait(1)
		tpButton.Text = "ចុចទៅ"
	end
end)

-- Invisibility Logic
local invisible = false
local function setInvisibility(state)
	local char = LocalPlayer.Character
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") or part:IsA("Decal") then
			part.LocalTransparencyModifier = state and 0.9 or 0
			part.Transparency = state and 1 or 0
		end
	end
	local head = char:FindFirstChild("Head")
	if head then
		for _, v in pairs(head:GetChildren()) do
			if v:IsA("BillboardGui") then
				v.Enabled = not state
			end
		end
	end
end

invisButton.MouseButton1Click:Connect(function()
	invisible = not invisible
	invisButton.Text = "បំបាំងកាយ: " .. (invisible and "បើក" or "បិទ")
	setInvisibility(invisible)
end)

-- Highlight Logic
local highlightsEnabled = false
local highlights = {}

local function toggleHighlights(state)
	for _, h in pairs(highlights) do
		h:Destroy()
	end
	highlights = {}

	if state then
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				for _, part in pairs(player.Character:GetChildren()) do
					if part:IsA("BasePart") then
						local box = Instance.new("BoxHandleAdornment")
						box.Size = part.Size
						box.Adornee = part
						box.AlwaysOnTop = true
						box.ZIndex = 5
						box.Transparency = 0.5
						box.Color3 = Color3.fromRGB(255, 255, 0)
						box.Parent = part
						table.insert(highlights, box)
					end
				end
			end
		end
	end
end

highlightButton.MouseButton1Click:Connect(function()
	highlightsEnabled = not highlightsEnabled
	highlightButton.Text = "បង្ហាញពន្លឺ: " .. (highlightsEnabled and "បើក" or "បិទ")
	toggleHighlights(highlightsEnabled)
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		if highlightsEnabled then
			task.wait(1)
			toggleHighlights(true)
		end
	end)
end)

-- Toggle UI show/hide
toggleButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)
