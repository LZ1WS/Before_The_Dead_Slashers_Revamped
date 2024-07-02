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

local lastcam_entity

function fnafgmSTSA:SecurityTablet2()

	if !IsValid(Monitor) then

		local nopeinit = hook.Call("fnafgmSecurityTabletCustomInit") or false

		if !nopeinit then
				LocalPlayer():ConCommand("play "..Sound("fnafgmstsa/camdown.ogg"))
		end

		if !IsValid(lastcam_entity) then
			lastcam = 1
		end

		fnafgmSTSA:SetViewCamMan(lastcam)

		--LocalPlayer():ConCommand( 'pp_mat_overlay "fnafgmstsa/camstatic"' )

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
			fnafgmSTSA:SetViewCamMan(0)
			--LocalPlayer():ConCommand( 'pp_mat_overlay ""' )
		end
		Monitor.Think = function()
			if input.IsKeyDown( KEY_ESCAPE ) then
				Monitor:Close()
			end
		end

		local CamsNames = vgui.Create( "DLabel" )
		CamsNames:SetParent(Monitor)
		CamsNames:SetText( "CAM"..lastcam )
		CamsNames:SetTextColor( Color( 255, 255, 255, 255 ) )
		CamsNames:SetFont("FNAFGMSTSATIME")
		CamsNames:SetPos( 70, 60 )
		CamsNames:SetSize( 200, 64 )

		local CAM = vgui.Create( "DNumberWang" )
		CAM:SetParent(Monitor)
		CAM:SetPos( ScrW()/2-16, ScrH()-80-50-80 )
		CAM:SetMinMax(1,table.Count(ents.FindByClass( "fnafgm_camera" )))
		CAM:SetSize( 34, 28 )
		CAM:SetValue(lastcam)
		CAM.OnValueChanged = function( val )
			LocalPlayer():ConCommand("play "..Sound("fnafgmstsa/camselect.ogg"))
			fnafgmSTSA:SetViewCamMan( math.Round( val:GetValue() ) )
			lastcam = val:GetValue()
			CamsNames:SetText( "CAM"..val:GetValue() )
		end

		CloseT = vgui.Create( "DButton" )
		CloseT:SetParent(Monitor)
		CloseT:SetSize( 512, 80 )
		CloseT:SetPos( ScrW()/2-256, ScrH()-80-50 )
		CloseT:SetText( "" )
		CloseT:SetTextColor( Color( 255, 255, 255, 255 ) )
		CloseT:SetFont("FNAFGMSTSAID")
		CloseT.DoClick = function( button )
			if IsValid(FNaFView) then waitt = CurTime()+1 end
			Monitor:Close()
			LocalPlayer():ConCommand("play "..Sound("fnafgmstsa/camdown.ogg"))
			hook.Remove( "CalcView", "Camera_View")
			if IsValid(OpenT) then OpenT:Show() end
		end
		CloseT.OnCursorEntered = function()
			if IsValid(FNaFView) then
				if !waitt then waitt=0 end
				if waitt<CurTime() then
					waitt = CurTime()+0.5
					Monitor:Close()
					LocalPlayer():ConCommand("play "..Sound("fnafgmstsa/camdown.ogg"))
					if IsValid(OpenT) then OpenT:Show() end
				end
			end
		end
		CloseT.Paint = function( self, w, h )

			draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 255, 255, 255, 32 ) )

			surface.SetDrawColor( 255, 255, 255, 128 )

			draw.NoTexture()

			surface.DrawLine( w/2-64, h/2-16, w/2, h/2 )
			surface.DrawLine( w/2, h/2, w/2+64, h/2-16 )

			surface.DrawLine( w/2-64, h/2-16+16, w/2, h/2+16 )
			surface.DrawLine( w/2, h/2+16, w/2+64, h/2-16+16 )

			surface.DrawOutlinedRect( 0, 0, w, h )

		end


	end


end

function fnafgmSTSA:SetViewCamMan(id)

	net.Start( "fnafgmSTSASetView2" )
	net.WriteFloat(id)
	net.SendToServer()

	hook.Add( "CalcView", "Camera_View", function( ply, pos, angles, fov )
		if ply:Team() ~= TEAM_KILLER then return end

		if IsValid(lastcam_entity) then

		local view = {
			origin = (lastcam_entity:GetPos() + Vector(0, 0, 55)) + (lastcam_entity:GetAngles():Forward() * 30),
			angles = lastcam_entity:GetAngles(),
			fov = fov,
			drawviewer = true
		}

		return view
	end
	end )

end

net.Receive( "sls_cams_entity2", function( len )
	lastcam_entity = net.ReadEntity()
end)

net.Receive( "fnafgmSecurityTabletSA2", function( len )
	fnafgmSTSA.SecurityTablet2()
end)

local camera_holo = nil;

function SWEP:Deploy()
	--if not IsFirstTimePredicted() then return true end
	camera_holo = ClientsideModel("models/rin/mgs5/props/camera.mdl", 9)
	camera_holo:SetRenderMode(4)
	return true
end

function SWEP:Holster()
	if not IsFirstTimePredicted() or !IsValid(camera_holo) then return true end
	camera_holo:Remove()
	return true
end

function SWEP:OnRemove()
	if !IsValid(camera_holo) then return end
	camera_holo:Remove()
end

function SWEP:Think()
	if !IsValid(camera_holo) then return end

	local eyetrace = LocalPlayer():GetEyeTrace()

	slashers_camera_place(LocalPlayer(), camera_holo)

	if LocalPlayer():GetPos():Distance(eyetrace.HitPos) > self.MaxDistance then
		camera_holo:SetNoDraw(true)
	else
		camera_holo:SetNoDraw(false)
		if eyetrace.HitWorld then
			camera_holo:SetColor(Color(0, 255, 0, 150))
		else
			camera_holo:SetColor(Color(255, 0, 0, 150))
		end
	end

end

--[[hook.Add( "ShouldDrawLocalPlayer", "Camera_View_Player", function( ply )
	if ply:Team() ~= TEAM_KILLER then return end

	if IsValid(lastcam_entity) and rendering_camera then
		return true
	end
end )]]

function SWEP:DrawHUD()
	if IsValid(Monitor) then
		if IsValid(cam_window) then
		cam_window:Remove()
		end
	return end
	if IsValid(cam_window) and !IsValid(lastcam_entity) then
		cam_window:Remove()
	end
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
			if !IsValid(lastcam_entity) then return end

			local x, y = self:GetPos()

			local old = DisableClipping( true ) -- Avoid issues introduced by the natural clipping of Panel rendering
			render.RenderView( {
				origin = (lastcam_entity:GetPos() + Vector(0, 0, 55)) + (lastcam_entity:GetAngles():Forward() * 30),
				angles = lastcam_entity:GetAngles(),
				x = x, y = y,
				w = w, h = h,
				zfar = 900,
				drawviewmodel = false
			} )
			DisableClipping( old )

			--rendering_camera = true

		end
	end
end