local mod = GrimyGremlinsMod

local THROW_DISTANCE = 120
local THROW_DEVIATION = 7

---@param item CollectibleType
---@param rng RNG
---@param player EntityPlayer
local function UseItem(_, item, rng, player)
    local launchTarget = player.Position + player:GetShootingInput()*THROW_DISTANCE
    local spreadStrength = 0
    for homunculus in mod:HomuncululIterator(player) do
        spreadStrength = spreadStrength + 1
        local data = mod:EntityData(homunculus)
        if data.FollowPlayer then
            data.FollowPlayer = nil
            data.LaunchPos = launchTarget + RandomVector()*spreadStrength*THROW_DEVIATION
        end
    end
    player:RemoveCollectible(item)
    player:SetPocketActiveItem(mod.Enums.CollectibleType.CONGREGATE, ActiveSlot.SLOT_POCKET, true)
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, UseItem, mod.Enums.CollectibleType.CONQUER)