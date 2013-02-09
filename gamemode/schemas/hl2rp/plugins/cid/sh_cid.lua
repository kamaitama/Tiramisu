if true then return end // some stuff in here is broken, lets just ignore this for now
if SERVER then

	function CAKE.SetCID( ply )
		if CAKE.GetCharField( ply, "cid" ) == "000000" then
			local cid = math.random( 0, 9) .. math.random( 0, 9) .. math.random( 0, 9) .. math.random( 0, 9) .. math.random( 0, 9) .. math.random( 1, 9)
			CAKE.SetCharField( ply, "cid", cid)
			ply:SetNWString( "cid", cid )
		end
	end

	concommand.Add( "rp_setcid", function( ply, cmd, args )
		CAKE.SetCID( ply )
	end)

	hook.Add( "PlayerSpawn", "HL2RPSendCID", function( ply )
		if ply:IsCharLoaded() then
			if CAKE.GetCharField(ply, "cid") == "000000" then
				
				CAKE.SetCID(ply)
				
			end
			
			ply:SetNWString( "cid", CAKE.GetCharField( ply, "cid" ) )
		end
	end)

else

	local struc = {}
	struc.pos = { ScrW(), ScrH() - 20 } -- Pos x, y
	struc.color = Color(230,230,230,255 ) -- Red
	struc.font = "Tiramisu18Font" -- Font
	struc.xalign = TEXT_ALIGN_RIGHT -- Horizontal Alignment
	struc.yalign = TEXT_ALIGN_LEFT -- Vertical Alignment

	hook.Add( "HUDPaint", "HL2RPDrawCID", function()
		if CAKE.MenuOpen then
			struc.text = "CID: " .. LocalPlayer():GetNWString( "cid", "000000" )
			draw.Text( struc )
		end
	end)

end