return function(CTX, UI)
    local COL = UI.COL
    local TeleportService = CTX.Services.TeleportService
    local page = UI.MakePage("Games")

    UI.Label(page, "⚠ Game ini tidak didukung. Pilih game dibawah:", UDim2.new(1, -48, 0, 22), UDim2.new(0, 24, 0, 12), { Left = true, Font = Enum.Font.GothamBold, TextSize = 14 })

    local scroll = UI.New("ScrollingFrame", {
        Position = UDim2.new(0, 24, 0, 42),
        Size = UDim2.new(1, -48, 1, -56),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 4, CanvasSize = UDim2.new(0, 0, 0, 0),
    }, page)
    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local api = {}
    function api.AddGame(g)
        local row = UI.New("Frame", {
            Size = UDim2.new(1, -8, 0, 64),
            BackgroundColor3 = COL.Panel, BorderSizePixel = 0,
        }, scroll)
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

        local icon = UI.New("ImageLabel", {
            Position = UDim2.new(0, 8, 0.5, -24),
            Size = UDim2.fromOffset(48, 48),
            BackgroundColor3 = COL.Input,
            Image = "rbxthumb://type=GameIcon&id=" .. tostring(g.UniverseId or 0) .. "&w=150&h=150",
        }, row)
        Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 8)

        UI.Label(row, g.Name, UDim2.new(0.55, 0, 0, 20), UDim2.new(0, 66, 0, 12), { Left = true, Font = Enum.Font.GothamBold, TextSize = 14 })
        UI.Label(row, "Supported hub game", UDim2.new(0.55, 0, 0, 16), UDim2.new(0, 66, 0, 34), { Left = true, Color = COL.Dim, TextSize = 11 })

        local tp = UI.Button(row, "Teleport ▶", UDim2.fromOffset(110, 32), UDim2.new(1, -118, 0.5, -16), true)
        tp.Activated:Connect(function()
            if g.TeleportId then TeleportService:Teleport(g.TeleportId) end
        end)

        scroll.CanvasSize = scroll.CanvasSize + UDim2.new(0, 0, 0, 72)
    end
    return api
end
