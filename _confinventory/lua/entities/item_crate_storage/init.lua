AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" ) 
 
include('shared.lua')


function ENT:Initialize()
 
	self:SetModel( "models/props_junk/wood_crate001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
 	self:SetUseType( SIMPLE_USE )
 	
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use( activator, caller )
	local locked = false
	for k, v in pairs(player.GetAll()) do
		if v.incrate == self then
			locked = true
			break
		end
	end
	if locked then
		caller:ChatPrint("ERROR: Somebody is using the crate already.")
	else
		self.storage = self.storage or {}
		net.Start("AA_CRATE")
		net.WriteTable(self.storage)
		net.WriteEntity(self)
		net.Send(caller)
		caller.incrate = self
	end
end


function ENT:Think()
	
end

function ENT:OnRemove()


end;

function ENT:SetStorage(tabl)
	
end

local function addtoCrateStorage(len, ply)
	local ent = net.ReadString()
	local me = net.ReadEntity()
	if ent != "null" then
		for k, v in pairs(ply.inventory) do
			if v.class == ent then
				table.insert(me.storage, conf.items[ent])
				table.remove(ply.inventory, k)
				break
			end
		end
		net.Start("AA_INVENTORY")
		net.WriteTable(ply.inventory)
		net.Send(ply)

		net.Start("AA_CRATE")
		net.WriteTable(me.storage)
		net.WriteEntity(me)
		net.Send(ply)
	end
end
net.Receive("AA_INCRATE", function(len, ply) ply.incrate = nil end)
net.Receive("AA_TRANSFER_TO_CRATE", addtoCrateStorage)