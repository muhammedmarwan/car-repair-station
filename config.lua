Config = {}
Config.Locale = 'en' -- en, tw
Config.RepairTime = 4000
Config.EnableSoundEffect = true
Config.Blips = true -- if you want repair for free, set cost to false
Config.Stations = { 
    { x = -2174.7021, y = -409.9080, z = 12.9314, cost = 500 }, -- near beach garage
    { x = 476.3405, y = 5416.8457, z = 671.2228, cost = 500 }, --dnx_chiliad
}
Locales = {}
function _U(str, ...)
    if Locales[Config.Locale] and Locales[Config.Locale][str] then
        local stringFormat = Locales[Config.Locale][str]
        local args = { ... }
        if #args > 0 then return string.format(stringFormat, ...) else return stringFormat end
    end
    return str
end
