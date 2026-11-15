return function(CTX)
    local api = {}

    function api.loadIndex()
        local ok, src = pcall(function() return game:HttpGet(CTX.Raw .. "src/games/index.lua", true) end)
        if not ok or not src or #src < 2 then return nil end
        local fn, err = loadstring(src, "=index")
        if not fn then return nil end
        local ok2, index = pcall(fn)
        if not ok2 or type(index) ~= "table" then return nil end
        return index
    end

    function api.findGame(index)
        for _, g in pairs(index) do
            if type(g) == "table" and type(g.Routes) == "table" then
                local mode = g.Routes[game.PlaceId]
                if mode then return g, mode end
            end
        end
        return nil
    end

    return api
end
