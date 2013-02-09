--Speed boost!
local surface = surface
local draw = draw
local Color = Color
local gradient = surface.GetTextureID("gui/gradient")
local matBlurScreen = Material( "pp/blurscreen" ) 
local gradientUp = surface.GetTextureID("gui/gradient_up")

local SKIN = derma.GetNamedSkin( "Tiramisu" )

function SKIN:InitIntro()
	CAKE.IntroStage1 = true
	CAKE.IntroStage2 = false
	CAKE.IntroStage3 = false
	CAKE.IntroStage4 = false
	CAKE.IntroStage1Alpha = 0
	CAKE.IntroStage2Alpha = 0
	CAKE.IntroStage3Alpha = 0
	timer.Create( "IntroStage1", 1, 1, function()
		CAKE.IntroSkippable = true
	end)
	timer.Create( "IntroStage2", 3, 1, function()
		CAKE.IntroStage2 = true
	end)
	timer.Create( "IntroStage3", 5, 1, function()
		CAKE.IntroStage3 = true
	end)
	timer.Create( "IntroStage4", 9, 1, function()
		CAKE.IntroStage1 = false
		CAKE.IntroStage2 = false
		CAKE.IntroStage3 = false
		CAKE.IntroStage4 = true
	end)
	timer.Create( "IntroStage5", 12, 1, function()
		CAKE.EndIntro()
	end)
end

function SKIN:PaintIntro()
	if CAKE.IntroStage1 then
		CAKE.IntroStage1Alpha = Lerp(1.5 * RealFrameTime(), CAKE.IntroStage1Alpha, 255 )
	end
	if CAKE.IntroStage2 then
		CAKE.IntroStage2Alpha = Lerp(1.5 * RealFrameTime(), CAKE.IntroStage2Alpha, 255 )
	end
	if CAKE.IntroStage3 then
		CAKE.IntroStage3Alpha = Lerp(1.5 * RealFrameTime(), CAKE.IntroStage3Alpha, 255 )
	end
	if CAKE.IntroStage4 then
		CAKE.IntroStage1Alpha = Lerp(2 * RealFrameTime(), CAKE.IntroStage1Alpha, 0 )
		CAKE.IntroStage2Alpha = Lerp(2 * RealFrameTime(), CAKE.IntroStage2Alpha, 0 )
		CAKE.IntroStage3Alpha = Lerp(2 * RealFrameTime(), CAKE.IntroStage3Alpha, 0 )
	end

	draw.SimpleTextOutlined( "Tiramisu", "Tiramisu64Font", ScrW()/2-20, ScrH() /2 - 50, Color(255,255,255,CAKE.IntroStage1Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(CAKE.IntroStage1Alpha, 130)))
	draw.SimpleTextOutlined( "                       2", "Tiramisu64Font", ScrW()/2, ScrH() /2 - 50, Color(255,0,0,CAKE.IntroStage2Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(CAKE.IntroStage2Alpha, 130)))
	draw.SimpleTextOutlined( "Freeform", "Tiramisu24Font", ScrW()/2, ScrH() / 2 + 10, Color(100,149,237,CAKE.IntroStage3Alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,math.max(CAKE.IntroStage3Alpha, 130)))
end


function SKIN:PaintTiramisuClock()
	if CAKE.MenuOpen then
		draw.SimpleTextOutlined( LocalPlayer():Nick(), "TiramisuNamesFont", ScrW() - 10, 30, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT, 1, Color(0,0,0,180))
		draw.SimpleTextOutlined( LocalPlayer():Title(), "TiramisuNamesFont", ScrW() - 10, 50, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT, 1, Color(0,0,0,180))
	end
end

function SetupChitpos()
	local tracedata = {}
	tracedata.start = CAKE.CameraPos
	tracedata.endpos = CAKE.CameraPos + (CAKE.OldAngles:Forward() * 3000)
	local trace = util.TraceLine(tracedata)

		--Hit Correction
			--if IsValid(trace.Entity) and !trace.HitWorld and !trace.HitSky then
				--local head = trace.Entity:LookupBone("ValveBiped.Bip01_Head1")
				--if head then
					--  hitpos = Lerp( 0.3, trace.HitPos, trace.Entity:GetBonePosition(head) )
				--else
					--  hitpos = Lerp( 0.3, trace.HitPos, trace.Entity:LocalToWorld(trace.Entity:OBBCenter()))
				--end
			--else
					--  hitpos = trace.HitPos
			--end

	--hitpos = hitpos - trace.HitNormal
				
	chitpos = trace.HitPos
end

local trace, pos
function SKIN:PaintTiramisuCrosshair()
		if !chitpos then
			SetupChitpos()
		end
		surface.SetDrawColor( 220, 220, 220, 220 )
		nv = chitpos:ToScreen()
		scrw = ScrW()/2
		scrh = ScrH()/2
		surface.DrawLine( scrw - 5, scrh, scrw + 5, scrh )
		surface.DrawLine( scrw, scrh - 5, scrw, scrh + 5 )
end

derma.DefineSkin( "TiramisuFreeform", "Custom skin for the freeform schema", SKIN )
CAKE.Skin = "TiramisuFreeform"
