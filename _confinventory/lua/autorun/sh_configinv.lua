AddCSLuaFile()

conf = conf or {}

local function config()
conf.commands = {
	["/inv"] = true,
}

conf.configreload = {
	["/reload"] = true,
}


conf.maxitems = 8
-- max items for inventory

conf.maxcrate = 12
-- max items for crates

conf.teams = {
	[TEAM_POLICE]= {["str"] = 1, ["med"] = 0},
	-- [TEAM_OVERWATCH] = {["str"] = 2, ["med"] = 1},
	-- [TEAN_CONSCRIPT] = {["str"] = 1, ["med"] = 0},
	-- [TEAM_CWU] = {["str"] = 0, ["med"] = 1},
	[TEAM_CITIZEN] = {["str"] = 0, ["med"] = 0},
}

--[[-----------------------------------------  
	SKILL:
		med = medical skill
		str = strength skill
		usage:
			 skill = {med = 2, str = 0} == Level 2 Medical Skill required
	TYPE:
		0 = weapon
		  1 = dont use this ever 
		2 = useable / consumeable
		3 = healths

--]]-----------------------------------------

conf.items = {
    --[[
		WEAPONS
    ]]--
    ["weapon_pistol"] = {
        name = "9mm Tatical USP",
        class = "weapon_pistol",
        skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 0,
        desc = "A grey tactical USP using 9mm rounds.",
      	col = Color(0, 150, 255, 100),
      	mdl = "models/weapons/w_pistol.mdl",
    },
    ["weapon_smg1"] = {
        name = "SMG-1",
        class = "weapon_smg1",
        skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 0,
		desc = "A black coated SMG-1 with a short barrel.",
		col = Color(0, 150, 255, 100),
		mdl = "models/weapons/w_smg1.mdl"
    },
    ["weapon_shotgun"] = {
        name = "Shotgun",
        class = "weapon_shotgun",
        skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 0,
		desc = "A black coated Shotgun.",
		col = Color(0, 150, 255, 100),
		mdl = "models/weapons/w_shotgun.mdl"
    },
    ["weapon_ar2"] = {
        name = "AR-2",
        class = "weapon_ar2",
        skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 0,
		desc = "A dark-blue AR-2.",
		col = Color(0, 150, 255, 100),
		mdl = "models/weapons/w_irifle.mdl"
    },
    ["weapon_crowbar"] = {
        name = "Crowbar",
        class = "weapon_crowbar",
        skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 0,
		desc = "A dark-blue AR-2.",
		col = Color(0, 150, 255, 100),
		mdl = "models/weapons/w_crowbar.mdl"
    },
    ["weapon_357"] = {
        name = "Revolver 357",
        class = "weapon_357",
        skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 0,
		desc = "A shining silver Revolver of the type 357.",
		col = Color(0, 150, 255, 100),
		mdl = "models/weapons/w_357.mdl"
    },
    ["weapon_crossbow"] = {
        name = "Makeshift Crossbow",
        class = "weapon_crossbow",
        skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 0,
		desc = "A makeshift Crossbow with a red rod loaded on it.",
		col = Color(0, 150, 255, 100),
		mdl = "models/weapons/w_crossbow.mdl"
    },
    ["weapon_rpg"] = {
        name = "RPG-7",
        class = "weapon_rpg",
        skill = {
            ["med"] = 0,
            ["str"] = 1
        },
        type = 0,
		desc = "A grey RPG-7.",
		col = Color(255, 50, 50, 100),
		mdl = "models/weapons/w_rocket_launcher.mdl"
    },
    ["weapon_medkit"] = {
        name = "Medkit",
        class = "weapon_medkit",
        skill = {
            ["med"] = 1,
            ["str"] = 0
        },
        type = 0,
        desc = "A white Medkit filled with a green goo.",
        col = Color(255, 255, 110, 100),
        mdl = "models/Items/HealthKit.mdl"
    },
    ["door_ram"] = {
        name = "Battering Ram",
        class = "door_ram",
        skill = {
            ["med"] = 0,
            ["str"] = 1
        },
        type = 0,
        desc = "A grey metallic battering ram.",
        col = Color(125, 255, 255, 100),
        mdl = "models/weapons/w_rocket_launcher.mdl"
    },

    --[[
		CONSUMEABLES & USEABLES
    ]]--
    ["item_healthvial"] = {
    	name = "MedVial",
    	class = "item_healthvial",
    	skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 3,
        desc = "A transparent vial filled with a green goo.",
        col = Color(50, 255, 150, 100),
        mdl = "models/healthvial.mdl"
    },

    ["item_book_medical"] = {
    	name = "Medical Fields - Book",
    	class = "item_book_medical",
    	skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 2,
        desc = "A book containing knowledge on Anatomy, Cardiology and Basic Science.",
        col = Color(80, 200, 255, 150),
        mdl = "models/props_lab/binderbluelabel.mdl"
    },

    ["item_book_physical"] = {
    	name = "Phyiscal Fields - Book",
    	class = "item_book_physical",
    	skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 2,
        desc = "A book containing knowledge on basic gymnastics and phyiscal training.",
        col = Color(80, 200, 255, 150),
        mdl = "models/props_lab/binderredlabel.mdl"
    },
    --[[
		AMMUNITION
    ]]--
    ["item_ammo_pistol"] = {
    	name = "9mm Bullet Case",
    	class = "item_ammo_pistol",
    	skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 2,
        desc = "A case of 9mm bullets ammunition.",
        col = Color(190, 190, 190, 150),
        mdl = "models/Items/BoxSRounds.mdl"
    },

    ["item_ammo_smg1"] = {
    	name = "SMG-1 Bullet Case",
    	class = "item_ammo_smg1",
    	skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 2,
        desc = "A case of SMG bullets ammunition.",
        col = Color(190, 190, 190, 150),
        mdl = "models/Items/BoxMRounds.mdl"
    },
    ["item_ammo_ar2"] = {
    	name = "AR-2 Cartridge",
    	class = "item_ammo_ar2",
    	skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 2,
        desc = "A AR-2 ammunition cartridge.",
        col = Color(190, 190, 190, 150),
        mdl = "models/Items/combine_rifle_cartridge01.mdl"
    },
    ["item_ammo_357"] = {
    	name = "357 Rounds",
    	class = "item_ammo_357",
    	skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 2,
        desc = "A case filled with 357 rounds.",
        col = Color(190, 190, 190, 150),
        mdl = "models/Items/357ammo.mdl"
    },
    ["item_box_buckshot"] = {
    	name = "Buckshot Case",
    	class = "item_box_buckshot",
    	skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 2,
        desc = "A shotgun ammunition case.",
        col = Color(190, 190, 190, 150),
        mdl = "models/Items/BoxBuckshot.mdl"
    },
    ["item_ammo_crossbow"] = {
    	name = "Crossbow Bolt",
    	class = "item_ammo_crossbow",
    	skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 2,
        desc = "A red crossbow bolt.",
        col = Color(190, 190, 190, 150),
        mdl = "models/Items/CrossbowRounds.mdl"
    },
   	["item_rpg_round"] = {
    	name = "RPG Round",
    	class = "item_rpg_round",
    	skill = {
            ["med"] = 0,
            ["str"] = 0
        },
        type = 2,
        desc = "A large RPG round.",
        col = Color(190, 190, 190, 150),
        mdl = "models/weapons/w_missile_closed.mdl"
    },
}

conf.whitelist = {
    ["weapon_physgun"] = true,
    ["gmod_tool"] = true,
    ["weapon_physcannon"] = true,
    ["weaponchecker"] = true,
    ["vort_heal"] = true,
    ["keys"] = true,
    ["gmod_camera"] = true,
    ["pocket"] = false,
    ["stunstick"] = true,
    ["weapon_r_handcuffs"] = true,
    ["thc_adminstick"] = true,
    ["weapon_keypadchecker"] = true,
    ["swep_vortigaunt_beam"] = true,
    ["weapon_frag"] = true
}




--[[-----------------------------------------  
	Don't touchy touchy
--]]-----------------------------------------
conf.credits = "http://steamcommunity.com/profiles/76561197967294342"
conf.tooltip = "Made by confuseth - STEAM_0:0:3514307"
conf.version = "confinventory v3.1b"

end

hook.Add("InitPostEntity","LoadConfigConf", config)

