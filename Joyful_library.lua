-- joyLIB v2
-- goofy comic-style GUI library
-- client-sided FE only

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

local joy = {}
joy.__index = joy

joy.GuiName = "Nameless hub"

-- ========================
-- UTIL
-- ========================
local function comicStroke(parent, thickness)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness or 3
    s.Color = Color3.new(0,0,0)
    s.Parent = parent
end

local function comicCorner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 14)
    c.Parent = parent
end

local function pop(obj, scale)
    scale = scale or 1.05
    local t1 = TweenService:Create(obj, TweenInfo.new(0.08), {Size = obj.Size * scale})
    local t2 = TweenService:Create(obj, TweenInfo.new(0.1), {Size = obj.Size})
    t1:Play()
    t1.Completed:Once(function()
        t2:Play()
    end)
end

-- ========================
-- SET NAME
-- ========================
function joy:setnamegui(name)
    self.GuiName = (typeof(name) == "string" and name ~= "") and name or "Nameless hub"
end

-- ========================
-- MAKE GUI
-- ========================
function joy:makegui()
    if PlayerGui:FindFirstChild("joyLIB") then
        PlayerGui.joyLIB:Destroy()
    end

    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.Name = "joyLIB"
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromScale(0.45, 0.6)
    main.Position = UDim2.fromScale(0.28, 0.2)
    main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    comicCorner(main, 24)
    comicStroke(main, 4)

    -- title bar
    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1, 0, 0, 60)
    top.BackgroundColor3 = Color3.fromRGB(255, 210, 70)
    comicCorner(top, 24)
    comicStroke(top, 3)

    local title = Instance.new("TextLabel", top)
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = self.GuiName
    title.Font = Enum.Font.FredokaOne
    title.TextSize = 28
    title.TextColor3 = Color3.new(0,0,0)
    title.TextXAlignment = Left

    -- content
    local content = Instance.new("ScrollingFrame", main)
    content.Position = UDim2.new(0, 10, 0, 70)
    content.Size = UDim2.new(1, -20, 1, -80)
    content.CanvasSize = UDim2.new(0,0,0,0)
    content.ScrollBarImageTransparency = 1
    content.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 10)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 20)
    end)

    self.Content = content
    return self
end

-- ========================
-- SECTION
-- ========================
function joy:Section(text)
    local s = Instance.new("TextLabel", self.Content)
    s.Size = UDim2.new(1, 0, 0, 30)
    s.BackgroundTransparency = 1
    s.Text = "★ "..text
    s.Font = Enum.Font.FredokaOne
    s.TextSize = 20
    s.TextXAlignment = Left
    s.TextColor3 = Color3.fromRGB(0,0,0)
end

-- ========================
-- BUTTON
-- ========================
function joy:Button(text, callback)
    local b = Instance.new("TextButton", self.Content)
    b.Size = UDim2.new(1, 0, 0, 45)
    b.Text = text
    b.Font = Enum.Font.FredokaOne
    b.TextSize = 20
    b.BackgroundColor3 = Color3.fromRGB(130, 200, 255)
    b.TextColor3 = Color3.new(0,0,0)

    comicCorner(b, 18)
    comicStroke(b, 3)

    b.MouseButton1Click:Connect(function()
        pop(b)
        if callback then callback() end
    end)
end

-- ========================
-- TOGGLE
-- ========================
function joy:Toggle(text, default, callback)
    local state = default or false

    local f = Instance.new("Frame", self.Content)
    f.Size = UDim2.new(1, 0, 0, 45)
    f.BackgroundColor3 = Color3.fromRGB(255, 190, 190)

    comicCorner(f, 18)
    comicStroke(f, 3)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.FredokaOne
    lbl.TextSize = 18
    lbl.TextColor3 = Color3.new(0,0,0)

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0.25, 0, 0.7, 0)
    btn.Position = UDim2.new(0.72, 0, 0.15, 0)
    btn.Text = state and "ON" or "OFF"
    btn.Font = Enum.Font.FredokaOne
    btn.TextSize = 16
    btn.BackgroundColor3 = state and Color3.fromRGB(120,255,120) or Color3.fromRGB(255,120,120)

    comicCorner(btn, 14)
    comicStroke(btn, 2)

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(120,255,120) or Color3.fromRGB(255,120,120)
        pop(btn)
        if callback then callback(state) end
    end)
end

-- ========================
-- SLIDER
-- ========================
function joy:Slider(text, min, max, default, callback)
    local value = default or min

    local f = Instance.new("Frame", self.Content)
    f.Size = UDim2.new(1, 0, 0, 60)
    f.BackgroundColor3 = Color3.fromRGB(220, 255, 200)

    comicCorner(f, 18)
    comicStroke(f, 3)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1, -10, 0, 25)
    lbl.Position = UDim2.new(0, 5, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.FredokaOne
    lbl.TextSize = 18
    lbl.TextColor3 = Color3.new(0,0,0)

    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(1, -20, 0, 10)
    bar.Position = UDim2.new(0, 10, 0, 40)
    bar.BackgroundColor3 = Color3.fromRGB(180,180,180)
    comicCorner(bar, 8)

    local fill = Instance.new("Frame", bar)
    fill.BackgroundColor3 = Color3.fromRGB(100,200,100)
    fill.Size = UDim2.new((value-min)/(max-min),0,1,0)
    comicCorner(fill, 8)

    local dragging = false

    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local pct = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * pct)
            fill.Size = UDim2.new(pct,0,1,0)
            lbl.Text = text.." : "..value
            if callback then callback(value) end
        end
    end)

    lbl.Text = text.." : "..value
end

return joy

