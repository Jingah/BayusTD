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

	caster:RemoveBuilding(true)
	if sellBounty ~= 0 then
		player.lumber = player.lumber + sellBounty
		--print("Lumber Gained. " .. hero:GetUnitName() .. " is currently at " .. player.lumber)
		FireGameEvent('cgm_player_lumber_changed', { player_ID = pID, lumber = player.lumber })
		PopupLumber(caster, sellBounty)
	end
end

function UpgradeBuilding( keys )
	local caster = keys.caster
	local pID = caster:GetPlayerOwnerID()
	local player = PlayerResource:GetPlayer(pID)
	local pos = caster:GetAbsOrigin()
	local hero = PlayerResource:GetSelectedHeroEntity(pID)
	
	
	caster:RemoveBuilding(true)
	
	--caster:RemoveSelf()
	unit = CreateUnitByName(keys.Building, pos, false, hero, nil, hero:GetTeamNumber())
	unit:SetOwner(hero)
	unit:SetControllableByPlayer(pID, true)
	unit:SetAbsOrigin(pos)
	
	player.lumber = player.lumber - keys.LumberCost
	--print("Lumber Spend. " .. hero:GetUnitName() .. " is currently at " .. player.lumber)
	FireGameEvent('cgm_player_lumber_changed', { player_ID = pID, lumber = player.lumber })
end