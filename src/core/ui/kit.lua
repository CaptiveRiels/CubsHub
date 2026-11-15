return function(CTX)
    local cfg = CTX.Config

    local COL = {
        Bg = Color3.fromRGB(13, 13, 16),
        Panel = Color3.fromRGB(23, 23, 28),
        Input = Color3.fromRGB(32, 32, 38),
        Stroke = Color3.fromRGB(45, 45, 54),
        Text = Color3.fromRGB(235, 235, 240),
        Dim = Color3.fromRGB(145, 145, 155),
        Ok = Color3.fromRGB(95, 205, 115),
        Bad = Color3.fromRGB(235, 95, 95),
        Accent = Color3.fromRGB(255, 122, 26),
    }

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "CubsHubLoader"
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.DisplayOrder = 999
    pcall(function() Gui.Parent = gethui() end)
    if not Gui.Parent then Gui.Parent = game:GetService("CoreGui") end

    local Main = Instance.new("Frame")
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.fromOffset(640, 400)
    Main.BackgroundColor3 = COL.Bg
    Main.BorderSizePixel = 0
    Main.Parent = Gui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Main).Color = COL.Stroke

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 46)
    TitleBar.BackgroundColor3 = COL.Panel
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)
    local fix = Instance.new("Frame")
    fix.Position = UDim2.new(0, 0, 1, -10)
    fix.Size = UDim2.new(1, 0, 0, 10)
    fix.BackgroundColor3 = COL.Panel
    fix.BorderSizePixel = 0
    fix.Parent = TitleBar

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.6, 0, 1, 0)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🐻 " .. cfg.HubName
    title.TextColor3 = COL.Text
    title.TextSize = 17
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = TitleBar

    local ver = Instance.new("TextLabel")
    ver.Size = UDim2.new(0.3, 0, 1, 0)
    ver.Position = UDim2.new(0.4, 0, 0, 0)
    ver.BackgroundTransparency = 1
    ver.Text = "Loader • v" .. cfg.Version
    ver.TextColor3 = COL.Dim
    ver.TextSize = 12
    ver.Font = Enum.Font.Gotham
    ver.Parent = TitleBar

    local close = Instance.new("TextButton")
    close.AnchorPoint = Vector2.new(1, 0.5)
    close.Position = UDim2.new(1, -12, 0.5, 0)
    close.Size = UDim2.fromOffset(28, 28)
    close.BackgroundTransparency = 1
    close.Text = "✕"
    close.TextColor3 = COL.Dim
    close.TextSize = 16
    close.Font = Enum.Font.GothamBold
    close.Parent = TitleBar

    local Body = Instance.new("Frame")
    Body.Position = UDim2.new(0, 0, 0, 46)
    Body.Size = UDim2.new(1, 0, 1, -46)
    Body.BackgroundTransparency = 1
    Body.Parent = Main

    local UI = { COL = COL, Gui = Gui, Main = Main, Body = Body, Pages = {} }

    function UI.New(cls, props, parent)
        local o = Instance.new(cls)
        for k, v in pairs(props) do o[k] = v end
        o.Parent = parent
        return o
    end

    function UI.MakePage(name)
        local p = UI.New("Frame", {
            Name = name,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
        }, Body)
        UI.Pages[name] = p
        return p
    end

    function UI.Show(name)
        for n, p in pairs(UI.Pages) do p.Visible = (n == name) end
    end

    function UI.Button(parent, text, size, pos, primary)
        local b = UI.New("TextButton", {
            Size = size, Position = pos,
            BackgroundColor3 = primary and COL.Accent or COL.Input,
            TextColor3 = primary and Color3.fromRGB(20, 20, 20) or COL.Text,
            Text = text, TextSize = 13, Font = Enum.Font.GothamBold,
            BorderSizePixel = 0, AutoButtonColor = true,
        }, parent)
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
        if not primary then
            Instance.new("UIStroke", b).Color = COL.Stroke
        end
        return b
    end

    function UI.Label(parent, text, size, pos, opts)
        opts = opts or {}
        local l = UI.New("TextLabel", {
            Size = size, Position = pos,
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = opts.Color or COL.Text,
            TextSize = opts.TextSize or 13,
            Font = opts.Font or Enum.Font.Gotham,
            TextXAlignment = opts.Left and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
        }, parent)
        return l
    end

    function UI.Box(parent, size, pos, placeholder)
        local t = UI.New("TextBox", {
            Size = size, Position = pos,
            BackgroundColor3 = COL.Input, BorderSizePixel = 0,
            PlaceholderText = placeholder or "",
            Text = "", TextColor3 = COL.Text, TextSize = 13,
            Font = Enum.Font.Gotham, ClearTextOnFocus = false,
        }, parent)
        Instance.new("UICorner", t).CornerRadius = UDim.new(0, 7)
        Instance.new("UIStroke", t).Color = COL.Stroke
        local pad = Instance.new("UIPadding", t)
        pad.PaddingLeft = UDim.new(0, 12)
        return t
    end

    function UI.Destroy()
        pcall(function() Gui:Destroy() end)
    end

    close.Activated:Connect(function() UI.Destroy() end)

    return UI
end
