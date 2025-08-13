local GM = GM or GAMEMODE

local color_survivor = Color( 22, 160, 133, 140 )
local color_killer = Color( 146, 1, 1, 140)

local color_gray = Color(255, 255, 255, 45)

local sls_ply_choosen_killer_model
local sls_ply_choosen_killer_description
local sls_ply_choosen_killer_stats

local PANEL = {}

function PANEL:Init()

	self:SetSize(ScrW(), ScrH())
	self:SetPos(ScrW() / 2, 0)
	self:MakePopup()
	self:MoveTo(0, 0, 1, 0, -1 )

	surface.PlaySound("ui/buttonrollover.wav")

	self.CloseBtn = self:Add("DImageButton")
	self.CloseBtn:AlignRight(-30)
	self.CloseBtn:SetImage( "icon16/cancel.png" )
	self.CloseBtn:SetSize(ScrW() * 0.015, ScrH() * 0.024)
	self.CloseBtn:SetKeepAspect(true)
	self.CloseBtn.DoClick = function()
		surface.PlaySound("ui/buttonclickrelease.wav")
		self:Remove()
	end
	self.CloseBtn:SetZPos(99)

	self.RightPanel = self:Add("slsHubRightPanel")

	self:Populate()

end

function PANEL:Paint(w, h)
	Derma_DrawBackgroundBlur(self)
end

function PANEL:Think()
	if input.IsKeyDown(KEY_ESCAPE) then
		return self:Remove()
	end
end

function PANEL:Populate()
	local description = self.RightPanel.descriptionpanel.RichText
	local modelpanel = self.RightPanel.modelpanel

	local sheet = vgui.Create( "slsColumnSheet", self )

	sheet:Dock(FILL)

	local survshow = sheet:Add("slsSheetSurvivor")
	survshow:Dock(FILL)

	local survshow_sheet = sheet:AddSheet( GM.LANG:GetString("hub_survivorshow"), survshow, "icon16/vcard.png" )
	survshow_sheet.Button:DockMargin(0, 0, 0, 0)
	survshow_sheet.Button.Paint = function( _, w, h ) draw.RoundedBox( 16, 0, 0, w, h, color_survivor) end
	survshow_sheet.Button:SetSize(60, 60)
	survshow_sheet.Button:SetContentAlignment(5)
	survshow_sheet.Button:SetFontInternal("Roboto F4")
	survshow_sheet.Button:SetAlpha(125)

	local killerchoose = sheet:Add("slsSheetKiller")
	killerchoose:Dock(FILL)

	local killerchoose_sheet = sheet:AddSheet( GM.LANG:GetString("hub_killerchoose"), killerchoose, "icon16/vcard_edit.png" )
	killerchoose_sheet.Button:DockMargin(0, 30, 0, 0)
	killerchoose_sheet.Button.Paint = function( _, w, h ) draw.RoundedBox( 16, 0, 0, w, h, color_killer ) end
	killerchoose_sheet.Button:SetSize(60, 60)
	killerchoose_sheet.Button:SetContentAlignment(5)
	killerchoose_sheet.Button:SetFontInternal("Roboto F4")

	--[[local settings = sheet:Add("slsHubSettings")
	settings:Dock(FILL)
	local settings_sheet = sheet:AddSheet( GM.LANG:GetString("hub_settings"), settings, "icon16/vcard_edit.png" )

	settings_sheet.Button:DockMargin(0, 30, 0, 0)
	settings_sheet.Button.Paint = function( _, w, h ) draw.RoundedBox( 16, 0, 0, w, h, color_black ) end
	settings_sheet.Button:SetSize(60, 60)
	settings_sheet.Button:SetContentAlignment(5)
	settings_sheet.Button:SetFontInternal("Roboto F4")]]

	survshow_sheet.Button.DoClick = function()
		local btn = survshow_sheet.Button
		btn:AlphaTo(125, 0.6)
		killerchoose_sheet.Button:AlphaTo(255, 0.2)
		--settings_sheet.Button:AlphaTo(255, 0.2)
		--descriptionpanel_sheet.Button:AlphaTo(255, 0.2)
		--modelpanel_sheet.Button:AlphaTo(255, 0.2)
		sheet:SetActiveButton(survshow_sheet.Button)
		surface.PlaySound("ui/buttonclick.wav")
		self.RightPanel:Show()
	end

	killerchoose_sheet.Button.DoClick = function()
		local btn = killerchoose_sheet.Button
		survshow_sheet.Button:AlphaTo(255, 0.2)
		--settings_sheet.Button:AlphaTo(255, 0.2)
		--descriptionpanel_sheet.Button:AlphaTo(255, 0.2)
		--modelpanel_sheet.Button:AlphaTo(255, 0.2)
		btn:AlphaTo(125, 0.6)
		sheet:SetActiveButton(killerchoose_sheet.Button)
		surface.PlaySound("ui/buttonclick.wav")
		self.RightPanel:Show()
	end

	--[[settings_sheet.Button.DoClick = function()
		local btn = settings_sheet.Button
		survshow_sheet.Button:AlphaTo(255, 0.2)
		killerchoose_sheet.Button:AlphaTo(255, 0.2)
		--descriptionpanel_sheet.Button:AlphaTo(255, 0.2)
		--modelpanel_sheet.Button:AlphaTo(255, 0.2)
		btn:AlphaTo(125, 0.6)
		sheet:SetActiveButton(settings_sheet.Button)
		surface.PlaySound("ui/buttonclick.wav")
		self.RightPanel:Hide()
	end]]

	for num, survivor in ipairs(GM.CLASS.Survivors) do
		local List2 = survshow.Scroll.Layout

		local DermaImageButton2 = List2:Add( "DImageButton" )
		local survnameimage = DermaImageButton2:Add("DLabel")

		survnameimage:SetFont("Roboto F4")
		survnameimage:SetText(survivor["dispname"])
		survnameimage:SetTextColor(color_gray)
		survnameimage:Dock(BOTTOM)
		survnameimage:SetWrap(true)
		survnameimage:SetAutoStretchVertical( true )
		survnameimage:SizeToContents()

		DermaImageButton2:SetMaterial(survivor["icon"])
		DermaImageButton2:SetSize(114, 114)
		DermaImageButton2.DoClick = function()
			if ULib and LocalPlayer():query("sls_setsurv") and GM.ROUND.Active then
				local Menu = DermaMenu()

				local equip = Menu:AddOption( GM.LANG:GetString("hub_equip"), function()
					surface.PlaySound("ui/buttonclickrelease.wav")

					net.Start("sls_survivor_choose_admin")
					net.WriteInt(num, 6)
					net.SendToServer()
				end)
				equip:SetIcon( "icon16/accept.png" )

				local inspect = Menu:AddOption(GM.LANG:GetString("hub_inspect"), function()
					surface.PlaySound("ui/buttonclickrelease.wav")

					if (string.find(GM.LANG:GetString(survivor["description"]), "Unknow")) then
						description:SetText(survivor["description"])
					else
						description:SetText(GM.LANG:GetString(survivor["description"]))
					end

					description:AppendText("\n" .. GM.LANG:GetString("hub_stats_health", survivor["life"]) .. "\n" .. GM.LANG:GetString("hub_stats_walkspeed", survivor["walkspeed"]) .. "\n" .. GM.LANG:GetString("hub_stats_runspeed", survivor["runspeed"]) .. "\n" .. GM.LANG:GetString("hub_stats_stamina", survivor["stamina"]))

					modelpanel.Model:SetModel(survivor["model"] )
				end)
				inspect:SetIcon( "icon16/magnifier_zoom_in.png" )

				Menu:Open()
				return
			end

			surface.PlaySound("ui/buttonclickrelease.wav")

			if (string.find(GM.LANG:GetString(survivor["description"]), "Unknow")) then
				description:SetText(survivor["description"])
			else
				description:SetText(GM.LANG:GetString(survivor["description"]))
			end

			description:AppendText("\n" .. GM.LANG:GetString("hub_stats_health", survivor["life"]) .. "\n" .. GM.LANG:GetString("hub_stats_walkspeed", survivor["walkspeed"]) .. "\n" .. GM.LANG:GetString("hub_stats_runspeed", survivor["runspeed"]) .. "\n" .. GM.LANG:GetString("hub_stats_stamina", survivor["stamina"]))

			modelpanel.Model:SetModel(survivor["model"] )
		end
	end

	local List = killerchoose.Scroll.Layout

	local sls_killer_random_button = List:Add( "DImageButton" )

	local sls_killer_random_button_name = sls_killer_random_button:Add("DLabel")
	sls_killer_random_button_name:Dock(BOTTOM)
	sls_killer_random_button_name:SetText(GM.LANG:GetString("hub_killer_random"))
	sls_killer_random_button_name:SetFont("Roboto F4")
	sls_killer_random_button_name:SetTextColor(color_gray)
	sls_killer_random_button_name:SizeToContents()
	sls_killer_random_button_name:SetWrap(true)
	sls_killer_random_button_name:SetAutoStretchVertical( true )

	sls_killer_random_button:SetImage("icons/no_icon_red.png")
	sls_killer_random_button:SetSize(114, 114)
	sls_killer_random_button.DoClick = function()
		surface.PlaySound("ui/buttonclickrelease.wav")

		net.Start("sls_hub_choosekiller")
		net.WriteInt(0, 6)
		net.SendToServer()
	end

		--if (GM.MAP.KILLERS[game.GetMap()]) then
	for k, killer in ipairs(GM.KILLERS) do --pairs(GM.MAP.KILLERS[game.GetMap()]) do
		local name = killer.Name
		local desc = killer.Desc
		local model = killer.Model
		local icon = killer.Icon

		if GetConVar("slashers_unserious_killers"):GetInt() == 0 and killer.Joke then continue end
		if GetConVar("slashers_unserious_killers"):GetInt() == 1 and killer.Serious then continue end

		local DermaImageButton = List:Add( "DImageButton" )
		local killername = DermaImageButton:Add("DLabel")
		killername:Dock(BOTTOM)
		killername:SetFont("Roboto F4")
		killername:SetText(name)
		killername:SetTextColor(color_gray)
		killername:SizeToContents()
		killername:SetWrap(true)
		killername:SetAutoStretchVertical( true )
		DermaImageButton:SetMaterial(icon)
		DermaImageButton:SetSize(114, 114)

		if sls_ply_choosen_killer_model and sls_ply_choosen_killer_description and sls_ply_choosen_killer_stats then
			description:SetText(sls_ply_choosen_killer_description)
			description:AppendText(sls_ply_choosen_killer_stats)

			modelpanel.Model:SetModel(sls_ply_choosen_killer_model)
		end

		if killer.SpecialRound and killer.SpecialRound == "GM.MAP.Pages" and !GM.MAP.Pages then DermaImageButton:SetEnabled(false) end
		if killer.SpecialRound and killer.SpecialRound == "GM.MAP.Vaccine" and !GM.MAP.Vaccine then DermaImageButton:SetEnabled(false) end

		DermaImageButton.DoClick = function()
			local Menu = DermaMenu()

			local equip = Menu:AddOption( GM.LANG:GetString("hub_equip"), function()
				surface.PlaySound("ui/buttonclickrelease.wav")
				net.Start("sls_hub_choosekiller")
				net.WriteInt(k, 6)
				net.SendToServer()

				if (string.find(GM.LANG:GetString(desc), "Unknow")) then
					description:SetText(desc)
					sls_ply_choosen_killer_description = desc
				else
					description:SetText(GM.LANG:GetString(desc))
					sls_ply_choosen_killer_description = GM.LANG:GetString(desc)
				end

				description:AppendText("\n" .. GM.LANG:GetString("hub_stats_runspeed", killer.RunSpeed) .. "\n" .. GM.LANG:GetString("hub_stats_walkspeed", killer.WalkSpeed))

				modelpanel.Model:SetModel(model)

				sls_ply_choosen_killer_model = model
				sls_ply_choosen_killer_stats = "\n" .. GM.LANG:GetString("hub_stats_runspeed", killer.RunSpeed) .. "\n" .. GM.LANG:GetString("hub_stats_walkspeed", killer.WalkSpeed)

			end)
			equip:SetIcon( "icon16/accept.png" )

			local inspect = Menu:AddOption(GM.LANG:GetString("hub_inspect"), function()
				surface.PlaySound("ui/buttonclickrelease.wav")

				if (string.find(GM.LANG:GetString(desc), "Unknow")) then
					description:SetText(desc)
				else
					description:SetText(GM.LANG:GetString(desc))
				end

				description:AppendText("\n" .. GM.LANG:GetString("hub_stats_runspeed", killer.RunSpeed) .. "\n" .. GM.LANG:GetString("hub_stats_walkspeed", killer.WalkSpeed))

				modelpanel.Model:SetModel(model)

			end)
			inspect:SetIcon( "icon16/magnifier_zoom_in.png" )

			Menu:Open()

		end
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

vgui.Register("slsHubMain", PANEL, "EditablePanel")