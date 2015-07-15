--[[Drains mana on every hit
	Author: Jingah
	Date: 07.04.2015]]
function ManaBurn( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local manaBurn = ability:GetLevelSpecialValueFor("mana_per_hit", (ability:GetLevel() - 1))
	
	target:ReduceMana(manaBurn)
end