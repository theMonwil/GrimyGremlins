GrimyGremlinsMod.Enums =
{
    PlayerType = {
        ROOK = Isaac.GetPlayerTypeByName("Rook"),
        T_ROOK = Isaac.GetPlayerTypeByName("Rook", true),
        SCRAP = Isaac.GetPlayerTypeByName("Scrap"),
        T_SCRAP = Isaac.GetPlayerTypeByName("Scrap", true),
        CONRAD = Isaac.GetPlayerTypeByName("Conrad"),
        T_CONRAD = Isaac.GetPlayerTypeByName("Conrad", true),
        REBORN = Isaac.GetPlayerTypeByName("Reborn"),
        T_REBORN = Isaac.GetPlayerTypeByName("Reborn", true),
    },

    CollectibleType = {
        ROOK_SOUL = Isaac.GetItemIdByName("Rook's Soul"),
        SCRAP_SOUL = Isaac.GetItemIdByName("Scrap's Soul"),
        CONRAD_SOUL = Isaac.GetItemIdByName("Conrad's Soul"),
        REBORN_SOUL = Isaac.GetItemIdByName("Reborn's Soul"),

        CASTLE = Isaac.GetItemIdByName("Castle"),

        CONJURE = Isaac.GetItemIdByName("Conjure"),
        CONGREGATE = Isaac.GetItemIdByName("Congregate"),
        CONQUER = Isaac.GetItemIdByName("Conquer"),

        REBIRTH = Isaac.GetItemIdByName("Rebirth"),
        VERDANT_SEED = Isaac.GetItemIdByName("Verdant Seed"),
        VERDANT_SEEDS = Isaac.GetItemIdByName("Verdant Seeds"),
        WITHERED_SEED = Isaac.GetItemIdByName("Withered Seed"),
        WITHERED_SEEDS = Isaac.GetItemIdByName("Withered Seeds"),
    },

    NullCostumes = {
        ROOK_HEAD = Isaac.GetCostumeIdByPath("gfx/characters/rook_head.anm2"),
        ROOK_HEAD_BLACK = Isaac.GetCostumeIdByPath("gfx/characters/rook_head_black.anm2"),
    },

    FamiliarVariant = {
        HOMUNCULUS = Isaac.GetEntityVariantByName("Artificer's Homunculus")
    }
}