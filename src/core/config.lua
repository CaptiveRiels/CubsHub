return {
    HubName = "CubsHub",
    Version = "1.0.0",
    WorkerUrl = "https://hub-key.damms304-suspect321.workers.dev",
    KeyFile = "CubsHub/key.txt",
    KeyDuration = 60 * 60 * 24, -- 24 jam
    Discord = "https://discord.gg/PLACEHOLDER",

    AdLinks = {
        { Name = "Work.ink",      Provider = "workink" },
        { Name = "Linkvertise 🔒", Provider = "rs-lv" },
        { Name = "LootLabs 🔒",    Provider = "rs-ll" },
    },

    CriticalFunctions = {
        "hookmetamethod", "getnamecallmethod", "newcclosure",
        "checkcaller", "getrawmetatable", "loadstring", "request",
    },
    OptionalFunctions = {
        "hookfunction", "clonefunction", "restorefunction", "gethui",
        "fireproximityprompt", "firetouchinterest",
        "readfile", "writefile", "setclipboard", "getclipboard", "identifyexecutor",
    },
}
