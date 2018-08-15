function inventoryCrateTable()
	local item = net.ReadTable()
	LocalPlayer().inventory = item
end

net.Receive("AA_TRANSFER_TO_PLAYER", inventoryCrateTable)

local function receiveCrate()
	if active then 
		frm:Close()
		active = false
		return 
	end
	local crateinventory = net.ReadTable()
	local sender = net.ReadEntity()
	local version = conf.version
	local active = true
	local frm = TDLib( "DFrame" )
	frm:SetPos(ScrW()/2 - 500, ScrH()/2 - 300)
	frm:SetSize( 1000, 600 )
	frm:SetTitle( "" )
	frm:ShowCloseButton(false)
	frm:MakePopup()
	frm:ClearPaint()
		:Background(Color(99, 99, 99, 150))
	

	-- design
	-- top bar, includes closebutton
	local bar = TDLib("DPanel", frm)
	bar:SetPos(0,0)
	bar:SetSize(frm:GetWide(), 30) -- 20 + 10 for button padding
	bar:ClearPaint()
		:Background(Color(60,60,60))

	local lblw, lblh = surface.GetTextSize(version)
	local lbl = TDLib("DLabel", bar)
	lbl:SetPos(5,5)
	lbl:SetWide(lblw)
	lbl:SetText("")
	lbl:ClearPaint()
		:Text(version, "Trebuchet18")

	-- close button
	local clsbtn = TDLib("DButton", bar)
	clsbtn:SetPos(bar:GetWide() - 55, 5)
	clsbtn:SetSize(50, 20)
	clsbtn:SetText("")
	clsbtn:SetRemove(frm)
	clsbtn:NetMessage("AA_INCRATE", function()
		active = false
		frm:Close()
	end)
	clsbtn:ClearPaint()
		:Background(Color(107, 107, 107))
    	:FadeHover(Color(200, 100, 100))
    	:Text("X", "Trebuchet18")


	---------------------------------------------------------

	local inv = TDLib("DPanel", frm)
	inv:SetPos(5, 35)
	inv:SetSize(frm:GetWide() / 2 - 10,frm:GetTall()-40)
	inv:ClearPaint()
		:Background(Color(115,115,115, 0))

	local invscroll = vgui.Create("DScrollPanel", inv)
	invscroll:Dock(FILL)

	local invent = LocalPlayer().inventory
	if invent then
		for k, v in pairs(invent) do
			if v.type == 1 then continue end
			local items = invscroll:Add("DPanel")
			items:Dock(TOP)
			items:DockMargin(5,5,5,0)
			items:SetSize(inv:GetWide() - 10 - 160, 60)
			items:TDLib()
				:Background(Color(55,55,55))
				:Gradient(v.col, LEFT)

			local imdl = TDLib("DModelPanel", items)
			imdl:SetSize(60, 60)
			imdl:SetText("")
			imdl:Dock(LEFT)
			imdl:DockMargin(5,5,5,5)
			imdl:SetModel( v.mdl )
			local mn, mx = imdl.Entity:GetRenderBounds()
			local size = 0
			size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
			size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
			size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

			imdl:SetFOV( 45 )
			imdl:SetCamPos( Vector( size, size, size ) )
			imdl:SetLookAt( ( mn + mx ) * 0.5 )
			function imdl:LayoutEntity( ent ) return end 

			local itxt = TDLib("DLabel", items)
			itxt:Dock(LEFT)
			itxt:DockMargin(5,0,5,0)
			itxt:SetText("")
			itxt:SetSize(items:GetWide() - 10 - imdl:GetWide() - 15, 60)
			itxt:TDLib()
				:Background(Color(0,0,0,0))
				:DualText(
			        v.name,
			        "Trebuchet24",
			        Color(0, 0, 0),

			        v.desc,
			        "Trebuchet18",
			        Color(45, 45, 45),
			        RIGHT
			    )

			local eqp = TDLib("DButton", items)
			eqp.entity = v.class
			eqp:Dock(TOP)
			eqp:DockMargin(5,5,5,0)
			eqp:NetMessage("AA_TRANSFER_TO_CRATE", function()
				if #crateinventory <= (conf.maxcrate - 1) then
					net.WriteString(eqp.entity)
				    table.remove(invent, invent[eqp.entity])
				    eqp:GetParent():Remove()
					net.WriteEntity(sender)
					frm:Close()
				else
					net.WriteString("null")
					net.WriteEntity(sender)
				end
			end)
			eqp:ClearPaint()
				:Background(Color(0,0,0,180))
    			:FadeHover(Color(222, 222, 222))
				:Text("TRANSFER", "Trebuchet18")
		end
	end

	local storage = TDLib("DPanel", frm)
	storage:SetPos(frm:GetWide() / 2 + 5, 35)
	storage:SetSize(frm:GetWide() / 2 - 10,frm:GetTall()-40)
	storage:ClearPaint()
		:Background(Color(115,115,115, 0))

	local sscroll = vgui.Create("DScrollPanel", storage)
	sscroll:Dock(FILL)

	if crateinventory then
		for k, v in pairs(crateinventory) do
			local sitems = sscroll:Add("DPanel")
			sitems:Dock(TOP)
			sitems:DockMargin(5,5,5,0)
			sitems:SetSize(storage:GetWide() - 10 - 160, 60)
			sitems:TDLib()
				:Background(Color(55,55,55))
				:Gradient(v.col, RIGHT)

			local simdl = TDLib("DModelPanel", sitems)
			simdl:SetSize(60, 60)
			simdl:SetText("")
			simdl:Dock(RIGHT)
			simdl:DockMargin(5,5,5,5)
			simdl:SetModel( v.mdl )
			local mn, mx = simdl.Entity:GetRenderBounds()
			local size = 0
			size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
			size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
			size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

			simdl:SetFOV( 45 )
			simdl:SetCamPos( Vector( size, size, size ) )
			simdl:SetLookAt( ( mn + mx ) * 0.5 )
			function simdl:LayoutEntity( ent ) return end 

			local sitxt = TDLib("DLabel", sitems)
			sitxt:Dock(RIGHT)
			sitxt:DockMargin(5,0,5,0)
			sitxt:SetText("")
			sitxt:SetSize(sitems:GetWide() - 10 - simdl:GetWide() - 15, 60)
			sitxt:TDLib()
				:Background(Color(0,0,0,0))
				:DualText(
			        v.name,
			        "Trebuchet24",
			        Color(0, 0, 0),

			        v.desc,
			        "Trebuchet18",
			        Color(45, 45, 45),
			        LEFT
			    )
			
			local seqp = TDLib("DButton", sitems)
			seqp.entity = v.class
			seqp:Dock(TOP)
			seqp:DockMargin(5,5,5,0)
			seqp:NetMessage("AA_TRANSFER_TO_PLAYER", function()
				if #invent <= (conf.maxitems - 1) then
					net.WriteString(seqp.entity)
				    table.remove(crateinventory, crateinventory[seqp.entity])
				    seqp:GetParent():Remove()
					net.WriteEntity(sender)
					frm:Close()
				else
					net.WriteString("null")
					net.WriteEntity(sender)
				end
			end)
			seqp:ClearPaint()
				:Background(Color(0,0,0,180))
    			:FadeHover(Color(222, 222, 222))
				:Text("TAKE", "Trebuchet18")
		end
	end
end

net.Receive("AA_CRATE", receiveCrate)
