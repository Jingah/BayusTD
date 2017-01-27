-- A build ability is used (not yet confirmed)
function Build( event )
    local caster = event.caster
    local ability = event.ability
    local ability_name = ability:GetAbilityName()
    local building_name = ability:GetAbilityKeyValues()['UnitName']
    local gold_cost = ability:GetGoldCost(1) 
    local hero = caster:IsRealHero() and caster or caster:GetOwner()
    local playerID = hero:GetPlayerID()
	local player = PlayerResource:GetPlayer(playerID)
	
	local UnitKV = GameRules.UnitKV
	local unit_table = UnitKV[building_name]
	local lumber_cost = unit_table.LumberCost

    -- If the ability has an AbilityGoldCost, it's impossible to not have enough gold the first time it's cast
    -- Always refund the gold here, as the building hasn't been placed yet
   -- hero:ModifyGold(gold_cost, false, 0)

    -- Makes a building dummy and starts panorama ghosting
    BuildingHelper:AddBuilding(event)

    -- Additional checks to confirm a valid building position can be performed here
    event:OnPreConstruction(function(vPos)

        -- Check for minimum height if defined
        if not BuildingHelper:MeetsHeightCondition(vPos) then
            BuildingHelper:print("Failed placement of " .. building_name .." - Placement is below the min height required")
            SendErrorMessage(playerID, "Wrong building position")
            return false
        end

        -- If not enough resources to queue, stop
        --[[if PlayerResource:GetGold(playerID) < gold_cost then
            BuildingHelper:print("Failed placement of " .. building_name .." - Not enough gold!")
            SendErrorMessage(playerID, "#error_not_enough_gold")
            return false
        end]]--
		print('Lumber: ' .. GameRules.lumbersList[playerID+1])
		if GameRules.lumbersList[playerID+1] < lumber_cost then
			BuildingHelper:print("Failed placement of " .. building_name .." - Not enough lumber!")
            SendErrorMessage(playerID, "You have not enough lumber")
            return false
		end

        return true
    end)

    -- Position for a building was confirmed and valid
    event:OnBuildingPosChosen(function(vPos)
        -- Spend resources
		GameRules.lumbersList[playerID+1] = GameRules.lumbersList[playerID+1] - lumber_cost
        CustomGameEventManager:Send_ServerToPlayer(player, "cgm_player_lumber_changed", { lumber = GameRules.lumbersList[playerID+1] })

        -- Play a sound
        EmitSoundOnClient("DOTA_Item.ObserverWard.Activate", PlayerResource:GetPlayer(playerID))
    end)

    -- The construction failed and was never confirmed due to the gridnav being blocked in the attempted area
    event:OnConstructionFailed(function()
        local playerTable = BuildingHelper:GetPlayerTable(playerID)
        local building_name = playerTable.activeBuilding

        BuildingHelper:print("Failed placement of " .. building_name)
    end)

    -- Cancelled due to ClearQueue
    event:OnConstructionCancelled(function(work)
        local building_name = work.name
        BuildingHelper:print("Cancelled construction of " .. building_name)

        -- Refund resources for this cancelled work
        if work.refund then
			GameRules.lumbersList[playerID+1] = GameRules.lumbersList[playerID+1] + lumber_cost
            CustomGameEventManager:Send_ServerToPlayer(player, "cgm_player_lumber_changed", { lumber = GameRules.lumbersList[playerID+1] })
        end
    end)

    -- A building unit was created
    event:OnConstructionStarted(function(unit)
        BuildingHelper:print("Started construction of " .. unit:GetUnitName() .. " " .. unit:GetEntityIndex())
        -- Play construction sound
		bayustd:giveUnitDataDrivenModifier(unit, unit, "modifier_protect_builder", -1)
		bayustd:giveUnitDataDrivenModifier(unit, unit, "modifier_disable_building", -1)

        -- If it's an item-ability and has charges, remove a charge or remove the item if no charges left
        if ability.GetCurrentCharges and not ability:IsPermanent() then
            local charges = ability:GetCurrentCharges()
            charges = charges-1
            if charges == 0 then
                ability:RemoveSelf()
            else
                ability:SetCurrentCharges(charges)
            end
        end

        -- Units can't attack while building
        unit.original_attack = unit:GetAttackCapability()
        unit:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)

        -- Give item to cancel
        unit.item_building_cancel = CreateItem("item_building_cancel", hero, hero)
        if unit.item_building_cancel then 
            unit:AddItem(unit.item_building_cancel)
            unit.lumber_cost = lumber_cost
        end

        -- FindClearSpace for the builder
        FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
        caster:AddNewModifier(caster, nil, "modifier_phased", {duration=0.03})

        -- Remove invulnerability on npc_dota_building baseclass
        unit:RemoveModifierByName("modifier_invulnerable")
    end)

    -- A building finished construction
    event:OnConstructionCompleted(function(unit)
        BuildingHelper:print("Completed construction of " .. unit:GetUnitName() .. " " .. unit:GetEntityIndex())
        
        -- Play construction complete sound
        
        -- Remove the item
        if unit.item_building_cancel then
            UTIL_Remove(unit.item_building_cancel)
        end

        -- Give the unit their original attack capability
        unit:SetAttackCapability(unit.original_attack)
		
		-- CUSTOM STUFF
		table.insert(GameRules.buildingEntities[playerID+1], unit)
		
		if bayustd:getWave() % 3 == 0 then 	--air levels. Stop ground towers from attacking
			if unit.buildingTable.AttackType ~= 0 then
				unit:RemoveModifierByName("modifier_disable_building")
				bayustd:giveUnitDataDrivenModifier(unit, unit, "modifier_enable_building", -1)
			end
		else
			if unit.buildingTable.AttackType ~= 1 then
				unit:RemoveModifierByName("modifier_disable_building")
				bayustd:giveUnitDataDrivenModifier(unit, unit, "modifier_enable_building", -1)
			end
		end
		
		if not GameRules.buildings[playerID+1][building_name] then
 			GameRules.buildings[playerID+1][building_name] = 1
 		else
 			GameRules.buildings[playerID+1][building_name] = GameRules.buildings[playerID+1][building_name] + 1
 		end
		
		-- Update the abilities of the builders
    	CheckAbilityRequirements(GameRules.builders[playerID+1], player)
		-- CUSTOM STUFF

    end)

    -- These callbacks will only fire when the state between below half health/above half health changes.
    -- i.e. it won't fire multiple times unnecessarily.
    event:OnBelowHalfHealth(function(unit)
        BuildingHelper:print(unit:GetUnitName() .. " is below half health.")
    end)

    event:OnAboveHalfHealth(function(unit)
        BuildingHelper:print(unit:GetUnitName().. " is above half health.")        
    end)
end

-- Called when the Cancel ability-item is used
function CancelBuilding( keys )
    local building = keys.unit
    local hero = building:GetOwner()
    local playerID = building:GetPlayerOwnerID()
	local player = PlayerResource:GetPlayer(playerID)

    BuildingHelper:print("CancelBuilding "..building:GetUnitName().." "..building:GetEntityIndex())

    -- Refund here
    if building.lumber_cost then
		GameRules.lumbersList[playerID+1] = GameRules.lumbersList[playerID+1] + lumber_cost
        CustomGameEventManager:Send_ServerToPlayer(player, "cgm_player_lumber_changed", { lumber = GameRules.lumbersList[playerID+1] })
    end

    -- Eject builder
    local builder = building.builder_inside
    if builder then
        BuildingHelper:ShowBuilder(builder)
    end

    building:ForceKill(true) --This will call RemoveBuilding
end

function SellBuilding( keys ) 
	local unit = keys.unit
	local building = unit.buildingTable
    local playerID = unit:GetPlayerOwnerID()
	local player = PlayerResource:GetPlayer(playerID)
    local building_name = building.UnitName
	
	local UnitKV = GameRules.UnitKV
	local unit_table = UnitKV[building_name]
	local sell_bounty = unit_table.SellBounty
	
	for i, v in ipairs(GameRules.buildingEntities[playerID+1]) do 
 		if v == caster then
 			print("Deleted building from table")
 			--table.remove(player.buildingEntities, i)
 		end
 		--PrintTable( player.buildingEntities )
 	end
	
	 -- Refund here
    if sell_bounty then
		GameRules.lumbersList[playerID+1] = GameRules.lumbersList[playerID+1] + sell_bounty
        CustomGameEventManager:Send_ServerToPlayer(player, "cgm_player_lumber_changed", { lumber = GameRules.lumbersList[playerID+1] })
    end
	
	unit:ForceKill(true) --This will call RemoveBuilding
end

-- Requires notifications library from bmddota/barebones
function SendErrorMessage( pID, string )
    Notifications:ClearBottom(pID)
    Notifications:Bottom(pID, {text=string, style={color='#E62020'}, duration=2})
    EmitSoundOnClient("General.Cancel", PlayerResource:GetPlayer(pID))
end
