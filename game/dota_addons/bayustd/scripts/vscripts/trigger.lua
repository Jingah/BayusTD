---------------------------------------------------------------------------
-- Teleport creeps to the battlefield
---------------------------------------------------------------------------
function OnStartTouch(trigger)
	if bayustd:getWave() % 10 ~= 0 then
		ent = Entities:FindByName( nil, "point_teleport_spot" )
	else
		ent = Entities:FindByName( nil, "point_teleport_spot_boss" )
	end
	local unit = trigger.activator
	local name = unit:GetUnitName()
	
	unit:RemoveSelf()
	bayustd:incrementRemovedCreeps()
	
	if bayustd:getRemovedCreeps() == bayustd:getCreeps() then
		print("all creeps teleproted")
		for d = 1, bayustd:getRemovedCreeps(), 1 do
			local point = ent:GetAbsOrigin() + RandomVector(RandomFloat(1, 1500))
			CreateUnitByName(name, point, true, nil, nil, DOTA_TEAM_NEUTRALS)
		end
		GameRules:SendCustomMessage("<font color='#FF0000'>" .. bayustd:getRemovedCreeps() .. "</font> creeps entered the town!", 0, 0)
	end
end

---------------------------------------------------------------------------
-- Teleport creeps to the battlefield
---------------------------------------------------------------------------
--function OnPass(trigger)
--	print("Unit passed path_corner ...")
--	trigger.activator:SetBaseMoveSpeed(500)
--end