--Sends a player a chat message using the enhanced message system.
function CAKE.SendChat( ply, msg, font, channel, handler )
	
	if IsValid( ply ) and ply:IsTiraPlayer() then
		--ply:PrintMessage( 3, msg )
		net.Start( "TiramisuAddToChat")
		net.WriteTable( {
			["text"] = msg,
			["font"] = font,
			["channel"] = channel or false,
			["handler"] = handler or ""
		})
		net.Send(ply)
		/*
		umsg.Start( "tiramisuaddtochat", ply )
			umsg.String( msg )
			umsg.String( font )
		umsg.End()*/
		--CAKE.SendConsole( ply, msg )
	else
		for i = 0, msg:len() / 255 do
			MsgN(string.sub( msg, i * 255 + 1, i * 255 + 255 ) )
		end
	end
	
end


--Sends a message to a player's console
function CAKE.SendConsole( ply, clrmsg, msg )
	
	if msg then // we got color

		if ply:IsTiraPlayer() then

			umsg.Start("CAKE.SendConsole", ply)

				local c = clrmsg
				umsg.String(msg)
				umsg.String(c.r .. ":" .. c.g .. ":" .. c.b)

			umsg.End()

		else

			MsgC(clrmsg, msg .. "\n")

		end

	else

		if ply:IsTiraPlayer() then
			
			ply:PrintMessage( 2, clrmsg )

		else

			MsgN(clrmsg)

		end

	end
	
end

--Sends a popup message to a player.
function CAKE.SendError( ply, msg )

	if ply:IsTiraPlayer() then
		umsg.Start( "Tiramisu.SendError", ply )
			umsg.String( msg )
		umsg.End()
	else
		print( msg )
	end
end

function CAKE.CreatePlayerRagdoll( ply )

	local speed = ply:GetVelocity()

	local rag = ents.Create( "prop_ragdoll" )
	rag:SetModel( ply:GetModel() )
	if !ply:GetNWBool("specialmodel") then
		rag:SetMaterial( "models/null" )
	end
	rag:SetPos( ply:GetPos( ) )
	rag:SetAngles( ply:GetAngles( ) )
	rag.ply = ply
	rag:Spawn( )

	local ragphys = rag:GetPhysicsObject()
	if ragphys:IsValid() then
		ragphys:AddVelocity(speed*ragphys:GetMass())
		for i = 1, rag:GetPhysicsObjectCount() do
			bonephys = rag:GetPhysicsObjectNum(i)
			boneindex = rag:TranslatePhysBoneToBone(i)
			bonepos, boneang = ply:GetBonePosition(boneindex)
			bonevel = bone
			if(bonephys and bonephys:IsValid())then
				bonephys:SetPos(bonepos)
				bonephys:SetAngles(boneang)
			end
		end
	end

	if ply.Clothing then
		for k, v in pairs( ply.Clothing ) do
			if( IsValid( v ) ) then
				v:SetParent( rag )
				v:Initialize()
			end
		end
	end
	
	if ply.Gear then
		for k, v in pairs( ply.Gear ) do
			if( IsValid( v ) ) then
				CAKE.HandleGear( rag, v.item, v.bone, v.itemid )
				v:Remove()
			end
		end
	end
	
	timer.Simple(.03, function()
		umsg.Start("Tiramisu.PlayerRagged")
			umsg.Entity( ply )
			umsg.Entity( rag )
		umsg.End()
	end)
	
	ply.Clothing = nil
	ply.Gear = nil

	return rag
end

local meta = FindMetaTable( "Player" )

function meta:ConCommand( cmd ) --Rewriting this due to Garry fucking it up.
	umsg.Start( "runconcommand", self )
		umsg.String( cmd ) 
		--Yeah it just sends the command as a string which is then ran clientside. 2 usermessages sent, all because of
		--A REALLY REALLY not well thought fix.
	umsg.End()
end

function CAKE.ChangeMoney( ply, amount ) -- Modify someone's money amount.

	-- Come on, Nori, how didn't you see the error in this?
	--if( ( CAKE.GetCharField( ply, "money" ) - amount ) < 0 ) then return end 
	
	CAKE.DayLog( "economy.txt", "Changing " .. ply:SteamID( ) .. "-" .. ply:GetNWString( "uid" ) .. " money by " .. tostring( amount ) )
	
	CAKE.SetCharField( ply, "money", CAKE.GetCharField( ply, "money" ) + amount )
	if CAKE.GetCharField( ply, "money" ) < 0 then -- An actual negative number block
		CAKE.SetCharField( ply, "money", 0 )
		ply:SetNWInt("money", 0 )
	else
		ply:SetNWInt("money", tonumber( CAKE.GetCharField( ply, "money" ) ))
	end

end

function CAKE.DrugPlayer( pl, mul ) -- DRUG DAT BITCH

	mul = mul / 10 * 2

	pl:ConCommand("pp_motionblur 1")
	pl:ConCommand("pp_motionblur_addalpha " .. 0.05 * mul)
	pl:ConCommand("pp_motionblur_delay " .. 0.035 * mul)
	pl:ConCommand("pp_motionblur_drawalpha 1.00")
	pl:ConCommand("pp_dof 1")
	pl:ConCommand("pp_dof_initlength 9")
	pl:ConCommand("pp_dof_spacing 8")

	local IDSteam = string.gsub(pl:SteamID(), ":", "")

	timer.Create(IDSteam, 40 * mul, 1, CAKE.UnDrugPlayer, pl)
end

function CAKE.UnDrugPlayer(pl)
	pl:ConCommand("pp_motionblur 0")
	pl:ConCommand("pp_dof 0")
end