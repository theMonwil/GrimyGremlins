local mod = GrimyGremlinsMod

local RANDOM_SPREAD = 15
local BASE_DAMAGE_MULTIPLIER = 0.8
local BASE_TEARS_MULTIPLIER = 1.25
local BASE_SPEED_PENALTY = 0.3
local CASTLING_TEARS_MULTIPLIER = 1.5

local PLAYER_TYPE = mod.Enums.PlayerType.ROOK

---@param player EntityPlayer
local function PostPlayerInit(_, player)
    if player:GetPlayerType() ~= PLAYER_TYPE then
        return end
    player:SetPocketActiveItem(mod.Enums.CollectibleType.CASTLE, ActiveSlot.SLOT_POCKET, true)
    if player.ControllerIndex%2 == 0 then
        player:AddNullCostume(mod.Enums.NullCostumes.ROOK_HEAD)
    else
        player:AddNullCostume(mod.Enums.NullCostumes.ROOK_HEAD_BLACK)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, PostPlayerInit)

---@param player EntityPlayer
local function PostPeffectUpdate(_, player)
    local data = player:GetData()
    if not data.CastlingBoostCooldown then
        return end
    print(data.CastlingBoostCooldown)
    Isaac.RenderText(tostring(data.CastlingBoostCooldown), 120, 120, 1,1,1,1)
    data.CastlingBoostCooldown = data.CastlingBoostCooldown - 1
    if data.CastlingBoostCooldown == 0 then
        data.CastlingBoostCooldown = nil
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        player:EvaluateItems()
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, PostPeffectUpdate, PLAYER_TYPE)

---@param _ any
---@param player EntityPlayer
---@param flag CacheFlag
local function EvaluateCache(_, player, flag)
    if player:GetPlayerType() ~= PLAYER_TYPE then
        return end
    if flag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed - BASE_SPEED_PENALTY
    elseif flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage * BASE_DAMAGE_MULTIPLIER
    elseif flag == CacheFlag.CACHE_FIREDELAY then
        local tears = 30/(1+player.MaxFireDelay)
        tears = tears * BASE_TEARS_MULTIPLIER
        if player:GetData().CastlingBoostCooldown then
            tears = tears * CASTLING_TEARS_MULTIPLIER
        end
        player.MaxFireDelay = 30/tears - 1
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EvaluateCache)

---@param tear EntityTear
local function TearInaccuracy(_, tear)
    if not(
        tear.SpawnerEntity
        and tear.SpawnerEntity:ToPlayer()
        and tear.SpawnerEntity:ToPlayer():GetPlayerType() == PLAYER_TYPE
    )then
        return end
    local rng = tear.SpawnerEntity:ToPlayer():GetCollectibleRNG(mod.Enums.CollectibleType.ROOK_SOUL)
    tear.Velocity = tear.Velocity:Rotated((rng:RandomFloat()-0.5)*RANDOM_SPREAD)
end
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, TearInaccuracy)

local function LaserInaccuracy(_, laser)
    if laser.FrameCount ~= 1 then
        return end
    if not(
        laser.SpawnerEntity
        and laser.SpawnerEntity:ToPlayer()
        and laser.SpawnerEntity:ToPlayer():GetPlayerType() == PLAYER_TYPE
    )then
        return end
    local rng = laser.SpawnerEntity:ToPlayer():GetCollectibleRNG(mod.Enums.CollectibleType.ROOK_SOUL)
    if laser.SubType == LaserSubType.LASER_SUBTYPE_RING_PROJECTILE then
        laser.Velocity = laser.Velocity:Rotated((rng:RandomFloat()-0.5)*RANDOM_SPREAD)
    else
        laser.AngleDegrees = laser.AngleDegrees + (rng:RandomFloat()-0.5)*RANDOM_SPREAD
    end
end
mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, LaserInaccuracy)