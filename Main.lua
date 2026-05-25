local zay = {}
function zay:Run(id)
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")
	local TweenService = game:GetService("TweenService")

	local discordLink = "https://discord.gg/ntaZrgxTUf"

	local function getUIParent()
		local suc, gui = pcall(function()
			return gethui and gethui() or game:GetService("CoreGui")
		end)
		return (suc and gui) or player:WaitForChild("PlayerGui")
	end

	local function notify(title, text, time)
		pcall(function()
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = title,
				Text = text,
				Duration = time or 5
			})
		end)
	end

	local Theme = {
		Background = Color3.fromRGB(15, 15, 18),
		Foreground = Color3.fromRGB(25, 25, 30),
		Accent = Color3.fromRGB(255, 60, 60),
		AccentGlow = Color3.fromRGB(180, 0, 0),
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(150, 150, 160),
		Success = Color3.fromRGB(45, 140, 95),
		Glass = 0.15
	}

	local function applyStyle(obj, radius, isButton)
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, radius or 12)
		corner.Parent = obj

		local stroke = Instance.new("UIStroke")
		stroke.Color = Theme.Accent
		stroke.Thickness = 1.6
		stroke.Transparency = 0.5
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Parent = obj

		if obj.Name == "MainFrame" or obj.Name == "MobileToggle" then
			local grad = Instance.new("UIGradient")
			grad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Theme.Accent),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 100)),
				ColorSequenceKeypoint.new(1, Theme.Accent)
			})
			grad.Parent = stroke
			task.spawn(function()
				local t = 0
				while grad.Parent do
					t = t + 0.02
					grad.Rotation = (t * 50) % 360
					task.wait()
				end
			end)
		end

		if isButton then
			obj.MouseEnter:Connect(function()
				TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0, Thickness = 2.2}):Play()
			end)
			obj.MouseLeave:Connect(function()
				TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0.5, Thickness = 1.6}):Play()
			end)
		end
	end

	local function addGlow(parent)
		local glow = Instance.new("ImageLabel")
		glow.Name = "Glow"
		glow.BackgroundTransparency = 1
		glow.Position = UDim2.new(0, -15, 0, -15)
		glow.Size = UDim2.new(1, 30, 1, 30)
		glow.ZIndex = parent.ZIndex - 1
		glow.Image = "rbxassetid://5028857084"
		glow.ImageColor3 = Theme.Accent
		glow.ImageTransparency = 0.8
		glow.ScaleType = Enum.ScaleType.Slice
		glow.SliceCenter = Rect.new(24, 24, 120, 120)
		glow.Parent = parent
		return glow
	end

	local function makeResponsive(frame, baseSize)
		local uiScale = Instance.new("UIScale")
		uiScale.Parent = frame
		local aspectRatio = Instance.new("UIAspectRatioConstraint")
		aspectRatio.AspectRatio = baseSize.X / baseSize.Y
		aspectRatio.AspectType = Enum.AspectType.FitWithinMaxSize
		aspectRatio.Parent = frame

		local function updateScale()
			local viewport = workspace.CurrentCamera.ViewportSize
			local scale = math.min(viewport.X / 1280, viewport.Y / 720)
			uiScale.Scale = math.clamp(scale, 0.45, 1.3)
		end
		workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
		updateScale()
	end

	local function makeDraggable(obj)
		local dragging, dragInput, dragStart, startPos
		obj.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = obj.Position

				local c;
				c = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						c:Disconnect()
					end
				end)
			end
		end)
		obj.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				local delta = input.Position - dragStart
				obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
	end

	local keyGui = Instance.new("ScreenGui")
	keyGui.Name = "ZezorKeyV3"
	keyGui.IgnoreGuiInset = true
	keyGui.Parent = getUIParent()

	local keyFrame = Instance.new("Frame")
	keyFrame.Size = UDim2.new(0, 400, 0, 260)
	keyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	keyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	keyFrame.BackgroundColor3 = Theme.Background
	keyFrame.BorderSizePixel = 0
	keyFrame.Parent = keyGui
	applyStyle(keyFrame, 15)
	local keyGlow = addGlow(keyFrame)
	makeResponsive(keyFrame, Vector2.new(400, 260))
	makeDraggable(keyFrame)

	local keyTitle = Instance.new("TextLabel")
	keyTitle.Size = UDim2.new(1, 0, 0, 50)
	keyTitle.BackgroundTransparency = 1
	keyTitle.Text = "ZEZOR V2.1 KEY-SYSTEM"
	keyTitle.TextColor3 = Theme.Accent
	keyTitle.Font = Enum.Font.GothamBold
	keyTitle.TextSize = 22
	keyTitle.Parent = keyFrame

	local keyBox = Instance.new("TextBox")
	keyBox.Size = UDim2.new(1, -60, 0, 50)
	keyBox.Position = UDim2.new(0, 30, 0, 70)
	keyBox.BackgroundColor3 = Theme.Foreground
	keyBox.PlaceholderText = "Put the key here."
	keyBox.Text = ""
	keyBox.TextColor3 = Theme.Text
	keyBox.Font = Enum.Font.GothamMedium
	keyBox.TextSize = 16
	keyBox.Parent = keyFrame
	applyStyle(keyBox, 10)

	local discordBtn = Instance.new("TextButton")
	discordBtn.Size = UDim2.new(1, -60, 0, 40)
	discordBtn.Position = UDim2.new(0, 30, 0, 130)
	discordBtn.BackgroundColor3 = Theme.Foreground
	discordBtn.Text = "Copy Discord link"
	discordBtn.TextColor3 = Theme.Text
	discordBtn.Font = Enum.Font.GothamMedium
	discordBtn.TextSize = 14
	discordBtn.Parent = keyFrame
	applyStyle(discordBtn, 10, true)

	discordBtn.MouseButton1Click:Connect(function()
		if setclipboard then setclipboard(discordLink) notify("Copied", "Link copied to clipboard!", 2) end
	end)

	local submitBtn = Instance.new("TextButton")
	submitBtn.Size = UDim2.new(1, -60, 0, 45)
	submitBtn.Position = UDim2.new(0, 30, 0, 185)
	submitBtn.BackgroundColor3 = Theme.Accent
	submitBtn.Text = "Submit Key"
	submitBtn.TextColor3 = Theme.Text
	submitBtn.Font = Enum.Font.GothamBold
	submitBtn.TextSize = 18
	submitBtn.Parent = keyFrame
	applyStyle(submitBtn, 10, true)

	keyFrame.Size = UDim2.new(0, 0, 0, 0)
	TweenService:Create(keyFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Size = UDim2.new(0, 400, 0, 260)}):Play()

	local verifyEvent = Instance.new("BindableEvent")
	local run
	local function runkey(key)
		local HttpService = game:GetService("HttpService")
		local url = "https://zkeys.pages.dev/api"
		local body = {
			key = key,
			id = id
		}

		local response = request({
			Url = url,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json"
			},
			Body = HttpService:JSONEncode(body)
		})

		return HttpService:JSONDecode(response.Body)
	end
	submitBtn.Activated:Connect(function()
		if submitBtn.Text == "SCANNING..." then return end
		local data = runkey(keyBox.Text)

		local originalText = submitBtn.Text
		submitBtn.Text = "SCANNING..."

		TweenService:Create(submitBtn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Accent:Lerp(Color3.new(1,1,1), 0.2)}):Play()

		local scanOverlay = Instance.new("Frame")
		scanOverlay.Name = "ScanOverlay"
		scanOverlay.Size = UDim2.new(1, 0, 1, 0)
		scanOverlay.BackgroundTransparency = 1
		scanOverlay.ClipsDescendants = true
		scanOverlay.ZIndex = 100
		scanOverlay.Parent = keyFrame
		Instance.new("UICorner", scanOverlay).CornerRadius = UDim.new(0, 15)

		local laser = Instance.new("Frame")
		laser.Name = "Laser"
		laser.Size = UDim2.new(1, 0, 0, 3)
		laser.Position = UDim2.new(0, 0, -0.1, 0)
		laser.BackgroundColor3 = Theme.Accent
		laser.BorderSizePixel = 0
		laser.ZIndex = 102
		laser.Parent = scanOverlay

		local laserGlow = Instance.new("ImageLabel")
		laserGlow.Name = "Glow"
		laserGlow.BackgroundTransparency = 1
		laserGlow.Position = UDim2.new(0, 0, 0.5, -15)
		laserGlow.Size = UDim2.new(1, 0, 0, 30)
		laserGlow.Image = "rbxassetid://6015667341"
		laserGlow.ImageColor3 = Theme.Accent
		laserGlow.ImageTransparency = 0.4
		laserGlow.ScaleType = Enum.ScaleType.Stretch
		laserGlow.Parent = laser

		local flare = Instance.new("Frame")
		flare.Size = UDim2.new(1, 0, 0, 60)
		flare.BackgroundColor3 = Theme.Accent
		flare.BackgroundTransparency = 0.95
		flare.BorderSizePixel = 0
		flare.ZIndex = 101
		flare.Parent = scanOverlay
		local fg = Instance.new("UIGradient", flare)
		fg.Rotation = 90

		fg.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 1)
		})

		local scanTime = 0.7
		local tweenInfo = TweenInfo.new(scanTime, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 1, true)
		local tween = TweenService:Create(laser, tweenInfo, {Position = UDim2.new(0, 0, 1.1, 0)})
		tween:Play()

		local connection = RunService.RenderStepped:Connect(function()
			flare.Position = laser.Position - UDim2.new(0, 0, 0, 60)
		end)

		task.wait(scanTime * 2)
		connection:Disconnect()

		if data.success then
			run = data.code
			laser.BackgroundColor3 = Theme.Success
			laserGlow.ImageColor3 = Theme.Success
			flare.BackgroundColor3 = Theme.Success
			submitBtn.Text = "KEY ACCEPTED"

			local bloomInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

			task.spawn(function()
				TweenService:Create(submitBtn, bloomInfo, {BackgroundColor3 = Color3.new(1,1,1), TextColor3 = Theme.Success}):Play()
				TweenService:Create(keyFrame, bloomInfo, {
					BackgroundColor3 = Theme.Success:Lerp(Color3.new(0,0,0), 0.1),
					Size = UDim2.new(0, 420, 0, 280)
				}):Play()

				TweenService:Create(keyGlow, bloomInfo, {
					ImageColor3 = Theme.Success,
					ImageTransparency = 0.2
				}):Play()

				TweenService:Create(scanOverlay, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
				TweenService:Create(flare, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
				TweenService:Create(laser, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
				TweenService:Create(laserGlow, TweenInfo.new(0.4), {ImageTransparency = 1}):Play()
			end)

			notify("Access Granted", "Welcome to Zezor Hub V2.1!", 2)
			task.wait(1.2)

			TweenService:Create(keyFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
			task.wait(0.6)
			keyGui:Destroy()
			verifyEvent:Fire()
		else
			scanOverlay:Destroy()
			submitBtn.Text = originalText
			TweenService:Create(submitBtn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Accent}):Play()

			local originalPos = keyFrame.Position
			local originalColor = keyFrame.BackgroundColor3

			task.spawn(function()
				for i = 1, 3 do
					TweenService:Create(keyFrame, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = originalPos + UDim2.new(0, 7, 0, 0), BackgroundColor3 = Color3.fromRGB(80, 20, 20)}):Play()
					task.wait(0.05)
					TweenService:Create(keyFrame, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = originalPos + UDim2.new(0, -7, 0, 0)}):Play()
					task.wait(0.05)
				end
				TweenService:Create(keyFrame, TweenInfo.new(0.2), {Position = originalPos, BackgroundColor3 = originalColor}):Play()
			end)

			notify("Denied", "Incorrect Key! Try again.", 3)
		end
	end)
	verifyEvent.Event:Wait()
	return loadstring(run)
end

return zay
