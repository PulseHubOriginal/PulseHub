-- PulseHub | Space Loading Screen
-- LocalScript / executor

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local function getParent()
    local ok, hui = pcall(function() return gethui() end)
    if ok and hui then return hui end
    local ok2, cg = pcall(function()
        local c = game:GetService("CoreGui")
        local _ = c.Name
        return c
    end)
    if ok2 and cg then return cg end
    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local gui = Instance.new("ScreenGui")
gui.Name = "PulseHubLoader"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = getParent()

local root = Instance.new("Frame")
root.Size = UDim2.fromScale(1, 1)
root.BackgroundColor3 = Color3.fromRGB(2, 3, 10)
root.BorderSizePixel = 0
root.Parent = gui

-- nebula
local nebulaA = Instance.new("Frame")
nebulaA.Size = UDim2.fromScale(1.4, 1.4)
nebulaA.Position = UDim2.fromScale(-0.2, -0.2)
nebulaA.BackgroundTransparency = 0.55
nebulaA.BorderSizePixel = 0
nebulaA.Parent = root

local gradA = Instance.new("UIGradient")
gradA.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 20, 70)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(45, 15, 85)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 3, 10)),
})
gradA.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.25),
    NumberSequenceKeypoint.new(0.6, 0.6),
    NumberSequenceKeypoint.new(1, 1),
})
gradA.Rotation = 35
gradA.Parent = nebulaA

local nebulaB = Instance.new("Frame")
nebulaB.Size = UDim2.fromScale(1.4, 1.4)
nebulaB.Position = UDim2.fromScale(-0.2, -0.2)
nebulaB.BackgroundTransparency = 0.6
nebulaB.BorderSizePixel = 0
nebulaB.Parent = root

local gradB = Instance.new("UIGradient")
gradB.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 80, 160)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 0, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 3, 10)),
})
gradB.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.5),
    NumberSequenceKeypoint.new(1, 1),
})
gradB.Rotation = 200
gradB.Parent = nebulaB

-- starfield
local starLayer = Instance.new("Frame")
starLayer.Size = UDim2.fromScale(1, 1)
starLayer.BackgroundTransparency = 1
starLayer.Parent = root

local rng = Random.new(os.clock() * 1000)
local stars = {}

for i = 1, 220 do
    local px = rng:NextInteger(1, 3)
    local s = Instance.new("Frame")
    s.Size = UDim2.fromOffset(px, px)
    s.Position = UDim2.fromScale(rng:NextNumber(), rng:NextNumber())
    s.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    s.BackgroundTransparency = rng:NextNumber(0.2, 0.85)
    s.BorderSizePixel = 0
    s.Parent = starLayer

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = s

    stars[i] = {
        frame = s,
        speed = rng:NextNumber(0.004, 0.022),
        base = s.BackgroundTransparency,
        phase = rng:NextNumber(0, math.pi * 2),
        twinkle = rng:NextNumber(1.2, 3.4),
    }
end

-- shooting stars
task.spawn(function()
    while gui.Parent do
        task.wait(rng:NextNumber(1.5, 4))
        if not gui.Parent then break end
        local trail = Instance.new("Frame")
        trail.Size = UDim2.fromOffset(rng:NextInteger(90, 160), 2)
        trail.Position = UDim2.fromScale(rng:NextNumber(-0.1, 0.4), rng:NextNumber(0, 0.5))
        trail.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        trail.BorderSizePixel = 0
        trail.Rotation = 24
        trail.Parent = starLayer

        local tg = Instance.new("UIGradient")
        tg.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0.1),
        })
        tg.Parent = trail

        local tw = TweenService:Create(trail, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = trail.Position + UDim2.fromScale(0.55, 0.30),
            BackgroundTransparency = 1,
        })
        tw:Play()
        tw.Completed:Connect(function() trail:Destroy() end)
    end
end)

local drift = RunService.RenderStepped:Connect(function(dt)
    local t = os.clock()
    for _, st in ipairs(stars) do
        local p = st.frame.Position
        local newY = p.Y.Scale + st.speed * dt
        if newY > 1.02 then
            newY = -0.02
            st.frame.Position = UDim2.fromScale(rng:NextNumber(), newY)
        else
            st.frame.Position = UDim2.new(p.X.Scale, 0, newY, 0)
        end
        st.frame.BackgroundTransparency = math.clamp(
            st.base + math.sin(t * st.twinkle + st.phase) * 0.28, 0, 1)
    end
    gradA.Rotation = 35 + math.sin(t * 0.08) * 12
    gradB.Rotation = 200 + math.cos(t * 0.06) * 14
end)

-- center stack
local center = Instance.new("Frame")
center.AnchorPoint = Vector2.new(0.5, 0.5)
center.Position = UDim2.fromScale(0.5, 0.5)
center.Size = UDim2.fromScale(0.9, 0.6)
center.BackgroundTransparency = 1
center.Parent = root

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 14)
layout.Parent = center

local title = Instance.new("TextLabel")
title.LayoutOrder = 1
title.Size = UDim2.new(1, 0, 0, 86)
title.BackgroundTransparency = 1
title.RichText = true
title.Font = Enum.Font.GothamBlack
title.TextSize = 72
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = '<font color="rgb(60,150,255)">Pulse</font><font color="rgb(255,255,255)">Hub</font>'
title.TextTransparency = 1
title.Parent = center

local glow = Instance.new("UIStroke")
glow.Color = Color3.fromRGB(40, 120, 255)
glow.Thickness = 1.5
glow.Transparency = 0.55
glow.Parent = title

local warn = Instance.new("TextLabel")
warn.LayoutOrder = 2
warn.Size = UDim2.new(0, 620, 0, 52)
warn.BackgroundTransparency = 1
warn.Font = Enum.Font.Gotham
warn.TextSize = 18
warn.TextWrapped = true
warn.TextColor3 = Color3.fromRGB(190, 205, 230)
warn.TextTransparency = 1
warn.Text = "When you start the script, the game may freeze for up to 15 seconds. This is normal — do not close the game, do not rejoin. Wait until the freeze ends and the hub opens."
warn.Parent = center

local subtle = Instance.new("TextLabel")
subtle.LayoutOrder = 3
subtle.Size = UDim2.new(0, 620, 0, 22)
subtle.BackgroundTransparency = 1
subtle.Font = Enum.Font.GothamMedium
subtle.TextSize = 13
subtle.TextColor3 = Color3.fromRGB(110, 130, 165)
subtle.TextTransparency = 1
subtle.Text = "loading assets · initializing modules · please wait"
subtle.Parent = center

local btn = Instance.new("TextButton")
btn.LayoutOrder = 4
btn.Size = UDim2.fromOffset(300, 54)
btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
btn.BackgroundTransparency = 0.9
btn.AutoButtonColor = false
btn.Active = false
btn.Font = Enum.Font.GothamBold
btn.TextSize = 18
btn.TextColor3 = Color3.fromRGB(215, 225, 245)
btn.TextTransparency = 1
btn.Text = "please read it  ·  10"
btn.Parent = center

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = btn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(120, 150, 210)
btnStroke.Thickness = 1
btnStroke.Transparency = 0.5
btnStroke.Parent = btn

local bar = Instance.new("Frame")
bar.LayoutOrder = 5
bar.Size = UDim2.fromOffset(300, 3)
bar.BackgroundColor3 = Color3.fromRGB(35, 45, 70)
bar.BorderSizePixel = 0
bar.BackgroundTransparency = 1
bar.Parent = center

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = bar

local fill = Instance.new("Frame")
fill.Size = UDim2.fromScale(0, 1)
fill.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
fill.BorderSizePixel = 0
fill.BackgroundTransparency = 1
fill.Parent = bar

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = fill

-- fade in
local fadeInfo = TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
TweenService:Create(title, fadeInfo, {TextTransparency = 0}):Play()
task.wait(0.15)
TweenService:Create(warn, fadeInfo, {TextTransparency = 0}):Play()
TweenService:Create(subtle, fadeInfo, {TextTransparency = 0.15}):Play()
task.wait(0.15)
TweenService:Create(btn, fadeInfo, {TextTransparency = 0, BackgroundTransparency = 0.88}):Play()
TweenService:Create(bar, fadeInfo, {BackgroundTransparency = 0.4}):Play()
TweenService:Create(fill, fadeInfo, {BackgroundTransparency = 0}):Play()

-- countdown
local DURATION = 10
local ready = false

task.spawn(function()
    local elapsed = 0
    local lastShown = -1
    while elapsed < DURATION and gui.Parent do
        local dt = RunService.RenderStepped:Wait()
        elapsed = math.min(elapsed + dt, DURATION)
        fill.Size = UDim2.fromScale(elapsed / DURATION, 1)
        local remaining = math.ceil(DURATION - elapsed)
        if remaining ~= lastShown and not ready then
            lastShown = remaining
            btn.Text = string.format("please read it  ·  %d", math.max(remaining, 0))
        end
    end
    if not gui.Parent then return end

    ready = true
    btn.Active = true
    btn.Text = "Start the script"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TweenService:Create(btn, TweenInfo.new(0.35), {BackgroundTransparency = 0.78}):Play()
    TweenService:Create(btnStroke, TweenInfo.new(0.35), {
        Color = Color3.fromRGB(60, 150, 255), Transparency = 0.1
    }):Play()
    TweenService:Create(subtle, TweenInfo.new(0.35), {TextTransparency = 1}):Play()

    local pop = TweenService:Create(btn, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(316, 58)
    })
    pop:Play()
    pop.Completed:Wait()
    TweenService:Create(btn, TweenInfo.new(0.12), {Size = UDim2.fromOffset(300, 54)}):Play()
end)

btn.MouseEnter:Connect(function()
    if not ready then return end
    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.68}):Play()
end)

btn.MouseLeave:Connect(function()
    if not ready then return end
    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.78}):Play()
end)

local fired = false
btn.MouseButton1Click:Connect(function()
    if not ready or fired then return end
    fired = true
    btn.Active = false
    btn.Text = "loading"

    local out = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    TweenService:Create(title, out, {TextTransparency = 1}):Play()
    TweenService:Create(warn, out, {TextTransparency = 1}):Play()
    TweenService:Create(btn, out, {TextTransparency = 1, BackgroundTransparency = 1}):Play()
    TweenService:Create(btnStroke, out, {Transparency = 1}):Play()
    TweenService:Create(bar, out, {BackgroundTransparency = 1}):Play()
    TweenService:Create(fill, out, {BackgroundTransparency = 1}):Play()
    TweenService:Create(glow, out, {Transparency = 1}):Play()
    TweenService:Create(root, out, {BackgroundTransparency = 1}):Play()
    TweenService:Create(nebulaA, out, {BackgroundTransparency = 1}):Play()
    TweenService:Create(nebulaB, out, {BackgroundTransparency = 1}):Play()
    for _, st in ipairs(stars) do
        TweenService:Create(st.frame, out, {BackgroundTransparency = 1}):Play()
    end

    task.wait(0.55)
    drift:Disconnect()
    gui:Destroy()

    -- buraya kendi loadstring'ini koy
    -- 
end)
