--[[
	Author: Jingah
	Date: 16.02.2015
	
	Credits to MNoya for Lumber UI
	Credits to Myll & MNoya for BuildingHelper
]]

print ('[BAYUSTD] bayustd.lua' )


----------------

ENABLE_HERO_RESPAWN = false              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = false             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = true        -- Should we let people select the same hero as each other

HERO_SELECTION_TIME = 30.0              -- How long should we let people select their hero?
PRE_GAME_TIME = 10.0                  -- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0                   -- How long should we let people look at the scoreboard before closing the server automatically?
TREE_REGROW_TIME = 1.0                 -- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 0                   	-- How much gold should players get per tick?
GOLD_TICK_TIME = 5                      -- How long should we wait in seconds between gold ticks?

RECOMMENDED_BUILDS_DISABLED = true     -- Should we disable the recommened builds for heroes (Note: this is not working currently I believe)
CAMERA_DISTANCE_OVERRIDE = 1600       -- How far out should we allow the camera to go?  1134 is the default in Dota

MINIMAP_ICON_SIZE = 1                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1              -- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120                    -- How long in seconds should we wait between rune spawns?
CUSTOM_BUYBACK_COST_ENABLED = true      -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = true  -- Should we use a custom buyback time?
BUYBACK_ENABLED = false                 -- Should we allow people to buyback when they die?

DISABLE_FOG_OF_WAR_ENTIRELY = false      -- Should we disable fog of war entirely for both teams?
--USE_STANDARD_DOTA_BOT_THINKING = false  -- Should we have bots act like they would in Dota? (This requires 3 lanes, normal items, etc)
USE_STANDARD_HERO_GOLD_BOUNTY = true    -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?

USE_CUSTOM_TOP_BAR_VALUES = true        -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = true             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = false-- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players get gold?

END_GAME_ON_KILLS = false                -- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 50         -- How many kills for a team should signify an end of game?

USE_CUSTOM_HERO_LEVELS = true           -- Should we allow heroes to have custom levels?
MAX_LEVEL = 40                          -- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = true             -- Should we use custom XP values to level up heroes, or the default Dota numbers?

BAYUSTD_VERSION = "1.1"

OutOfWorldVector = Vector(9000,9000,-100)

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {}
for i=1,MAX_LEVEL do
	XP_PER_LEVEL_TABLE[i] = i * 100
end

-- Generated from template
if bayustd == nil then
	print ( '[BAYUSTD] creating bayustd game mode' )
	bayustd = class({})
end


--[[
This function should be used to set up Async precache calls at the beginning of the game.  The Precache() function 
in addon_game_mode.lua used to and may still sometimes have issues with client's appropriately precaching stuff.
If this occurs it causes the client to never precache things configured in that block.
In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
defined on the unit.
This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
time, you can call the functions individually (for example if you want to precache units in a new wave of
holdout).
]]
function bayustd:PostLoadPrecache()
		print("[BAYUSTD] Performing Post-Load precache")
		--PrecacheUnitByNameAsync("npc_precache_everything", function(...) end)
end

--[[
This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
It can be used to initialize state that isn't initializeable in Initbayustd() but needs to be done before everyone loads in.
]]
function bayustd:OnFirstPlayerLoaded()
	print("[BAYUSTD] First Player has loaded")
	CreateUnitByName("npc_dota_fountain", Vector(-6784,4352,128), false, nil, nil, DOTA_TEAM_GOODGUYS)
end

--[[
This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function bayustd:OnAllPlayersLoaded()
	print("[BAYUSTD] All Players have loaded into the game")
	-- Reassign all the players to the Radiant Team
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		if PlayerResource:IsValidPlayer(nPlayerID) and not PlayerResource:IsBroadcaster(nPlayerID) then 
			PlayerResource:SetCustomTeamAssignment(nPlayerID, DOTA_TEAM_GOODGUYS )
		end
	end
end

--[[
This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
levels, changing the starting gold, removing/adding abilities, adding physics, etc.
The hero parameter is the hero entity that just spawned in
]]
function bayustd:OnHeroInGame(hero)
	print("[BAYUSTD] Hero spawned in game for first time -- " .. hero:GetUnitName())
	local pID = hero:GetPlayerID()
	
	local player = PlayerResource:GetPlayer(pID)
	
	--[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
	--with the "example_ability" ability
	local abil = hero:GetAbilityByIndex(1)
	hero:RemoveAbility(abil:GetAbilityName())
	hero:AddAbility("example_ability")]]
end

--[[
This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function bayustd:OnGameInProgress()
	print("[BAYUSTD] The game has officially begun")

	Timers:CreateTimer(30, -- Start this timer 30 game-time seconds later
		function()
			print("This function is called 30 seconds after the game begins, and every 30 seconds thereafter")
			return 30.0 -- Rerun this timer every 30 game-time seconds 
		end)
end

-- An NPC has spawned somewhere in game.  This includes heroes
function bayustd:OnNPCSpawned(keys)
	--print("[bayustd] NPC Spawned")
	--PrintTable(keys)
	local npc = EntIndexToHScript(keys.entindex)

	if npc:IsRealHero() and npc.bFirstSpawned == nil then
		npc.bFirstSpawned = true
	end
end

-- The overall game state has changed
function bayustd:OnPlayerPickHero(keys)
	print("Player picked hero")
	--DeepPrintTable(keys)
	
	local hero = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
	local playerID = hero:GetPlayerID()
	local point =  Entities:FindByName( nil, "builder_spawns" .. playerID):GetAbsOrigin()
	
	-- This line for example will set the starting gold of every hero to 500 unreliable gold
	hero:SetGold(300, false)
	
	player.lumber = 50
	print("Lumber Gained. " .. hero:GetUnitName() .. " is currently at " .. player.lumber)
    FireGameEvent('cgm_player_lumber_changed', { player_ID = playerID, lumber = player.lumber })
	
	GameRules.PLAYERS_PICKED = GameRules.PLAYERS_PICKED + 1

	if GameRules.PLAYERS_PICKED == GameRules.TOTAL_PLAYERS then 
		self:OnEveryonePicked()
	end
	
	--TODO: Ensure correct Builder
	local number = RandomInt(1, 4)
	local builder = CreateUnitByName("npc_dota_builder" .. number, point, true, nil, nil, DOTA_TEAM_GOODGUYS)
	builder:SetOwner(hero)
	builder:SetControllableByPlayer(playerID, true)
	bayustd:giveUnitDataDrivenModifier(builder, builder, "modifier_protect_builder", -1)
	player.isDead = nil
	
end

function bayustd:OnEveryonePicked()
    GameRules:SendCustomMessage("Welcome to <font color='#2EFE2E'>Bayus TD!</font>", 0, 0)
    GameRules:SendCustomMessage("Created by <font color='#2EFE2E'>Jingah</font>", 0, 0)
	GameRules:SendCustomMessage("Idea from original Warcraft 3 Map",0,0)
    GameRules:SendCustomMessage("Version: " .. BAYUSTD_VERSION, 0, 0)
    GameRules:SendCustomMessage("Please report bugs and leave feedback in our workshop page", 0, 0)
end

mode = nil

-- This function is called as the first player loads and sets up the bayustd parameters
function bayustd:CaptureBayusTD()
	if mode == nil then
		-- Set bayustd parameters
		mode = GameRules:GetGameModeEntity()
		mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
		mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
		mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
		mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
		mode:SetBuybackEnabled( BUYBACK_ENABLED )
		mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
		mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
		mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
		mode:SetCustomHeroMaxLevel ( MAX_LEVEL )
		mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

		--mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
		mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

		mode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
		mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
		mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )
		
		mode:SetHUDVisible(9, false)  -- Disable courier hud. Is replaced by lumber count

		self:OnFirstPlayerLoaded()
	end
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function bayustd:OnConnectFull(keys)
	--print ('[bayustd] OnConnectFull')
	--PrintTable(keys)
	bayustd:CaptureBayusTD()
	
	GameRules.TOTAL_PLAYERS = GameRules.TOTAL_PLAYERS + 1

	local entIndex = keys.index+1
	-- The Player entity of the joining user
	local ply = EntIndexToHScript(entIndex)

	-- The Player ID of the joining player
	local playerID = ply:GetPlayerID()

	-- Update the user ID table with this user
	self.vUserIds[keys.userid] = ply

	-- Update the Steam ID table
	self.vSteamIds[PlayerResource:GetSteamAccountID(playerID)] = ply

	-- If the player is a broadcaster flag it in the Broadcasters table
	if PlayerResource:IsBroadcaster(playerID) then
		self.vBroadcasters[keys.userid] = 1
		return
	end
end

-- An ability was used by a player
function bayustd:OnAbilityUsed(keys)
	--print('[BAYUSTD] AbilityUsed')
	--PrintTable(keys)

	local player = EntIndexToHScript(keys.PlayerID)
	local abilityname = keys.abilityname
	local hero = player:GetAssignedHero()

	-- Cancel the ghost if the player casts another active ability.
	-- Start of BH Snippet:
	if hero ~= nil then
		local abil = hero:FindAbilityByName(abilityname)
		if player.cursorStream ~= nil then
			if not (string.len(abilityname) > 14 and string.sub(abilityname,1,14) == "move_to_point_") then
				if not DontCancelBuildingGhostAbils[abilityname] then
					player.cancelBuilding = true
				else
					print(abilityname .. " did not cancel building ghost.")
				end
			end
		end
	end
	-- End of BH Snippet
end

-- Cleanup a player when they leave
function bayustd:OnDisconnect(keys)
	--print('[bayustd] Player Disconnected ' .. tostring(keys.userid))
	--PrintTable(keys)

	local name = keys.name
	local networkid = keys.networkid
	local reason = keys.reason
	local userid = keys.userid
end

-- An item was picked up off the ground
function bayustd:OnItemPickedUp(keys)
	print ( '[DOTACRAFT] OnItemPickedUp' )
	--DeepPrintTable(keys)

	local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local hero = player:GetAssignedHero()
	local itemname = keys.itemname
	
	
	--[[Currently not possible with units other than heroes
	if itemname == "item_graveyard_gold" then
		PlayerResource:SetGold(keys.PlayerID, 10, true)
		player:RemoveItem(itemEntity)
	elseif itemname == "npc_dota_lumber" then
		hero.lumber = hero.lumber + 10
		--print("Lumber Gained. " .. hero:GetUnitName() .. " is currently at " .. hero.lumber)
		FireGameEvent('cgm_player_lumber_changed', { player_ID = keys.PlayerID, lumber = hero.lumber })
		player:RemoveItem(itemEntity)
	end--]]
end

-- An item was purchased by a player
function bayustd:OnItemPurchased( keys )
	print ( '[DOTACRAFT] OnItemPurchased' )
	--DeepPrintTable(keys)

	-- The playerID of the hero who is buying something
	local plyID = keys.PlayerID
	if not plyID then return end

	local player = PlayerResource:GetPlayer(plyID)
	
	-- The name of the item purchased
	local itemName = keys.itemname 

	-- The cost of the item purchased
	local itemcost = keys.itemcost
	
	local hero = player:GetAssignedHero()
	local baseInt = hero:GetBaseIntellect()
	local baseStr = hero:GetBaseStrength()
	local baseAgi = hero:GetBaseAgility()
	
	if itemName == "item_tome_of_intelligence" then
		hero:ModifyIntellect(1)
	elseif itemName == "item_tome_of_strength" then
		hero:ModifyStrength(1)
	elseif itemName == "item_tome_of_agility" then
		hero:ModifyAgility(1)
	elseif itemName == "item_tome_of_experience" then
		hero:HeroLevelUp(true)
	else
		return
	end
	
    for i=0,5 do
		local item = hero:GetItemInSlot(i)
		if item ~= nil and (item:GetName() == "item_tome_of_intelligence" or item:GetName() == "item_tome_of_strength" or item:GetName() == "item_tome_of_agility" or item:GetName() == "item_tome_of_experience") then
			hero:RemoveItem(item)
			break
		end
    end

end


-- The overall game state has changed
function bayustd:OnGameRulesStateChange(keys)
	
	--DeepPrintTable(keys)

	local newState = GameRules:State_Get()
	print("[BAYUSTD] GameRules State Changed to " .. newState)
	if newState == DOTA_GAMERULES_STATE_HERO_SELECTION  then
		bayustd:OnAllPlayersLoaded()
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		bayustd:SpawnCreeps()
	end
end



creepsCount = 0
wave = 1
firstGhost = false

-- An entity died
function bayustd:OnEntityKilled( keys )
	--print( '[bayustd] OnEntityKilled Called' )
	--PrintTable( keys )

	-- The Unit that was Killed
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	-- The Killing entity
	
	local killerEntity = nil
	
	if keys.entindex_attacker ~= nil then
		killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end

	if killedUnit:IsOwnedByAnyPlayer() then
		pID = killedUnit:GetPlayerOwnerID()
	else
		pID = killerEntity:GetPlayerOwnerID()
	end
	local player = PlayerResource:GetPlayer(pID)
	local hero = PlayerResource:GetSelectedHeroEntity(pID)
	if hero == nil then
		hero = player:GetAssignedHero()
	end
	
	if killedUnit:IsRealHero() then
		self.nDireKills = self.nDireKills + 1
		--[[GameRules.DEAD_PLAYER_COUNT = GameRules.DEAD_PLAYER_COUNT + 1
		if GameRules.DEAD_PLAYER_COUNT == GameRules.TOTAL_PLAYERS then
			local messageinfo = { message = "YOU SUCKED", duration = 5}
			FireGameEvent("show_center_message",messageinfo)
			bayustd:PrintEndgameMessage()
			Timers:CreateTimer(15, function() GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS) end)	
		end--]]
		firstGhost = true
		local lostGold = PlayerResource:GetGoldLostToDeath(pID)
		PlayerResource:SetGold(pID, lostGold, true)
		player.isDead = 0
		local point = Entities:FindByName( nil, "graveyard_pos0" ):GetAbsOrigin()
		player.ghost = CreateUnitByName("npc_dota_ghost", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
		player.ghost:SetOwner(hero)
		player.ghost:SetControllableByPlayer(pID, true)
		bayustd:giveUnitDataDrivenModifier(player.ghost, player.ghost, "modifier_protect_builder", -1)
	end
	
	if killedUnit:GetUnitName() == "npc_dota_wave20" then
		ScreenShake(killerEntity:GetAbsOrigin(), 50.0, 50.0, 5.0, 9000, 0, true)
		PlayerResource:SetCameraTarget(killerEntity:GetPlayerOwnerID(), killedUnit)
		EmitGlobalSound("diretide_roshdeath_Stinger")
		GameRules:SendCustomMessage("<br>BEHOLD HEROES!!<br>You defeated your town.",0,0)
		local messageinfo = { message = "YOU DEFEATED", duration = 5}
		FireGameEvent("show_center_message",messageinfo)
		bayustd:PrintEndgameMessage()
		Timers:CreateTimer(15, function() GameRules:MakeTeamLose( DOTA_TEAM_BADGUYS) end)
	end
	
	if killedUnit:GetTeam() == DOTA_TEAM_NEUTRALS then
		local name = killedUnit:GetUnitName()
		local unit_table = GameRules.UnitKV[name]
		local bountyLumber = unit_table.BountyLumber
		local playerKills = PlayerResource:GetKills(pID)

		player.lumber = player.lumber + bountyLumber
		--print("Lumber Gained. " .. hero:GetUnitName() .. " is currently at " .. player.lumber)
		FireGameEvent('cgm_player_lumber_changed', { player_ID = pID, lumber = player.lumber })
		PopupLumber(killedUnit, bountyLumber)
		
		if name == "npc_dota_lumber" or name == "npc_dota_gold" then
			return
		end
		if name == "npc_dota_wave10" then
			for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
				if PlayerResource:HasSelectedHero(nPlayerID) then					
					PlayerResource:SetGold(nPlayerID, 2500, true)
				end
			end
		elseif name == "npc_dota_wave20" then
			for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
				if PlayerResource:HasSelectedHero(nPlayerID) then					
					PlayerResource:SetGold(nPlayerID, 4500, true)
				end
			end
		elseif name == "npc_dota_wave30" then
			for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
				if PlayerResource:HasSelectedHero(nPlayerID) then					
					PlayerResource:SetGold(nPlayerID, 6500, true)
				end
			end
		end
			
		PlayerResource:IncrementKills(pID, playerKills + 1)
		self.nRadiantKills = self.nRadiantKills + 1
		
		creepsCount = creepsCount - 1
		
		if creepsCount == 0 then
			for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
				if PlayerResource:HasSelectedHero(nPlayerID) then
					local nPlayer = PlayerResource:GetPlayer(nPlayerID)
					if nPlayer.isDead ~= nil then
						if nPlayer.isDead == 2 then
							nPlayer.ghost:RemoveSelf()
							nPlayer:GetAssignedHero():RespawnHero(false, false, false)
							nPlayer.isDead = nil
							GameRules.DEAD_PLAYER_COUNT = GameRules.DEAD_PLAYER_COUNT - 1
						end
						nPlayer.isDead = nPlayer.isDead + 1
					end
					
					nPlayer.lumber = nPlayer.lumber + 100
					FireGameEvent('cgm_player_lumber_changed', { player_ID = nPlayerID, lumber = nPlayer.lumber })
					
					PlayerResource:SetGold(nPlayerID, 100, true)
				end
			end
			print("All creeps are dead")
			bayustd:setRemovedCreeps(0)
			local a = 20
			Timers:CreateTimer(function()
				GameRules:SendCustomMessage("Round " .. wave .. " in <font color='#FF0000'>" .. a .. "</font> seconds!", 0, 0)
				a = a - 1
				if a == 0 then
					bayustd:SpawnCreeps()
					return
				end
				return 1
			 end
			 )
			end
	end

	GameRules:GetGameModeEntity():SetTopBarTeamValue( DOTA_TEAM_BADGUYS, self.nDireKills )
    GameRules:GetGameModeEntity():SetTopBarTeamValue( DOTA_TEAM_GOODGUYS, self.nRadiantKills )
end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function bayustd:Initbayustd()
	bayustd = self
	print('[BAYUSTD] Starting to load bayustd gamemode...')

	-- Setup rules
	GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
	GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
	GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	GameRules:SetPreGameTime( PRE_GAME_TIME)
	GameRules:SetPostGameTime( POST_GAME_TIME )
	GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
	GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
	GameRules:SetGoldPerTick(GOLD_PER_TICK)
	GameRules:SetGoldTickTime(GOLD_TICK_TIME)
	GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
	GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
	GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
	GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
	GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )
	print('[BAYUSTD] GameRules set')
	
	GameRules.PLAYERS_PICKED = 0
	GameRules.TOTAL_PLAYERS = 0
	GameRules.DEAD_PLAYER_COUNT = 0

	InitLogFile( "log/bayustd.txt","")

	---------------------------------------------------------------------------
	
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( bayustd, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(bayustd, 'OnDisconnect'), self)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(bayustd, 'OnPlayerPickHero'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(bayustd, 'OnAbilityUsed'), self)
	--ListenToGameEvent('npc_spawned', Dynamic_Wrap(bayustd, 'OnNPCSpawned'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(bayustd, 'OnConnectFull'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(bayustd, 'OnEntityKilled'), self)
	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(bayustd, 'OnItemPurchased'), self)

	--ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(bayustd, 'OnItemPickedUp'), self)
	
	--[[ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(bayustd, 'OnPlayerLevelUp'), self)
	ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(bayustd, 'OnAbilityChannelFinished'), self)
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(bayustd, 'OnPlayerLearnedAbility'), self)
	
	
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(bayustd, 'OnDisconnect'), self)
	
	ListenToGameEvent('last_hit', Dynamic_Wrap(bayustd, 'OnLastHit'), self)
	ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(bayustd, 'OnNonPlayerUsedAbility'), self)
	ListenToGameEvent('player_changename', Dynamic_Wrap(bayustd, 'OnPlayerChangedName'), self)
	ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(bayustd, 'OnRuneActivated'), self)
	ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(bayustd, 'OnPlayerTakeTowerDamage'), self)
	ListenToGameEvent('tree_cut', Dynamic_Wrap(bayustd, 'OnTreeCut'), self)
	ListenToGameEvent('entity_hurt', Dynamic_Wrap(bayustd, 'OnEntityHurt'), self)
	ListenToGameEvent('player_connect', Dynamic_Wrap(bayustd, 'PlayerConnect'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(bayustd, 'OnAbilityUsed'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(bayustd, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(bayustd, 'OnTeamKillCredit'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(bayustd, 'OnPlayerReconnect'), self)
	--ListenToGameEvent('player_spawn', Dynamic_Wrap(bayustd, 'OnPlayerSpawn'), self)
	--ListenToGameEvent('dota_unit_event', Dynamic_Wrap(bayustd, 'OnDotaUnitEvent'), self)
	--ListenToGameEvent('nommed_tree', Dynamic_Wrap(bayustd, 'OnPlayerAteTree'), self)
	--ListenToGameEvent('player_completed_game', Dynamic_Wrap(bayustd, 'OnPlayerCompletedGame'), self)
	--ListenToGameEvent('dota_match_done', Dynamic_Wrap(bayustd, 'OnDotaMatchDone'), self)
	--ListenToGameEvent('dota_combatlog', Dynamic_Wrap(bayustd, 'OnCombatLogEvent'), self)
	--ListenToGameEvent('dota_player_killed', Dynamic_Wrap(bayustd, 'OnPlayerKilled'), self)
	--ListenToGameEvent('player_team', Dynamic_Wrap(bayustd, 'OnPlayerTeam'), self)
]]--
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 ) 
	GameRules:GetGameModeEntity():SetThink( "OnGraveyardThink", self)
	
	
	-- Event Hooks
	-- All of these events can potentially be fired by the game, though only the uncommented ones have had
	-- Functions supplied for them.  If you are interested in the other events, you can uncomment the
	-- ListenToGameEvent line and add a function to handle the event

	-- Full units file to get the custom values
  	GameRules.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")

	-- Initialized tables for tracking state
	self.vUserIds = {}
	self.vSteamIds = {}
	self.vBots = {}
	self.vBroadcasters = {}

	self.vPlayers = {}
	self.vRadiant = {}
	self.vDire = {}

	self.nRadiantKills = 0
	self.nDireKills = 0

	self.bSeenWaitForPlayers = false
	
  	-- Building Helper by Myll
  	BuildingHelper:Init(8192) -- nHalfMapLength
	-- Prevent Builder from building on lanes
	BuildingHelper:BlockRectangularArea(Vector(-704,-6784,0), Vector(448,3008,192))
	BuildingHelper:BlockRectangularArea(Vector(-8192,-8192,128), Vector(8192,-6784,192))
	BuildingHelper:BlockRectangularArea(Vector(-7360,-6784,128), Vector(-6720,-64,192))
	BuildingHelper:BlockRectangularArea(Vector(-6720,-960,128), Vector(7104,-64,192))
	BuildingHelper:BlockRectangularArea(Vector(6464,-6784,128), Vector(7104,-960,192))
	BuildingHelper:BlockRectangularArea(Vector(1856,-3264,128), Vector(6464,-2624,192))
	BuildingHelper:BlockRectangularArea(Vector(4160,-6784,128), Vector(4800,-3264,192))
	BuildingHelper:BlockRectangularArea(Vector(1856,-6784,128), Vector(2496,-3264,192))
	BuildingHelper:BlockRectangularArea(Vector(-6720,-3264,128), Vector(-2112,-2624,192))
	BuildingHelper:BlockRectangularArea(Vector(-5056,-6784,128), Vector(-4416,-3264,192))
	BuildingHelper:BlockRectangularArea(Vector(-2752,-6784,128), Vector(-2112,-3264,192))
	BuildingHelper:BlockRectangularArea(Vector(-1216,1088,0), Vector(1088,1856,192))
	
	
	print('[BAYUSTD] Done loading bayusTD gamemode!\n\n')
end

-- Spawn gold and lumber on the graveyard (every 10 sec)
function bayustd:OnGraveyardThink()
	if firstGhost then
		
		pos_gold = RandomInt(1, 2)
		pos_lumber = RandomInt(3, 4)
		local point_gold = Entities:FindByName( nil, "graveyard_pos" .. pos_gold):GetAbsOrigin() + RandomVector(RandomFloat(1, 800))
		local point_lumber = Entities:FindByName( nil, "graveyard_pos" .. pos_lumber):GetAbsOrigin() + RandomVector(RandomFloat(1, 800))
		local gold = CreateUnitByName("npc_dota_gold", point_gold, true, nil, nil, DOTA_TEAM_NEUTRALS)
		local lumber = CreateUnitByName("npc_dota_lumber", point_lumber, true, nil, nil, DOTA_TEAM_NEUTRALS)
		
		--TODO: Set gold and lumber as an item 
		--local gold = CreateItem("item_graveyard_gold", nil, nil)
		--local lumber = CreateItem("item_graveyard_lumber", nil, nil)
		--CreateItemOnPositionSync(point_lumber, lumber)
		--CreateItemOnPositionSync(point_lumber, gold)
		return 60
	end
	return 10
end

-- Evaluate the state of the game
function bayustd:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function bayustd:giveUnitDataDrivenModifier(source, target, modifier, dur)
    --source and target should be hscript-units. The same unit can be in both source and target
    local item = CreateItem( "item_apply_modifiers", source, source)
    item:ApplyDataDrivenModifier( source, target, modifier, {duration=dur} )
end

---------------------------------------------------------------------------
-- Get correct Builder for every Hero
---------------------------------------------------------------------------
function bayustd:EnsureCorrectBuilder(hero)
	--TODO
end

---------------------------------------------------------------------------
-- Spawn Creepwaves
---------------------------------------------------------------------------
function bayustd:SpawnCreeps()
	print( "Spawning creeps ..." )
	if wave % 10 ~= 0 then
		for i = 0, 7, 1 do
			local moveLocation = Entities:FindByName( nil, "path_corner_" .. i)
			local spawnLocation = Entities:FindByName( nil, "creep_spawner" .. i):GetAbsOrigin()
				for d = 1, 10, 1 do
					local unit = CreateUnitByName("npc_dota_wave" .. wave, spawnLocation, true, nil, nil, DOTA_TEAM_NEUTRALS)
					creepsCount = creepsCount + 1
					Timers:CreateTimer(1.0, function()
						unit:SetInitialGoalEntity(moveLocation)
						unit:SetBaseMoveSpeed(500)
						return
					end
					)
				end
		end
	else
		local moveLocation = Entities:FindByName( nil, "path_corner_0")
		local spawnLocation = Entities:FindByName( nil, "creep_spawner0"):GetAbsOrigin()
		local unit = CreateUnitByName("npc_dota_wave" .. wave, spawnLocation, true, nil, nil, DOTA_TEAM_NEUTRALS)
		creepsCount = creepsCount + 1
		Timers:CreateTimer(1.0, function()
			unit:SetInitialGoalEntity(moveLocation)
			unit:SetBaseMoveSpeed(500)
			return
		end
		)
	end
	local messageinfo = {
		message = "Round " .. wave .. " coming",
		duration = 2
	}
	FireGameEvent("show_center_message", messageinfo)  
	--GameRules:SendCustomMessage("Round <font color='#FF0000'>" .. wave .. " coming!", 0, 0)
	print(creepsCount .. " creeps on the way")
	wave = wave + 1
	return 1 -- Check again later in case more players spawn
end

---------------------------------------------------------------------------
-- Needed for trigger, so we disable modifiers for our heroes
---------------------------------------------------------------------------
countRemovedCreeps = 0

function bayustd:getWave()
	return wave
end

function bayustd:getCreeps()
	return creepsCount
end

function bayustd:getRemovedCreeps()
	return countRemovedCreeps
end

function bayustd:incrementRemovedCreeps()
	countRemovedCreeps = countRemovedCreeps + 1
end

function bayustd:setRemovedCreeps(val)
	countRemovedCreeps = val
end

function bayustd:PrintEndgameMessage()

	Timers:CreateTimer(5, function() GameRules:SendCustomMessage("<font color='#DBA901'><br>Game will end in 10 seconds</font>",0,0) end)
	Timers:CreateTimer(10, function() GameRules:SendCustomMessage("<font color='#DBA901'>Please leave your feedback at our workshop page</font>",0,0) end)

	Timers:CreateTimer(12, function() GameRules:SendCustomMessage("<font color='#DBA901'>3</font>",0,0) end)
	Timers:CreateTimer(13, function() GameRules:SendCustomMessage("<font color='#DBA901'>2</font>",0,0) end)
	Timers:CreateTimer(14, function() GameRules:SendCustomMessage("<font color='#DBA901'>1...</font>",0,0) end)
end