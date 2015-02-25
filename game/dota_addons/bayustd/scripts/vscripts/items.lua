function mana_potion( event )
	local mana = event.ability:GetSpecialValueFor("mana_amount")
    event.caster:GiveMana(mana)
end
