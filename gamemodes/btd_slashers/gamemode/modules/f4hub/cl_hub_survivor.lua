local GM = GM or GAMEMODE

local color_bg = Color(44, 62, 80)
local color_fg = Color(255, 255, 255)

local PANEL = {}

function PANEL:Init()
end

--[[function PANEL:Paint(w, h)
	draw.RoundedBox( 16, 0, 0, w, h, Color( color_bg.r, color_bg.g, color_bg.b, self:GetAlpha() ) )
end]]

function PANEL:AddLabel(text, font, color)
	local label = self:Add("DLabel")
	label:SetText(text or "")
	label:SetFont(font or "Roboto F4")
	label:SetTextColor(color or color_white)

	return label
end

--[[function PANEL:PaintOver(w, h)
	surface.SetDrawColor(color_fg)
	surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
end]]

--[[function PANEL:OnRemove()
	--timer.Simple(0.1, function()
		--PLUGIN.healthPanel = nil
	--end)
end]]

vgui.Register("slsSurvivorButton", PANEL, "DImageButton")

PANEL = {}
function PANEL:Init()

	--self:Dock(FILL)
	self.Scroll = self:Add("DScrollPanel")
	self.Scroll:Dock(FILL)

	self.Scroll.Layout = self.Scroll:Add("DIconLayout")
	self.Scroll.Layout:Dock( FILL )
	self.Scroll.Layout:SetSpaceY( 5 )
	self.Scroll.Layout:SetSpaceX( 5 )

end

function PANEL:Paint(w, h)
	draw.RoundedBox( 16, 0, 0, w, h, Color( color_bg.r, color_bg.g, color_bg.b, self:GetAlpha() ) )
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

vgui.Register("slsSheetSurvivor", PANEL, "EditablePanel")