util.AddNetworkString("AA_CRATE")
util.AddNetworkString("AA_TRANSFER_TO_CRATE")
util.AddNetworkString("AA_TRANSFER_TO_PLAYER")
util.AddNetworkString("AA_INCRATE")

local function pt(t)
	Msg("=============================================\n")
	PrintTable(t)
	Msg("=============================================\n")
end

local function transferToPlayer(len, ply)
	if !ply:Alive() then return end
	local read = net.ReadString()
	local sender = net.ReadEntity()
	if read != "null" then
		for k, v in pairs(sender.storage) do
			if v.class == read then
				table.insert(ply.inventory, conf.items[v.class])
				table.remove(sender.storage, k)
				break
			end
		end
		net.Start("AA_INVENTORY")
		net.WriteTable(ply.inventory)
		net.Send(ply)

		net.Start("AA_CRATE")
		net.WriteTable(sender.storage)
		net.WriteEntity(sender)
		net.Send(ply)
	end
end

net.Receive("AA_TRANSFER_TO_PLAYER", transferToPlayer)