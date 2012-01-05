--Speed boost!
local surface = surface
local draw = draw
local Color = Color

function derma.SkinHook( strType, strName, panel )
	local Skin
	if panel then
		Skin = panel:GetSkin()
	else
		Skin = derma.GetDefaultSkin()
	end
	local func = Skin[ strType .. strName ]
	if !func then return end
	return func(Skin, panel)
end

local SKIN = {}

SKIN.PrintName 		= "Tiramisu Skin"
SKIN.Author 		= "FNox"
SKIN.DermaVersion	= 1

SKIN.bg_color 					= Color( 110, 110, 110, 255 )
SKIN.bg_color_sleep 			= Color( 70, 70, 70, 255 )
SKIN.bg_color_dark				= Color( 55, 57, 61, 255 )
SKIN.bg_color_bright			= Color( 220, 220, 220, 255 )
SKIN.frame_border				= Color( 50, 50, 50, 255 )
SKIN.frame_title				= Color( 130, 130, 130, 255 )


SKIN.fontFrame					= "TiramisuDefaultFont"

SKIN.control_color 				= Color( 120, 120, 120, 255 )
SKIN.control_color_highlight	= Color( 150, 150, 150, 255 )
SKIN.control_color_active 		= Color( 110, 150, 250, 255 )
SKIN.control_color_bright 		= Color( 255, 200, 100, 255 )
SKIN.control_color_dark 		= Color( 100, 100, 100, 255 )

SKIN.bg_alt1 					= Color( 50, 50, 50, 255 )
SKIN.bg_alt2 					= Color( 55, 55, 55, 255 )

SKIN.listview_hover				= Color( 70, 70, 70, 255 )
SKIN.listview_selected			= Color( 100, 170, 220, 255 )

SKIN.text_bright				= Color( 255, 255, 255, 255 )
SKIN.text_normal				= Color( 180, 180, 180, 255 )
SKIN.text_dark					= Color( 20, 20, 20, 255 )
SKIN.text_highlight				= Color( 255, 20, 20, 255 )

SKIN.texGradientUp				= Material( "gui/gradient_up" )
SKIN.texGradientDown			= Material( "gui/gradient_down" )

SKIN.combobox_selected			= SKIN.listview_selected

SKIN.panel_transback			= Color( 255, 255, 255, 50 )
SKIN.tooltip					= Color( 255, 245, 175, 255 )

SKIN.colPropertySheet 			= Color( 170, 170, 170, 255 )
SKIN.colTab			 			= SKIN.colPropertySheet
SKIN.colTabInactive				= Color( 140, 140, 140, 255 )
SKIN.colTabShadow				= Color( 0, 0, 0, 170 )
SKIN.colTabText		 			= Color( 255, 255, 255, 255 )
SKIN.colTabTextInactive			= Color( 0, 0, 0, 200 )
SKIN.fontTab					= "TiramisuDefaultFont"

SKIN.colCollapsibleCategory		= Color( 255, 255, 255, 20 )

SKIN.colCategoryText			= Color( 255, 255, 255, 255 )
SKIN.colCategoryTextInactive	= Color( 200, 200, 200, 255 )
SKIN.fontCategoryHeader			= "Tiramisu16Font"

SKIN.colNumberWangBG			= Color( 255, 240, 150, 255 )
SKIN.colTextEntryBG				= Color( 240, 240, 240, 255 )
SKIN.colTextEntryBorder			= Color( 20, 20, 20, 255 )
SKIN.colTextEntryText			= Color( 20, 20, 20, 255 )
SKIN.colTextEntryTextHighlight	= Color( 20, 200, 250, 255 )
SKIN.colTextEntryTextHighlight	= Color( 20, 200, 250, 255 )

SKIN.colMenuBG					= Color( 255, 255, 255, 200 )
SKIN.colMenuBorder				= Color( 0, 0, 0, 200 )

SKIN.colButtonText				= Color( 255, 255, 255, 255 )
SKIN.colButtonTextDisabled		= Color( 255, 255, 255, 55 )
SKIN.colButtonBorder			= Color( 20, 20, 20, 255 )
SKIN.colButtonBorderHighlight	= Color( 255, 255, 255, 50 )
SKIN.colButtonBorderShadow		= Color( 0, 0, 0, 100 )
SKIN.fontButton					= "TiramisuDefaultFont"

--------------------
--------------------
--DEFAULT ELEMENTS--
--------------------
--------------------
/*---------------------------------------------------------
	Frame
---------------------------------------------------------*/
local matBlurScreen = Material( "pp/blurscreen" ) 
local gradientUp = surface.GetTextureID("gui/gradient_up")
function SKIN:PaintFrame( panel )

	x, y = panel:ScreenToLocal( 0, 0 ) 
	color = panel.Color or CAKE.BaseColor or Color( 100, 100, 115, 150 )
	
	// Background 
	surface.SetMaterial( matBlurScreen ) 
	surface.SetDrawColor( 255, 255, 255, 255 ) 
	
	matBlurScreen:SetMaterialFloat( "$blur", 5 ) 
	render.UpdateScreenEffectTexture() 
	
	surface.DrawTexturedRect( x, y, ScrW(), ScrH() ) 

	if ( panel.m_bBackgroundBlur ) then
		Derma_DrawBackgroundBlur( panel, panel.m_fCreateTime )
	end
	
	surface.SetDrawColor( color.r, color.g, color.b, 150 ) 
	surface.DrawRect( x, y, ScrW(), ScrH() ) 

	// Pretentious line bullshit :P
	x = math.floor( panel:GetWide() / 5 )
	y = math.floor( panel:GetTall() / 5 )

	surface.SetDrawColor( 50, 50, 50, 80 ) 

	for i = 1, panel:GetWide() / 5 * 2  do
		surface.DrawLine( ( i * 5 ), 23, 0, ( i * 5 ) + 23 )
	end

	// and some gradient shit for additional overkill

	surface.SetTexture( gradientUp )
	surface.SetDrawColor( math.Clamp( color.r - 50, 0, 255 ), math.Clamp( color.g - 50,0, 255 ), math.Clamp( color.b - 50, 0, 255 ), color.a ) 
	surface.DrawTexturedRectUV( 0, 0, panel:GetWide(), panel:GetTall(), panel:GetWide(), panel:GetWide() )

	// Border 
	surface.SetDrawColor( math.Clamp( color.r - 50, 0, 255 ), math.Clamp( color.g - 50,0, 255 ), math.Clamp( color.b - 50, 0, 255 ), 255 ) 
	surface.DrawOutlinedRect( 0, 0, panel:GetWide(), panel:GetTall() )
	surface.DrawLine( 0, 23, panel:GetWide(), 23 )

end

--------------------
--------------------
--CUSTOM--ELEMENTS--
--------------------
--------------------

/*---------------------------------------------------------
	Quick Menu
---------------------------------------------------------*/

local fade = 0
local x, y
local gradient = surface.GetTextureID("gui/gradient")
function SKIN:PaintQuickMenu(panel)
	if panel then
		if !panel.FadeOut then
			fade = Lerp( 10 * RealFrameTime(), fade, 255 )
			panel.FadeAlpha = fade
		else
			fade = Lerp( 10 * RealFrameTime(), fade, 0 )
			panel.FadeAlpha = fade
			if fade < 5 then
				panel:Remove()
			end
		end
		x, y = panel:ScreenToLocal( 0, 0 )
		surface.SetTexture( gradient )
		surface.SetDrawColor( 0, 0, 0, fade ) 
		surface.DrawTexturedRectUV( x, y, panel:GetWide(), panel:GetTall(), panel:GetWide(), panel:GetWide() )
		surface.SetDrawColor( 0, 0, 0, fade ) 
		surface.DrawTexturedRectUV(  x, y, panel:GetWide(), panel:GetTall(), panel:GetWide(), panel:GetWide() )
	end
end

function SKIN:PaintQuickMenuLabel(panel)
	draw.SimpleTextOutlined( panel.LabelText or "", "Tiramisu32Font", panel:GetWide()/2, 0, Color(panel.FuckingColor.r,panel.FuckingColor.g,panel.FuckingColor.b,fade), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, 1, Color(0,0,0,fade))
end

/*---------------------------------------------------------
	Stamina Bar
---------------------------------------------------------*/
local perc, alpha
alpha = 230
function SKIN:PaintStaminaBar()
	if CAKE.MinimalHUD:GetBool() then
		if LocalPlayer().TiramisuStaminaRegen and alpha != 230 then
			alpha = Lerp( 10 * RealFrameTime(), alpha, 230 )
		else
			alpha = Lerp( 10 * RealFrameTime(), alpha, 0 )
		end
	else
		alpha = 230
	end
	perc = LocalPlayer():GetStamina() / 100
	if alpha != 0 then
		--perc = math.Clamp( perc - 0.001, 0, 1 )
		draw.RoundedBoxEx( 4, ScrW()/2 - 150, 0, 300, 31, Color( 50, 50, 50, alpha ), false, false, false, true )
		surface.SetDrawColor( Color( 10, 10, 10, alpha ) )
		surface.DrawRect( ScrW()/2 - 147, 2, 293, 26 )
		draw.SimpleText(tostring(math.ceil(perc * 100)) .. "%", "Tiramisu12Font", ScrW()/2 - 144 + 287, 9, Color(255,255,255,alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
		if perc != 0 then
			draw.RoundedBoxEx( 2, ScrW()/2 - 144, 5, 287 * perc, 20, Color( 200, 200, 50, alpha ), false, false, false, true )
			draw.RoundedBoxEx( 2, ScrW()/2 - 140, 8, 280 * perc, 4, Color( 255, 255, 255, math.Clamp( alpha - 180, 0, 50) ), false, false, false, true )
		end
		draw.SimpleText("STAMINA", "Tiramisu12Font", ScrW()/2 - 144 + math.Clamp( 287 * perc, 41, 287), 9, Color(255,255,255,alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
	end
end

/*---------------------------------------------------------
	DeathMessage
---------------------------------------------------------*/
function SKIN:PaintDeathMessage()
	if LocalPlayer():GetNWInt("deathmode", 0 ) == 1 then
		draw.DrawText( "You have been mortally wounded. Wait " .. tostring( LocalPlayer( ):GetNWInt( "deathmoderemaining" ) ) .. " seconds", "Tiramisu18Font", ScrW( ) / 2,60, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
	end
	
	if LocalPlayer():GetNWBool("unconciousmode", false ) then
		draw.DrawText( "You have been knocked out. Type 'rp_wakeup' on console.", "Tiramisu18Font", ScrW( ) / 2 ,60, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
	end
end

/*---------------------------------------------------------
	TiramisuClock, draws current gamemode time and player title.
---------------------------------------------------------*/
local struc = {}
struc.pos = { ScrW() - 10, 10 } -- Pos x, y
struc.color = Color(230,230,230,255 ) -- Red
struc.font = "Tiramisu18Font" -- Font
struc.xalign = TEXT_ALIGN_RIGHT -- Horizontal Alignment
struc.yalign = TEXT_ALIGN_RIGHT -- Vertical Alignment

function SKIN:PaintTiramisuClock()
	local markuplbl = markup.Parse( "<color=230,230,230,255><font=TiramisuTimeFont>" .. LocalPlayer():GetNWString( "title", "Connecting..." ) .. "</font></color>", 300 )
	if !CAKE.MinimalHUD:GetBool() or CAKE.MenuOpen then 
		if GetGlobalString( "time" ) != "Loading.." and GetGlobalString( "time" ) != "" then
			struc.text = CAKE.FindDayName() .. ", " .. GetGlobalString( "time" )
			struc.pos = { ScrW() - 10, 10 } -- Pos x, y
			draw.Text( struc )
		else
			struc.text = GetGlobalString( "time" )
			struc.pos = { ScrW() - 10, 10 } -- Pos x, y
			draw.Text( struc )
		end
	end
	if CAKE.MenuOpen then
		struc.text = LocalPlayer():Nick()
		struc.pos = { ScrW() - 10, 30 }
		draw.Text( struc )
		markuplbl:Draw( ScrW() - 10, 50, TEXT_ALIGN_RIGHT )
	end
end

/*---------------------------------------------------------
	TargetInfo, messages over items and props
---------------------------------------------------------*/

function SKIN:PaintTargetInfo()
	local ang = gui.ScreenToVector(gui.MouseX(), gui.MouseY())
	local tracedata = {}
	tracedata.start = CAKE.CameraPos
	tracedata.endpos = CAKE.CameraPos+(ang*300)
	tracedata.filter = LocalPlayer()
	local tr = util.TraceLine(tracedata)
	
	if( !tr.HitNonWorld ) then return end
	
	if( tr.Entity:GetClass( ) == "item_prop" and tr.Entity:GetPos( ):Distance( CAKE.CameraPos ) <= 200 ) then
		--If the entity is nearby, we draw it's name and description fully.

		local screenpos = tr.Entity:GetPos( ):ToScreen( )
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "Tiramisu18Font", screenpos.x + 2, screenpos.y + 2, Color( 0, 0, 0, 255 ), 1 )	
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "Tiramisu18Font", screenpos.x, screenpos.y, Color( 255, 255, 255, 255 ), 1 )
		draw.DrawText( tr.Entity:GetNWString( "Description" ), "Tiramisu18Font", screenpos.x + 2, screenpos.y + 22, Color( 0, 0, 0, 255 ), 1 )
		draw.DrawText( tr.Entity:GetNWString( "Description" ), "Tiramisu18Font", screenpos.x, screenpos.y + 20, Color( 255, 255, 255, 255 ), 1 )

	elseif ( tr.Entity:GetClass( ) == "item_prop" and tr.Entity:GetPos( ):Distance( CAKE.CameraPos ) > 200 ) then
		--If the entity is further away than 200 units, we draw only it's name, but greyed out to indicate that you can't use it unless you get closer.

		local screenpos = tr.Entity:GetPos( ):ToScreen( )
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "Tiramisu18Font", screenpos.x + 2, screenpos.y + 2, Color( 0, 0, 0, 185 ), 1 )	
		draw.DrawText( tr.Entity:GetNWString( "Name" ), "Tiramisu18Font", screenpos.x, screenpos.y, Color( 125, 125, 125, 185 ), 1 )

	elseif tr.Entity:GetNWString( "propdescription", "" ) != "" and tr.Entity:GetPos( ):Distance( LocalPlayer( ):GetPos( ) ) < 200 then
		--if it's a prop with a description added to it, you can read it's description only if you're 200 units near.

		local screenpos = tr.Entity:GetPos( ):ToScreen( )
		draw.DrawText( tr.Entity:GetNWString( "propdescription" ), "Tiramisu18Font", screenpos.x + 2, screenpos.y + 2, Color( 0, 0, 0, 255 ), 1 )
		draw.DrawText( tr.Entity:GetNWString( "propdescription" ), "Tiramisu18Font", screenpos.x, screenpos.y, Color( 255, 255, 255, 255 ), 1 )
	end
end

/*---------------------------------------------------------
	TiramisuChatBox
---------------------------------------------------------*/

function SKIN:PaintTiramisuChatBox(panel)

	if !panel.Alpha then
		panel.Alpha = 0
	else
		if !panel.Open then
			panel.Alpha = Lerp( 0.2, panel.Alpha, 0 )
		else
			 panel.Alpha = Lerp( 0.2, panel.Alpha, 150 )
		end
	end

	x, y = panel:ScreenToLocal( 0, 0 ) 
	lastpos = 0
	color = CAKE.BaseColor or Color( 100, 100, 115, 150 )
	
	// Background 
	surface.SetMaterial( matBlurScreen ) 
	surface.SetDrawColor( 255, 255, 255, panel.Alpha or 0 ) 
	
	matBlurScreen:SetMaterialFloat( "$blur", panel.Alpha or 0 / 50 ) 
	render.UpdateScreenEffectTexture() 
	
	surface.DrawTexturedRect( x, y, ScrW(), ScrH() ) 

	if ( panel.m_bBackgroundBlur ) then
		Derma_DrawBackgroundBlur( panel, panel.m_fCreateTime )
	end
	
	surface.SetDrawColor( color.r, color.g, color.b, panel.Alpha or 0 ) 
	surface.DrawRect( x, y, ScrW(), ScrH() ) 

	surface.SetDrawColor( 50, 50, 50, math.Clamp( panel.Alpha or 0 - 50, 0, 255 ) ) 

	for i = 1, panel:GetWide() / 5 * 2  do
		surface.DrawLine( ( i * 5 ), 0, 0, ( i * 5 ) )
	end

	// Pretentious line bullshit :P
	x = math.floor( panel:GetWide() / 5 )
	y = math.floor( panel:GetTall() / 5 )

	// and some gradient shit for additional overkill

	for i = 1, ( y + 5 ) do
		surface.SetDrawColor( math.Clamp( color.r - 50, 0, 255 ), math.Clamp( color.g - 50,0, 255 ), math.Clamp( color.b - 50, 0, 255 ), Lerp( i / ( ( y + 5 ) ), 0 , panel.Alpha or 0 ) ) 
		surface.DrawRect( 0, ( i * 5 ) , panel:GetWide(), 5 )
	end

	// Border 
	surface.SetDrawColor( math.Clamp( color.r - 50, 0, 255 ), math.Clamp( color.g - 50,0, 255 ), math.Clamp( color.b - 50, 0, 255 ), panel.Alpha or 0 ) 
	surface.DrawOutlinedRect( 0, 0, panel:GetWide(), panel:GetTall() )

end


derma.DefineSkin( "Tiramisu", "Made to look like some good stuff", SKIN )