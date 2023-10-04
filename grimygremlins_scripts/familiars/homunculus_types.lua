---@class Homunculus
---@field Damage number
---@field Color Color

---@type { [string]: Color }
local COLORS = {
    Coin = Color(0.78, 0.56, 0.24),
    RedHeart = Color(0.75, 0.21, 0.29),
    Bomb = Color(0.26, 0.26, 0.26),
    Key = Color(0.89, 0.89, 0.89),
    GoldPickup = Color(1.00, 0.89, 0.00),
}

return {

    ---@type { [integer]: Homunculus }
    [PickupVariant.PICKUP_COIN] = {
        [CoinSubType.COIN_PENNY] = {Damage = 1, Color = COLORS.Coin},
        [CoinSubType.COIN_LUCKYPENNY] = {Damage = 1, Color = COLORS.Coin},
        [CoinSubType.COIN_DOUBLEPACK] = {Damage = 2, Color = COLORS.Coin},
        [CoinSubType.COIN_NICKEL] = {Damage = 5, Color = COLORS.Coin},
        [CoinSubType.COIN_STICKYNICKEL] = {Damage = 5, Color = COLORS.Coin},
        [CoinSubType.COIN_DIME] = {Damage = 10, Color = COLORS.Coin},
        [CoinSubType.COIN_GOLDEN] = {Damage = 10, Color = COLORS.GoldPickup},
    },
    ---@type { [integer]: Homunculus }
    [PickupVariant.PICKUP_HEART] = {
        [HeartSubType.HEART_FULL] = {Damage = 2, Color = COLORS.RedHeart},
        [HeartSubType.HEART_SCARED] = {Damage = 2, Color = COLORS.RedHeart},
        [HeartSubType.HEART_DOUBLEPACK] = {Damage = 4, Color = COLORS.RedHeart},
        [HeartSubType.HEART_HALF] = {Damage = 1, Color = COLORS.RedHeart},
        [HeartSubType.HEART_SOUL] = {Damage = 4, Color = COLORS.RedHeart},
        [HeartSubType.HEART_HALF_SOUL] = {Damage = 4, Color = COLORS.RedHeart},
        [HeartSubType.HEART_BLACK] = {Damage = 5, Color = COLORS.RedHeart},
        [HeartSubType.HEART_BLENDED] = {Damage = 4, Color = COLORS.RedHeart},
        [HeartSubType.HEART_GOLDEN] = {Damage = 7, Color = COLORS.GoldPickup},
        [HeartSubType.HEART_BONE] = {Damage = 8, Color = COLORS.RedHeart},
        [HeartSubType.HEART_ROTTEN] = {Damage = 6, Color = COLORS.RedHeart},
        [HeartSubType.HEART_ETERNAL] = {Damage = 12, Color = COLORS.RedHeart},
    },
    ---@type { [integer]: Homunculus }
    [PickupVariant.PICKUP_BOMB] = {
        [BombSubType.BOMB_NORMAL] = {Damage = 5, Color = COLORS.Bomb},
        [BombSubType.BOMB_DOUBLEPACK] = {Damage = 10, Color = COLORS.Bomb},
        [BombSubType.BOMB_GOLDEN] = {Damage = 25, Color = COLORS.GoldPickup},
        [BombSubType.BOMB_GIGA] = {Damage = 25, Color = COLORS.Bomb},
    },
    ---@type { [integer]: Homunculus }
    [PickupVariant.PICKUP_KEY] = {
        [KeySubType.KEY_NORMAL] = {Damage = 5, Color = COLORS.Key},
        [KeySubType.KEY_DOUBLEPACK] = {Damage = 10, Color = COLORS.Key},
        [KeySubType.KEY_CHARGED] = {Damage = 8, Color = COLORS.Key},
        [KeySubType.KEY_GOLDEN] = {Damage = 25, Color = COLORS.GoldPickup},
    },

    ---@type Homunculus
    [PickupVariant.PICKUP_PILL] = {
        Damage = 8, Color = Color(0.31, 0.25, 0.6)
    },

    ---@type Homunculus 
    [PickupVariant.PICKUP_TAROTCARD] = {
        Damage = 8, Color = Color(0.6, 0.4, 0.25)
    },

    ---@type Homunculus 
    [PickupVariant.PICKUP_TRINKET] = {
        Damage = 12, Color = Color(0.7, 0.7, 0.8)
    },
}