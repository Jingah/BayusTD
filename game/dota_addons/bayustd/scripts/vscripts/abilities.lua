-- The following three functions are necessary for building helper.

function build( keys )
	local player = keys.caster:GetPlayerOwner()
	local pID = player:GetPlayerID()
	local returnTable = BuildingHelper:AddBuilding(keys)
	--print("Lumber: " .. player.lumber)
	--print("Stone: " .. player.stone)
	-- handle errors if any
	if TableLength(returnTable) > 0 then
		--PrintTable(returnTable)
		if returnTable["error"] == "not_enough_resources" then
			local resourceTable = returnTable["resourceTable"]
			-- resourceTable is like this: {["lumber"] = 3, ["stone"] = 6}
			-- so resourceName = cost-playersResourceAmount
			-- the api searches for player[resourceName]. you need to keep this number updated
			-- throughout your game
			local firstResource = nil
			for k,v in pairs(resourceTable) do
				if not firstResource then
					firstResource = k
				end
				if Debug_BH then
					print("P" .. pID .. " needs " .. v .. " more " .. k .. ".")
				end
			end
			local capitalLetter = firstResource:sub(1,1):upper()
			firstResource = capitalLetter .. firstResource:sub(2)
			FireGameEvent( 'custom_error_show', { player_ID = pID, _error = "Not enough " .. firstResource .. "." } )
			return
		end
	end

	keys:OnBuildingPosChosen(function(vPos)
		--print("OnBuildingPosChosen")
		-- in WC3 some build sound was played here.
	end)

	keys:OnConstructionStarted(function(unit)
		--print("Started construction of " .. unit:GetUnitName())
		-- Unit is the building be built.
		-- Play construction sound
		-- FindClearSpace for the builder
		FindClearSpaceForUnit(keys.caster, keys.caster:GetAbsOrigin(), true)
		-- start the building with 0 mana.
		unit:SetMana(0)
	end)
	keys:OnConstructionCompleted(function(unit)
		--print("Completed construction of " .. unit:GetUnitName())
		-- Play construction complete sound.
		-- Give building its abilities
		-- add the mana
		unit:SetMana(unit:GetMaxMana())
		
		local caster = keys.caster
		local hero = caster:GetPlayerOwner():GetAssignedHero()
		local playerID = hero:GetPlayerID()
		local player = PlayerResource:GetPlayer(playerID)
		local building_name = unit:GetUnitName()
		
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

