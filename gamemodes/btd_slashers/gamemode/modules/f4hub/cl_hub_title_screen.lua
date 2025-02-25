local GM = GM or GAMEMODE

surface.CreateFont( "Roboto Small Italic", {
	font = "Roboto Bold", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 24,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = true,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

surface.CreateFont( "Roboto Title Screen", {
	font = "Roboto Bold", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 55,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
} )

local color_bg = Color(71, 71, 71, 100)
local color_gray = Color(255, 255, 255, 45)

local PANEL = {}

function PANEL:Init()

	self:SetWidth(250)
	self:SetPos(0, 0)

	self:DockPadding(25, 5, 25, 0)

	self.Buttons = self.Buttons or {}
end

function PANEL:Paint(w, h)
	draw.RoundedBox( 16, 0, 0, w, h, color_bg )
end

function PANEL:AddButton(text, font)
	local button = self:Add("DButton")
	button:SetText( text or "Text" )
	button:Dock(TOP)
	button:DockMargin(0, 0, 0, 10)
	button:SetFontInternal(font or "Roboto F4")

	self.Buttons[#self.Buttons + 1] = button

	return button
end

function PANEL:SizeToContentsY()
	local height = self:GetTall()

	for _, v in ipairs(self.Buttons) do
		height = height + v:GetTall()
	end

	self:SetHeight(height)
	self:InvalidateLayout()
end

function PANEL:OnRemove()
end

vgui.Register("slsButtonHolder", PANEL, "EditablePanel")

PANEL = {}

local butMat = Material("materials/icons/scoreboard_line.png")
local title_allow_gameui
local just_joined = true

function PANEL:Init()
	title_allow_gameui = false

	self:SetSize(ScrW(), ScrH())
	self:SetPos(0, ScrH() / 2)
	self:MakePopup()
	self:MoveTo(0, 0, 1, 0, -1 )

	surface.PlaySound("ui/buttonrollover.wav")

	self.Logo = self:Add("DImage")
	self.Logo:SetSize(ScrW() * 0.210416, ScrH() * 0.1185185185185185)
	self.Logo:Center()
	self.Logo:SetY(ScrH() * 0.2083)
	self.Logo:SetImage("gamemode/logo.png")

	self.LogoText = self:Add("DLabel")
	self.LogoText:SetText("Revamped")
	self.LogoText:SetFont("Roboto Title Screen")
	self.LogoText:SizeToContents()
	self.LogoText:Center()
	self.LogoText:SetY(ScrH() * 0.3240740740740741)
	self.LogoText:SetTextColor(color_gray)

	self.VersionText = self:Add("DLabel")
	self.VersionText:SetText("v" .. GM.Version)
	self.VersionText:SetFont("Roboto Small Italic")
	self.VersionText:SizeToContents()
	self.VersionText:SetWide(self.VersionText:GetWide() + 10)
	self.VersionText:SetPos(0, 0)
	self.VersionText:AlignBottom()
	self.VersionText:AlignRight()
	self.VersionText:SetTextColor(color_gray)

	self.Holder = self:Add("slsButtonHolder")
	self.Holder:SetWidth(ScrW() * 0.2604166666666667)
	self.Holder:Center()

	function self.Holder:Paint(w, h)
		return
	end

	self.Play = self.Holder:AddButton(GM.LANG:GetString("hub_play"), "Roboto F4")
	self.Play:SetTall(ScrH() * 0.05)

	self.Play.DoClick = function()
		surface.PlaySound("UI/buttonclickrelease.wav")

		if just_joined then
			RunConsoleCommand("gm_showhelp")

			if IsValid(HUBMENU) then return end

			HUBMENU = vgui.Create( "slsHubMain" )

			just_joined = false
		end

		self:Remove()
	end

	self.Play.Paint = function(_, w, h) surface.SetDrawColor(color_white) surface.SetMaterial(butMat) surface.DrawTexturedRect(0, 0, w, h * 2) end

	self.Settings = self.Holder:AddButton(GM.LANG:GetString("hub_settings"), "Roboto F4")
	self.Settings:SetTall(ScrH() * 0.05)

	self.Settings.DoClick = function()
		surface.PlaySound("UI/buttonclickrelease.wav")

		local settings = vgui.Create("slsHubSettings")
		settings:SetSize(ScrW() / 3, ScrH())
		settings:Center()
		settings:MakePopup()

		settings.CloseBtn = settings:Add("DImageButton")
		settings.CloseBtn:AlignRight(-30)
		settings.CloseBtn:SetImage( "icon16/cancel.png" )
		settings.CloseBtn:SetSize(ScrW() * 0.015, ScrH() * 0.024)
		settings.CloseBtn:SetKeepAspect(true)
		settings.CloseBtn.DoClick = function()
			surface.PlaySound("ui/buttonclickrelease.wav")
			settings:Remove()
		end
		settings.CloseBtn:SetZPos(99)
	end

	self.Settings.Paint = function(_, w, h) surface.SetDrawColor(color_white) surface.SetMaterial(butMat) surface.DrawTexturedRect(0, 0, w, h * 2) end

	self.GameUI = self.Holder:AddButton(GM.LANG:GetString("hub_defaultmenu"), "Roboto F4")
	self.GameUI:SetTall(ScrH() * 0.05)

	self.GameUI.DoClick = function()
		surface.PlaySound("UI/buttonclickrelease.wav")

		title_allow_gameui = true

		gui.ActivateGameUI()

		self:Remove()

		title_allow_gameui = false
	end

	self.GameUI.Paint = function(_, w, h) surface.SetDrawColor(color_white) surface.SetMaterial(butMat) surface.DrawTexturedRect(0, 0, w, h * 2) end

	self.Disconnect = self.Holder:AddButton(GM.LANG:GetString("hub_disconnect"), "Roboto F4")
	self.Disconnect:SetTall(ScrH() * 0.05)

	self.Disconnect.DoClick = function()
		RunConsoleCommand("disconnect")

		self:Remove()
	end

	self.Disconnect.Paint = function(_, w, h) surface.SetDrawColor(color_white) surface.SetMaterial(butMat) surface.DrawTexturedRect(0, 0, w, h * 2) end

	self.Holder:SizeToContentsY()
	self.Holder:SetTall(self.Holder:GetTall() + 20)

	self:PlayMusic()
end

function PANEL:Paint(w, h)
	Derma_DrawBackgroundBlur(self)
end

function PANEL:Think()
	--[[if input.IsKeyDown(KEY_ESCAPE) then
		return self:Remove()
	end]]
end

function PANEL:OnRemove()
	if (IsValid(self.channel)) then
		self.channel:Stop()
		self.channel = nil
	end
end

function PANEL:PlayMusic()
	local path = (GM.MAP.LobbyMusic and ("sound/" .. GM.MAP.LobbyMusic)) or ("sound/lobby/normal" .. math.random(1, 10) .. ".ogg")

	local url = path:match("http[s]?://.+")
	local play = url and sound.PlayURL or sound.PlayFile
	path = url and url or path

	play(path, "noplay noblock", function(channel, error, message)
		if (!IsValid(self) or !IsValid(channel)) then
			return
		end

		channel:SetVolume(0.1)
		channel:EnableLooping(true)
		channel:Play()

		self.channel = channel

--[[		self:CreateAnimation(audioFadeInTime, {
			index = 10,
			target = {volume = 1},

			Think = function(animation, panel)
				if (IsValid(panel.channel)) then
					panel.channel:SetVolume(self.volume * 0.5)
				end
			end
		})]]
	end)
end

vgui.Register("slsTitleScreen", PANEL, "EditablePanel")

hook.Add("InitPostEntity","sls_lobbymusic_init", function()
	TITLESCREEN = vgui.Create( "slsTitleScreen" )
end)

hook.Add( "OnPauseMenuShow", "sls_open_title_screen", function()
	if !title_allow_gameui then
		if IsValid(TITLESCREEN) then return false end

		TITLESCREEN = vgui.Create( "slsTitleScreen" )

		return false
	end
end )