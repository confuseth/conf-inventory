AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" ) 
 
include('shared.lua')


function ENT:Initialize()
 
	self:SetModel( "models/props_lab/binderredlabel.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
 	self:SetUseType( SIMPLE_USE )
 	self:SetTrigger(true)
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:StartTouch( ent )
	self.pickup = true
	ent:AddSkillLevel("str", 1)
	ent:ChatPrint("You increased your strength level.")
	self:Remove()
end


function ENT:Think()
	
end

function ENT:OnRemove()


end;
