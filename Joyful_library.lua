-- joyLIB (Joyful Library)
-- Comic / goofy styled GUI library
-- Local FE only

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
local function corner(obj, r)
    local c = Instance.new("UICorner", obj)
    c.CornerRadius = UDim.new(0, r or 14)
end

local function stroke(obj, t)
    local s = Instance.new("UIStroke", obj)
    s.Thickness = t or 3
    s.Color = Color3.new(0,0,0)
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
    main.BackgroundColor3 = Color3.fromRGB(255,255,255)

    corner(main, 24)
    stroke(main, 4)

    -- ========================
    -- TOP BAR
    -- ========================
    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1, 0, 0, 60)
    top.BackgroundColor3 = Color3.fromRGB(255, 210, 70)
    corner(top, 24)
    stroke(top, 3)

    local title = Instance.new("TextLabel", top)
    title.Size = UDim2.new(1, -110, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = self.GuiName
    title.Font = Enum.Font.FredokaOne
    title.TextSize = 26
    title.TextColor3 = Color3.new(0,0,0)
    title.TextXAlignment = Left

    -- ========================
    -- CONTENT
    -- ========================
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

    -- ========================
    -- DRAGGING
    -- ========================
    local dragging, dragStart, startPos = false

    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    top.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- ========================
    -- WINDOW CONTROLS
    -- ========================
    local minimized = false
    local originalSize = main.Size
    local pulseTween

    local controls = Instance.new("Frame", top)
    controls.Size = UDim2.new(0, 90, 1, 0)
    controls.Position = UDim2.new(1, -95, 0, 0)
    controls.BackgroundTransparency = 1

    local function makeBtn(text, x)
        local b = Instance.new("TextButton", controls)
        b.Size = UDim2.new(0, 40, 0, 35)
        b.Position = UDim2.new(0, x, 0.2, 0)
        b.Text = text
        b.Font = Enum.Font.FredokaOne
        b.TextSize = 24
        b.TextColor3 = Color3.new(0,0,0)
        b.BackgroundColor3 = Color3.fromRGB(255,235,120)
        corner(b, 10)
        stroke(b, 2)
        return b
    end

    local minBtn = makeBtn("_", 0)
    local closeBtn = makeBtn("X", 45)

    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(main, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
            Size = UDim2.fromScale(0,0)
        }):Play()
        task.wait(0.18)
        gui:Destroy()
    end)

    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized

        if minimized then
            content.Visible = false
            TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 65)
            }):Play()

            pulseTween = TweenService:Create(
                top,
                TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {BackgroundColor3 = Color3.fromRGB(255,255,140)}
            )
            pulseTween:Play()
        else
            if pulseTween then pulseTween:Cancel() end
            top.BackgroundColor3 = Color3.fromRGB(255,210,70)

            TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                Size = originalSize
            }):Play()

            task.wait(0.2)
            content.Visible = true
        end
    end)

    return self
end

-- ========================
-- ELEMENTS
-- ========================
function joy:Section(text)
    local l = Instance.new("TextLabel", self.Content)
    l.Size = UDim2.new(1,0,0,30)
    l.BackgroundTransparency = 1
    l.Text = "★ "..text
    l.Font = Enum.Font.FredokaOne
    l.TextSize = 20
    l.TextXAlignment = Left
    l.TextColor3 = Color3.new(0,0,0)
end

function joy:Button(text, cb)
    local b = Instance.new("TextButton", self.Content)
    b.Size = UDim2.new(1,0,0,45)
    b.Text = text
    b.Font = Enum.Font.FredokaOne
    b.TextSize = 20
    b.TextColor3 = Color3.new(0,0,0)
    b.BackgroundColor3 = Color3.fromRGB(130,200,255)
    corner(b, 18)
    stroke(b, 3)

    b.MouseButton1Click:Connect(function()
        if cb then cb() end
    end)
end

function joy:Toggle(text, default, cb)
    local state = default or false
    local f = Instance.new("Frame", self.Content)
    f.Size = UDim2.new(1,0,0,45)
    f.BackgroundColor3 = Color3.fromRGB(255,190,190)
    corner(f, 18)
    stroke(f, 3)

    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.7,0,1,0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.FredokaOne
    l.TextSize = 18
    l.TextColor3 = Color3.new(0,0,0)

    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0.25,0,0.7,0)
    b.Position = UDim2.new(0.72,0,0.15,0)
    b.Font = Enum.Font.FredokaOne
    b.TextSize = 16

    local function update()
        b.Text = state and "ON" or "OFF"
        b.BackgroundColor3 = state and Color3.fromRGB(120,255,120) or Color3.fromRGB(255,120,120)
    end
    update()

    corner(b, 14)
    stroke(b, 2)

    b.MouseButton1Click:Connect(function()
        state = not state
        update()
        if cb then cb(state) end
    end)
end

function joy:Slider(text, min, max, def, cb)
    local val = def or min
    local f = Instance.new("Frame", self.Content)
    f.Size = UDim2.new(1,0,0,60)
    f.BackgroundColor3 = Color3.fromRGB(220,255,200)
    corner(f, 18)
    stroke(f, 3)

    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1,-10,0,25)
    l.Position = UDim2.new(0,5,0,0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.FredokaOne
    l.TextSize = 18
    l.TextColor3 = Color3.new(0,0,0)

    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(1,-20,0,10)
    bar.Position = UDim2.new(0,10,0,40)
    bar.BackgroundColor3 = Color3.fromRGB(180,180,180)
    corner(bar, 8)

    local fill = Instance.new("Frame", bar)
    fill.BackgroundColor3 = Color3.fromRGB(100,200,100)
    corner(fill, 8)

    local dragging = false

    local function set(p)
        p = math.clamp(p, 0, 1)
        val = math.floor(min + (max - min) * p)
        fill.Size = UDim2.new(p,0,1,0)
        l.Text = text.." : "..val
        if cb then cb(val) end
    end

    set((val-min)/(max-min))

    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            set((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X)
        end
    end)
end

return joy
