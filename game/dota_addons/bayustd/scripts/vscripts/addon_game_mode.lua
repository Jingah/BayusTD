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
require('lib.loadhelper')


function Precache( context )
	--Loading general stuff
	PrecacheUnitByNameSync("npc_dota_ghost", context)
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
	PrecacheUnitByNameSync("npc_dota_hero_furion", context)
	PrecacheUnitByNameSync("npc_dota_hero_lina", context)
	PrecacheUnitByNameSync("npc_dota_hero_morphling", context)
	PrecacheUnitByNameSync("npc_dota_hero_pudge", context)
	PrecacheUnitByNameSync("npc_dota_hero_zuus", context)
	--Loading possible Buildings
	PrecacheUnitByNameSync("npc_tower_blade_explorer", context)
	PrecacheUnitByNameSync("npc_tower_blade_bouncer", context)
	PrecacheUnitByNameSync("npc_tower_poison_tower", context)
	PrecacheUnitByNameSync("npc_tower_stormbringer", context)
	PrecacheUnitByNameSync("npc_tower_voodoo_spirit", context)
	PrecacheUnitByNameSync("npc_tower_war_drill", context)
	PrecacheUnitByNameSync("npc_tower_blade_totem", context)
	PrecacheUnitByNameSync("npc_tower_ember_slinger", context)
	PrecacheUnitByNameSync("npc_tower_voodoo_overseer", context)
	PrecacheUnitByNameSync("npc_tower_power_tower", context)
	PrecacheUnitByNameSync("npc_tower_voodoo_lounge", context)
	
	PrecacheUnitByNameSync("npc_tower_spirit_destroyer", context)
	PrecacheUnitByNameSync("npc_tower_ice_fiend", context)
	PrecacheUnitByNameSync("npc_tower_graveyard", context)
	PrecacheUnitByNameSync("npc_tower_obsidian_destroyer", context)
	PrecacheUnitByNameSync("npc_tower_unholy_pit", context)
	PrecacheUnitByNameSync("npc_tower_necromancer", context)
	PrecacheUnitByNameSync("npc_tower_haunted_house", context)
	PrecacheUnitByNameSync("npc_tower_crypt", context)
	PrecacheUnitByNameSync("npc_tower_altar_of_the_darkness", context)
	PrecacheUnitByNameSync("npc_tower_temple_of_the_damned", context)
	PrecacheUnitByNameSync("npc_tower_unholy_warlock", context)
	
	PrecacheUnitByNameSync("npc_tower_holy_root", context)
	PrecacheUnitByNameSync("npc_tower_ent", context)
	PrecacheUnitByNameSync("npc_tower_obliterator", context)
	PrecacheUnitByNameSync("npc_tower_fury_maiden", context)
	PrecacheUnitByNameSync("npc_tower_lord_of_the_woods", context)
	PrecacheUnitByNameSync("npc_tower_wind_archer", context)
	PrecacheUnitByNameSync("npc_tower_thunders_hall", context)
	PrecacheUnitByNameSync("npc_tower_air_ripper", context)
	PrecacheUnitByNameSync("npc_tower_life_sapper", context)
	PrecacheUnitByNameSync("npc_tower_ancient_protector", context)
	PrecacheUnitByNameSync("npc_tower_the_morphling", context)
	--Loading Creep waves
	PrecacheUnitByNameSync("npc_boss1_add", context)
	PrecacheUnitByNameSync("npc_boss2_add", context)
	PrecacheUnitByNameSync("npc_boss2_buffer", context)
	--PrecacheUnitByNameSync("dummy_unit_vulnerable", context)
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
	--Loading extra stuff
	PrecacheResource("particle_folder", "particles/units/heroes/hero_juggernaut", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_nyx_assassin", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_viper", context)
	PrecacheResource("particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_siren/siren_net.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_siren/siren_net_projectile.vpcf", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_spectre.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.bayustd = bayustd()
	GameRules.bayustd:Initbayustd()
	loadhelper.init()
end
