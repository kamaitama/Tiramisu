CLPLUGIN.Name = "Third Person Camera"
CLPLUGIN.Author = "F-Nox/Big Bang"

function CLPLUGIN.Init()
end

CAKE.Thirdperson = CreateClientConVar( "rp_thirdperson", 0, true, true )
CAKE.ThirdpersonDistance = CreateClientConVar( "rp_thirdpersondistance", 50, true, true )
CAKE.Headbob = CreateClientConVar( "rp_headbob", 1, true, true )
CAKE.HeadbobAmount = CreateClientConVar( "rp_headbob", 1, true, true )
CAKE.FreeScroll = false

local mouserotate = Angle( 0, 0, 0 )
local mousex
local newpos
local headpos, headang
local tracedata = {}
local ignoreent

local function RecieveViewRagdoll( handler, id, encoded, decoded )
	CAKE.ViewRagdoll = decoded.ragdoll
	if ValidEntity( CAKE.ViewRagdoll ) then
		CAKE.ViewRagdoll.Clothing = decoded.clothing
	end
end
datastream.Hook( "RecieveViewRagdoll", RecieveViewRagdoll )

local function RecieveUnconciousRagdoll( handler, id, encoded, decoded )
	CAKE.ViewRagdoll = decoded.ragdoll
	if ValidEntity( CAKE.ViewRagdoll ) then
		CAKE.ViewRagdoll.Clothing = decoded.clothing
	end
end
datastream.Hook( "RecieveUnconciousRagdoll", RecieveUnconciousRagdoll )

local function drawlocalplayer()

	if CAKE.Thirdperson:GetBool() or CAKE.FreeScroll then
		return true
	end

	return false

end
hook.Add("ShouldDrawLocalPlayer","TiramisuDrawLocalPlayer", drawlocalplayer )

hook.Add("CalcView", "TiramisuThirdperson", function(ply, pos , angles ,fov)

	if !newpos then
		newpos = pos
	end
	
	if CAKE.FreeScroll and CAKE.InEditor then
		newpos = ply:GetForward()*100
		newpos:Rotate(mouserotate)
		pos = ply:GetPos()+Vector(0,0,60) + newpos
		return GAMEMODE:CalcView(ply, pos , (ply:GetPos()+Vector(0,0,60)-pos):Angle(),fov)
	end

	if( CAKE.Thirdperson:GetBool() ) then
		if ValidEntity( CAKE.ViewRagdoll ) then
			pos = CAKE.ViewRagdoll:GetPos()
			ignoreent = CAKE.ViewRagdoll
		else
			ignoreent = ply
		end
					
		if( ply:GetNWBool( "aiming", false ) ) then
            tracedata.start = pos
            tracedata.endpos = pos - ( angles:Forward() * CAKE.ThirdpersonDistance:GetInt() ) + ( angles:Right()* 30 )
            tracedata.filter = ignoreent
            trace = util.TraceLine(tracedata)
            
            pos = newpos
			newpos = LerpVector( 0.2, pos, trace.HitPos )

			return GAMEMODE:CalcView(ply, newpos , angles ,fov)
		else
            tracedata.start = pos
            tracedata.endpos = pos - ( angles:Forward() * CAKE.ThirdpersonDistance:GetInt() * 2 ) + ( angles:Up()* 20 )
            tracedata.filter = ignoreent
            trace = util.TraceLine(tracedata)
            
            pos = newpos
			newpos = LerpVector( 0.2, pos, trace.HitPos )

			return GAMEMODE:CalcView(ply, newpos , angles ,fov)

		end
	else --It's firstperson time!

		if ValidEntity( CAKE.ViewRagdoll ) then
			headpos, headang = CAKE.ViewRagdoll:GetBonePosition( CAKE.ViewRagdoll:LookupBone( "ValveBiped.Bip01_Head1" ) )
			return GAMEMODE:CalcView(ply, headpos, angles ,fov)
		end

		if CAKE.Headbob:GetBool() then
			headpos, headang = LocalPlayer():GetBonePosition( LocalPlayer():LookupBone( "ValveBiped.Bip01_Head1" ) )
			return GAMEMODE:CalcView(ply, headpos, angles ,fov)
		end

	end

	return GAMEMODE:CalcView(ply, pos , angles ,fov)


end)

local keydown = false
timer.Create( "LocalMouseControlCam", 0.01, 0, function()

	if !CAKE.InEditor then
		CAKE.FreeScroll = input.IsMouseDown(MOUSE_RIGHT)
	else
		CAKE.FreeScroll = input.IsMouseDown(MOUSE_RIGHT)
	end
	
	if !CAKE.FreeScroll then
		if !CAKE.InEditor then
			mouserotate = false
			gui.EnableScreenClicker( false )
		end
	else
		if !mouserotate then
			gui.EnableScreenClicker( true )
			gui.SetMousePos( ScrW()/2, ScrH()/2 )
			mouserotate = Angle(0,0,0)
			mousex = gui.MouseX()
		end
		mouserotate.y = math.NormalizeAngle(( gui.MouseX() - mousex ) / 2)
	end

end)