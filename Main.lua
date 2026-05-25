local hub = {}

function hub:Run(id)
    local TextService = game:GetService("TextService")

    local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))

    local FullFrame = Instance.new("Frame", sg)
    FullFrame.Size = UDim2.new(0.4, 0, 0.4, 0)
    FullFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    FullFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    FullFrame.BackgroundColor3 = Color3.fromRGB(12, 44, 62)
    Instance.new("UICorner", FullFrame).CornerRadius = UDim.new(0.025, 0)
    Instance.new("UIDragDetector", FullFrame)
    Instance.new("UIAspectRatioConstraint", FullFrame).AspectRatio = 1.59

    local title = Instance.new("TextLabel", FullFrame)
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.Position = UDim2.new(0, 0, 0.01, 0)
    title.Text = "Key System"
    title.TextWrapped = true
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.TextScaled = true

    local main = Instance.new("Frame", FullFrame)
    main.Size = UDim2.new(1, 0, 0.88, 0)
    main.Position = UDim2.new(0, 0, 1, 0)
    main.AnchorPoint = Vector2.new(0, 1)
    main.BackgroundColor3 = Color3.fromRGB(10, 37, 53)
    Instance.new("UICorner", main).CornerRadius = UDim.new(0.025, 0)
    local tip = Instance.new("TextLabel", main)
    tip.Size = UDim2.new(1, 0, 0.3, 0)
    tip.Position = UDim2.new(0, 0, 0, 0)
    tip.RichText = true
    tip.Text = 'Join <font color="rgb(50, 50, 255)">https://discord.gg/HfMBj367jT</font> for key.'
    tip.TextScaled = true
    tip.TextColor3 = Color3.new(1, 1, 1)
    tip.BackgroundTransparency = 1
    local button = Instance.new("TextButton", tip)
    button.Size = UDim2.fromScale(1,1)
    button.Text = ""
    button.BackgroundTransparency = 1
    button.Activated:Connect(function()
        setclipboard("https://discord.gg/HfMBj367jT")
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Key System",
            Text = "Copied Discord Link!",
            Duration = 5
        })
    end)

    local key = Instance.new("TextBox", main)
    key.Size = UDim2.new(0.5, 0, 0.15, 0)
    key.Position = UDim2.new(0.5, 0, 0.55, 0)
    key.PlaceholderText = "Put key here"
    key.Text = ""
    key.TextScaled = true
    key.AnchorPoint = Vector2.new(0.5, 1)
    key.TextColor3 = Color3.new(1, 1, 1)
    key.BackgroundTransparency = 0
    key.ClearTextOnFocus = false
    key.BackgroundColor3 =  Color3.fromRGB(12, 44, 62)
    Instance.new("UICorner", key).CornerRadius = UDim.new(0.2, 0)

    local button = Instance.new("TextButton", main)
    button.Size = UDim2.new(0.6, 0, 0.15, 0)
    button.Position = UDim2.new(0.5, 0, 0.85, 0)
    button.AnchorPoint = Vector2.new(0.5, 1)
    button.Text = "Verify"
    button.TextScaled = true
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundTransparency = 0
    button.BackgroundColor3 = Color3.new(0.117647, 0.588235, 1)
    Instance.new("UICorner", button).CornerRadius = UDim.new(0.2, 0)

    local verifyEvent = Instance.new("BindableEvent")
    local run
    local function runkey()
        local HttpService = game:GetService("HttpService")
        local url = "https://zkeys.pages.dev/api"
        local body = {
            key = key.Text,
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

        local data = HttpService:JSONDecode(response.Body)
        if data.success then
            run = data.code
            verifyEvent:Fire()
            sg:Destroy()
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Key System",
                Text = "Wrong or old Key!",
                Duration = 5
            })
        end
    end
    button.Activated:Connect(runkey)

    verifyEvent.Event:Wait()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Key System",
        Text = "Verified!",
        Duration = 5
    })
    return loadstring(run)
end

return hub
