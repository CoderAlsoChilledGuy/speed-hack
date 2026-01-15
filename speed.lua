-- SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- SETTINGS
local SPEED_MULT = 1
local MIN_MULT = 0
local MAX_MULT = 100
local STEP = 10
local BASE_SPEED = 10

local ENABLED = false

-- INPUT STATE
local moveDir = Vector3.zero

-- INPUT
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.W then moveDir += Vector3.new(0,0,-1)
	elseif input.KeyCode == Enum.KeyCode.S then moveDir += Vector3.new(0,0,1)
	elseif input.KeyCode == Enum.KeyCode.A then moveDir += Vector3.new(-1,0,0)
	elseif input.KeyCode == Enum.KeyCode.D then moveDir += Vector3.new(1,0,0)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W then moveDir -= Vector3.new(0,0,-1)
	elseif input.KeyCode == Enum.KeyCode.S then moveDir -= Vector3.new(0,0,1)
	elseif input.KeyCode == Enum.KeyCode.A then moveDir -= Vector3.new(-1,0,0)
	elseif input.KeyCode == Enum.KeyCode.D then moveDir -= Vector3.new(1,0,0)
	end
end)

-- APPLY VELOCITY
RunService.RenderStepped:Connect(function()
	if not ENABLED then return end
	if SPEED_MULT <= 0 then return end

	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	local cam = workspace.CurrentCamera
	if not hrp or not cam then return end

	if moveDir.Magnitude > 0 then
		local dir = cam.CFrame:VectorToWorldSpace(moveDir).Unit
		local vel = hrp.AssemblyLinearVelocity

		hrp.AssemblyLinearVelocity = Vector3.new(
			dir.X * BASE_SPEED * SPEED_MULT,
			vel.Y,
			dir.Z * BASE_SPEED * SPEED_MULT
		)
	end
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SpeedGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,190)
frame.Position = UDim2.new(0,20,0.5,-95)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Speed Controller"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1,0,0,25)
label.Position = UDim2.new(0,0,0,35)
label.TextColor3 = Color3.fromRGB(200,200,200)
label.BackgroundTransparency = 1
label.Font = Enum.Font.SourceSans
label.TextSize = 16

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1,-20,0,35)
toggle.Position = UDim2.new(0,10,0,65)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 18
toggle.TextColor3 = Color3.new(1,1,1)

local minus = Instance.new("TextButton", frame)
minus.Size = UDim2.new(0.4,-5,0,35)
minus.Position = UDim2.new(0,10,0,110)
minus.Text = "-"
minus.Font = Enum.Font.SourceSansBold
minus.TextSize = 22
minus.BackgroundColor3 = Color3.fromRGB(70,70,70)
minus.TextColor3 = Color3.new(1,1,1)

local plus = Instance.new("TextButton", frame)
plus.Size = UDim2.new(0.4,-5,0,35)
plus.Position = UDim2.new(0.6,5,0,110)
plus.Text = "+"
plus.Font = Enum.Font.SourceSansBold
plus.TextSize = 22
plus.BackgroundColor3 = Color3.fromRGB(70,70,70)
plus.TextColor3 = Color3.new(1,1,1)

-- UI UPDATE
local function updateUI()
	label.Text = "Multiplier: "..SPEED_MULT
	if ENABLED then
		toggle.Text = "ON | set ur speed to 1"
		toggle.BackgroundColor3 = Color3.fromRGB(40,120,40)
	else
		toggle.Text = "OFF "
		toggle.BackgroundColor3 = Color3.fromRGB(120,40,40)
	end
end

updateUI()

-- BUTTONS
toggle.MouseButton1Click:Connect(function()
	ENABLED = not ENABLED
	updateUI()
end)

minus.MouseButton1Click:Connect(function()
	if not ENABLED then return end
	SPEED_MULT = math.max(MIN_MULT, SPEED_MULT - STEP)
	updateUI()
end)

plus.MouseButton1Click:Connect(function()
	if not ENABLED then return end
	SPEED_MULT = math.min(MAX_MULT, SPEED_MULT + STEP)
	updateUI()
end)
