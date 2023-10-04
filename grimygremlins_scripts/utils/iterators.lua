local game = Game()

---@param playerType integer?
function GrimyGremlinsMod:PlayerIterator(playerType)
    local maxIndex = game:GetNumPlayers()-1
    local currentIndex = -1
    return function ()
        while currentIndex < maxIndex do
            currentIndex = currentIndex + 1
            local player = Isaac.GetPlayer(currentIndex)
            if not playerType or (player:GetPlayerType() == playerType) then
                return currentIndex, player
            end
        end
    end
end

---@param player EntityPlayer?
function GrimyGremlinsMod:HomuncululIterator(player)
    local homunculi = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, GrimyGremlinsMod.Enums.FamiliarVariant.HOMUNCULUS)
    local playerHash
    if player then
        playerHash = GetPtrHash(player)
    end
    local i = 0
    return function ()
        local entity
        repeat
            i = i+1
            entity = homunculi[i]
            if not entity then
                return
            end
        until not playerHash or GetPtrHash(entity:ToFamiliar().Player) == playerHash
        return entity:ToFamiliar()
    end
end