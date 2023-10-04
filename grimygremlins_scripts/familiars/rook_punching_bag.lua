local mod = GrimyGremlinsMod

local SKIN_SUFFIX = {}
for name, num in pairs(SkinColor) do
    SKIN_SUFFIX[num] = string.lower(string.sub(name, 5))
end
SKIN_SUFFIX[SkinColor.SKIN_PINK] = ""

---@param familiar EntityFamiliar
local function PunchingBagInit(_, familiar)
    if familiar.Player:HasCollectible(mod.Enums.CollectibleType.CASTLE) then
        return end
    local skinSuffix = SKIN_SUFFIX[familiar.Player:GetBodyColor()]
    local headSprite = "gfx/familiars/familiar_281_punchingbag" .. skinSuffix
    local bodySprite = "gfx/characters/costumes/costume_body" .. skinSuffix
    --[[
    if skinSuffix == "" then
        bodySprite = "blah"
    else
        bodySprite = "gfx/characters/costumes/costume_body" .. skinSuffix
    end
    ]]
    local sprite = familiar:GetSprite()
    --sprite:Load("blah", false)
    sprite:ReplaceSpritesheet(1, headSprite .. ".png")
    sprite:ReplaceSpritesheet(0, bodySprite .. ".png")
    sprite:LoadGraphics()
    --sprite:Play("Idle")
end
mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, PunchingBagInit, FamiliarVariant.PUNCHING_BAG)