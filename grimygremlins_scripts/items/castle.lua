local mod = GrimyGremlinsMod
local game = Game()
local sfx = SFXManager()

local ITEM_ID = mod.Enums.CollectibleType.CASTLE

local SLAM_RADIUS = 75
local SLAM_IFRAMES = 45
local CONFUSION_DURATION = 45
local TEARS_UP_DURATION = 150

---@param player EntityPlayer
local function Unstuck(player)
    local effects = player:GetEffects()
    effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BIBLE)
    effects:RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_BIBLE)
end

---@param player EntityPlayer
---@return number
local function SlamDamage(player)
    return player.Damage * 3 + 10
end

---@param source EntityPlayer
---@return boolean
local function Slam(source)
    local swirl = Isaac.Spawn(
        EntityType.ENTITY_EFFECT,
        EffectVariant.POOF02,
        0,
        source.Position,
        Vector.Zero,
        source
    ):ToEffect()
    swirl.Color = Color(0,0,0)

    local hitSomething = false
    local sourceRef = EntityRef(source)
    local damage = SlamDamage(source)
    for _, enemy in ipairs(Isaac.FindInRadius(source.Position, SLAM_RADIUS, EntityPartition.ENEMY)) do
        if enemy:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
            goto continue
        end
        enemy:TakeDamage(damage, 0, sourceRef, 0)
        enemy:AddConfusion(sourceRef, CONFUSION_DURATION, true)
        hitSomething = true
        ::continue::
    end
    if hitSomething then
        if not source:GetData().CastlingBoostCooldown then
            source:GetData().CastlingBoostCooldown = TEARS_UP_DURATION
        else
            source:GetData().CastlingBoostCooldown = source:GetData().CastlingBoostCooldown + TEARS_UP_DURATION
        end
        source:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        source:EvaluateItems()
    end
    return hitSomething
end

---@param player EntityPlayer
---@return EntityPlayer
local function ClosestPlayer(player)
    local playerHash = GetPtrHash(player)
    local closestPlayer
    for i = 0, game:GetNumPlayers()-1 do
        local otherPlayer = Isaac.GetPlayer(i)
        if GetPtrHash(otherPlayer) == playerHash then
            goto continue
        end
        if not closestPlayer then
            closestPlayer = otherPlayer
            goto continue
        end
        if player.Position:Distance(closestPlayer.Position) > player.Position:Distance(otherPlayer.Position) then
            closestPlayer = otherPlayer
        end
        ::continue::
    end
    return closestPlayer
end

---@param player EntityPlayer
---@return EntityFamiliar?
local function ClosestPunchingBag(player)
    local punchingBags = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.PUNCHING_BAG)
    local closestPunchingBag = punchingBags[1]
    if not closestPunchingBag then
        return nil
    end
    for _, bag in ipairs(punchingBags) do
        if player.Position:Distance(closestPunchingBag.Position) > player.Position:Distance(bag.Position) then
            closestPunchingBag = bag
        end
    end
    return closestPunchingBag:ToFamiliar()
end

---@param _ any
---@param item CollectibleType
---@param rng RNG
---@param player EntityPlayer
---@return table
local function UseCastle(_, item, rng, player)
    local target
    if game:GetNumPlayers() == 1 then
        target = ClosestPunchingBag(player)
    else
        target = ClosestPlayer(player)
    end
    if not target then
        sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ)
        return
        {
            Discharge = false,
            ShowAnim = false
        }
    end
    local playerPos = player.Position
    local targetPos = target.Position

    sfx:Play(SoundEffect.SOUND_TOOTH_AND_NAIL)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        Slam(player)
    end
    local trail = Isaac.Spawn(
        EntityType.ENTITY_EFFECT,
        EffectVariant.SPRITE_TRAIL,
        0,
        playerPos,
        Vector.Zero,
        player
    ):ToEffect()
    trail.Parent = player
    trail:FollowParent(player)
    trail.MinRadius = 0.1
    trail:Update()

    Isaac.Spawn(
        EntityType.ENTITY_EFFECT,
        EffectVariant.POOF01,
        0,
        playerPos,
        Vector.Zero,
        player
    )

    player.Position = targetPos
    target.Position = playerPos
    trail:Update()
    trail.Parent = nil
    Slam(player)

    Isaac.Spawn(
        EntityType.ENTITY_EFFECT,
        EffectVariant.POOF01,
        0,
        playerPos,
        Vector.Zero,
        player
    )

    local laser = EntityLaser.ShootAngle(
        LaserVariant.THICKER_RED,
        playerPos,
        (targetPos-playerPos):GetAngleDegrees(),
        1,
        Vector.Zero,
        player
    ):ToLaser()
    laser.CollisionDamage = SlamDamage(player)
    laser.Visible = false
    laser.DisableFollowParent = true
    laser:SetOneHit(true)
    laser.MaxDistance = playerPos:Distance(targetPos)

    player:SetMinDamageCooldown(SLAM_IFRAMES)
    Unstuck(player)
    if target:ToPlayer() then
        target:SetMinDamageCooldown(SLAM_IFRAMES)
        Unstuck(target:ToPlayer())
    end
    return
    {
        Discharge = true,
        ShowAnim = false
    }
end
mod:AddCallback(ModCallbacks.MC_USE_ITEM, UseCastle, ITEM_ID)

local function PostNewRoom()
    if game:GetNumPlayers() > 1 then
        return end
    --if game:GetRoom():IsClear() then
    --    return end
    local player = Isaac.GetPlayer()    --shut
    if not player:HasCollectible(ITEM_ID) then
        return
    end
    player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_PUNCHING_BAG)
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PostNewRoom)