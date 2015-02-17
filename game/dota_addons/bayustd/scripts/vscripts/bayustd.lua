print ('[BAYUSTD] bayustd.lua' )


----------------

ENABLE_HERO_RESPAWN = true              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = false             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = true        -- Should we let people select the same hero as each other

HERO_SELECTION_TIME = 30.0              -- How long should we let people select their hero?
PRE_GAME_TIME = 10.0                  -- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0                   -- How long should we let people look at the scoreboard before closing the server automatically?
TREE_REGROW_TIME = 1.0                 -- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 0                   	-- How much gold should players get per tick?
GOLD_TICK_TIME = 5                      -- How long should we wait in seconds between gold ticks?

RECOMMENDED_BUILDS_DISABLED = false     -- Should we disable the recommened builds for heroes (Note: this is not working currently I believe)
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
TOP_BAR_VISIBLE = false                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = false             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = false-- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players get gold?

END_GAME_ON_KILLS = false                -- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 50         -- How many kills for a team should signify an end of game?

USE_CUSTOM_HERO_LEVELS = true           -- Should we allow heroes to have custom levels?
MAX_LEVEL = 40                          -- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = true             -- Should we use custom XP values to level up heroes, or the default Dota numbers?

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
end

--[[
This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function bayustd:OnAllPlayersLoaded()
	print("[BAYUSTD] All Players have loaded into the game")
end

--[[
This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
levels, changing the starting gold, removing/adding abilities, adding physics, etc.
The hero parameter is the hero entity that just spawned in
]]
function bayustd:OnHeroInGame(hero)
	print("[BAYUSTD] Hero spawned in game for first time -- " .. hero:GetUnitName())


	-- This line for example will set the starting gold of every hero to 500 unreliable gold
	hero:SetGold(70, false)

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
	--print("[SAMPLERTS] NPC Spawned")
	--PrintTable(keys)
	local npc = EntIndexToHScript(keys.entindex)

	if npc:IsRealHero() and npc.bFirstSpawned == nil then
		npc.bFirstSpawned = true
		bayustd:OnHeroInGame(npc)
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
	--print('[SAMPLERTS] Player Disconnected ' .. tostring(keys.userid))
	--PrintTable(keys)

	local name = keys.name
	local networkid = keys.networkid
	local reason = keys.reason
	local userid = keys.userid
end

-- The overall game state has changed
function bayustd:OnGameRulesStateChange(keys)
	
	--DeepPrintTable(keys)

	local newState = GameRules:State_Get()
	print("[BAYUSTD] GameRules State Changed to " .. newState)
	if newState == DOTA_GAMERULES_STATE_PRE_GAME then
		--bayustd:EnsureCorrectBuilder(keys)
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		bayustd:SpawnCreeps()
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
	
	
	--TODO: Ensure correct Builder
	local number = math.random(1,4)
	local builder = CreateUnitByName("npc_dota_builder" .. number, point, true, nil, nil, DOTA_TEAM_GOODGUYS)
	builder:SetOwner(hero)
	builder:SetControllableByPlayer(playerID, true)
	
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

	InitLogFile( "log/bayustd.txt","")

	---------------------------------------------------------------------------
	
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( bayustd, 'OnGameRulesStateChange' ), self )
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(bayustd, 'OnDisconnect'), self)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(bayustd, 'OnPlayerPickHero'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(bayustd, 'OnAbilityUsed'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(bayustd, 'OnNPCSpawned'), self)

	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 ) 

	-- Event Hooks
	-- All of these events can potentially be fired by the game, though only the uncommented ones have had
	-- Functions supplied for them.  If you are interested in the other events, you can uncomment the
	-- ListenToGameEvent line and add a function to handle the event

	-- Full units file to get the custom values
  	GameRules.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")

  	-- Building Helper by Myll
  	BuildingHelper:Init(8192) -- nHalfMapLength

	print('[BAYUSTD] Done loading bayusTD gamemode!\n\n')
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
	for i = 0, 6, 1 do
		local spawnLocation = Entities:FindByName( nil, "creep_spawner" .. i):GetAbsOrigin()
		--self:GetCorrectWave(spawnLocation, "npc_dota_wave1)
		if i == 0 then
			
			for d = 0, 20, 1 do
				local moveLocation0 = Entities:FindByName( nil, "path_corner_0"):GetAbsOrigin()
				local mL0 = moveLocation0
				print(moveLocation0)
				round1Creep = CreateUnitByName("npc_dota_wave1", spawnLocation, true, nil, nil, DOTA_TEAM_NEUTRALS)
				print("spawned creep ...")
				Timers:CreateTimer( 2, function()
					round1Creep:MoveToPosition(moveLocation0)
					return nil
				end
				)
				moveLocation0 = mL0
				print("creep moves to location " .. moveLocation0)
			--	round1Creep:MoveToPosition(moveLocation0)
				--round1Creep:SetThink(function() round1Creep:MoveToPosition(moveLocation0) end, self)
				--round1Creep:MoveToPosition(moveLocation0)
			end
		end		
	end
	return 1 -- Check again later in case more players spawn
end

---------------------------------------------------------------------------
-- Create correct Unit and set correct waypoints
---------------------------------------------------------------------------
function bayustd:GetCorrectWave(i, wave) 
	
end