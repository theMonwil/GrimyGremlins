local mod = GrimyGremlinsMod
local game = Game()
local itemPool = game:GetItemPool()
local itemConfig = Isaac.GetItemConfig()

---@param rng RNG
---@param player EntityPlayer
local function UseRebirth(_, _, rng, player)
    local pool = itemPool:GetPoolForRoom(game:GetRoom():GetType(), 1)
    if pool == ItemPoolType.POOL_NULL then
        pool = ItemPoolType.POOL_TREASURE
    end

    local singleSeedCount = player:GetCollectibleNum(mod.Enums.CollectibleType.VERDANT_SEED, true)
    local doubleSeedCount = player:GetCollectibleNum(mod.Enums.CollectibleType.VERDANT_SEEDS, true)
    if singleSeedCount+doubleSeedCount == 0 then    --I swear some Yotuber is going to pop this thing floor 1 and be surprised why nothing happened.
        player:AnimateSad()
        return
    end
    for i=1, singleSeedCount do
        player:RemoveCollectible(mod.Enums.CollectibleType.VERDANT_SEED)
    end
    for i=1, doubleSeedCount do
        player:RemoveCollectible(mod.Enums.CollectibleType.VERDANT_SEEDS)
    end
    local itemCount = singleSeedCount+(2*doubleSeedCount)
    local i = 1
    local emergencyBreak = 2000
    while i <= itemCount and emergencyBreak > 0 do  --Apparently you cannot mess with the iterators in Lua for loops or something Idk.
        emergencyBreak = emergencyBreak - 1
        local item = itemPool:GetCollectible(pool, true, Random(), mod.Enums.CollectibleType.WITHERED_SEED)
        if itemConfig:GetCollectible(item).Type ~= ItemType.ITEM_ACTIVE then
            player:AddCollectible(item)
            i = i + 1
        end
    end

    return {
        ShowAnim = true,
        Remove = true,
        Discharge = true,
    }
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, UseRebirth, mod.Enums.CollectibleType.REBIRTH)