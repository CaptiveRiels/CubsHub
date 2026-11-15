return function(CTX, UI)
    local COL = UI.COL
    local TweenService = CTX.Services.TweenService
    local page = UI.MakePage("Loading")

    local spinner = UI.New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.32, 0, 0.30, 0),
        Size = UDim2.fromOffset(46, 46),
        BackgroundTransparency = 1,
    }, page)
    Instance.new("UICorner", spinner).CornerRadius = UDim.new(1, 0)
    local stroke = UI.New("UIStroke", { Thickness = 4, Color = COL.Accent }, spinner)
    UI.New("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.45, 0),
            NumberSequenceKeypoint.new(0.5, 1),
            NumberSequenceKeypoint.new(1, 1),
        }),
    }, stroke)
    TweenService:Create(spinner, TweenInfo.new(0.9, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), { Rotation = 360 }):Play()

    UI.Label(page, "Initializing...", UDim2.new(0.6, 0, 0, 22), UDim2.new(0.02, 0, 0.46, 0), { Font = Enum.Font.GothamBold, TextSize = 15 })
    local status = UI.Label(page, "Checking executor functions", UDim2.new(0.6, 0, 0, 18), UDim2.new(0.02, 0, 0.56, 0), { Color = COL.Dim, TextSize = 12 })

    local barOuter = UI.New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.32, 0, 0.70, 0),
        Size = UDim2.new(0.55, 0, 0, 16),
        BackgroundColor3 = COL.Input, BorderSizePixel = 0,
    }, page)
    Instance.new("UICorner", barOuter).CornerRadius = UDim.new(0, 5)
    local barInner = UI.New("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = COL.Accent, BorderSizePixel = 0,
    }, barOuter)
    Instance.new("UICorner", barInner).CornerRadius = UDim.new(0, 5)
    local barLabel = UI.Label(page, "0/0", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), { TextSize = 11, Font = Enum.Font.GothamBold })
    barLabel.Parent = barOuter

    local panel = UI.New("Frame", {
        Position = UDim2.new(0.66, 0, 0, 14),
        Size = UDim2.new(0.32, -14, 1, -28),
        BackgroundColor3 = COL.Panel, BorderSizePixel = 0,
    }, page)
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 8)
    local layout = Instance.new("UIListLayout", panel)
    layout.Padding = UDim.new(0, 3)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", panel)
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 12)

    local api = {}
    function api.SetStatus(text, kind)
        status.Text = text
        status.TextColor3 = (kind == "ok") and COL.Ok or (kind == "bad") and COL.Bad or COL.Dim
    end
    function api.AddRow(name)
        return UI.Label(panel, "⬜ " .. name, UDim2.new(1, -12, 0, 18), UDim2.new(0, 0, 0, 0), { Left = true, Color = COL.Dim, TextSize = 12 })
    end
    function api.SetRow(row, exists, critical)
        row.Text = (exists and "✅ " or "❌ ") .. row.Text:sub(3)
        row.TextColor3 = exists and COL.Ok or (critical and COL.Bad or COL.Dim)
    end
    function api.SetProgress(done, total)
        barLabel.Text = done .. "/" .. total
        barInner.Size = UDim2.new(total > 0 and (done / total) or 0, 0, 1, 0)
    end
    return api
end
