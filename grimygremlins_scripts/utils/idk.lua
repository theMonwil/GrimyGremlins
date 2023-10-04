local mod = GrimyGremlinsMod

---@param familiar EntityFamiliar
function mod:AddHomunculusTrail(familiar)
    local trail = Isaac.Spawn(
        EntityType.ENTITY_EFFECT,
        EffectVariant.SPRITE_TRAIL,
        0,
        familiar.Position,
        Vector.Zero,
        familiar
    ):ToEffect()
    trail.Color = familiar.Color
    trail.Parent = familiar
    trail:FollowParent(familiar)
    --trail.ParentOffset = Vector(0, -25)
end