return function(CTX)
    local cfg = CTX.Config

    local REFS = {
        hookmetamethod = hookmetamethod,
        getnamecallmethod = getnamecallmethod,
        newcclosure = newcclosure,
        checkcaller = checkcaller,
        getrawmetatable = getrawmetatable,
        loadstring = loadstring,
        request = request,
        hookfunction = hookfunction,
        clonefunction = clonefunction,
        restorefunction = restorefunction,
        gethui = gethui,
        fireproximityprompt = fireproximityprompt,
        firetouchinterest = firetouchinterest,
        readfile = readfile,
        writefile = writefile,
        setclipboard = setclipboard,
        getclipboard = getclipboard,
        identifyexecutor = identifyexecutor,
    }

    local api = {}
    function api.scan(page)
        local list = {}
        for _, n in ipairs(cfg.CriticalFunctions) do list[#list + 1] = { name = n, critical = true } end
        for _, n in ipairs(cfg.OptionalFunctions) do list[#list + 1] = { name = n, critical = false } end

        local rows = {}
        for _, entry in ipairs(list) do rows[entry.name] = page.AddRow(entry.name) end

        local passed, criticalOk = 0, true
        for i, entry in ipairs(list) do
            local exists = type(REFS[entry.name]) == "function"
            page.SetRow(rows[entry.name], exists, entry.critical)
            if exists then passed = passed + 1 elseif entry.critical then criticalOk = false end
            page.SetProgress(passed, #list)
            task.wait(0.04)
        end
        return criticalOk
    end
    return api
end
