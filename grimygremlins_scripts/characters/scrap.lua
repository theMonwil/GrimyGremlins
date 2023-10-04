local mod = GrimyGremlinsMod
local itemConfig = Isaac.GetItemConfig()

local MAX_QUALITY = 2
local ITEMS_TO_SPAWN = 4
local ITEMS_TO_SPAWN_BIRTHRIGHT = 8
local SPAWN_DISTANCE_STEP = 55
local MIN_ROOMS_UNTIL_CRASH = 3
local MAX_ROOMS_UNTIL_CRASH = 7

local PLAYER_TYPE = mod.Enums.PlayerType.SCRAP

local SPECIAL_CHARGETYPE = 2 --https://wofsauge.github.io/IsaacDocs/rep/ItemConfig_Item.html#chargetype

local SCRAP_ITEM_POOL = {}
for item = 1, itemConfig:GetCollectibles().Size-1 do
    if not ItemConfig.Config.IsValidCollectible(item) then
        goto continue
    end

    local config = itemConfig:GetCollectible(item)
    if config:IsAvailable()
    and config.Type == ItemType.ITEM_ACTIVE
    and config.Quality <= MAX_QUALITY
    and config.ChargeType ~= SPECIAL_CHARGETYPE
    and config:HasTags(ItemConfig.TAG_OFFENSIVE)
    and not config.Hidden then
        table.insert(SCRAP_ITEM_POOL, item)
    end

    ::continue::
end

---@return integer
local function FreeOptionsIndex()
    local result = 1
    for _,pickup in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP)) do
        if pickup:ToPickup().OptionsPickupIndex >= result then
            result = pickup:ToPickup().OptionsPickupIndex+1
        end
    end

    return result
end

---@param player EntityPlayer
local function SpawnItems(player)
    local itemCount
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        itemCount = ITEMS_TO_SPAWN_BIRTHRIGHT
    else
        itemCount = ITEMS_TO_SPAWN
    end
    local sharedOptionsIndex = FreeOptionsIndex()
    local rng = player:GetCollectibleRNG(mod.Enums.CollectibleType.SCRAP_SOUL)
    for i=1,itemCount do
        local position = Isaac.GetFreeNearPosition(player.Position, SPAWN_DISTANCE_STEP)
        local id = SCRAP_ITEM_POOL[1+rng:RandomInt(#SCRAP_ITEM_POOL)]
        local item = Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            id,
            position,
            Vector.Zero,
            player
        ):ToPickup()
        item.Touched = true
        item.OptionsPickupIndex = sharedOptionsIndex
    end
end

---@param player EntityPlayer
local function TryDestroyActiveItem(player)
    local effects = player:GetEffects()
    if effects:HasCollectibleEffect(mod.Enums.CollectibleType.SCRAP_SOUL) then
        effects:RemoveCollectibleEffect(mod.Enums.CollectibleType.SCRAP_SOUL, 1)
        return end
    local rng = player:GetCollectibleRNG(mod.Enums.CollectibleType.SCRAP_SOUL)
    local newRoomCooldown = rng:RandomInt(1+MAX_ROOMS_UNTIL_CRASH-MIN_ROOMS_UNTIL_CRASH) + MIN_ROOMS_UNTIL_CRASH
    effects:AddCollectibleEffect(mod.Enums.CollectibleType.SCRAP_SOUL, false, newRoomCooldown)

    local active = player:GetActiveItem()
    if active ~= CollectibleType.COLLECTIBLE_NULL then
        player:RemoveCollectible(active)
        player:AnimateSad()
    end
    SpawnItems(player)
end

---@param _ any
---@param player EntityPlayer
local function PostPeffectUpdate(_, player)
    if player:HasTrinket(TrinketType.TRINKET_NO) then
        return end
    player:AddTrinket(TrinketType.TRINKET_NO)
    player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM)
    player:AddCollectible(CollectibleType.COLLECTIBLE_9_VOLT)
    player:RemoveCostume(itemConfig:GetCollectible(CollectibleType.COLLECTIBLE_9_VOLT))
    TryDestroyActiveItem(player)
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, PostPeffectUpdate, mod.Enums.PlayerType.SCRAP)

local function PreSpawnClearAward()
    for _, player in mod:PlayerIterator(PLAYER_TYPE) do
        TryDestroyActiveItem(player)
    end
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, PreSpawnClearAward)