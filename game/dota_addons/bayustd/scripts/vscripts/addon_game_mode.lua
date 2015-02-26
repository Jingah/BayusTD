--[[
	Author: Jingah
	Date: 16.02.2015
	
	Credits to MNoya for Lumber UI
	Credits to Myll & MNoya for BuildingHelper
]]

require('bayustd')

require('util')
require('timers')
require('physics')
require('popups')
require('FlashUtil')
require('buildinghelper')
require('abilities')

function Precache( context )
	--Loading general stuff
	PrecacheUnitByNameSync("npc_dota_ghost", context)
	PrecacheUnitByNameSync("npc_dota_gold", context)
	PrecacheUnitByNameSync("npc_dota_lumber", context)
	PrecacheUnitByNameSync("npc_dota_fountain", context)
	--Loading Builders
    PrecacheUnitByNameSync("npc_dota_builder1", context)
	PrecacheUnitByNameSync("npc_dota_builder2", context)
	PrecacheUnitByNameSync("npc_dota_builder3", context)
	PrecacheUnitByNameSync("npc_dota_builder4", context)
	--Loading Heroes
	PrecacheUnitByNameSync("npc_dota_hero_axe", context)
	PrecacheUnitByNameSync("npc_dota_hero_antimage", context)
	PrecacheUnitByNameSync("npc_dota_hero_drow_ranger", context)
	PrecacheUnitByNameSync("npc_dota_hero_leshrac", context)
	PrecacheUnitByNameSync("npc_dota_hero_lina", context)
	PrecacheUnitByNameSync("npc_dota_hero_mirana", context)
	PrecacheUnitByNameSync("npc_dota_hero_omniknight", context)
	PrecacheUnitByNameSync("npc_dota_hero_morphling", context)
	--Loading possible Buildings
	PrecacheUnitByNameSync("npc_tower_wooden", context)
	PrecacheUnitByNameSync("npc_tower_idol", context)
	PrecacheUnitByNameSync("npc_tower_racks", context)
	PrecacheUnitByNameSync("npc_tower_dragon", context)
	--Loading Creep waves
	PrecacheUnitByNameSync("npc_boss1_add", context)
	PrecacheUnitByNameSync("npc_boss2_add", context)
	PrecacheUnitByNameSync("npc_dota_wave1", context)
	PrecacheUnitByNameSync("npc_dota_wave2", context)
	PrecacheUnitByNameSync("npc_dota_wave3", context)
	PrecacheUnitByNameSync("npc_dota_wave4", context)
	PrecacheUnitByNameSync("npc_dota_wave5", context)
	PrecacheUnitByNameSync("npc_dota_wave6", context)
	PrecacheUnitByNameSync("npc_dota_wave7", context)
	PrecacheUnitByNameSync("npc_dota_wave8", context)
	PrecacheUnitByNameSync("npc_dota_wave9", context)
	PrecacheUnitByNameSync("npc_dota_wave10", context)
	PrecacheUnitByNameSync("npc_dota_wave11", context)
	PrecacheUnitByNameSync("npc_dota_wave12", context)
	PrecacheUnitByNameSync("npc_dota_wave13", context)
	PrecacheUnitByNameSync("npc_dota_wave14", context)
	PrecacheUnitByNameSync("npc_dota_wave15", context)
	PrecacheUnitByNameSync("npc_dota_wave16", context)
	PrecacheUnitByNameSync("npc_dota_wave17", context)
	PrecacheUnitByNameSync("npc_dota_wave18", context)
	PrecacheUnitByNameSync("npc_dota_wave19", context)
	PrecacheUnitByNameSync("npc_dota_wave20", context)
	--Loading Buildinghelper stuff
	PrecacheResource("particle_folder", "particles/buildinghelper", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.bayustd = bayustd()
	GameRules.bayustd:Initbayustd()
end
