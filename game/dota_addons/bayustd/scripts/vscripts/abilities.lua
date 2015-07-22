-- The following three functions are necessary for building helper.

function build( keys )
	local caster = keys.caster
	local hero = caster:GetPlayerOwner():GetAssignedHero()
	local player = keys.caster:GetPlayerOwner()
	local playerID = player:GetPlayerID()

	-- Check if player has enough resources here. If he doesn't they just return this function.
	local ability_name = keys.ability:GetAbilityName()
	local UnitKV = GameRules.UnitKV
	local AbilityKV = GameRules.AbilityKV
	local ItemKV = GameRules.ItemKV
	
	local building_name
	
	if string.find(tostring(ability_name), "item_") then
		--print("Ability is an item")
		building_name = ItemKV[ability_name].UnitName
	else
		--print("Ability isn't an item")
		building_name = AbilityKV[ability_name].UnitName
	end
	
	local unit_table = UnitKV[building_name]
	local lumber_cost = unit_table.LumberCost

	if GameRules.lumbersList[playerID] < lumber_cost then
	--if player.lumber < lumber_cost then
		FireGameEvent( 'custom_error_show', { player_ID = playerID, _error = "Need more Lumber" } )		
		return
	end
	
	local returnTable = BuildingHelper:AddBuilding(keys)

	keys:OnBuildingPosChosen(function(vPos)
		--print("OnBuildingPosChosen")
		-- in WC3 some build sound was played here.
	end)

	keys:OnConstructionStarted(function(unit)
		if Debug_BH then
			print("Started construction of " .. unit:GetUnitName())
		end
		-- Unit is the building be built.
		-- Play construction sound
		-- FindClearSpace for the builder
		FindClearSpaceForUnit(keys.caster, keys.caster:GetAbsOrigin(), true)
		--Remove lumber from player
		GameRules.lumbersList[playerID] = GameRules.lumbersList[playerID]  - lumber_cost
		--player.lumber = player.lumber - lumber_cost
		FireGameEvent('cgm_player_lumber_changed', { player_ID = playerID, lumber = GameRules.lumbersList[playerID] })
		-- start the building with 0 mana.
		unit:SetMana(0)
	end)
	keys:OnConstructionCompleted(function(unit)
		if Debug_BH then
			print("Completed construction of " .. unit:GetUnitName())
		end
		-- Play construction complete sound.
		-- Give building its abilities
		-- add the mana
		unit:SetMana(unit:GetMaxMana())
		
		-- CUSTOM STUFF
		table.insert(player.buildingEntities, unit)
		
		if bayustd:getWave() % 3 == 0 then 	--air levels. Stop ground towers from attacking
			if unit.attackType ~= 0 then
				unit:RemoveModifierByName("modifier_disable_building")
				bayustd:giveUnitDataDrivenModifier(unit, unit, "modifier_enable_building", -1)
			end
		else
			if unit.attackType ~= 1 then
				unit:RemoveModifierByName("modifier_disable_building")
				bayustd:giveUnitDataDrivenModifier(unit, unit, "modifier_enable_building", -1)
			end
		end
		
		-- Add 1 to the player building tracking table for that name
		if not player.buildings[building_name] then
			player.buildings[building_name] = 1
		else
			player.buildings[building_name] = player.buildings[building_name] + 1
		end
		
		-- Update the abilities of the builders
    	for k,builder in pairs(player.builders) do
    		CheckAbilityRequirements( builder, player )
    	end
		-- CUSTOM STUFF
	end)

	-- These callbacks will only fire when the state between below half health/above half health changes.
	-- i.e. it won't unnecessarily fire multiple times.
	keys:OnBelowHalfHealth(function(unit)
		if Debug_BH then
			print(unit:GetUnitName() .. " is below half health.")
		end
	end)

	keys:OnAboveHalfHealth(function(unit)
		if Debug_BH then
			print(unit:GetUnitName() .. " is above half health.")
		end
	end)

	--[[keys:OnCanceled(function()
		print(keys.ability:GetAbilityName() .. " was canceled.")
	end)]]

	-- Have a fire effect when the building goes below 50% health.
	-- It will turn off it building goes above 50% health again.
	keys:EnableFireEffect("modifier_jakiro_liquid_fire_burn")
end

function building_canceled( keys )
	BuildingHelper:CancelBuilding(keys)
end

function create_building_entity( keys )
	BuildingHelper:InitializeBuildingEntity(keys)
end

