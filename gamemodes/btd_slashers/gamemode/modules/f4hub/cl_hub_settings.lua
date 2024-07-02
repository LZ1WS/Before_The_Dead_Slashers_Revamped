local GM = GM or GAMEMODE

local color_bg = Color(44, 62, 80)
local color_fg = Color(255, 255, 255)

local color_properties = Color( 0, 0, 0, 145)
local color_main_settings = Color( 61, 0, 117, 145)
local color_checkbox = Color( 236, 240, 241, 80 )

local PANEL = {}

function PANEL:Init()

	self:Dock(FILL)
	self:DockPadding(75, 350, 75, 10)

	self:Populate()

end

function PANEL:Paint(w, h)
	draw.RoundedBox( 4, 0, 0, w, h, color_main_settings)
end

function PANEL:Populate()
	local settings_w, settings_h = self:GetSize()

	local Discord = self:Add("DButton")
	Discord:SetText( "Discord" )
	Discord:Dock(TOP)
	Discord:DockMargin(0, 0, 0, 5)
	Discord:SetSize(ScrW() * 0.10, ScrH() * 0.05)
	Discord:SetFontInternal("Roboto F4")
	Discord.DoClick = function()
		surface.PlaySound("UI/buttonclickrelease.wav")
		gui.OpenURL("https://discord.gg/MRs5zBXq9z")
	end

	local Workshop = self:Add("DButton")
	Workshop:SetText( "Workshop" )
	Workshop:Dock(TOP)
	Workshop:DockMargin(0, 0, 0, 5)
	Workshop:SetSize(ScrW() * 0.10, ScrH() * 0.05)
	Workshop:SetFontInternal("Roboto F4")
	Workshop.DoClick = function()
		surface.PlaySound("UI/buttonclickrelease.wav")
		gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2804558040")
	end

	local sls_intro_disable = self:Add( "DCheckBoxLabel" ) -- Create the checkbox
	--sls_killer_Checkbox:Dock(TOP)
	--sls_intro_disable:SetPos(settings_w / 0.298, settings_h * 39.50)
	sls_intro_disable:Dock(BOTTOM)
	sls_intro_disable:DockMargin(45, 0, 0, 0)
	--sls_intro_disable:SetWidth(sls_intro_disable:GetWide() / 2)
	sls_intro_disable:SetText(GM.LANG:GetString("hub_intro_checkbox"))					-- Set the text next to the box
	sls_intro_disable:SetFont("ChatFont")
	sls_intro_disable:SetValue( LocalPlayer():GetNWBool("sls_intro_disabled", true) )						-- Initial value
	if LocalPlayer():GetNWBool("sls_intro_disabled", false) then
		sls_intro_disable:SetAlpha(50)
	end

	function sls_intro_disable:OnChange( val )
		LocalPlayer():SetNWBool("sls_intro_disabled", val)
		surface.PlaySound("ui/buttonrollover.wav")
		if !val then
			sls_intro_disable:AlphaTo(50, 0.2)
		else
			sls_intro_disable:AlphaTo(255, 0.2)
		end
	end

	sls_intro_disable:SetTextColor(Color(18, 191, 243))
	sls_intro_disable:SetIndent( 4 )
	sls_intro_disable.Paint = function( _, w, h ) draw.RoundedBox( 16, 0, 0, sls_intro_disable.Label:GetWide() + sls_intro_disable.Button:GetWide() + 20, h, color_checkbox) end
	--[[local Checkbox_w, _ = sls_intro_disable:GetChild(1):GetSize()
	sls_intro_disable.Paint = function( _, w, h ) draw.RoundedBox( 16, 0, 0, ScrW() * Checkbox_w * 1.10 / ScrW(), h, color_checkbox) end
	sls_intro_disable:SizeToContents()
	local Checkbox_w2, Checkbox_h2 = sls_intro_disable:GetSize()
	sls_intro_disable:SetSize(Checkbox_w2 + 12, Checkbox_h2)]]

	local sls_killer_Checkbox = self:Add( "DCheckBoxLabel" ) -- Create the checkbox
	sls_killer_Checkbox:Dock(BOTTOM)
	sls_killer_Checkbox:DockMargin(90, 0, 0, 0)
	--sls_killer_Checkbox:SetPos(settings_w / 0.255, settings_h * 40.50)
	sls_killer_Checkbox:SetText(GM.LANG:GetString("hub_killer_checkbox"))					-- Set the text next to the box
	sls_killer_Checkbox:SetFont("ChatFont")
	sls_killer_Checkbox:SetValue( LocalPlayer():GetNWBool("sls_killer_choose", true) )						-- Initial value

	if !LocalPlayer():GetNWBool("sls_killer_choose", true) then
		sls_killer_Checkbox:SetAlpha(50)
	end

	function sls_killer_Checkbox:OnChange( val )
		LocalPlayer():SetNWBool("sls_killer_choose", val)

		net.Start("sls_killer_choose_nw")
		net.WriteBool(val)
		net.SendToServer()

		surface.PlaySound("ui/buttonrollover.wav")
		if !val then
			sls_killer_Checkbox:AlphaTo(50, 0.2)
		else
			sls_killer_Checkbox:AlphaTo(255, 0.2)
		end
	end

	sls_killer_Checkbox:SetTextColor(Color(243, 156, 18, 255))
	sls_killer_Checkbox:SetIndent( 4 )
	sls_killer_Checkbox.Paint = function( _, w, h ) draw.RoundedBox( 16, 0, 0, sls_killer_Checkbox.Label:GetWide() + sls_killer_Checkbox.Button:GetWide() + 20, h,  color_checkbox) end
	--[[Checkbox_w, Checkbox_h = sls_killer_Checkbox:GetChild(1):GetSize()
	sls_killer_Checkbox.Paint = function( _, w, h ) draw.RoundedBox( 16, 0, 0, ScrW() * Checkbox_w * 1.14 / ScrW(), h,  color_checkbox) end
	sls_killer_Checkbox:SizeToContents()

	Checkbox_w2, Checkbox_h2 = sls_killer_Checkbox:GetSize()
	sls_killer_Checkbox:SetSize(Checkbox_w2 + 12, Checkbox_h2)]]

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

vgui.Register("slsSettingsMain", PANEL, "EditablePanel")

PANEL = {}

function PANEL:Init()

	self:SetSize(250, 500)
	self:DockMargin(250, 0, 250, 0)
	self:DockPadding(25, 10, 25, 10)

	self.Properties = self:Add("DPropertySheet")
	self.Properties:Dock( FILL )
	self.Properties.Paint = function( _, w, h ) draw.RoundedBox( 4, 0, 0, w, h, color_properties ) end

	self.MainSettings = self:Add("slsSettingsMain")

	self.Properties:AddSheet( GM.LANG:GetString("hub_settings_main"), self.MainSettings, "icon16/wrench.png" )

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

vgui.Register("slsHubSettings", PANEL, "EditablePanel")