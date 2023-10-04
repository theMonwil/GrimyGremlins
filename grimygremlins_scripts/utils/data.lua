local mod = GrimyGremlinsMod

local GetDataReplacement = {}

---@param entity Entity
---@return table
function mod:EntityData(entity)
    local hash = GetPtrHash(entity)
    if not GetDataReplacement[hash] then
        GetDataReplacement[hash] = {}
    end
    return GetDataReplacement[hash]
end

local function PreGameExit()
    GetDataReplacement = {}
end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, PreGameExit)

local function PostEntityRemove(_,entity)
    GetDataReplacement[GetPtrHash(entity)] = nil
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, PostEntityRemove)