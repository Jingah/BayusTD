function ChangeModel(keys)
	local target = keys.target
	local ability = keys.ability
	local model_scale = ability:GetLevelSpecialValueFor( "model_scale", ability:GetLevel() - 1 )
	
	-- Instant scaling, as opposed to the gradual way it happens in Dota
	target:SetModelScale(model_scale)
end

function RevertModel(keys)
	local target = keys.target
	
	-- Instant scaling, as opposed to the gradual way it happens in Dota
	target:SetModelScale(1)
end