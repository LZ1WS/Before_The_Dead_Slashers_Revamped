include( 'shared.lua' )

SWEP.BounceWeaponIcon = false
SWEP.WepSelectIcon = surface.GetTextureID( "fnafgmstsa/securitytablet" )

if !STSAfont then
	
	fontloaded = true
	if file.Exists( "resource/fonts/graph-35-pix.ttf", "GAME" ) then STSAfont = "Graph 35+ pix" else STSAfont = "Courier" fontloaded = false end
	
end

surface.CreateFont("FNAFGMSTSATIME", {
	font = STSAfont,
	size = 38, 
	weight = 1000, 
	blursize = 0, 
	scanlines = 0, 
	antialias = false, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = true, 
	additive = false, 
	outline = false, 
})
surface.CreateFont("FNAFGMSTSAID", {
	font = STSAfont, 
	size = 14, 
	weight = 1000, 
	blursize = 0, 
	scanlines = 0, 
	antialias = false, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = true, 
	additive = false, 
	outline = false, 
})
surface.CreateFont("FNAFGMSTSATXT", {
	font = STSAfont, 
	size = 12, 
	weight = 500, 
	blursize = 0, 
	scanlines = 0, 
	antialias = false, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = true, 
	additive = false, 
	outline = false, 
})


function fnafgmSTSA:SecurityTablet() 
	
	if !IsValid(Monitor) then
		
		local nopeinit = hook.Call("fnafgmSecurityTabletCustomInit") or false
		
		if !nopeinit then
				if !lastcam then
					lastcam = 1
				end
				LocalPlayer():ConCommand("play "..Sound("fnafgmstsa/camdown.ogg"))
		end
		
		fnafgmSTSA:SetView(lastcam)
		
		LocalPlayer():ConCommand( 'pp_mat_overlay "fnafgmstsa/camstatic"' )
		
		Monitor = vgui.Create( "DFrame" )
		Monitor:SetPos(0, 0)
		Monitor:SetSize(ScrW(), ScrH())
		Monitor:SetTitle("")
		Monitor:SetVisible(true)
		Monitor:SetDraggable(false)
		Monitor:ShowCloseButton(false)
		Monitor:MakePopup()
		Monitor.Paint = function( self, w, h )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawOutlinedRect( 35, 30, w-70, h-60 )
			surface.SetDrawColor( 255, 0, 0, 255 )
			draw.NoTexture()
		end
		Monitor.OnClose = function()
			fnafgmSTSA:SetView(0)
			LocalPlayer():ConCommand( 'pp_mat_overlay ""' )
		end
		Monitor.Think = function()
			if input.IsKeyDown( KEY_ESCAPE ) then
				Monitor:Close()
			end
		end			
		
		
	end
	
	
end

function fnafgmSTSA:SetView(id)
	net.Start( "fnafgmSTSASetView" )
		net.WriteFloat(id)
	net.SendToServer()
end

net.Receive( "fnafgmSecurityTabletSA", function( len )
	fnafgmSTSA.SecurityTablet()
end)

local lastcam_entity

net.Receive( "sls_cams_entity", function( len )
	lastcam_entity = net.ReadEntity()
end)

function SWEP:DrawHUD()
	if IsValid(Monitor) then
		if IsValid(cam_window) then
		cam_window:Remove()
		end
	return end
	if IsValid(lastcam_entity) and !IsValid(cam_window) then
		cam_window = vgui.Create( "DFrame" )
		cam_window:SetSize( ScrW() / 4, ScrH() / 4 )
		cam_window:AlignTop()
		cam_window:AlignRight()
		cam_window:SetMouseInputEnabled( false )
		cam_window:ShowCloseButton( false )
		cam_window:SetTitle("")
		cam_window:SetVisible(true)
		cam_window:SetDraggable(false)
		
		function cam_window:Paint( w, h )
		
			local x, y = self:GetPos()
		
			local old = DisableClipping( true ) -- Avoid issues introduced by the natural clipping of Panel rendering
			render.RenderView( {
				origin = lastcam_entity:GetPos(),
				angles = lastcam_entity:GetAngles(),
				x = x, y = y,
				w = w, h = h,
				zfar = 900
			} )
			DisableClipping( old )
		
		end
	end
end