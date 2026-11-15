-- ═══════════════════════════════════════════
-- CubsHub Loader (entry point loadstring)
-- ═══════════════════════════════════════════
if getgenv and getgenv().CubsHubLoader then return end
if getgenv then getgenv().CubsHubLoader = true end

-- SATU-SATUNYA tempat ganti URL repo saat rebrand nanti
local RAW = "https://raw.githubusercontent.com/resurface043/CubsHub/main/"

local function mod(path)
    local ok, src = pcall(function() return game:HttpGet(RAW .. path, true) end)
    if not ok or not src or #src < 2 then
        error("[CubsHub] Gagal fetch module: " .. path)
    end
    local fn, err = loadstring(src, "=" .. path)
    if not fn then error("[CubsHub] Compile error " .. path .. ": " .. tostring(err)) end
    return fn
end

-- Module boleh return table langsung (config) ATAU factory function(CTX, UI).
-- Helper ini menangani keduanya supaya tidak salah panggil.
local function loadModule(path, ...)
    local chunk = mod(path)
    local result = chunk()
    if type(result) == "function" then
        return result(...)
    end
    return result
end

local okMain, errMain = pcall(function()
    local CTX = {
        Raw = RAW,
        Services = {
            Players = game:GetService("Players"),
            TeleportService = game:GetService("TeleportService"),
            TweenService = game:GetService("TweenService"),
            Http = game:GetService("HttpService"),
        },
    }

    CTX.Config = loadModule("src/core/config.lua")
    local UI = loadModule("src/core/ui/kit.lua", CTX)
    CTX.UI = UI
    CTX.Key = loadModule("src/core/keysystem.lua", CTX)
    CTX.Router = loadModule("src/core/router.lua", CTX)
    CTX.FuncCheck = loadModule("src/core/functioncheck.lua", CTX)

    local PageKey = loadModule("src/core/ui/page_key.lua", CTX, UI)
    local PageLoad = loadModule("src/core/ui/page_loading.lua", CTX, UI)
    local PageGames = loadModule("src/core/ui/page_games.lua", CTX, UI)

    local function runScriptBody(body)
        local fn, err = loadstring(body, "=CubsHubScript")
        if not fn then
            UI.Show("Loading")
            PageLoad.SetStatus("Compile error script: " .. tostring(err), "bad")
            return
        end
        task.spawn(fn)
        task.delay(0.4, function() pcall(function() UI.Destroy() end) end)
    end

    local function askKey(scriptPath)
        UI.Show("Key")
        PageKey.SetOnSubmit(function(keyText)
            PageKey.SetStatus("Memvalidasi key...", "dim")
            task.spawn(function()
                local ok, data = CTX.Key.validate(keyText, scriptPath)
                if ok then
                    CTX.Key.save(keyText)
                    PageKey.SetStatus("✓ Key valid! Menjalankan script...", "ok")
                    task.wait(0.3)
                    runScriptBody(data.body)
                else
                    PageKey.SetStatus("✕ " .. tostring(data), "bad")
                end
            end)
        end)
    end

    UI.Show("Loading")
    task.spawn(function()
        local criticalOk = CTX.FuncCheck.scan(PageLoad)
        if not criticalOk then
            PageLoad.SetStatus("Executor tidak didukung (critical function hilang)", "bad")
            return
        end

        PageLoad.SetStatus("Mengecek game...", "dim")
        local index = CTX.Router.loadIndex()
        if not index then
            PageLoad.SetStatus("Gagal memuat daftar game", "bad")
            return
        end

        local gameMeta, mode = CTX.Router.findGame(index)
        if not gameMeta then
            UI.Show("Games")
            for _, g in pairs(index) do
                if type(g) == "table" and g.Name then
                    PageGames.AddGame(g)
                end
            end
            return
        end

        local scriptPath = gameMeta.Scripts and gameMeta.Scripts[mode]
        if not scriptPath then
            PageLoad.SetStatus("Script mode '" .. tostring(mode) .. "' tidak ditemukan", "bad")
            return
        end

        PageLoad.SetStatus("Didukung: " .. gameMeta.Name .. " (" .. mode .. ")", "ok")

        -- coba key tersimpan dulu (skip halaman key kalau masih valid)
        local saved = CTX.Key.loadSaved()
        if saved then
            local ok, data = CTX.Key.validate(saved, scriptPath)
            if ok then
                runScriptBody(data.body)
                return
            end
            if data == "expired" or data == "invalid_key" or data == "revoked_shared" then
                CTX.Key.clear()
            end
        end

        askKey(scriptPath)
    end)
end)

if not okMain then
    if getgenv then getgenv().CubsHubLoader = nil end
    warn("[CubsHub] Loader error: " .. tostring(errMain))
end
