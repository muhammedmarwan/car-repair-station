local fixing = false
CreateThread(function()
    if Config.Blips then
        for i = 1, #Config.Stations, 1 do
            local blip = AddBlipForCoord(Config.Stations[i].x, Config.Stations[i].y, Config.Stations[i].z)
            SetBlipSprite(blip, 402)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 47)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(_U('blips_name'))
            EndTextCommandSetBlipName(blip)
        end
    end
    for k, v in pairs(Config.Stations) do
        local point = lib.points.new({ coords = vec3(v.x, v.y, v.z), distance = 50, cost = v.cost })
        function point:nearby()
            local playerPed = PlayerPedId()
            local inVehicle = IsPedInAnyVehicle(playerPed, false)
            if fixing then
                if self.isClosest and self.currentDistance < 2.5 and inVehicle then
                    local sinValue = (math.sin(GetGameTimer() / 500) + 1) / 2
                    local zcoords = -0.4 + (0.9 * sinValue)
                    local mcolor = math.floor(255 * sinValue)
                    DrawMarker(27, self.coords.x, self.coords.y, self.coords.z + zcoords + 0.6, 0.0, 0.0, 0.0, 0, 0.0,
                        0.0, 5.0, 5.0, 1.0, 255, mcolor, 0, 255, false, false, 2, true, false, false, false)
                    DrawMarker(23, self.coords.x, self.coords.y, self.coords.z + zcoords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0,
                        5.0, 1.0, 255, mcolor, 0, 255, false, false, 2, true, false, false, false)
                    DrawMarker(27, self.coords.x, self.coords.y, self.coords.z + zcoords - 0.6, 0.0, 0.0, 0.0, 0, 0.0,
                        0.0, 5.0, 5.0, 1.0, 255, mcolor, 0, 255, false, false, 2, true, false, false, false)
                else
                    if inVehicle then
                        DrawMarker(36, self.coords.x, self.coords.y, self.coords.z + 1.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0,
                            5.0, 1.0, 255, 0, 0, 100, true, true, 2, true, false, false, false)
                        DrawMarker(0, self.coords.x, self.coords.y, self.coords.z - 0.4, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0,
                            5.0, 1.0, 255, 255, 0, 100, false, false, 2, false, false, false, false)
                    end
                end
                if self.textActive then
                    lib.hideTextUI()
                    self.textActive = false
                end
                return
            end
            if inVehicle then
                DrawMarker(36, self.coords.x, self.coords.y, self.coords.z + 1.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 5.0,
                    1.0, 255, 0, 0, 100, true, true, 2, true, false, false, false)
                DrawMarker(0, self.coords.x, self.coords.y, self.coords.z - 0.4, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0, 5.0,
                    1.0, 255, 255, 0, 100, false, false, 2, false, false, false, false)
                if self.isClosest and self.currentDistance < 2.5 then
                    if not self.textActive then
                        if self.cost then
                            lib.showTextUI(_U('press_repair_cost', self.cost))
                        else
                            lib.showTextUI(_U(
                                'press_repair_free'))
                        end
                        self.textActive = true
                    end
                    if IsControlJustPressed(0, 38) then
                        lib.hideTextUI()
                        self.textActive = false
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
                        if GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
                            lib.notify({ title = _U('blips_name'), description = _U('not_driver'), type = 'error' })
                            return
                        end
                        SetPedCoordsKeepVehicle(playerPed, self.coords.x, self.coords.y, self.coords.z)
                        if self.cost then
                            lib.callback('carfixstation:server:payRepair', false,
                                function(success) if success then FixVehicle(vehicle) end end, self.cost)
                        else
                            FixVehicle(
                                vehicle)
                        end
                    end
                elseif self.textActive then
                    lib.hideTextUI()
                    self.textActive = false
                end
            elseif self.textActive then
                lib.hideTextUI()
                self.textActive = false
            end
        end

        function point:onExit()
            if self.textActive then
                lib.hideTextUI()
                self.textActive = false
            end
        end
    end
end)
function FixVehicle(vehicle)
    fixing = true
    FreezeEntityPosition(vehicle, true)
    if Config.EnableSoundEffect then TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'car_repair', 0.7) end
    if lib.progressCircle({ duration = Config.RepairTime, label = _U('repair_processing'), position = 'bottom', useWhileDead = false, canCancel = false, disable = { car = true, move = true, combat = true, } }) then
        local fuelLevel = exports['lc_fuel']:GetFuel(vehicle)
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleDirtLevel(vehicle, 0.0)
        exports['lc_fuel']:SetFuel(vehicle, fuelLevel)
        lib.notify({ title = _U('blips_name'), description = _U('repair_finish'), type = 'success' })
    end
    FreezeEntityPosition(vehicle, false)
    fixing = false
end
