local GM = GM or GAMEMODE

local color_bg = Color(52, 73, 94, 80)
local color_fg = Color(255, 255, 255)
local color_richtext = Color( 0, 16, 32 )

local color_modelpanel = Color( 4, 72, 139)
local color_description = Color(44, 62, 80)

local PANEL = {}

function PANEL:Init()

	self:Dock(RIGHT)
	self:SetSize(ScrW() * 0.25, ScrH() * 0.5)
	self:SetZPos(1)

	self:Populate()

end

function PANEL:Paint(w, h)
	draw.RoundedBox( 16, 0, 0, w, h, color_bg )
end

function PANEL:Populate()

	self.descriptionpanel = self:Add("EditablePanel")
	self.descriptionpanel:SetPos(0, 0)
	self.descriptionpanel:SetSize(ScrW() * 0.25, ScrH() * 0.5)
	self.descriptionpanel.Paint = function( this, w, h ) draw.RoundedBox( 16, 0, 0, w, h, Color( color_description.r, color_description.g, color_description.b, this:GetAlpha() ) ) end

	self.descriptionpanel.RichText = self.descriptionpanel:Add("RichText")
	self.descriptionpanel.RichText:Dock( FILL )

	function self.descriptionpanel.RichText:PerformLayout()
		self:SetFontInternal( "Roboto F4" )
		self:SetBGColor( color_richtext )
	end

	self.modelpanel = self:Add("EditablePanel")
	self.modelpanel:AlignBottom(-24)
	self.modelpanel:SetSize(ScrW() * 0.25, ScrH() * 0.5)

	self.modelpanel.Paint = function( _, w, h ) surface.SetDrawColor(color_modelpanel) surface.DrawOutlinedRect( 0, 0, w, h, 7) end

	self.modelpanel.Model = self.modelpanel:Add("DModelPanel")
	self.modelpanel.Model:Dock(FILL)
	self.modelpanel.Model:DockMargin(0, 0, 0, 9)

	function self.modelpanel.Model:LayoutEntity( Entity ) return end -- disables default rotation

	if self.modelpanel.Model.Entity and self.modelpanel.Model.Entity:LookupBone("ValveBiped.Bip01_Head1") then
		local headpos = self.modelpanel.Model.Entity:GetBonePosition(self.modelpanel.Model.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		self.modelpanel.Model:SetLookAt(headpos)

		self.modelpanel.Model:SetCamPos(headpos-Vector(-35, 0, 0))	-- Move cam in front of face

		self.modelpanel.Model.Entity:SetEyeTarget(headpos-Vector(-35, 0, 0))
	end

end


--[[function PANEL:PaintOver(w, h)
	surface.SetDrawColor(color_fg)
	surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
end]]

function PANEL:OnRemove()
	--timer.Simple(0.1, function()
		--PLUGIN.healthPanel = nil
	--end)
end

vgui.Register("slsHubRightPanel", PANEL, "EditablePanel")