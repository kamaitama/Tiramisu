util.AddNetworkString("Tiramisu.InitialSpawn")

-- Set Model
concommand.Add( "rp_setmodel", function(ply, cmd, args)
	local mdl = args[ 1 ]
	
	if( ply:GetNWInt( "charactercreate" ) == 1 ) then
		CAKE.SetCharField(ply, "model", mdl )
	end

end )

concommand.Add( "rp_setage", function(ply, cmd, args)
	local age = args[ 1 ]
	CAKE.SetCharField(ply, "age", age )	
end )

concommand.Add( "rp_facevariation", function(ply, cmd, args)
	local skin = tonumber(args[ 1 ]) or 0
	CAKE.SetCharField(ply, "skin", skin )
end)

concommand.Add( "rp_setstartclothing", function(ply,cmd,args)
	if( ply:GetNWInt( "charactercreate" ) == 1 ) then
		if CAKE.ConVars[ "DefaultClothing" ][ ply:GetNWString( "gender", "Male" ) ] then

			if table.HasValue( CAKE.ConVars[ "DefaultClothing" ][ ply:GetNWString( "gender", "Male" ) ], args[1] ) then
				ply:GiveItem( args[1] )
				CAKE.SetCharField(ply, "clothing", args[1] )
			end

		end

	end
end )

concommand.Add( "rp_setgender", function(ply, cmd, args)
	local gender = args[ 1 ]
	
	if( ply:GetNWInt( "charactercreate" ) == 1 ) then
		CAKE.SetCharField(ply, "gender", gender )	
	end
end )

concommand.Add( "rp_begincreate", function(ply, cmd, args)

	if CAKE.ConVars[ "MaxCharacters" ] == 0 or (CAKE.ConVars[ "MaxCharacters" ] > 0 and table.Count(CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ][ "characters" ]) < CAKE.ConVars[ "MaxCharacters" ]) then
		ply:SetNWInt( "charactercreate", 1 )
		umsg.Start( "StartCharacterCreation", ply )
		umsg.End()
	elseif CAKE.ConVars[ "MaxCharacters" ] > 0 and table.Count(CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ][ "characters" ]) >= CAKE.ConVars[ "MaxCharacters" ] then
		CAKE.SendError( ply, "You can't create any more characters! (You have:" .. table.Count(CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ][ "characters" ]) .. ", Max: " ..   CAKE.ConVars[ "MaxCharacters" ] .. ")")
	end

end )

-- Start Creation
concommand.Add( "rp_startcreate", function(ply, cmd, args)
	if ply:GetNWInt( "charactercreate", 0 )> 0 then
		local PlyCharTable = CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ][ "characters" ]
		
		-- Find the highest Unique ID
		local high = 0
		
		for k, v in pairs( PlyCharTable ) do
		
			k = tonumber( k )
			high = tonumber( high )
			
			if( k > high ) then 
			
				high = k
				
			end
			
		end
		
		high = high + 1
		ply:SetNWString( "uid", tostring(high) )

		CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ][ "characters" ][ tostring(high) ] = {  }
	end
end )

concommand.Add( "rp_escapecreate", function(ply, cmd, args)
	if ply:GetNWInt( "charactercreate", 0 ) > 0 then
		ply:SetNWInt( "charactercreate", 0 )
	end
	CAKE.SelectRandomCharacter( ply )
end )

concommand.Add( "rp_testclothing", function(ply, cmd, args)
	if ply:GetNWInt( "charactercreate", 0 )> 0 then
		CAKE.RemoveAllGear( ply )
		if args[ 1 ] and args[ 1 ] != "none" then
			ply:SetNWBool( "specialmodel", false ) 
			ply:SetModel( Anims[args[ 1 ]][ "models" ][1] )
			ply:SetNWString( "gender", args[ 1 ] )
			ply:SetMaterial("models/null")
		end
		if args[ 2 ] and args[ 2 ] != "none" then
			CAKE.TestClothing( ply, args[ 2 ] )
		end
		if args[ 3 ] and args[ 3 ] != "none" then
			CAKE.TestClothing( ply, args[ 2 ], args[ 3 ] )
		end
		if args[ 4 ] and args[ 4 ] != "none" then
			CAKE.TestClothing( ply, args[ 2 ], args[ 3 ], args[ 4 ] )
		end
	end
end )

concommand.Add("rp_testskin", function(ply, cmd, args)
	local skin = tonumber(args[1]) or 0
	if ply:GetNWInt( "charactercreate", 0 )> 0 then
		for _, ent in pairs( ply.Clothing ) do
			ent:SetSkin( skin )
		end
	end
end)

-- Finish Creation
concommand.Add( "rp_finishcreate", function(ply, cmd, args)
	if( ply:GetNWInt( "charactercreate" ) == 1 ) then
		
		ply:SetNWInt( "charactercreate", 0 )
		
		local SteamID = CAKE.FormatText( ply:SteamID() )
		
		for fieldname, default in pairs( CAKE.CharacterDataFields ) do
			if( CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ fieldname ] == nil) then
				CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ][ fieldname ] = CAKE.ReferenceFix(default)
			end
		end

		CAKE.PlayerData[ SteamID ][ "characters" ][ ply:GetNWString( "uid" ) ]["inventory"] = CAKE.CreatePlayerInventory( ply )
		
		ply:SetTeam( 1 )
		
		umsg.Start("ClearReceivedChars", ply)
		umsg.End()
		for k, v in pairs( CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ]["characters"] ) do -- Send them all their characters for selection

			umsg.Start( "ReceiveChar", ply )
				umsg.Long( tonumber(k) )
				umsg.String( v[ "name" ] )
			umsg.End( )
			
		end
		umsg.Start("DisplayCharacterList", ply)
		umsg.End()
		CAKE.ResendCharData( ply )
		
	end
end )

concommand.Add( "rp_selectchar", function(ply, cmd, args)
	local uid = args[ 1 ]
	
	CAKE.SelectChar( ply, uid )
end)

concommand.Add( "rp_spawnchar", function(ply, cmd, args) 
	local uid = args[ 1 ]
	
	if CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ]["characters"] and CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ]["characters"][uid]  then
		MsgN("Spawning Character ", args[1], " from player ", ply:SteamID())
		ply:SetNWString( "uid", uid )
		
		ply:SetNWInt( "charactercreate", 0 )
	
		ply:SetTeam( 1 )
		ply:SetNWBool( "charloaded", true )

		ply:Spawn( )
		CAKE.ResendCharData( ply )
	end
end)

concommand.Add( "rp_ready", function(ply, cmd, args) 
	if( ply.Ready == false ) then

		ply.Ready = true
		
		timer.Simple( 1, function()
			if !IsValid(ply) then return end
			ply:SetNWBool( "charactercreate", true )
			
			umsg.Start( "Tiramisu.InitialSpawn", ply )
				umsg.Bool( ply.FirstTimeJoining ) --This activates the intro if this is your first spawn ever. 
			umsg.End( )
		end)
		
	end
end )


concommand.Add( "rp_receivechars", function( ply, cmd, args )
	umsg.Start("ClearReceivedChars", ply)
	umsg.End()
	for k, v in pairs( CAKE.PlayerData[ CAKE.FormatText( ply:SteamID() ) ]["characters"] ) do -- Send them all their characters for selection

		umsg.Start( "ReceiveChar", ply )
			umsg.Long( tonumber(k) )
			umsg.String( v[ "name" ] )
		umsg.End( )
		
	end
	umsg.Start("DisplayCharacterList", ply)
	umsg.End()
	if !util.tobool(args[1]) then
		timer.Simple( 1, function()
			CAKE.SelectRandomCharacter( ply )
		end)
	end
end)
concommand.Add( "rp_confirmremoval", function(ply, cmd, args) 
	local id = args[1]
	local SteamID = CAKE.FormatText( ply:SteamID() )
	local name = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "name" ]
	local age = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "age" ]
	local model = CAKE.PlayerData[ SteamID ][ "characters" ][ id ][ "model" ]
	umsg.Start("ConfirmCharRemoval", ply)
		umsg.String( name )
		umsg.Long( id )
	umsg.End()
end )

concommand.Add( "rp_removechar", function(ply, cmd, args) 
	local id = args[1]
	CAKE.RemoveCharacter( ply, id )
	umsg.Start( "DisplayCharacterList", ply )
	umsg.End()
end )


function CAKE.SelectRandomCharacter( ply )
	local tbl = {}
	for k, _ in pairs(CAKE.PlayerData[ CAKE.FormatText(ply:SteamID()) ][ "characters" ]) do
		table.insert( tbl, k )
	end
	if table.Count( tbl ) > 0 then
		CAKE.SelectChar( ply, table.Random(tbl) )
	end
end

function CAKE.SelectChar( ply, uid )
	local SteamID = CAKE.FormatText(ply:SteamID())
	local char = CAKE.PlayerData[ SteamID ][ "characters" ][ uid ]
	local shouldload, reason = hook.Call("PlayerSelectChar", GAMEMODE, ply, uid, char)
	reason = reason or "You cannot select this character at this time."
	
	if char != nil then
		-- local char = CAKE.PlayerData[ SteamID ][ "characters" ][ uid ]
		if shouldload == false then
			
			CAKE.SendError(ply, reason)
			return
			
		end
		
		local special = char[ "specialmodel" ]
		if special == "none" or special == "" then
			
			ply:SetNWBool( "specialmodel", false ) 
			local m = char[ "gender" ]
			ply:SetModel( Anims[m][ "models" ][1] )
			ply:SetNWString( "gender", m )
			ply:SetMaterial("models/null")

			CAKE.TestClothing( ply, char[ "model" ], char[ "clothing" ], char[ "helmet" ], char[ "headratio" ],char[ "bodyratio" ], char[ "handratio" ], char[ "clothingid" ], char[ "helmetid" ], char[ "bodygroup1"], char[ "bodygroup2"], char[ "bodygroup3"], char[ "skin"])

			local tbl = char[ "gear" ]
			CAKE.RemoveAllGear( ply )

			for k, v in pairs( tbl ) do
				CAKE.HandleGear( ply, v[ "item" ], v[ "bone" ], v[ "itemid" ], v[ "offset" ], v[ "angle" ], v[ "scale" ], v[ "skin" ] )
			end
			
			local str = CAKE.GetCharSignature(ply) .. " has loaded the character " .. CAKE.GetCharField(ply, "name")
			
			CAKE.AdminLog(Color(97, 145, 61), str)
			CAKE.DayLog("characters.txt", str)
			
			CAKE.SendGearToClient( ply )
			
		else
			
			ply:SetNWBool( "specialmodel", true ) 
			ply:SetModel( tostring( special ) )
			
		end 
		
		umsg.Start("SelectThisCharacter")
			umsg.Long( uid )
		umsg.End()
		
	end

end