local category = {}
local allowedids = {"76561198120723359", "76561198408663756"}

category.Identifier = "patreonvanity"
category.Decoration = "group"

local function isAllowed(client)
    for _, id in pairs(allowedids) do
        if id == client.SteamID then
            return true
        end
    end
    return false
end

category.CanAccess = function(client)
    return client.Character and not client.Character.IsDead and isAllowed(client)
end

category.Products = {
    {
        Identifier = "Clown outfit",
        Price = 200,
        Limit = 5,
        Items = {"clownmask", "clowncostume", "bikehorn"},
    },
    {
        Identifier = "Honkmother outfit",
        Price = 1000,
        Limit = 1,
        Items = {"clownmaskunique", "clownsuitunique", "bikehorn"}, -- honkmother stuff
    },
}

return category
