--Removing the cleanup command.
concommand.Remove( "gmod_admin_cleanup" )
concommand.Add( "gmod_admin_cleanup", function( ply, cmd, args )
	-- Thanks SirMasterCombat
	if IsValid(ply) then
		
		CAKE.SendChat("Cannot use cleanup in this gamemode!")
		
	else
		
		print("Cannot use cleanup in this gamemode!")
		
	end
	print("Cannot use cleanup in this gamemode!")
end)


-- Set Title
concommand.Add( "rp_title", function( ply, cmd, args )

	local title = table.concat( args, " " )

	CAKE.SetCharField( ply, "title", title )
	ply:SetNWString("title", title)

end)

--Set Name
concommand.Add( "rp_changename", function( ply, cmd, args )

	local name = table.concat( args, " " )

	hook.Call( "TiramisuPlayerChangeName", GAMEMODE, ply, name, ply:GetNWString("name", "") )

	CAKE.SetCharField(ply, "name", name )
	ply:SetNWString("name", name)

end)

--Give Money
concommand.Add( "rp_givemoney", function( ply, cmd, args )

	if( player.GetByID( args[ 1 ] ) != nil ) then
		local target = player.GetByID( args[ 1 ] )
		if( tonumber( args[ 2 ] ) > 0 ) then
			if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= tonumber( args[ 2 ] ) ) then
				CAKE.ChangeMoney( target, args[ 2 ] )
				CAKE.ChangeMoney( ply, 0 - args[ 2 ] )
				CAKE.SendChat( ply, "You gave " .. target:Nick( ) .. " " .. args[ 2 ] .. " " .. CAKE.ConVars[ "CurrencyName" ] .. "(s)!" )
				CAKE.SendChat( target, ply:Nick( ) .. " gave you " .. args[ 2 ] .. CAKE.ConVars[ "CurrencyName" ] .. "(s)!" )
			else
				CAKE.SendChat( ply, "You do not have that many " .. CAKE.ConVars[ "CurrencyName" ] .. "(s)!" )
			end
		else
			CAKE.SendChat( ply, "Invalid amount of money!" )
		end
	else
		CAKE.SendChat( ply, "Target not found!" )
	end
	
end)	

--Selects a weapon.
concommand.Add( "rp_selectweapon", function( ply, cmd, args )
	if ply:HasWeapon(args[1]) then
		ply:SelectWeapon(args[1])
		ply:HideActiveWeapon()
	end
end)

--Renames an item.
concommand.Add( "rp_renameitem", function( ply, cmd, args )
	if ply:HasItemID( args[1] ) and !CAKE.GetUData( args[2], "uniquename" ) then
		CAKE.SetUData( args[1], "name", args[2])
		CAKE.SendUData( ply, args[1] )
	elseif CAKE.GetUData( args[2], "uniquename" ) then
		CAKE.SendError( ply, "You cannot rename that item!" )
	end
end)