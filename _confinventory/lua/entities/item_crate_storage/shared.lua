ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Crate"
ENT.Author			= "confuseth"
ENT.Category		= "confInventory";
ENT.Spawnable		= true;
ENT.AdminOnly		= true;


function ENT:SetupDataTables()
	self:NetworkVar("Table", 0, "Contents")
end


