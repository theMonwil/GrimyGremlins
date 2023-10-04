local mod = GrimyGremlinsMod
local game = Game()
local itemPool = game:GetItemPool()
local itemConfig = Isaac.GetItemConfig()

local PLAYER_TYPE = mod.Enums.PlayerType.REBORN

local ITEM_REPLACE_FREQUENCY = 4

local VALUABLE_ITEM_POOLS = {
    [ItemPoolType.POOL_DEVIL] = true,
    [ItemPoolType.POOL_ANGEL] = true,
    [ItemPoolType.POOL_PLANETARIUM] = true,
    [ItemPoolType.POOL_ULTRA_SECRET] = true,
    [ItemPoolType.POOL_GREED_DEVIL] = true,
    [ItemPoolType.POOL_GREED_ANGEL] = true,
}

local antiRerollLoop = false

---@param usedRebirth boolean
---@return integer
local function ReplacementItem(usedRebirth)
    local room = game:GetRoom()
    local pool = itemPool:GetPoolForRoom(room:GetType(), 1)

    if VALUABLE_ITEM_POOLS[pool] then
        if usedRebirth then
            return mod.Enums.CollectibleType.WITHERED_SEEDS
        end
        return mod.Enums.CollectibleType.VERDANT_SEEDS
    end

    if usedRebirth then
        return mod.Enums.CollectibleType.WITHERED_SEED
    end
    return mod.Enums.CollectibleType.VERDANT_SEED
end

---@return EntityPlayer, boolean
local function IsRebornPresent()
    local reborn = nil
    local usedRebirth = false
    for _, player in mod:PlayerIterator(PLAYER_TYPE) do
        reborn = reborn or player
        if not player:HasCollectible(mod.Enums.CollectibleType.REBIRTH) then
            usedRebirth = true
        end
    end
    return reborn, usedRebirth
end

local function ItemPedestalInit(_, pickup)
    if antiRerollLoop then
        antiRerollLoop = false
        return
    end
    if not game:GetRoom():IsFirstVisit() and game:GetRoom():GetFrameCount() < 0 then
        return end
    if itemConfig:GetCollectible(pickup.SubType):HasTags(ItemConfig.TAG_QUEST) then
        return end
    local reborn, usedRebirth = IsRebornPresent()
    if not reborn then
        return end
    local itemToSpawn = ReplacementItem(usedRebirth)
    local peffects = reborn:GetEffects()
    if not peffects:HasCollectibleEffect(mod.Enums.CollectibleType.REBORN_SOUL) then
        antiRerollLoop = true
        pickup:Morph(pickup.Type, pickup.Variant, itemToSpawn, true)
        peffects:AddCollectibleEffect(mod.Enums.CollectibleType.REBORN_SOUL, true, ITEM_REPLACE_FREQUENCY-1)
    else
        peffects:RemoveCollectibleEffect(mod.Enums.CollectibleType.REBORN_SOUL, 1)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, ItemPedestalInit, PickupVariant.PICKUP_COLLECTIBLE)

---@param player EntityPlayer
local function PostPlayerInit(_, player)
    if player:GetPlayerType() ~= PLAYER_TYPE then
        return end
    player:SetPocketActiveItem(mod.Enums.CollectibleType.REBIRTH, ActiveSlot.SLOT_POCKET, true)
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, PostPlayerInit)

---@param player EntityPlayer
---@param flag CacheFlag
local function EvaluateCache(_, player, flag)
    if not (player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT, true)
            and not player:HasCollectible(mod.Enums.CollectibleType.REBIRTH)
            and player:GetPlayerType() == PLAYER_TYPE) then
        return end
    player:RemoveCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    player:SetPocketActiveItem(mod.Enums.CollectibleType.REBIRTH, ActiveSlot.SLOT_POCKET, true)
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvaluateCache, CacheFlag.CACHE_WEAPON) --The flag choice was absolutely arbitrary