local GM = GM or GAMEMODE

local color_bg = Color(44, 62, 80)
local color_fg = Color(255, 255, 255)

local color_properties = Color( 0, 0, 0, 145)
local color_main_settings = Color( 61, 0, 117, 145)
local color_checkbox = Color( 236, 240, 241, 80 )

local settingsMain = {
	["DButton"] = {
		{
			["title"] = "Discord",
			["dock"] = TOP,
			["dockMargin"] = {0, 0, 0, 5},
			["font"] = "Roboto F4",
			["sound"] = "UI/buttonclickrelease.wav",
			["URL"] = "https://discord.gg/MRs5zBXq9z",
		},

		{
			["title"] = "Workshop",
			["dock"] = TOP,
			["dockMargin"] = {0, 0, 0, 5},
			["font"] = "Roboto F4",
			["sound"] = "UI/buttonclickrelease.wav",
			["URL"] = "https://steamcommunity.com/sharedfiles/filedetails/?id=2804558040",
		},
	},

	["DCheckBoxLabel"] = {
		{
			["title"] = GM.LANG:GetString("hub_intro_checkbox"),
			["dock"] = BOTTOM,
			["dockMargin"] = {45, 0, 0, 0},
			["font"] = "ChatFont",
			["textColor"] = Color(18, 191, 243),
			["sound"] = "ui/buttonrollover.wav",
			["indent"] = 4,
			["initFunc"] = function(_, panel)
				panel:SetValue( LocalPlayer():GetNWBool("sls_intro_disabled", true) )

				if LocalPlayer():GetNWBool("sls_intro_disabled", false) then
					panel:SetAlpha(50)
				end

				panel.Paint = function( self, w, h ) draw.RoundedBox( 16, 0, 0, self.Label:GetWide() + self.Button:GetWide() + 20, h, color_checkbox) end
			end,
			["customFunc"] = function(_, panel, val)
				LocalPlayer():SetNWBool("sls_intro_disabled", val)
				surface.PlaySound("ui/buttonrollover.wav")
				if !val then
					panel:AlphaTo(50, 0.2)
				else
					panel:AlphaTo(255, 0.2)
				end
			end
		},

		{
			["title"] = GM.LANG:GetString("hub_killer_checkbox"),
			["dock"] = BOTTOM,
			["dockMargin"] = {90, 0, 0, 0},
			["font"] = "ChatFont",
			["textColor"] = Color(243, 156, 18, 255),
			["sound"] = "ui/buttonrollover.wav",
			["indent"] = 4,
			["initFunc"] = function(_, panel)
				panel:SetValue( LocalPlayer():GetNWBool("sls_killer_choose", true) )

				if LocalPlayer():GetNWBool("sls_killer_choose", false) then
					panel:SetAlpha(50)
				end

				panel.Paint = function( self, w, h ) draw.RoundedBox( 16, 0, 0, panel.Label:GetWide() + panel.Button:GetWide() + 20, h,  color_checkbox) end
			end,
			["customFunc"] = function(_, panel, val)
				LocalPlayer():SetNWBool("sls_killer_choose", val)

				net.Start("sls_killer_choose_nw")
				net.WriteBool(val)
				net.SendToServer()

				surface.PlaySound("ui/buttonrollover.wav")
				if !val then
					panel:AlphaTo(50, 0.2)
				else
					panel:AlphaTo(255, 0.2)
				end
			end
		},
	},
}

local lobbyConVar = GetConVar("slashers_lobby_volume")
local chaseConVar = GetConVar("slashers_chase_volume")
local escapeConVar = GetConVar("slashers_escape_volume")

local settingsAudio = {
	["DNumSlider"] = {
		{
			["title"] = GM.LANG:GetString("hub_audio_lobbyMusic"),
			["dock"] = TOP,
			["dockMargin"] = {0, 0, 0, 5},
			["font"] = "ChatFont",
			--["sound"] = "ui/buttonrollover.wav",
			["conVar"] = "slashers_lobby_volume",
			["decimals"] = 0,
			["min"] = lobbyConVar:GetMin(),
			["max"] = lobbyConVar:GetMax(),
		},

		{
			["title"] = GM.LANG:GetString("hub_audio_chaseMusic"),
			["dock"] = TOP,
			["dockMargin"] = {0, 0, 0, 5},
			["font"] = "ChatFont",
			--["sound"] = "ui/buttonrollover.wav",
			["conVar"] = "slashers_chase_volume",
			["decimals"] = 0,
			["min"] = chaseConVar:GetMin(),
			["max"] = chaseConVar:GetMax(),
		},

		{
			["title"] = GM.LANG:GetString("hub_audio_escapeMusic"),
			["dock"] = TOP,
			["dockMargin"] = {0, 0, 0, 5},
			["font"] = "ChatFont",
			--["sound"] = "ui/buttonrollover.wav",
			["conVar"] = "slashers_escape_volume",
			["decimals"] = 0,
			["min"] = escapeConVar:GetMin(),
			["max"] = escapeConVar:GetMax(),
		},
	},
}

local PANEL = {}

function PANEL:Init()
	self:Dock(FILL)
	self:DockPadding(75, 350, 75, 10)

	self.Buttons = {}
	self.CheckBoxes = {}
	self.Sliders = {}
end

function PANEL:Paint(w, h)
	draw.RoundedBox( 4, 0, 0, w, h, color_main_settings)
end

function PANEL:Populate()
	--local settings_w, settings_h = self:GetSize()

	for pnlType, settingTbl in pairs(settingsMain) do
		for _, setting in ipairs(settingTbl) do
			local settingPanel = self:Add(pnlType)

			if pnlType == "DButton" then
				settingPanel:SetText(setting.title or "Unknown")
				settingPanel:Dock(setting.dock or TOP)
				settingPanel:DockMargin(unpack(setting.dockMargin))
				settingPanel:SetSize(ScrW() * 0.10, ScrH() * 0.05)
				settingPanel:SetFontInternal(setting.font or "Roboto F4")

				if isfunction(setting.initFunc) then
					setting:initFunc(settingPanel)
				end

				settingPanel.DoClick = function()
					if setting.sound then
						surface.PlaySound(setting.sound)
					end

					if setting.URL then
						gui.OpenURL(setting.URL)
					end

					if isfunction(setting.customFunc) then
						setting:CustomFunc(settingPanel)
					end
				end

				settingPanel.index = #self.Buttons + 1

				self.Buttons[settingPanel.index] = settingPanel
			end

			if pnlType == "DCheckBoxLabel" then
				settingPanel:Dock(setting.dock)
				settingPanel:DockMargin(unpack(setting.dockMargin))
				settingPanel:SetText(setting.title or "Unknown")
				settingPanel:SetTextColor(setting.textColor)
				settingPanel:SetFont(setting.font)
				settingPanel:SetIndent( setting.indent )

				if isfunction(setting.initFunc) then
					setting:initFunc(settingPanel)
				end

				settingPanel.OnChange = function(_, val)
					if setting.sound then
						surface.PlaySound(setting.sound)
					end

					if isfunction(setting.customFunc) then
						setting:CustomFunc(settingPanel, val)
					end
				end

				settingPanel.index = #self.CheckBoxes + 1

				self.CheckBoxes[settingPanel.index] = settingPanel
			end
		end
	end
end

function PANEL:PopulateAudio()
	for pnlType, settingTbl in pairs(settingsAudio) do
		for _, setting in ipairs(settingTbl) do
			local settingPanel = self:Add(pnlType)

			if pnlType == "DNumSlider" then
				settingPanel:SetText(setting.title or "Unknown")
				settingPanel:Dock(setting.dock or TOP)
				settingPanel:DockMargin(unpack(setting.dockMargin))
				settingPanel:SetSize(ScrW() * 0.10, ScrH() * 0.05)
				settingPanel:SetFontInternal(setting.font or "Roboto F4")
				settingPanel:SetMinMax(setting.min or 0, setting.max or 100)
				settingPanel:SetDecimals(setting.decimals or 0)

				if setting.conVar then
					settingPanel:SetConVar(setting.conVar)
				end

				if isfunction(setting.initFunc) then
					setting:initFunc(settingPanel)
				end

				settingPanel.OnValueChanged = function(_, value)
					if setting.sound then
						surface.PlaySound(setting.sound)
					end

					if isfunction(setting.customFunc) then
						setting:CustomFunc(settingPanel, value)
					end
				end

				settingPanel.index = #self.Sliders + 1

				self.Sliders[settingPanel.index] = settingPanel
			end
		end
	end
end

--[[function PANEL:PaintOver(w, h)
	surface.SetDrawColor(color_fg)
	surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
end]]

function PANEL:OnRemove()
end

vgui.Register("slsSettingsPanel", PANEL, "EditablePanel")

PANEL = {}

function PANEL:Init()

	self:SetSize(250, 500)
	self:DockMargin(250, 0, 250, 0)
	self:DockPadding(25, 10, 25, 10)

	self.Properties = self:Add("DPropertySheet")
	self.Properties:Dock( FILL )
	self.Properties.Paint = function( _, w, h ) draw.RoundedBox( 4, 0, 0, w, h, color_properties ) end

	self.MainSettings = self:Add("slsSettingsPanel")
	self.MainSettings:Populate()

	self.AudioSettings = self:Add("slsSettingsPanel")
	self.AudioSettings:PopulateAudio()

	self.Properties:AddSheet( GM.LANG:GetString("hub_settings_main"), self.MainSettings, "icon16/wrench.png" )
	self.Properties:AddSheet( GM.LANG:GetString("hub_settings_audio"), self.AudioSettings, "icon16/sound.png" )
end

function PANEL:Paint(w, h)
	draw.RoundedBox( 16, 0, 0, w, h, Color( color_bg.r, color_bg.g, color_bg.b, self:GetAlpha() ) )
end

--[[function PANEL:PaintOver(w, h)
	surface.SetDrawColor(color_fg)
	surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
end]]

function PANEL:OnRemove()
end

vgui.Register("slsHubSettings", PANEL, "EditablePanel")