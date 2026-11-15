return function(CTX)
    local cfg = CTX.Config
    local Http = CTX.Services.Http
    local Players = CTX.Services.Players
    local api = {}

    local function req(path, body)
        local ok, res = pcall(function()
            return request({
                Url = cfg.WorkerUrl .. path,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = Http:JSONEncode(body or {}),
            })
        end)
        if not ok or not res then return nil, "network" end
        local ok2, data = pcall(function() return Http:JSONDecode(res.Body) end)
        if not ok2 then return nil, "bad_response" end
        return data, nil, res.StatusCode
    end

    function api.getHWID()
        local ok, h = pcall(function() return gethwid() end)
        if ok and h and h ~= "" then return tostring(h) end
        local ok2, e = pcall(identifyexecutor)
        return (ok2 and e or "UnknownExec") .. "-" .. Players.LocalPlayer.UserId
    end

    function api.loadSaved()
        local ok, content = pcall(function()
            if type(readfile) ~= "function" then return nil end
            if type(isfile) == "function" and not isfile(cfg.KeyFile) then return nil end
            return readfile(cfg.KeyFile)
        end)
        if not ok or not content then return nil end
        local key, hwid, expiry = content:match("^(.-)\n(.-)\n(%d+)$")
        if not key or not expiry then return nil end
        if hwid ~= api.getHWID() then return nil end
        if os.time() > tonumber(expiry) then return nil end
        return key
    end

    function api.save(key)
        pcall(function()
            if type(writefile) ~= "function" then return end
            local folder = cfg.KeyFile:match("^(.+)/[^/]+$")
            if folder and type(makefolder) == "function" and type(isfolder) == "function" and not isfolder(folder) then
                makefolder(folder)
            end
            writefile(cfg.KeyFile, key .. "\n" .. api.getHWID() .. "\n" .. (os.time() + cfg.KeyDuration))
        end)
    end

    function api.clear()
        pcall(function()
            if type(delfile) == "function" and type(isfile) == "function" and isfile(cfg.KeyFile) then
                delfile(cfg.KeyFile)
            end
        end)
    end

    function api.validate(key, scriptPath)
        local data, err, status = req("/validate", { key = key, hwid = api.getHWID(), script = scriptPath })
        if not data then return false, err end
        if data.ok then return true, data end
        return false, data.reason or ("http_" .. tostring(status))
    end

    return api
end
