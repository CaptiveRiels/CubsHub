return function(CTX, UI)
    local cfg = CTX.Config
    local COL = UI.COL
    local Http = CTX.Services.Http
    local page = UI.MakePage("Key")
    local onSubmit = nil

    UI.Label(page, "🔑 Access Key", UDim2.new(0.5, 0, 0, 22), UDim2.new(0, 24, 0, 14), { Left = true, Font = Enum.Font.GothamBold, TextSize = 15 })

    local badge = UI.New("TextLabel", {
        Position = UDim2.new(1, -130, 0, 14),
        Size = UDim2.fromOffset(106, 22),
        BackgroundColor3 = COL.Input,
        Text = "Key required",
        TextColor3 = COL.Dim, TextSize = 11, Font = Enum.Font.Gotham,
    }, page)
    Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 6)

    local keyBox = UI.Box(page, UDim2.new(1, -48, 0, 40), UDim2.new(0, 24, 0, 44), "Paste your key here...")

    local checkBtn = UI.Button(page, "⚡ Check Key", UDim2.new(0.62, -28, 0, 40), UDim2.new(0, 24, 0, 94), true)
    local pasteBtn = UI.Button(page, "Paste", UDim2.new(0.38, -4, 0, 40), UDim2.new(0.62, 4, 0, 94), false)
    if type(getclipboard) ~= "function" then
        pasteBtn.Visible = false
        checkBtn.Size = UDim2.new(1, -48, 0, 40)
    end

    local status = UI.Label(page, "Paste key kamu, atau ambil key gratis lewat adlink di atas.", UDim2.new(1, -48, 0, 20), UDim2.new(0, 24, 1, -40), { Left = true, Color = COL.Dim, TextSize = 12 })

    UI.Label(page, "🗝 GET FREE KEY :", UDim2.new(0.5, 0, 0, 18), UDim2.new(0, 24, 0, 148), { Left = true, Color = COL.Dim, TextSize = 12, Font = Enum.Font.GothamBold })

    local x = 24
    for _, link in ipairs(cfg.AdLinks) do
        local b = UI.Button(page, link.Name, UDim2.fromOffset(124, 34), UDim2.new(0, x, 0, 172), false)
        b.Activated:Connect(function()
            status.Text = "Menyiapkan link..."
            status.TextColor3 = COL.Dim
            
            task.spawn(function()
                local httpRequest = syn and syn.request or http_request or request
                local ok, res = pcall(function()
                    return httpRequest({
                        Url = cfg.WorkerUrl .. "/prepare",
                        Method = "POST",
                        Headers = { ["Content-Type"] = "application/json" },
                        Body = Http:JSONEncode({
                            hwid = CTX.Key.getHWID(),
                            provider = link.Provider or "workink",
                        })
                    })
                end)
                
                if not ok or not res then
                    status.Text = "✕ Gagal connect ke server"
                    status.TextColor3 = COL.Bad
                    return
                end
                
                local ok2, data = pcall(function() return Http:JSONDecode(res.Body) end)
                if not ok2 or not data.ok then
                    status.Text = "✕ Gagal menyiapkan link: " .. tostring(data and data.reason)
                        .. (data and data.detail and (" (" .. tostring(data.detail) .. ")") or "")
                    status.TextColor3 = COL.Bad
                    return
                end
                
                if type(setclipboard) == "function" then
                    pcall(function() setclipboard(data.url) end)
                    status.Text = "✓ Link tersalin — buka di browser, selesaikan, lalu kembali"
                    status.TextColor3 = COL.Ok
                else
                    status.Text = "Buka manual: " .. data.url
                    status.TextColor3 = COL.Dim
                end
            end)
        end)
        x = x + 132
    end

    local discBtn = UI.Button(page, "💬 Discord", UDim2.fromOffset(100, 34), UDim2.new(0, x, 0, 172), false)
    discBtn.Activated:Connect(function()
        if type(setclipboard) == "function" then
            pcall(function() setclipboard(cfg.Discord) end)
            status.Text = "✓ Link Discord tersalin!"
            status.TextColor3 = COL.Ok
        end
    end)

    local execName = "unknown"
    pcall(function() execName = identifyexecutor() end)
    UI.Label(page, "Executor: " .. execName .. "  •  Place: " .. game.PlaceId, UDim2.new(1, -48, 0, 14), UDim2.new(0, 24, 1, -20), { Left = true, Color = Color3.fromRGB(90, 90, 100), TextSize = 10 })

    pasteBtn.Activated:Connect(function()
        local ok, clip = pcall(function() return getclipboard() end)
        if ok and clip then keyBox.Text = clip end
    end)

    checkBtn.Activated:Connect(function()
        if onSubmit then onSubmit(keyBox.Text) end
    end)

    local api = {}
    function api.SetStatus(text, kind)
        status.Text = text
        status.TextColor3 = (kind == "ok") and COL.Ok or (kind == "bad") and COL.Bad or COL.Dim
    end
    function api.SetOnSubmit(fn) onSubmit = fn end
    return api
end
