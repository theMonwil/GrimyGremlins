GrimyGremlinsMod = RegisterMod("Grimy Gremlins", 1)

for _, directory in ipairs({
    {
        directoryName = "utils",
        "data",
        "iterators",
        "enums",
        "idk",
    },
    {
        directoryName = "items",
        "castle",
        "conjure",
        "congregate",
        "conquer",
        "rebirth",
    },
    {
        directoryName = "familiars",
        "rook_punching_bag",
        "homunculus"
    },
    {
        directoryName = "characters",
        "rook",
        "scrap",
        "conrad",
        "reborn",
    },
}) do
    local directoryName = directory.directoryName
    for _, fileName in ipairs(directory) do
        include("grimygremlins_scripts." .. directoryName .. "." .. fileName)
    end
end