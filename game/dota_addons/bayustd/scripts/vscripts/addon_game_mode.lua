require('bayustd')
-- Loading Buildinhelper
require('util')
require('timers')
require('physics')
require('popups')
require('FlashUtil')
require('buildinghelper')
require('abilities')

function Precache( context )
	PrecacheUnitByNameSync("npc_dota_ghost", context)
	PrecacheUnitByNameSync("npc_dota_gold", context)
	PrecacheUnitByNameSync("npc_dota_lumber", context)
    PrecacheUnitByNameSync("npc_dota_builder1", context)
	PrecacheUnitByNameSync("npc_dota_builder2", context)
	PrecacheUnitByNameSync("npc_dota_builder3", context)
	PrecacheUnitByNameSync("npc_dota_builder4", context)
	PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
	PrecacheUnitByNameSync("npc_barracks", context)
	PrecacheUnitByNameSync("npc_barracks2", context)
	PrecacheUnitByNameSync("npc_barracks3", context)
	PrecacheUnitByNameSync("npc_dota_wave1", context)
	PrecacheUnitByNameSync("npc_dota_wave2", context)
	PrecacheUnitByNameSync("npc_dota_wave4", context)
	PrecacheUnitByNameSync("npc_dota_wave5", context)
	PrecacheResource("particle_folder", "particles/buildinghelper", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.bayustd = bayustd()
	GameRules.bayustd:Initbayustd()
end
