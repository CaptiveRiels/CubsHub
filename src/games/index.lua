-- Registry game. Tambah game baru = tambah entry baru. TIDAK ada isi script di sini.
return {
    sellfries = {
        Name = "Sell Fries [Anomaly]",
        UniverseId = 10767380385,          --universe id game
        TeleportId = 94891079210424,     --place id
        Routes = {
            [94891079210424] = "lobby",  --place id lobby
            [139542527731344] = "main",   --place id game
        },
        Scripts = {
            lobby = "sellfries/lobby.lua",
            main = "sellfries/main.lua",
        },
    },
}
