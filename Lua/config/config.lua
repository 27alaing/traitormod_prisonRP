local config = {}
config.DebugLogs = true

----- USER FEEDBACK -----
config.Language = "English"
config.SendWelcomeMessage = true
config.ChatMessageType = ChatMessageType.Private    -- Error = red | Private = green | Dead = blue | Radio = yellow

config.Extensions = {
    dofile(Traitormod.Path .. "/Lua/extensions/weaponnerfs.lua"),
    --dofile(Traitormod.Path .. "/Lua/extensions/paralysisnerf.lua"),
    dofile(Traitormod.Path .. "/Lua/extensions/pressuremidjoin.lua"),
}

config.ExtensionConfig = {

}

----- GAMEPLAY -----
config.Codewords = {
    "hull", "tabacco", "nonsense", "fish", "clown", "quartermaster", "fast", "possibility",
	"thalamus", "hungry", "water", "looks", "renegade", "angry", "green", "sink", "rubber",
	"mask", "sweet", "ice", "charybdis", "cult", "secret", "frequency",
	"husk", "rust", "ruins", "red", "boat", "cats", "rats", "blast",
	"tire", "trunk", "weapons", "threshers", "cargo", "method", "monkey"
}

config.AmountCodeWords = 2

config.OptionalTraitors = true        -- players can use !toggletraitor
config.RagdollOnDisconnect = false
config.EnableControlHusk = false     -- EXPERIMENTAL: enable to control husked character after death
config.DeathLogBook = true
config.HideCrewList = true -- EXPERIMENTAL
config.RoleplayNames = true -- if you want a rp name on round start
config.RoleIntros = true -- messages for each role everytime the round starts
config.NLRMessage = true

-- This overrides the game's respawn shuttle, and uses it as a submarine injector, to spawn submarines in game easily. Respawn should still work as expected, but the shuttle submarine file needs to be manually added here.
-- Note: If this is disabled, traitormod will disable all functions related to submarine spawning.
-- Warning: Only respawn shuttles will be used, the option to spawn people directly into the submarine doesnt work.
config.OverrideRespawnSubmarine = true
config.RespawnSubmarineFile = "Content/Submarines/Selkie.sub"
config.RespawnText = "Respawn in %s seconds."
config.RespawnTeam = CharacterTeamType.Team2
config.RespawnOnKillPoints = 500
config.RespawnEnabled = false -- set this to false to disable respawn, respawn shuttle override features will still be active, there just wont be any respawns

-- Allows players that just joined the server to instantly spawn
config.MidRoundSpawn = true

----- POINTS + LIVES -----
config.StartPoints = 950 -- new players start with this amount of points
config.PermanentPoints = true      -- sets if points and lives will be stored in and loaded from a file
config.RemotePoints = nil
config.RemoteServerAuth = {}
config.PermanentStatistics = true  -- sets if statistics be stored in and loaded from a file
config.MaxLives = 5
config.MinRoundTimeToLooseLives = 10000000
config.RespawnedPlayersDontLooseLives = true
config.MaxExperienceFromPoints = 500000     -- if not nil, this amount is the maximum experience players gain from stored points (30k = lvl 10 | 38400 = lvl 12)

config.FreeExperience = 1000         -- temporary experience given every ExperienceTimer seconds
config.ExperienceTimer = 145

config.PointsGainedFromSkill = {
    medical = 5,
    weapons = 5,
    mechanical = 4,
    electrical = 4,
    cooking = 3,
    butchery = 3,
}

config.PointsLostAfterNoLives = function (x)
    return x * 0.75
end

config.AmountExperienceWithPoints = function (x)
    return x
end

-- Give weight based on the logarithm of experience
-- 100 experience = 4 chance
-- 1000 experience = 6 chance
config.AmountWeightWithPoints = function (x)
    return math.log(x + 1) -- add 1 because log of 0 is -infinity
end

----- GAMEMODE -----
config.GamemodeConfig = {
    Secret = {
        PointshopCategories = {"clown", "traitormedic", "traitor", "cultist", "deathspawn", "prisoner", "maintenance", "materials", "medical", "security", "ships", "eventmanager", "eventships", "chef", "janitor"},
        EndOnComplete = true,           -- end round everyone but traitors are dead
        EnableRandomEvents = true,
        EndGameDelaySeconds = 15,

        TraitorSelectDelayMin = 85,
        TraitorSelectDelayMax = 135,

        PointsGainedFromHandcuffedTraitors = 1000,
        DistanceToEndOutpostRequired = 8000,

        MissionPoints = {
            Salvage = 1100,
            Monster = 1050,
            Cargo = 1000,
            Beacon = 1200,
            Nest = 1700,
            Mineral = 1000,
            Combat = 1400,
            AbandonedOutpost = 500,
            Escort = 1200,
            Pirate = 1300,
            GoTo = 1000,
            ScanAlienRuins = 1600,
            ClearAlienRuins = 2000,
            Default = 1000,
        },
        PointsGainedFromCrewMissionsCompleted = 1000,
        LivesGainedFromCrewMissionsCompleted = 1,

        TraitorTypeSelectionMode = "Vote", -- Vote | Random
        TraitorTypeChance = {
            Traitor = 50, -- Traitors have 33% chance of being a normal traitor
            Cultist = 20,
            Clown = 30,
        },

        AmountTraitors = function (amountPlayers)
            config.TestMode = false
            if amountPlayers > 14 then return 3 end
            if amountPlayers > 7 then return 2 end            
            if amountPlayers > 3 then return 1 end
            if amountPlayers == 1 then 
                Traitormod.SendMessageEveryone("1P testing mode - no points can be gained or lost") 
                config.TestMode = true
                return 1
            end
            print("Not enough players to start traitor mode.")
            return 0
        end,

        -- 0 = 0% chance
        -- 1 = 100% chance
        TraitorFilter = function (client)
            if client.Character.TeamID ~= CharacterTeamType.Team1 then return 0 end
            if not client.Character.IsHuman then return 0 end
            if client.Character.HasJob("warden") then return 0 end
            if client.Character.HasJob("headguard") then return 0 end
            if client.Character.HasJob("convict") then return 0 end
            if client.Character.HasJob("guard") then return 0 end
            if client.Character.HasJob("prisondoctor") then return 0.6 end
            if client.Character.HasJob("he-chef") then return 0.8 end

            return 1
        end
    },

    PvP = {
        PointshopCategories = {"clown", "traitor", "cultist", "deathspawn", "maintenance", "materials", "medical", "ores", "other", "security", "wiring", "ships"},
        EnableRandomEvents = false, -- most events are coded to only affect the main submarine
        WinningPoints = 1000,
        WinningDeadPoints = 500,
        MinimumPlayersForPoints = 4,
        ShowSonar = true,
        IdCardAllAccess = true,
        CrossTeamCommunication = true,
        BannedItems = {"coilgunammoboxexplosive", "nuclearshell"}
    },

    AttackDefend = {
        PointshopCategories = {"maintenance", "materials", "medical", "ores", "other", "wiring"},
        DefendTime = 15,
        DefendRespawn = 60,
        AttackRespawn = 70,
        WinningPoints = 1000,
    },
}

config.RoleConfig = {
    Crew = {
        AvailableObjectives = {
            ["warden"] = {"CrewSurvival", "KillSmallMonsters"},
            ["headguard"] = {"SecurityTeamSurvival", "KillLargeMonsters", "KillSmallMonsters"},
            ["guard"] = {"KillLargeMonsters", "KillSmallMonsters", "KeepPrisonersInside"},
            ["prisondoctor"] = {"HealCharacters", "MakeDrugs"},
            ["staff"] = {"RepairElectrical", "RepairMechanical", "RepairHull"},
            ["janitor"] = {"CleanBodies", "KillPets"},
            ["convict"] = {"Escape"},
            ["he-chef"] = {"Make4FoodItems", "CookMeth"},
        }
    },

    Cultist = {
        SubObjectives = {"Assassinate", "Kidnap", "TurnHusk", "DestroyCaly"},
        MinSubObjectives = 2,
        MaxSubObjectives = 3,

        NextObjectiveDelayMin = 30,
        NextObjectiveDelayMax = 60,

        TraitorBroadcast = true,           -- traitors can broadcast to other traitors using !tc
        TraitorBroadcastHearable = false,  -- if true, !tc will be hearable in the vicinity via local chat
        TraitorDm = true,                  -- traitors can send direct messages to other players using !tdm

        -- Names, None
        TraitorMethodCommunication = "Names",

        SelectBotsAsTargets = true,
        SelectPiratesAsTargets = false,
    },

    HuskServant = {
        TraitorBroadcast = true,
    },

    Pirate = {
        TraitorBroadcast = true,
    },

    Traitor = {
        SubObjectives = {"StealCaptainID", "Survive", "Kidnap", "PoisonCaptain", "DestroyWeapons", "SavePrisoner"},
        MinSubObjectives = 2,
        MaxSubObjectives = 3,

        NextObjectiveDelayMin = 30,
        NextObjectiveDelayMax = 60,

        TraitorBroadcast = true,           -- traitors can broadcast to other traitors using !tc
        TraitorBroadcastHearable = false,  -- if true, !tc will be hearable in the vicinity via local chat
        TraitorDm = true,                  -- traitors can send direct messages to other players using !tdm

        -- Names, Codewords, None
        TraitorMethodCommunication = "Names",

        SelectBotsAsTargets = true,
        SelectPiratesAsTargets = false,
        SelectUniqueTargets = true,     -- every traitor target can only be chosen once per traitor (respawn+false -> no end)
        PointsPerAssassination = 100,
    },

    Clown = {
        SubObjectives = {"BananaSlip", "SuffocateCrew", "AssassinateDrunk", "GrowMudraptors", "Survive", "OnAcid", "ClownControl"},
        MinSubObjectives = 3,
        MaxSubObjectives = 3,

        NextObjectiveDelayMin = 30,
        NextObjectiveDelayMax = 60,

        TraitorBroadcast = true,           -- traitors can broadcast to other traitors using !tc
        TraitorBroadcastHearable = false,  -- if true, !tc will be hearable in the vicinity via local chat
        TraitorDm = true,                  -- traitors can send direct messages to other players using !tdm

        -- Names, None
        TraitorMethodCommunication = "Names",

        SelectBotsAsTargets = true,
        SelectPiratesAsTargets = false,
    },
}

config.ObjectiveConfig = {
    Assassinate = {
        AmountPoints = 600,
    },

    Survive = {
        AlwaysActive = true,
        AmountPoints = 500,
        AmountLives = 1,
    },

    StealCaptainID = {
        AmountPoints = 1300,
    },

    Kidnap = {
        AmountPoints = 2500,
        Seconds = 100,
    },

    PoisonCaptain = {
        AmountPoints = 1600,
    },

    Husk = {
        AmountPoints = 800,
    },

    TurnHusk = {
        AmountPoints = 500,
        AmountLives = 1,
    },

    DestroyCaly = {
        AmountPoints = 500,
    },
}

----- EVENTS -----
config.RandomEventConfig = {
    Events = {
        dofile(Traitormod.Path .. "/Lua/config/randomevents/communicationsoffline.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/superballastflora.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/maintenancetoolsdelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/medicaldelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/ammodelivery.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/hiddenpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/electricalfixdischarge.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/wreckpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/beaconpirate.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/abysshelp.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/tuberculosis.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/lightsoff.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/emergencyteam.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/piratecrew.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/outpostpirateattack.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/shadymission.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/oxygengenpoison.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/oxygengenhusk.lua"),
        --dofile(Traitormod.Path .. "/Lua/config/randomevents/prisoner.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/randomlights.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/clownmagic.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/CleanupCrew.lua"),
        dofile(Traitormod.Path .. "/Lua/config/randomevents/NukieTakeover.lua"),
    }
}

config.PointShopConfig = {
    Enabled = true,
    DeathTimeoutTime = 60,
    ItemCategories = {
        dofile(Traitormod.Path .. "/Lua/config/pointshop/clown.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/cultist.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/traitormedic.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/prisoner.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/traitor.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/security.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/maintenance.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/materials.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/medical.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/ores.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/other.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/wiring.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/deathspawn.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/ships.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/janitor.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/chef.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/eventmanager.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/eventships.lua"),
        dofile(Traitormod.Path .. "/Lua/config/pointshop/patreonvanity.lua"),
    }
}

config.GhostRoleConfig = {
    Enabled = true,
    MiscGhostRoles = {
        ["Watcher"] = true,
        ["Mudraptor_pet"] = true,
        ["Fractalguardian"] = true,
        ["Fractalguardian2"] = true,
        ["Fractalguardian3"] = true,
    }
}

return config


