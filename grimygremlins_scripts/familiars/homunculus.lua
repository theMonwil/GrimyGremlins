local mod = GrimyGremlinsMod
local game = Game()

local BASE_DURATION = 3
local BIRTHTIGHT_DURATION = 5

local BASE_SPEED = 10
local DEVIATION = 5
local YOINK_SPEED = 15
local SEARCH_RADIUS = 80

local PLAYER_FOLLOW_OFFSET = Vector(0, -15)

local PLAYER_TYPE = mod.Enums.PlayerType.CONRAD

local CLOSE_DISTANCE = 3

---@param familiar EntityFamiliar
local function FamiliarUpdate(_, familiar)
    if game:GetRoom():GetFrameCount() < 1 then  --There was a bug caused by familiars finding targets before being moved to their new locations.
        return end
    local scale = 0.9 + familiar.CollisionDamage*0.05   --Idk why these 2 only work if I set them on update.
    familiar.SpriteScale = Vector(scale,scale)
    local lifetime = BASE_DURATION
    if familiar.Player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    and familiar.Player:GetPlayerType() == PLAYER_TYPE then
        lifetime = BIRTHTIGHT_DURATION
    end

    if familiar.RoomClearCount >= lifetime then
        familiar:Kill()
        return
    end

    local isForceDragged = false
    local data = mod:EntityData(familiar)
    local targetPos = familiar.Position
    if game:GetRoom():IsClear() then
        data.FollowPlayer = nil
        data.LaunchPos = nil
    elseif data.FollowPlayer then
        isForceDragged = true
        targetPos = data.FollowPlayer.Position + PLAYER_FOLLOW_OFFSET
    elseif data.LaunchPos then
        isForceDragged = true
        targetPos = data.LaunchPos
        if familiar.Position:Distance(targetPos) < CLOSE_DISTANCE then
            data.LaunchPos = nil
        end
    else
        if familiar.Target then
            targetPos = familiar.Target.Position
        else
            familiar.Target = Isaac.FindInRadius(familiar.Position, SEARCH_RADIUS, EntityPartition.ENEMY)[1]
        end
    end

    local targetDelta = targetPos - familiar.Position
    if not isForceDragged then
        if targetDelta:Length() > BASE_SPEED then
            targetDelta:Resize(BASE_SPEED)
        end
        familiar.Velocity = targetDelta + RandomVector()*DEVIATION
    else
        if targetDelta:Length() > YOINK_SPEED then
            targetDelta:Resize(YOINK_SPEED)
        end
        familiar.Velocity = targetDelta
    end
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, FamiliarUpdate, mod.Enums.FamiliarVariant.HOMUNCULUS)

local function PostNewRoom()
    for homunculus in mod:HomuncululIterator() do
        homunculus.Position = Isaac.GetRandomPosition()
        mod:AddHomunculusTrail(homunculus)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PostNewRoom)