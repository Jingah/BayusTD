---------------------------------------------------------------------------
-- Teleport creeps to the battlefield
---------------------------------------------------------------------------
function OnStartTouch(trigger)
	local ent = Entities:FindByName( nil, "point_teleport_spot" )
	local point = ent:GetAbsOrigin()
	
	FindClearSpaceForUnit(trigger.activator, point, false)
	trigger.activator:SetInitialGoalEntity(ent)
	trigger.activator:Stop()
	bayustd:incrementTeleportedCreeps()
	
	if bayustd:getTeleportedCreeps() == bayustd:getCreeps() then
		print("all creeps teleproted")
		for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			if PlayerResource:HasSelectedHero(nPlayerID) then
				local hero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
				giveUnitDataDrivenModifier(hero, hero, "modifier_enable_hero", -1)
				GameRules:SendCustomMessage("<font color='#FF0000'>" .. bayustd:getTeleportedCreeps() .. "</font> creeps entered the city!", 0, 0)
			end
	   end
	end
end

---------------------------------------------------------------------------
-- Teleport creeps to the battlefield
---------------------------------------------------------------------------
--function OnPass(trigger)
--	print("Unit passed path_corner ...")
--	trigger.activator:SetBaseMoveSpeed(500)
--end