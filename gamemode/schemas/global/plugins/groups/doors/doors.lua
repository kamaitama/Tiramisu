hook.Add( "InitPostEntity", "TiramisuLoadDoors", function()
	CAKE.LoadDoors()
end)

CAKE.Doors = {}

--Loads all door information
function CAKE.LoadDoors()

	if(file.Exists(CAKE.Name .. "/DoorData/" .. game.GetMap() .. ".txt")) then

		local rawdata = file.Read( CAKE.Name .. "/DoorData/" .. game.GetMap() .. ".txt");
		local tabledata = glon.decode( rawdata )
		
		CAKE.Doors = tabledata;
		local entities

		for _, door in pairs( CAKE.Doors ) do
			entities = ents.FindByClass( door["class"] )
			for _, entity in pairs( entities ) do
				if ValidEntity( entity ) and entity:GetPos() == door["pos"] then
					entity.doorgroup = door["doorgroup"]
					entity.title = door["title"]
					entity.building = door["building"]
					entity.purchaseable = door["purchaseable"]
					CAKE.SetDoorTitle( entity, entity.title )
				end
			end
		end
		
	end 

end

function CAKE.SaveDoors()

	local keys = glon.encode(CAKE.Doors);
	file.Write(CAKE.Name .. "/DoorData/" .. game.GetMap() .. ".txt", keys);

end

--Fetches a door's group affinity.
function CAKE.GetDoorGroup( entity )

	if ValidEntity( entity ) then
		if entity.doorgroup then
			return entity.doorgroup
		end

		for k, v in pairs(CAKE.Doors) do
			
			if(v["class"] == entity:GetClass() and v["pos"] == entity:GetPos() and v["doorgroup"] != 0 ) then
				
				return v["doorgroup"]
					
			end
				
		end
	end

	return false

end

--Fetches on what group of doors does this entity belong to.
function CAKE.GetDoorBuilding(entity)

	if entity.building then
		return entity.building
	end

	for k, v in pairs(CAKE.Doors) do
		
		if(v["class"] == entity:GetClass() and v["pos"] == entity:GetPos() and v["building"] != 0 ) then
			
			return v["building"]
				
		end
			
	end

	return false

end

--Sets a door's title.
function CAKE.SetDoorTitle( door, title )
	door:SetNWString( "doortitle", string.sub( title, 1, 33) )
end

function ccLockDoor( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) );
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) );
	local doorgroup = CAKE.GetDoorGroup(entity) or 0
	local groupdoor = CAKE.GetGroupFlag( CAKE.GetCharField( ply, "group" ), "doorgroups" ) or 0
	if( CAKE.IsDoor( door ) ) then
		if( ( door.owner != nil ) and door.owner == ply ) or ply:IsSuperAdmin() or ply:IsAdmin() then
			door:Fire( "lock", "", 0 );
			CAKE.SendChat( ply, "Door locked!" );
		else
			if type( groupdoor ) == "table" then groupdoor = groupdoor[1] end
			if doorgroup == groupdoor then --lol
				door:Fire( "lock", "", 0 );
				CAKE.SendChat( ply, "Door locked!" );
			else
				CAKE.SendChat( ply, "This is not your door!" );
			end
		end
	end

end
concommand.Add( "rp_lockdoor", ccLockDoor );

function ccUnLockDoor( ply, cmd, args )
	
	local entity = ents.GetByIndex( tonumber( args[ 1 ] ) );
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) );
	local doorgroup = CAKE.GetDoorGroup(entity) or 0
	local groupdoor = CAKE.GetGroupFlag( CAKE.GetCharField( ply, "group" ), "doorgroups" ) or 0
	if( CAKE.IsDoor( door ) ) then
		if( ( door.owner != nil ) and door.owner == ply ) or ply:IsSuperAdmin() or ply:IsAdmin() then
			door:Fire( "unlock", "", 0 );
			CAKE.SendChat( ply, "Door unlocked!" );
		else
			if type( groupdoor ) == "table" then groupdoor = groupdoor[1] end
			if doorgroup == groupdoor then --lol
				door:Fire( "unlock", "", 0 );
				CAKE.SendChat( ply, "Door unlocked!" );
			else
				CAKE.SendChat( ply, "This is not your door!" );
			end
		end
	end


end
concommand.Add( "rp_unlockdoor", ccUnLockDoor );

function ccPurchaseDoor( ply, cmd, args )
	local door = ents.GetByIndex( tonumber( args[ 1 ] ) );
	
	local pos = door:GetPos( );
	
		
	if( CAKE.GetDoorGroup( door ) and !door.purchaseable ) then
		
		CAKE.SendChat( ply, "This is not a purchaseable door!" );
		return;
			
	end

	
	if( CAKE.IsDoor( door ) ) then

		if( door.owner == nil ) then

			if CAKE.GetDoorBuilding(door) then
				local building = CAKE.GetDoorBuilding(door)
				local doors
				for _, targetdoor in pairs( CAKE.Doors ) do
					if targetdoor["building"] == building then
						doors = ents.FindByClass( targetdoor["class"] )
						for k, v in pairs( doors ) do
							if v:GetPos() == targetdoor["pos"] then
								CAKE.ChangeMoney( ply, -50 )
								v.owner = ply
							end
						end
					end
				end
				CAKE.SendChat( ply, "Building Owned" );
			else
				if( tonumber( CAKE.GetCharField( ply, "money" ) ) >= 50 ) then
					
					-- Enough money to start off, let's start the rental.
					CAKE.ChangeMoney( ply, -50 );
					door.owner = ply;
					CAKE.SendChat( ply, "Door Owned" );

				end
			end
			
		elseif( door.owner == ply ) then
		
			door.owner = nil;
			CAKE.ChangeMoney( ply, 50 );
			CAKE.SetDoorTitle( door, "" )
			CAKE.SendChat( ply, "Door Unowned" );
			
		else
		
			CAKE.SendChat( ply, "This door is already rented by someone else!" );
			
		end
	
	end
	
end
concommand.Add( "rp_purchasedoor", ccPurchaseDoor );

local function ccDoorTitle( ply, cmd, args )

	local door = ply:GetEyeTrace( ).Entity
	if ValidEntity( door ) and CAKE.IsDoor( door ) and door.owner == ply then
		local title = table.concat( args, " " )
		CAKE.SetDoorTitle( door, title )
	end

end
concommand.Add( "rp_doortitle", ccDoorTitle )