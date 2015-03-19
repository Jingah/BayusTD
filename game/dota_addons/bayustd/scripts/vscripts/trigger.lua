---------------------------------------------------------------------------
-- Teleport creeps to the battlefield
---------------------------------------------------------------------------
function OnStartTouch(trigger)
	local unit = trigger.activator
	local name = unit:GetUnitName()
	
	unit:RemoveSelf()
	bayustd:incrementRemovedCreeps()
	
	if bayustd:getRemovedCreeps() == bayustd:getCreeps() then
		print("all creeps teleproted")
		for d = 1, bayustd:getRemovedCreeps(), 1 do
			--local point = ent:GetAbsOrigin() + RandomVector(RandomFloat(1, 1400))
			--CreateUnitByName(name, point, true, nil, nil, DOTA_TEAM_NEUTRALS)
			if bayustd:getWave() % 10 ~= 0 then
				CreateUnitByName(name, bayustd:RandomSpawnPosition(), true, nil, nil, DOTA_TEAM_NEUTRALS)
			else
				CreateUnitByName(name, Entities:FindByName( nil, "point_teleport_spot_boss" ):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
			end
		end
		GameRules:SendCustomMessage("<font color='#FF0000'>" .. bayustd:getRemovedCreeps() .. "</font> creeps entered the town!", 0, 0)
	end
end