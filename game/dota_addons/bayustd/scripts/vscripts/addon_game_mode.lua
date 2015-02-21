require('bayustd')
-- Loading Buildinhelper
require('timers')
require('physics')
require('FlashUtil')
require('buildinghelper')
require('abilities')

function Precache( context )
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
	PrecacheUnitByNameSync("npc_dota_wave3", context)
	PrecacheResource("particle_folder", "particles/buildinghelper", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.bayustd = bayustd()
	GameRules.bayustd:Initbayustd()
end
