function mana_potion( event )
	local mana = event.ability:GetSpecialValueFor("mana_amount")
    event.caster:GiveMana(mana)
end


function tomeUsed( event )
    local hero = event.caster
    local tome = event.ability
	local name = tome:GetAbilityName()
	local playerID = hero:GetPlayerOwnerID()
	
	if name == "item_tome_of_intelligence" then
		hero:ModifyIntellect(1)
	elseif name == "item_tome_of_strength" then
		hero:ModifyStrength(1)
	elseif name == "item_tome_of_agility" then
		hero:ModifyAgility(1)
	elseif name == "item_tome_of_experience" then
		if hero:GetLevel() == 100 then
			PlayerResource:SetGold(playerID, PlayerResource:GetGold(playerID) + 500, true)
			FireGameEvent( 'custom_error_show', { player_ID = playerID, _error = "You are already level 100" } )
			return
		end
		--local lvlxp = XP_PER_LEVEL_TABLE[hero:GetLevel() + 1] - XP_PER_LEVEL_TABLE[hero:GetLevel()]
		hero:AddExperience(500, false, false)
	end
end

function graveyardGold( event )
    local hero = event.caster
	local playerID = hero:GetPlayerOwnerID()
	
	local goldBounty = PlayerResource:GetUnreliableGold(playerID) + 20
	PlayerResource:SetGold(playerID, goldBounty, false)
end

function graveyardLumber( event )
    local hero = event.caster
	local playerID = hero:GetPlayerOwnerID()
	local player = PlayerResource:GetPlayer(playerID)
	
	--.lumber = player.lumber + 15
	GameRules.lumbersList[playerID+1] = GameRules.lumbersList[playerID+1] + 15
	--print("Lumber Gained. " .. PlayerResource:GetPlayerName(playerID) .. " is currently at " .. player.lumber)
	FireGameEvent('cgm_player_lumber_changed', { player_ID = playerID, lumber = GameRules.lumbersList[playerID+1] })
	PopupLumber(player, hero, 15)
end