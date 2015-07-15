function MagicDamage(event)
	local caster = event.caster
	local ability = event.ability
	local min_dmg = ability:GetLevelSpecialValueFor( "Min_dmg", ability:GetLevel() - 1 )
	local max_dmg = ability:GetLevelSpecialValueFor( "Max_dmg", ability:GetLevel() - 1 )
	
	local keydamage = RandomInt(min_dmg, max_dmg)
	
	local damageTable = {
		victim = event.target,
		attacker = caster,
		damage = keydamage,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	ApplyDamage(damageTable)
end