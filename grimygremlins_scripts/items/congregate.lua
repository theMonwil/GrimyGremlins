local mod = GrimyGremlinsMod

local GRAB_RADIUS = 180

---@param item CollectibleType
---@param rng RNG
---@param player EntityPlayer
local function UseItem(_, item, rng, player)
    local gotSomething = false
    for homunculus in mod:HomuncululIterator(player) do
        if (homunculus.Position-player.Position):Length() < GRAB_RADIUS then
            mod:EntityData(homunculus).FollowPlayer = player
            gotSomething = true
        end
    end
    if not gotSomething then
        return
        {
            Discharge = false,
            ShowAnim = true,
        }
    end
    player:RemoveCollectible(item)
    player:SetPocketActiveItem(mod.Enums.CollectibleType.CONQUER, ActiveSlot.SLOT_POCKET, true)
    return
    {
        Discharge = true,
        ShowAnim = true,
    }
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, UseItem, mod.Enums.CollectibleType.CONGREGATE)