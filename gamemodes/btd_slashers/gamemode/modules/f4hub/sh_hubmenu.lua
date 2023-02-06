local GM = GM or GAMEMODE

if CLIENT then

	surface.CreateFont( "Roboto F4", {
		font = "Roboto Bold", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 20,
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
		outline = false,
	} )

local sls_ply_choosen_killer_model
local sls_ply_choosen_killer_description
local sls_ply_choosen_killer_stats

function OpenHUBMENU()
	if IsValid(HUBMENU) then HUBMENU:Remove() return end
HUBMENU = vgui.Create( "DFrame" )
HUBMENU:SetSize( ScrW(), ScrH() )
HUBMENU:SetTitle("")
--HUBMENU:Center()
HUBMENU:SetPos(ScrW()/2, 0)
HUBMENU:MakePopup()
HUBMENU:SetDraggable(false)
HUBMENU:ShowCloseButton(false)
HUBMENU:MoveTo(0, 0, 1, 0, -1 )    
HUBMENU.Think = function(me)
	if input.IsKeyDown(KEY_ESCAPE) then
		return me:Remove()
	end
end
surface.PlaySound("ui/buttonrollover.wav")

function HUBMENU:Paint( w, h )
Derma_DrawBackgroundBlur(self)
end

local rightpanel = vgui.Create( "DPanel", HUBMENU )
rightpanel:Dock(RIGHT)
--rightpanel:DockMargin(75, 0, 75, 0)
rightpanel:SetSize(ScrW() * 0.25, ScrH() * 0.5)

rightpanel.Paint = function( self, w, h ) draw.RoundedBox( 16, 0, 0, w, h, Color( 52, 73, 94, 80 ) ) end

local sheet = vgui.Create( "DColumnSheet", HUBMENU )

sheet:Dock(FILL)

--sheet:SetSize(ScrW(), ScrH())

local hub_close = HUBMENU:Add("DImageButton")
hub_close:AlignRight(-30)
hub_close:SetImage( "icon16/cancel.png" )
hub_close:SetSize(ScrW() * 0.015, ScrH() * 0.024)
hub_close:SetKeepAspect(true)
hub_close.DoClick = function()
	surface.PlaySound("ui/buttonclickrelease.wav")
	HUBMENU:Remove()
end

sheet.Paint = function( self, w, h ) draw.RoundedBox( 16, 0, 0, w * 0.084, h * 0.25, Color( 52, 73, 94, 80 ) ) end

local survshow = vgui.Create( "DPanel", sheet )
survshow:Dock(FILL)
survshow.Paint = function( self, w, h ) draw.RoundedBox( 16, 0, 0, w, h, Color( 44, 62, 80, self:GetAlpha() ) ) end 
local survshow_sheet = sheet:AddSheet( GM.LANG:GetString("hub_survivorshow"), survshow, "icon16/vcard.png" )
survshow_sheet.Button:DockMargin(0, 0, 0, 0)
survshow_sheet.Button.Paint = function( self, w, h ) draw.RoundedBox( 16, 0, 0, w, h, Color( 22, 160, 133, 140 ) ) end
survshow_sheet.Button:SetSize(60, 60)
survshow_sheet.Button:SetContentAlignment(5)
survshow_sheet.Button:SetFontInternal("Roboto F4")
for _,v in ipairs(survshow_sheet.Button:GetChildren()) do
	v:Remove()
end
survshow_sheet.Button:SetAlpha(125)

local killerchoose = vgui.Create( "DPanel", sheet )
killerchoose:Dock(FILL)
killerchoose.Paint = function( self, w, h ) draw.RoundedBox( 16, 0, 0, w, h, Color( 44, 62, 80, self:GetAlpha() ) ) end 
local killerchoose_sheet = sheet:AddSheet( GM.LANG:GetString("hub_killerchoose"), killerchoose, "icon16/vcard_edit.png" )
killerchoose_sheet.Button:DockMargin(0, 30, 0, 0)
killerchoose_sheet.Button.Paint = function( self, w, h ) draw.RoundedBox( 16, 0, 0, w, h, Color( 0, 0, 0, 140 ) ) end
killerchoose_sheet.Button:SetSize(60, 60)
killerchoose_sheet.Button:SetContentAlignment(5)
killerchoose_sheet.Button:SetFontInternal("Roboto F4")
for _,v in ipairs(killerchoose_sheet.Button:GetChildren()) do
	v:Remove()
end

local settings = vgui.Create( "DPanel", sheet )
settings:Dock(FILL)
settings:DockMargin(250, 0, 250, 0)
settings:DockPadding(25, 10, 25, 10)
settings.Paint = function( self, w, h ) draw.RoundedBox( 16, 0, 0, w, h, Color( 44, 62, 80, self:GetAlpha() ) ) end 
local settings_sheet = sheet:AddSheet( GM.LANG:GetString("hub_settings"), settings, "icon16/vcard_edit.png" )
settings_sheet.Button:DockMargin(0, 30, 0, 0)
settings_sheet.Button.Paint = function( self, w, h ) draw.RoundedBox( 16, 0, 0, w, h, Color( 0, 0, 0) ) end 
settings_sheet.Button:SetSize(60, 60)
settings_sheet.Button:SetContentAlignment(5)
settings_sheet.Button:SetFontInternal("Roboto F4")
for _,v in ipairs(settings_sheet.Button:GetChildren()) do
	v:Remove()
end

local settings_properties = vgui.Create( "DPropertySheet", settings )
settings_properties:Dock( FILL )
settings_properties.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 145) ) end 

local main_settings = vgui.Create( "DPanel", sheet )
main_settings:DockPadding(150, 350, 150, 10)
main_settings.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 61, 0, 117, 145) ) end 
settings_properties:AddSheet( GM.LANG:GetString("hub_settings_main"), main_settings, "icon16/wrench.png" )

local settings_w,settings_h = main_settings:GetSize()

local Discord = main_settings:Add("DButton")
Discord:SetText( "Discord" )
Discord:Dock(TOP)
Discord:DockMargin(0, 0, 0, 5)
Discord:SetSize(ScrW() * 0.10, ScrH() * 0.05)
Discord:SetFontInternal("Roboto F4")
Discord.DoClick = function()
	surface.PlaySound("UI/buttonclickrelease.wav")
	gui.OpenURL("https://discord.gg/MRs5zBXq9z")
end

local Workshop = main_settings:Add("DButton")
Workshop:SetText( "Workshop" )
Workshop:Dock(TOP)
Workshop:DockMargin(0, 0, 0, 5)
Workshop:SetSize(ScrW() * 0.10, ScrH() * 0.05)
Workshop:SetFontInternal("Roboto F4")
Workshop.DoClick = function()
	surface.PlaySound("UI/buttonclickrelease.wav")
	gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=2804558040")
end

local sls_killer_Checkbox = main_settings:Add( "DCheckBoxLabel" ) -- Create the checkbox
	--sls_killer_Checkbox:Dock(TOP)
	sls_killer_Checkbox:SetPos(settings_w / 0.27, settings_h * 40.50)
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
local Checkbox_w, Checkbox_h = sls_killer_Checkbox:GetChild(1):GetSize()
sls_killer_Checkbox.Paint = function( self, w, h ) draw.RoundedBox( 16, 0, 0, ScrW() * Checkbox_w * 1.16 / ScrW(), h, Color( 236, 240, 241, 80 ) ) end
sls_killer_Checkbox:SetIndent( 4 )
sls_killer_Checkbox:SetTextColor(Color(243, 156, 18, 255))
sls_killer_Checkbox:SizeToContents()						-- Make its size the same as the contents
local Checkbox_w2, Checkbox_h2 = sls_killer_Checkbox:GetSize()
sls_killer_Checkbox:SetSize(Checkbox_w2 + 12, Checkbox_h2)

local descriptionpanel = vgui.Create( "DPanel", rightpanel )
descriptionpanel:SetPos(0, 0)
--descriptionpanel:SetPos(0, 0)
descriptionpanel:SetSize(ScrW() * 0.25, ScrH() * 0.5)
descriptionpanel.Paint = function( self, w, h ) draw.RoundedBox( 16, 0, 0, w, h, Color( 44, 62, 80, self:GetAlpha() ) ) end 
--[[local descriptionpanel_sheet = sheet:AddSheet( GM.LANG:GetString("hub_description"), descriptionpanel, "icon16/page.png" )
descriptionpanel_sheet.Button.Paint = function( self, w, h ) draw.RoundedBox( 16, 0, 0, w, h, Color( 41, 128, 185, self:GetAlpha() ) ) end 
descriptionpanel_sheet.Button:SetSize(60, 60)
descriptionpanel_sheet.Button:SetContentAlignment(5)
descriptionpanel_sheet.Button:SetFontInternal("Roboto F4")
for _,v in ipairs(descriptionpanel_sheet.Button:GetChildren()) do
	v:Remove()
end]]--

local description = descriptionpanel:Add("RichText")
description:Dock( FILL )

function description:PerformLayout()
	self:SetFontInternal( "Roboto F4" )
	self:SetBGColor( Color( 0, 16, 32 ) )
end

local modelpanel = vgui.Create( "DPanel", rightpanel )
modelpanel:AlignBottom(-24)
modelpanel:SetSize(ScrW() * 0.25, ScrH() * 0.47)
modelpanel.Paint = function( self, w, h ) surface.SetDrawColor(Color( 4, 72, 139)) surface.DrawOutlinedRect( 0, 0, w, h, 7) end 
--[[local modelpanel_sheet = sheet:AddSheet( GM.LANG:GetString("hub_model"), modelpanel, "icon16/user_gray.png" )
modelpanel_sheet.Button.Paint = function( self, w, h ) draw.RoundedBox( 16, 0, 0, w, h, Color( 127, 140, 141, self:GetAlpha() ) ) end 
modelpanel_sheet.Button:SetSize(60, 60)
modelpanel_sheet.Button:SetContentAlignment(5)
modelpanel_sheet.Button:SetFontInternal("Roboto F4")
for _,v in ipairs(modelpanel_sheet.Button:GetChildren()) do
	v:Remove()
end]]--


survshow_sheet.Button.DoClick = function()
	local btn = survshow_sheet.Button
	btn:AlphaTo(125, 0.6)
	killerchoose_sheet.Button:AlphaTo(255, 0.2)
	settings_sheet.Button:AlphaTo(255, 0.2)
	--descriptionpanel_sheet.Button:AlphaTo(255, 0.2)
	--modelpanel_sheet.Button:AlphaTo(255, 0.2)
	sheet:SetActiveButton(survshow_sheet.Button)
	surface.PlaySound("ui/buttonclick.wav")
	rightpanel:Show()
end

killerchoose_sheet.Button.DoClick = function()
	local btn = killerchoose_sheet.Button
	survshow_sheet.Button:AlphaTo(255, 0.2)
	settings_sheet.Button:AlphaTo(255, 0.2)
	--descriptionpanel_sheet.Button:AlphaTo(255, 0.2)
	--modelpanel_sheet.Button:AlphaTo(255, 0.2)
	btn:AlphaTo(125, 0.6)
	sheet:SetActiveButton(killerchoose_sheet.Button)
	surface.PlaySound("ui/buttonclick.wav")
	rightpanel:Show()
end

settings_sheet.Button.DoClick = function()
	local btn = settings_sheet.Button
	survshow_sheet.Button:AlphaTo(255, 0.2)
	killerchoose_sheet.Button:AlphaTo(255, 0.2)
	--descriptionpanel_sheet.Button:AlphaTo(255, 0.2)
	--modelpanel_sheet.Button:AlphaTo(255, 0.2)
	btn:AlphaTo(125, 0.6)
	sheet:SetActiveButton(settings_sheet.Button)
	surface.PlaySound("ui/buttonclick.wav")
	rightpanel:Hide()
end

--[[descriptionpanel_sheet.Button.DoClick = function()
	local btn = descriptionpanel_sheet.Button
	btn:AlphaTo(125, 0.6)
	survshow_sheet.Button:AlphaTo(255, 0.2)
	killerchoose_sheet.Button:AlphaTo(255, 0.2)
	modelpanel_sheet.Button:AlphaTo(255, 0.2)
	sheet:SetActiveButton(descriptionpanel_sheet.Button)
	surface.PlaySound("ui/buttonclick.wav")
end]]--

--[[modelpanel_sheet.Button.DoClick = function()
	local btn = modelpanel_sheet.Button
	btn:AlphaTo(125, 0.6)
	survshow_sheet.Button:AlphaTo(255, 0.1)
	killerchoose_sheet.Button:AlphaTo(255, 0.1)
	descriptionpanel_sheet.Button:AlphaTo(255, 0.2)
	sheet:SetActiveButton(modelpanel_sheet.Button)
	surface.PlaySound("ui/buttonclick.wav")
end]]--

HUBMENUSSURVCROLL = vgui.Create("DScrollPanel", survshow)
HUBMENUSSURVCROLL:Dock( FILL )

local List2 = HUBMENUSSURVCROLL:Add( "DIconLayout" )
List2:Dock( FILL )
List2:SetSpaceY( 5 )
List2:SetSpaceX( 5 )

for num, survivor in ipairs(GM.CLASS.Survivors) do
local DermaImageButton2 = List2:Add( "DImageButton" )
local survnameimage = DermaImageButton2:Add("DLabel")
survnameimage:SetFont("Roboto F4")
survnameimage:SetText(survivor["dispname"])
survnameimage:SetTextColor(Color(255, 255, 255, 45))
survnameimage:Dock(BOTTOM)
survnameimage:SetWrap(true)
survnameimage:SetAutoStretchVertical( true )
survnameimage:SizeToContents()

DermaImageButton2:SetMaterial(survivor["icon"])
DermaImageButton2:SetSize(114, 114)
DermaImageButton2.DoClick = function()
	surface.PlaySound("ui/buttonclickrelease.wav")
	if istable(ULib) and LocalPlayer():query("sls_setsurv") and GM.ROUND.Active then
	net.Start("sls_survivor_choose_admin")
	net.WriteInt(num, 6)
	net.SendToServer()
	end
if (string.find(GM.LANG:GetString(survivor["description"]), "Unknow")) then
description:SetText(survivor["description"])
description:AppendText("\nHP = " .. survivor["life"] .. "\n" .. "Walk Speed = " .. survivor["walkspeed"] .. "\n" .. "Run Speed = " .. survivor["runspeed"] .. "\n" .. "Stamina = " .. survivor["stamina"])
else
description:SetText(GM.LANG:GetString(survivor["description"]))
description:AppendText("\nHP = " .. survivor["life"] .. "\n" .. "Walk Speed = " .. survivor["walkspeed"] .. "\n" .. "Run Speed = " .. survivor["runspeed"] .. "\n" .. "Stamina = " .. survivor["stamina"])
end
if IsValid(sls_playermodel) then sls_playermodel:Remove() end
sls_playermodel = modelpanel:Add( "DModelPanel" )
sls_playermodel:Dock(FILL)
sls_playermodel:DockMargin(0, 0, 0, 9)
function sls_playermodel:LayoutEntity( Entity ) return end -- disables default rotation

--[[local clickonme_mdl = sls_playermodel:Add("DLabel")
clickonme_mdl:Dock(TOP)
clickonme_mdl:SetFont("GModNotify")
clickonme_mdl:SetText("Click to show model")
clickonme_mdl:SetTextColor(Color(255, 200, 0, 50))
clickonme_mdl:SetContentAlignment(8)
clickonme_mdl:SizeToContents()]]--

sls_playermodel:SetModel(survivor["model"] )

local headpos = sls_playermodel.Entity:GetBonePosition(sls_playermodel.Entity:LookupBone("ValveBiped.Bip01_Head1"))
sls_playermodel:SetLookAt(headpos)

sls_playermodel:SetCamPos(headpos-Vector(-35, 0, 0))	-- Move cam in front of face

sls_playermodel.Entity:SetEyeTarget(headpos-Vector(-35, 0, 0))
end
end

HUBMENUSCROLL = vgui.Create("DScrollPanel", killerchoose)
HUBMENUSCROLL:Dock( FILL )

local List = HUBMENUSCROLL:Add( "DIconLayout" )
List:Dock( FILL )
List:SetSpaceY( 5 )
List:SetSpaceX( 5 )

local sls_killer_random_button = List:Add( "DImageButton" )
local sls_killer_random_button_name = sls_killer_random_button:Add("DLabel")
sls_killer_random_button_name:Dock(BOTTOM)
sls_killer_random_button_name:SetText(GM.LANG:GetString("hub_killer_random"))
sls_killer_random_button_name:SetFont("Roboto F4")
sls_killer_random_button_name:SetTextColor(Color(255, 255, 255, 45))
sls_killer_random_button_name:SizeToContents()
sls_killer_random_button_name:SetWrap(true)
sls_killer_random_button_name:SetAutoStretchVertical( true )
sls_killer_random_button:SetImage("icons/no_icon_red.png")
sls_killer_random_button:SetSize(114, 114)
sls_killer_random_button.DoClick = function()
	surface.PlaySound("ui/buttonclickrelease.wav")
	local rnd_killer
	for number, killer in RandomPairs(GM.KILLERS) do
		if (killer.SpecialRound) then
			if killer.SpecialRound == "GM.MAP.Pages" and !(GM.MAP.Pages) then continue end
			if killer.SpecialRound == "GM.MAP.Vaccine" and !(GM.MAP.Vaccine) then continue end
		end
		if (killer.Joke) and GetConVar("slashers_unserious_killers"):GetInt() == 0 and killer.Joke == true then continue end
		rnd_killer = number
		net.Start("sls_hub_choosekiller")
		net.WriteInt(rnd_killer, 6)
		net.SendToServer()
	if (string.find(GM.LANG:GetString(killer.Desc), "Unknow")) then
		description:SetText(killer.Desc)
		description:AppendText("\nRun Speed = " .. killer.RunSpeed .. "\n" .. "Walk Speed = " .. killer.WalkSpeed)
		sls_ply_choosen_killer_description = killer.Desc
		sls_ply_choosen_killer_stats = "\nRun Speed = " .. killer.RunSpeed .. "\n" .. "Walk Speed = " .. killer.WalkSpeed
		else
		description:SetText(GM.LANG:GetString(killer.Desc))
		description:AppendText( "\nRun Speed = " .. killer.RunSpeed .. "\n" .. "Walk Speed = " .. killer.WalkSpeed)
		sls_ply_choosen_killer_description = GM.LANG:GetString(killer.Desc)
		sls_ply_choosen_killer_stats = "\nRun Speed = " .. killer.RunSpeed .. "\n" .. "Walk Speed = " .. killer.WalkSpeed
		end
		if IsValid(sls_playermodel) then sls_playermodel:Remove() end
		sls_playermodel = modelpanel:Add( "DModelPanel" )
--[[		local clickonme_mdl = sls_playermodel:Add("DLabel")
		clickonme_mdl:Dock(TOP)
		clickonme_mdl:SetFont("GModNotify")
		clickonme_mdl:SetText("Click to show model")
		clickonme_mdl:SetTextColor(Color(255, 200, 0, 50))
		clickonme_mdl:SetContentAlignment(8)
		clickonme_mdl:SizeToContents()]]--
		sls_playermodel:Dock(FILL)
sls_playermodel:DockMargin(0, 0, 0, 9)
		function sls_playermodel:LayoutEntity( Entity ) return end -- disables default rotation
		sls_playermodel:SetModel(killer.Model)
		
		if (sls_playermodel.Entity:LookupBone("ValveBiped.Bip01_Head1")) then
		local headpos = sls_playermodel.Entity:GetBonePosition(sls_playermodel.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		sls_playermodel:SetLookAt(headpos)
		
		sls_playermodel:SetCamPos(headpos-Vector(-35, 0, 0))	-- Move cam in front of face

		sls_playermodel.Entity:SetEyeTarget(headpos-Vector(-35, 0, 0))
		end
		
		sls_ply_choosen_killer_model = killer.Model
	end
end

--if (GM.MAP.KILLERS[game.GetMap()]) then
for k, killer in ipairs(GM.KILLERS) do --pairs(GM.MAP.KILLERS[game.GetMap()]) do
	if (killer.SpecialRound) then
		if killer.SpecialRound == "GM.MAP.Pages" and !(GM.MAP.Pages) then continue end
		if killer.SpecialRound == "GM.MAP.Vaccine" and !(GM.MAP.Vaccine) then continue end
	end

local DermaImageButton = List:Add( "DImageButton" )
local killername = DermaImageButton:Add("DLabel")
killername:Dock(BOTTOM)
killername:SetFont("Roboto F4")
killername:SetText(killer.Name)
killername:SetTextColor(Color(255, 255, 255, 45))
killername:SizeToContents()
killername:SetWrap(true)
killername:SetAutoStretchVertical( true )
DermaImageButton:SetMaterial(killer.Icon)
DermaImageButton:SetSize(114, 114)

if (sls_ply_choosen_killer_model) and (sls_ply_choosen_killer_description) and (sls_ply_choosen_killer_stats) then
description:SetText(sls_ply_choosen_killer_description)
description:AppendText(sls_ply_choosen_killer_stats)
if IsValid(sls_playermodel) then sls_playermodel:Remove() end
sls_playermodel = modelpanel:Add( "DModelPanel" )
sls_playermodel:Dock(FILL)
sls_playermodel:DockMargin(0, 0, 0, 9)
function sls_playermodel:LayoutEntity( Entity ) return end -- disables default rotation
sls_playermodel:SetModel(sls_ply_choosen_killer_model)

if (sls_playermodel.Entity:LookupBone("ValveBiped.Bip01_Head1")) then
local headpos = sls_playermodel.Entity:GetBonePosition(sls_playermodel.Entity:LookupBone("ValveBiped.Bip01_Head1"))
sls_playermodel:SetLookAt(headpos)

sls_playermodel:SetCamPos(headpos-Vector(-35, 0, 0))	-- Move cam in front of face

sls_playermodel.Entity:SetEyeTarget(headpos-Vector(-35, 0, 0))
end

--[[local clickonme_mdl = sls_playermodel:Add("DLabel")
clickonme_mdl:Dock(TOP)
clickonme_mdl:SetFont("GModNotify")
clickonme_mdl:SetText("Click to show model")
clickonme_mdl:SetTextColor(Color(255, 200, 0, 50))
clickonme_mdl:SetContentAlignment(8)
clickonme_mdl:SizeToContents()]]--
end

DermaImageButton.DoClick = function()
	surface.PlaySound("ui/buttonclickrelease.wav")
net.Start("sls_hub_choosekiller")
net.WriteInt(k, 6)
net.SendToServer()
if (string.find(GM.LANG:GetString(killer.Desc), "Unknow")) then
description:SetText(killer.Desc)
description:AppendText("\nRun Speed = " .. killer.RunSpeed .. "\n" .. "Walk Speed = " .. killer.WalkSpeed)
sls_ply_choosen_killer_description = killer.Desc
sls_ply_choosen_killer_stats = "\nRun Speed = " .. killer.RunSpeed .. "\n" .. "Walk Speed = " .. killer.WalkSpeed
else
description:SetText(GM.LANG:GetString(killer.Desc))
description:AppendText("\nRun Speed = " .. killer.RunSpeed .. "\n" .. "Walk Speed = " .. killer.WalkSpeed)
sls_ply_choosen_killer_description = GM.LANG:GetString(killer.Desc)
sls_ply_choosen_killer_stats = "\nRun Speed = " .. killer.RunSpeed .. "\n" .. "Walk Speed = " .. killer.WalkSpeed
end
if IsValid(sls_playermodel) then sls_playermodel:Remove() end
sls_playermodel = modelpanel:Add( "DModelPanel" )
--[[local clickonme_mdl = sls_playermodel:Add("DLabel")
clickonme_mdl:Dock(TOP)
clickonme_mdl:SetFont("GModNotify")
clickonme_mdl:SetText("Click to show model")
clickonme_mdl:SetTextColor(Color(255, 200, 0, 50))
clickonme_mdl:SetContentAlignment(8)
clickonme_mdl:SizeToContents()]]--
sls_playermodel:Dock(FILL)
sls_playermodel:DockMargin(0, 0, 0, 9)
sls_playermodel:DockMargin(0, 0, 0, 9)
function sls_playermodel:LayoutEntity( Entity ) return end -- disables default rotation
sls_playermodel:SetModel(killer.Model)

if (sls_playermodel.Entity:LookupBone("ValveBiped.Bip01_Head1")) then
local headpos = sls_playermodel.Entity:GetBonePosition(sls_playermodel.Entity:LookupBone("ValveBiped.Bip01_Head1"))
sls_playermodel:SetLookAt(headpos)

sls_playermodel:SetCamPos(headpos-Vector(-35, 0, 0))	-- Move cam in front of face

sls_playermodel.Entity:SetEyeTarget(headpos-Vector(-35, 0, 0))
end

sls_ply_choosen_killer_model = killer.Model
end
end
end
end
net.Receive("sls_OpenHUB", OpenHUBMENU)

--end

if SERVER then
util.AddNetworkString("sls_OpenHUB")
util.AddNetworkString("sls_hub_choosekiller")
util.AddNetworkString("sls_killer_choose_nw")
util.AddNetworkString("sls_survivor_choose_admin")

hook.Add("ShowSpare2", "sls_hub_ShowSpare2", function(ply)
net.Start("sls_OpenHUB")
net.Send(ply)
end)

net.Receive("sls_hub_choosekiller", function(len, ply)
	ply:SetNWInt("choosen_killer", net.ReadInt(6))
end)

net.Receive("sls_survivor_choose_admin", function(len, ply)
	if istable(ULib) and ply:query("sls_setsurv") and GM.ROUND.Active then
	ply:SetSurvClass(net.ReadInt(6))
	end
end)

net.Receive("sls_killer_choose_nw", function(len, ply)
ply:SetNWBool("sls_killer_choose", net.ReadBool())
end)

end