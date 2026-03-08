local qbx = exports.qbx_core

lib.callback.register('carfixstation:server:payRepair', function(source, cost)
    local player = qbx:GetPlayer(source)
    if not player then return false end
    
    local cash = player.PlayerData.money['cash'] or 0
    local bank = player.PlayerData.money['bank'] or 0

    if cash >= cost then
        player.Functions.RemoveMoney('cash', cost, "car-repair")
        TriggerClientEvent('ox_lib:notify', source, {
            title = _U('blips_name'),
            description = _U('cost_repair', cost),
            type = 'success'
        })
        return true
    elseif bank >= cost then
        player.Functions.RemoveMoney('bank', cost, "car-repair")
        TriggerClientEvent('ox_lib:notify', source, {
            title = _U('blips_name'),
            description = _U('cost_repair', cost),
            type = 'success'
        })
        return true
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = _U('blips_name'),
            description = _U('not_enough_money'),
            type = 'error'
        })
        return false
    end
end)