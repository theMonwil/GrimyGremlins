local mod = GrimyGremlinsMod
local game = Game()
local sfx = SFXManager()

local INFUSE_RADIUS = 80

local HomunculusTypes = include("grimygremlins_scripts.familiars.homunculus_types")

---@param pickup EntityPickup
---@param player EntityPlayer
local function SpawnHomunculus(pickup, player)
    if not(
        not pickup:ToPickup():IsShopItem()
        and HomunculusTypes[pickup.Variant])
        then return end

    local homunculus = Isaac.Spawn(
        EntityType.ENTITY_FAMILIAR,
        mod.Enums.FamiliarVariant.HOMUNCULUS,
        0,
        pickup.Position,
        Vector.Zero,
        player
    ):ToFamiliar()

    --Some pickup variants just have one table assigned to it, others have extra layer of tables for each subtype.
    ---@type Homunculus
    local config = HomunculusTypes[pickup.Variant][pickup.SubType] or HomunculusTypes[pickup.Variant]

    --Choice of checking damage was arbitrary. I just want to know there's a config at all.
    if not config.Damage then
        return end

    homunculus.Player = player
    homunculus.CollisionDamage = config.Damage
    homunculus.Color = config.Color
    mod:AddHomunculusTrail(homunculus)

    pickup:Remove()
end

local function UseItem(_, item, rng, player)
    game:MakeShockwave(player.Position, 0.01, 0.02, 15)
    sfx:Play(SoundEffect.SOUND_DEATH_REVERSE)

    for _,pickup in ipairs(Isaac.FindInRadius(player.Position, INFUSE_RADIUS, EntityPartition.PICKUP)) do
        SpawnHomunculus(pickup:ToPickup(), player)
    end

    return false
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, UseItem, mod.Enums.CollectibleType.CONJURE)