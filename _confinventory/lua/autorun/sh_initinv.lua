AddCSLuaFile()
if SERVER then
	include("inventory/sv_methods.lua")
	include("inventory/sv_cratemethods.lua")
else
	include("inventory/cl_methods.lua")
	include("inventory/cl_cratemethods.lua")
end