--[[
	Author: Jingah
	Date: 20.02.2015.
	Sells the unit by removing entity and opening squares in BH
]]
function SellBuilding( keys )
	local caster = keys.caster
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	local pID = hero:GetPlayerID()
	local player = PlayerResource:GetPlayer(pID)
	local pos = caster:GetAbsOrigin()
	
	local name = caster:GetUnitName()
	local unit_table = GameRules.UnitKV[name]
	local sellBounty = unit_table.SellBounty

	caster:RemoveBuilding(false)
	
	hero.lumber = hero.lumber + sellBounty
	--print("Lumber Gained. " .. hero:GetUnitName() .. " is currently at " .. hero.lumber)
	FireGameEvent('cgm_player_lumber_changed', { player_ID = pID, lumber = hero.lumber })
end