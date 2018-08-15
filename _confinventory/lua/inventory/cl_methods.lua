function inventoryTable()
	local item = net.ReadTable()
	LocalPlayer().inventory = item
end

net.Receive("AA_INVENTORY", inventoryTable)

function clearTable()
	LocalPlayer().inventory = {}
end

local PANEL = FindMetaTable("Panel")


net.Receive("AA_DEATH", clearTable)
local function receiveCommand()
	if active then 
		frm:Close()
		active = false
		return 
	end
	local version = conf.version
	local active = true
	local skills = net.ReadTable()

	LocalPlayer().skills = skills

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
	local lbl = TDLib("DButton", bar)
	lbl:Dock(LEFT)
	lbl:SetWide(lblw)
	lbl:SetText("")
	lbl:SetToolTip(conf.tooltip)
	lbl:SetOpenURL(conf.credits)
	lbl:ClearPaint()
		:Background(Color(255,255,255,0))
		:Text(version, "Trebuchet18")


	-- close button
	local clsbtn = TDLib("DButton", bar)
	clsbtn:SetPos(bar:GetWide() - 55, 5)
	clsbtn:SetSize(50, 20)
	clsbtn:SetText("")
	clsbtn:SetRemove(frm)
	clsbtn.DoClick = function() frm:Close() active = false end
	clsbtn:ClearPaint()
		:Background(Color(107, 107, 107))
    	:FadeHover(Color(200, 100, 100))
    	:Text("X", "Trebuchet18")


	-- nav bar where the model is in
	local nav = TDLib("DPanel", frm)
	nav:SetPos(0,30)
	nav:SetTall(frm:GetTall() - 30)
	nav:ClearPaint()
		:Background(Color(107,107,107, 0	))
		:DivWide(3)

	-- first option, model
	local model = TDLib("DModelPanel", nav)
	model:SetSize(nav:GetWide() - 10, nav:GetTall() / 1.3)
	model:SetText("")
	model:Dock(TOP)
	model:DockMargin(5, -20, 5, 5)
	model:SetModel( LocalPlayer():GetModel() ) 
	model:SetFOV(49)
	local skill = TDLib("DPanel", nav)
	skill:Dock(BOTTOM)
	skill:DockMargin(5,5,5,0)
	skill:SetTall(nav:GetTall() / 4 - 15)
	skill:ClearPaint()
		:Background(Color(60,60,60, 0))

	local slblstring = "Current Skills"
	local slblw, slblh = surface.GetTextSize(slblstring)

	local slbl = TDLib("DButton", skill)
	slbl:Dock(TOP)
	slbl:DockMargin(5,5,5,0)
	slbl:SetWide(slblw)
	slbl:ClearPaint()
		:Background(Color(67,67,67,255))
		:Text(slblstring, "Trebuchet18")

	--[[ for k, v in pairs(skilltable) do
		
	end --]]
	-- make those below inside for each skill for hte player
	for k, v in pairs(LocalPlayer().skills) do

		local stringk = "Undefined"
		if k == "med" then strink = "Medical Fields" elseif k == "str" then strink = "Physical Strength" end

		local skilltop = TDLib("DLabel", skill)
		skilltop:Dock(TOP)
		skilltop:DockMargin(5,5,5,0)
		skilltop:ClearPaint()
			:Background(Color(67,67,67,255))
			:Text(" Skill: "..strink, "Trebuchet18")

		local skillbot = TDLib("DLabel", skill)
		skillbot:Dock(TOP)
		skillbot:DockMargin(5,0,5,0)
		skillbot:ClearPaint()
			:Background(Color(100,100,100,255))
			:Text(" Level " ..v, "Trebuchet18")
	end
	
	---------------------------------------------------------

	local inv = TDLib("DPanel", frm)
	inv:SetPos(nav:GetWide() + 5, 35)
	inv:SetSize(frm:GetWide() - nav:GetWide() - 10,frm:GetTall()-40)
	inv:ClearPaint()
		:Background(Color(115,115,115, 0))

	local invscroll = vgui.Create("DScrollPanel", inv)
	invscroll:Dock(FILL)

	local invent = LocalPlayer().inventory
	if invent then
		for k, v in pairs(invent) do
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
			local labl = "EQUIP"
			local cole = Color(100,255,100)
			if v.type >= 2 then 
				labl = "USE"
				local cole = Color(255,255,255)
			elseif v.type == 1 then
				labl = "UNEQUIP"
				cole = Color(255,111,111)
			end
			local eqp = TDLib("DButton", items)
			eqp.entity = v.class
			eqp:Dock(TOP)
			eqp:DockMargin(5,5,5,0)
			eqp.locked = false
			eqp:NetMessage("AA_EQUIP", function()
				for h, g in pairs(LocalPlayer().skills) do
					if !(g >= v.skill[h]) then 
						eqp.locked = true
					end
				end
				for j, l in pairs(LocalPlayer():GetWeapons()) do
					if v.class == l:GetClass() and v.type == 0 then
						eqp.locked = true
						break
					end
				end
				if v.type == 3 and LocalPlayer():Health() >= 100 or eqp.locked then
					net.WriteInt(v.type, 4)
					net.WriteInt(-1, 8)
				elseif v.type >= 2 then
					net.WriteInt(v.type, 4)
					net.WriteInt(k, 8)
				    table.remove(invent, invent[eqp.entity])
				else
					if v.type == 0 then
						v.type = 1
						net.WriteInt(v.type, 4)
						net.WriteInt(k, 8)	
					elseif v.type == 1 then
						v.type = 0
						net.WriteInt(v.type, 4)
						net.WriteInt(k, 8)
					end
				end
				frm:Close()
			end)
			eqp:ClearPaint()
				:Background(Color(0,0,0,180))
    			:FadeHover(Color(222, 222, 222))
				:Text(labl, "Trebuchet18", cole)

			local drp = TDLib("DButton", items)
			drp.entity = v.class
			drp:Dock(TOP)
			drp:DockMargin(5,5,5,5)
			drp:NetMessage("AA_DROP", function()
				if v.type == 1 then
					net.WriteInt(v.type, 4)
					net.WriteString(drp.entity)
				    table.remove(invent, invent[drp.entity])
				    frm:Close()
				elseif v.type == 0 then	
					net.WriteInt(v.type, 4)
				    net.WriteString(drp.entity)
				    table.remove(invent, invent[drp.entity])
				    frm:Close()
				end
			end)
			drp:ClearPaint()
				:Background(Color(0,0,0,180))
    			:FadeHover(Color(222, 222, 222))
				:Text("DROP", "Trebuchet18")
		end
	end

end

net.Receive("AA_COMMAND", receiveCommand)