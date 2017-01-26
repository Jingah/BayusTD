function SplashDamage(event)
	local attacker = event.caster
    local target = event.target
    local ability = event.ability
    local radius = event.radius
    local full_damage = attacker:GetAttackDamage()/2
    
    local splash_targets = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    for _,unit in pairs(splash_targets) do
        if unit ~= target then
            ApplyDamage({victim = unit, attacker = attacker, damage = full_damage, ability = ability, damage_type = DAMAGE_TYPE_PHYSICAL})
        end
    end
end