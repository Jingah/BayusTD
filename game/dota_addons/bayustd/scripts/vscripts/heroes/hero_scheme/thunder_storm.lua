--[[
	Autor: Jingah
	Date: 23.03.2015
	
]]
function ThunderStorm( event )
	--local hero = event.caster
	local target = event.target

	local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(lightningBolt,0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + 1600))
	ParticleManager:SetParticleControl(lightningBolt,1, target:GetAbsOrigin())
end