local mod = GrimyGremlinsMod
local game = Game()
local playerToUpdate = nil

local PLAYER_TYPE = mod.Enums.PlayerType.CONRAD

local LUCK_BONUS = 2

local function PostNewRoom()
    if game:GetRoom():IsClear() then
        for _, player in mod:PlayerIterator(PLAYER_TYPE) do
            player:RemoveCollectible(player:GetActiveItem(ActiveSlot.SLOT_POCKET), false, ActiveSlot.SLOT_POCKET)
            player:SetPocketActiveItem(mod.Enums.CollectibleType.CONJURE, ActiveSlot.SLOT_POCKET, true)
            player:GetEffects():RemoveCollectibleEffect(mod.Enums.CollectibleType.CONRAD_SOUL)
        end
    else
        for _, player in mod:PlayerIterator(PLAYER_TYPE) do
            player:RemoveCollectible(player:GetActiveItem(ActiveSlot.SLOT_POCKET), false, ActiveSlot.SLOT_POCKET)
            player:SetPocketActiveItem(mod.Enums.CollectibleType.CONGREGATE, ActiveSlot.SLOT_POCKET, true)
            player:GetEffects():AddCollectibleEffect(mod.Enums.CollectibleType.CONRAD_SOUL)
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PostNewRoom)

local function PreSpawnClearAward()
    for _, player in mod:PlayerIterator(PLAYER_TYPE) do
        player:RemoveCollectible(player:GetActiveItem(ActiveSlot.SLOT_POCKET), false, ActiveSlot.SLOT_POCKET)
        player:SetPocketActiveItem(mod.Enums.CollectibleType.CONJURE, ActiveSlot.SLOT_POCKET, true)
        player:GetEffects():RemoveCollectibleEffect(mod.Enums.CollectibleType.CONRAD_SOUL)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, PreSpawnClearAward)

---@param player EntityPlayer
local function EvaluateCacheDamage(_, player)
    if player:GetPlayerType() ~= PLAYER_TYPE then
        return end
    local bonus = mod:EntityData(player).HomunculiCounter or 0
    bonus = math.min(25, bonus)
    local multiplier = 0.5 + 0.1*math.sqrt(bonus)
    player.Damage = player.Damage * multiplier
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvaluateCacheDamage, CacheFlag.CACHE_DAMAGE)

local function EvaluateCacheLuck(_, player)
    if player:GetPlayerType() ~= PLAYER_TYPE then
        return end
    player.Luck = player.Luck + LUCK_BONUS
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvaluateCacheLuck, CacheFlag.CACHE_LUCK)

local function RecountHomunculiBonus()
    if not playerToUpdate then
        return end
    local player = playerToUpdate
    playerToUpdate = nil
    if player:GetPlayerType() ~= PLAYER_TYPE then
        return end
    local totalBonus = 0
    for homunculus in mod:HomuncululIterator(player) do
        totalBonus = totalBonus + homunculus.CollisionDamage
    end
    local data = mod:EntityData(player)
    data.HomunculiCounter = totalBonus
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, RecountHomunculiBonus)

---@param player EntityPlayer
local function PostPlayerInit(_, player)
    if player:GetPlayerType() ~= PLAYER_TYPE then
        return end
    playerToUpdate = player
    player:SetPocketActiveItem(mod.Enums.CollectibleType.CONJURE, ActiveSlot.SLOT_POCKET, true)
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, PostPlayerInit)


---@param familiar EntityFamiliar
local function PostHomunculusInit(_, familiar)
    playerToUpdate = familiar.Player
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, PostHomunculusInit, mod.Enums.FamiliarVariant.HOMUNCULUS)

---@param entity Entity
local function PostHomunculusRemove(_, entity)
    if entity.Variant ~= mod.Enums.FamiliarVariant.HOMUNCULUS then
        return end
    local familiar = entity:ToFamiliar()
    playerToUpdate = familiar.Player
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, PostHomunculusRemove, EntityType.ENTITY_FAMILIAR)