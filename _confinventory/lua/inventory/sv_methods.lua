AddCSLuaFile( "inventory/cl_methods.lua" )
AddCSLuaFile( "inventory/cl_cratemethods.lua" )
util.AddNetworkString("AA_COMMAND")
util.AddNetworkString("AA_INVENTORY")
util.AddNetworkString("AA_DROP")
util.AddNetworkString("AA_EQUIP")
util.AddNetworkString("AA_USE")
util.AddNetworkString("AA_DEATH")
util.AddNetworkString("AA_REFRESH")

local function pt(t)
	Msg("=============================================\n")
	PrintTable(t)
	Msg("=============================================\n")
end

local meta = FindMetaTable("Player")

function meta:SetSkills(tables)
	self.skills = table.Copy(tables)
end

function meta:AddSkillLevel(skill, level)
	if type(skill) != "string" then return end
	if level < 0 then return end
	self.skills[skill] = level
end

function meta:GetSkills()
	return self.skills
end


local function searchCommand(ply, txt)
	local lookat = ply:GetEyeTrace().Entity
	if (string.lower(txt) == "/search" ) then
		if ply:GetPos():Distance( lookat:GetPos() ) < 150 then
			if lookat.inventory then
				ply:Freeze(true)
				timer.Simple(1,function()
					ply:ChatPrint("Their inventory contains:")
					for k, v in pairs(lookat.inventory) do
						ply:ChatPrint(v.class)
					end
				end)
			return ""
			end
		else
			ply:ChatPrint("You can find no items in their inventory.")
			return ""
		end
	end
end

hook.Add("PlayerSay", "PlayerLookAtInventory", searchCommand)

local function commandinventoryString(ply, txt)

	if (conf.commands[string.lower(txt)] == true ) then
		
		net.Start("AA_COMMAND")
		net.WriteTable(ply.skills)
		net.Send(ply)
		return ""
	end

end

hook.Add("PlayerSay", "PlayerSayInventory", commandinventoryString)


local function bindinventoryString(ply)

	net.Start("AA_COMMAND")
	net.WriteTable(ply.skills)
	net.Send(ply)

end

hook.Add("ShowHelp", "PlayerShowHelpInventory", bindinventoryString)


local function handleskillsPlayer(ply)
	ply.inventory = {}
	for k, v in pairs(conf.teams) do
		if k == ply:Team() then
			ply:SetSkills(v)
		end
	end
end

hook.Add("PlayerInitialSpawn", "PlayerInitialSpawnSkill", handleskillsPlayer)
hook.Add("PlayerSpawn", "PlayerSpawnSkill", handleskillsPlayer)

function meta:SetInventory(tbl, ammo, clip)
    local tabl = table.Copy(tbl)
	if ammo then
		tabl.ammo = ammo
		if clip then
			tabl.clip = clip
		end
	end
	table.insert(self.inventory, tabl)
	net.Start("AA_INVENTORY")
	net.WriteTable(self.inventory)
	net.Send(self)
end

local function handleweaponPickup()
	for keys, ply in pairs(player.GetAll()) do
		local ent = ply:GetEyeTrace().Entity
		if !ent:IsWorld() and !ent:IsPlayer() then
		if ply:GetPos():Distance(ent:GetPos()) < 150 then
			if ply:KeyPressed(IN_USE) then
			    if conf.items[ent:GetClass()] and conf.items[ent:GetClass()].type > 2 then
			    	if #ply.inventory <= (conf.maxitems - 1) then
			    		if ent:IsWeapon() then
			    			local weapon = conf.items[ent:GetClass()]
			    			local ammo = ply:GetAmmoCount( ent:GetPrimaryAmmoType() ) 
			    			local clip = ent:Clip1()
					    	ent:Remove()
					    	ply:SetInventory(weapon, ammo, clip)
			    		else
				    		ent:Remove()
				    		ply:SetInventory(conf.items[ent:GetClass()])
				    	end
			    	end
			    elseif conf.items[ent:GetClass()] and conf.items[ent:GetClass()].type <= 2 then
				    if #ply.inventory <= (conf.maxitems - 1) then
						ent:Remove()
						ply:SetInventory(conf.items[ent:GetClass()])
				    end
				end
			end
		end
	end
	end
end

hook.Add("Think", "PlayerPickups", handleweaponPickup)
local function handldefaultPickups(ply, ent)
	if conf.whitelist[ent:GetClass()] != nil then
	    return conf.whitelist[ent:GetClass()]
	end
	
	if ent.pickup == true then
	    ent.pickup = false;
	    return true
	end

	if string.match(ent:GetClass(), "pill") then
	    return true
	end

	if conf.items[ent:GetClass()] then
		return false
	end
	return true
end
hook.Add("PlayerCanPickupItem", "PlayerPickupItemSkill", handldefaultPickups)
hook.Add("PlayerCanPickupWeapon", "PlayerPickupItemSkill", handldefaultPickups)

local function dropentityInventory(len, ply)
	if !ply:Alive() then return end
	local int = net.ReadInt(4) -- IS THE TYPE, 0 == unequipped 1 == EQUIPPED
	local read = net.ReadString() 
	for k, v in pairs(ply.inventory) do
		if v.class == read then
			if int == 1 then
				ply:StripWeapon(v.class)
				ply.inventory[k].type = 0
				table.remove(ply.inventory, k)
				net.Start("AA_INVENTORY")
				net.WriteTable(ply.inventory)
				net.Send(ply)

				local ent = ents.Create(read)
				ent:SetPos(ply:GetPos() + ply:GetForward():GetNormalized() * 100)
				ent:SetModel(conf.items[read].mdl)
				ent:Spawn()

				break
			else
				table.remove(ply.inventory, k)
				net.Start("AA_INVENTORY")
				net.WriteTable(ply.inventory)
				net.Send(ply)

				local ent = ents.Create(read)
				ent:SetPos(ply:GetPos() + ply:GetForward():GetNormalized() * 100)
				ent:SetModel(conf.items[read].mdl)
				ent:Spawn()
				break
			end
		end
	end
	

	net.Start("AA_COMMAND")
	net.WriteTable(ply:GetSkills())
	net.Send(ply)
end

net.Receive("AA_DROP", dropentityInventory)

local function equipentityInventory(len, ply)
	if !ply:Alive() then return end
	local int = net.ReadInt(4)
	local read = net.ReadInt(8) -- THE KEY OF THE ITEM THAT I WANT TO EQUIP
	if read == -1 then
		ply:ChatPrint("ERROR: You cannot use this item right now.")
		return 
	end
	if int == 1 then
		for k, v in ipairs(ply.inventory) do
			if k == read then
				local ent = ents.Create(v.class)
				ent:SetPos(ply:GetPos())
				ent.pickup = true
				ent:Spawn()
				timer.Simple(0.5,function()
					local wep = ply:GetWeapon(v.class)
					ply:SetAmmo(v.ammo, wep:GetPrimaryAmmoType() )
					wep:SetClip1(v.clip)
					ply.inventory[read].type = int
					net.Start("AA_INVENTORY")
					net.WriteTable(ply.inventory)
					net.Send(ply)
				end)
				break
			end
		end
	elseif int == 0 then
		for k, v in ipairs(ply.inventory) do
			if k == read then
				local wep = ply:GetWeapon(v.class)
				print("error")
				v.ammo = ply:GetAmmoCount(wep:GetPrimaryAmmoType())
				v.clip = wep:Clip1()
				ply:StripWeapon(v.class)
				ply.inventory[read].type = int
				net.Start("AA_INVENTORY")
				net.WriteTable(ply.inventory)
				net.Send(ply)
				break
			end
		end
	else
		for k, v in pairs(ply.inventory) do
			if k == read then
				table.remove(ply.inventory, k)
				net.Start("AA_INVENTORY")
				net.WriteTable(ply.inventory)
				net.Send(ply)

				local ent = ents.Create(v.class)
				ent:SetPos(ply:GetPos())
				ent.pickup = true
				ent:Spawn()
				break
			end
		end
	end
	
	
	net.Start("AA_COMMAND")
	net.WriteTable(ply:GetSkills())
	net.Send(ply)
end

net.Receive("AA_EQUIP", equipentityInventory)

local function updateonDeath(ply, inf, att)
	ply:ClearInventory(ply:GetPos())
end

hook.Add("PlayerDeath", "PlayerDeathInventory", updateonDeath)

function meta:ClearInventory(pos)
	if table.Count( self.inventory ) > 0 then
		for k, v in pairs(self.inventory) do
			local ents = ents.Create(v.class)
			ents:SetPos(pos)
			ents:SetModel(v.mdl)
			ents:Spawn()
		end
	end
	self.skills = {}
	self.inventory = {}
	net.Start("AA_DEATH")
	net.Send(self)
end