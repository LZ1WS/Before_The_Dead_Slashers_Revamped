if CLIENT then
local GM = GM or GAMEMODE

--[[GM.MAP.KILLERS =
{
["slash_summercamp"] = {
		[1] = {
		["name"] = "Jason Voorhees",
		["icon"] = "icons/icon_jason.png",
		["description"] = "class_desc_jason",
		["model"] = "models/player/mkx_jason.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 210"
		},
		[2] = {
		["name"] = "KAMENSHIK",
		["icon"] = "icons/xleb.png",
		["description"] = "class_desc_kamen",
		["model"] = "models/player/kamenshik.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 240"
		},
		[3] = {
		["name"] = "Huntress",
		["icon"] = "icons/huntress.png",
		["description"] = "class_desc_huntress",
		["model"] = "models/players/mj_dbd_bear.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 240",
		},
		[4] = {
		["name"] = "Slenderman",
		["icon"] = "icons/slenderman.png",
		["description"] = "class_desc_slender",
		["model"] = "models/player/lordvipes/slenderman/slenderman_playermodel_cvp.mdl",
		["stats"] = "\nWalk Speed = 120\nRun Speed = 160",
		["map"] = "slash_summercamp",
		},
	},
["slash_subway"] = {
		[1] = {
		["name"] = "the Proxy",
		["icon"] = "icons/icon_proxy.png",
		["description"] = "class_desc_proxy",
		["model"] = "models/slender_arrival/chaser.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		},
		[2] = {
		["name"] = "Springtrap",
		["icon"] = "icons/springtrap.png",
		["description"] = "class_desc_wip",
		["model"] = "models/player/Maximo/springtrap1.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		},
		[3] = {
		["name"] = "Albert Wesker",
		["icon"] = "icons/wesker.png",
		["description"] = "class_desc_wesker",
		["model"] = "Models/Player/slow/amberlyn/re5/wesker/slow.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		["map"] = "slash_subway",
		},
		[4] = {
		["name"] = "Scrake",
		["icon"] = "icons/no_icon_red.png",
		["description"] = "class_desc_scrake",
		["model"] = "models/Splinks/KF2/zeds/Player_Scrake.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		},
		[5] = {
		["name"] = "T-800",
		["icon"] = "icons/t800.png",
		["description"] = "class_desc_t800",
		["model"] = "models/player/t-800/t800nw.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		},
	},
["slash_highschool"] = {
		[1] = {
		["name"] = "Ghostface",
		["icon"] = "icons/icon_ghostface.png",
		["description"] = "class_desc_ghostface",
		["model"] = "models/player/dbd/oman_killer.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 240",
		},
		[2] = {
		["name"] = "Cloaker",
		["icon"] = "icons/cloaker.png",
		["description"] = "class_desc_cloaker",
		["model"] = "models/mark2580/payday2/pd2_cloaker_zeal_player.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 240",
		},
		[3] = {
		["name"] = "Specimen 8",
		["icon"] = "icons/spec8.png",
		["description"] = "class_desc_specimen8",
		["model"] = "models/violetqueen/sjsm/deerlord.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 190",
		},
		[4] = {
		["name"] = "Tirsiak",
		["icon"] = "icons/tirsiak.png",
		["description"] = "class_desc_uspecimen4",
		["model"] = "models/Lucifer/helltaker/rstar/Lucifer/Lucifer.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 210",
		},
		[5] = {
		["name"] = "Leo Kasper",
		["icon"] = "icons/kasper.png",
		["description"] = "class_desc_kasper",
		["model"] = "models/svotnik/Leo_Kasper/Leo_Kasper_PM.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 210",
		},
		[6] = {
		["name"] = "Metallyst",
		["icon"] = "icons/metalworker.png",
		["description"] = "class_desc_metallyst",
		["model"] = "models/materials/humans/group03m/male_08.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 210",
		},
	},
["slash_lodge"] = {
		[1] = {
		["name"] = "the Intruder",
		["icon"] = "icons/icon_intruder.png",
		["description"] = "class_desc_intruder",
		["model"] = "models/steinman/slashers/intruder_pm.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		},
		[2] = {
		["name"] = "AMOGUS",
		["icon"] = "icons/amogus.png",
		["description"] = "NONONONONO! GET OUT OF MY HEAD!",
		["model"] = "models/josephthekp/amongdrip.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		},
		[3] = {
		["name"] = "White Face",
		["icon"] = "icons/whiteface.png",
		["description"] = "class_desc_whiteface",
		["model"] = "models/imscared/whiteface.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200\nRage Walk/Run Speed = 300",
		},
	},
["slash_motel"] = {
		[1] = {
		["name"] = "Norman Bates",
		["icon"] = "icons/icon_bates.png",
		["description"] = "class_desc_bates",
		["model"] = "models/steinman/slashers/bates_pm.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		},
		[2] = {
		["name"] = "Tadero the Necromancer",
		["icon"] = "icons/tadero.png",
		["description"] = "class_desc_tadero",
		["model"] = "models/players/an_cc_necromancer.mdl",
		["stats"] = "\nWalk Speed = 160\nRun Speed = 160",
		},
		[3] = {
		["name"] = "SCP-049",
		["icon"] = "icons/scp049.png",
		["description"] = "class_desc_scp049",
		["model"] = "models/lolozaure/scp49.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		},
	},
}]]--

GM.MAP.KILLERS =
{
		[1] = {
		["name"] = "Jason Voorhees",
		["icon"] = "icons/icon_jason.png",
		["description"] = "class_desc_jason",
		["model"] = "models/player/mkx_jason.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 210"
		},
		[2] = {
		["name"] = "KAMENSHIK",
		["icon"] = "icons/xleb.png",
		["description"] = "class_desc_kamen",
		["model"] = "models/player/kamenshik.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 240",
		["joke"] = true
		},
		[3] = {
		["name"] = "Huntress",
		["icon"] = "icons/huntress.png",
		["description"] = "class_desc_huntress",
		["model"] = "models/players/mj_dbd_bear.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 240",
		},
		[4] = {
		["name"] = "Slenderman",
		["icon"] = "icons/slenderman.png",
		["description"] = "class_desc_slender",
		["model"] = "models/player/lordvipes/slenderman/slenderman_playermodel_cvp.mdl",
		["stats"] = "\nWalk Speed = 120\nRun Speed = 160",
		["map"] = "slash_summercamp",
		},
		[5] = {
		["name"] = "Michael Myers",
		["icon"] = "icons/icon_myers.png",
		["description"] = "class_desc_myers",
		["model"] = "models/player/dewobedil/mike_myers/default_p.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		},
		[6] = {
		["name"] = "the Proxy",
		["icon"] = "icons/icon_proxy.png",
		["description"] = "class_desc_proxy",
		["model"] = "models/slender_arrival/chaser.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		},
		[7] = {
		["name"] = "the Machine",
		["icon"] = "icons/springtrap.png",
		["description"] = "class_desc_springtrap",
		["model"] = "models/tetTris/FNaF/SB/Burntrap_inkmanspm.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		},
		[8] = {
		["name"] = "Albert Wesker",
		["icon"] = "icons/wesker.png",
		["description"] = "class_desc_wesker",
		["model"] = "Models/Player/slow/amberlyn/re5/wesker/slow.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		["map"] = "slash_subway",
		},
		[9] = {
		["name"] = "Scrake",
		["icon"] = "icons/scrake.png",
		["description"] = "class_desc_scrake",
		["model"] = "models/Splinks/KF2/zeds/Player_Scrake.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		},
		[10] = {
		["name"] = "T-800",
		["icon"] = "icons/t800.png",
		["description"] = "class_desc_t800",
		["model"] = "models/player/t-800/t800nw.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		},
		[11] = {
		["name"] = "Ghostface",
		["icon"] = "icons/icon_ghostface.png",
		["description"] = "class_desc_ghostface",
		["model"] = "models/player/dbd/oman_killer.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 240",
		},
		[12] = {
		["name"] = "Cloaker",
		["icon"] = "icons/cloaker.png",
		["description"] = "class_desc_cloaker",
		["model"] = "models/mark2580/payday2/pd2_cloaker_zeal_player.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 240",
		["joke"] = true
		},
		[13] = {
		["name"] = "Specimen 8",
		["icon"] = "icons/spec8.png",
		["description"] = "class_desc_specimen8",
		["model"] = "models/violetqueen/sjsm/deerlord.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 190",
		},
		[14] = {
		["name"] = "Tirsiak",
		["icon"] = "icons/tirsiak.png",
		["description"] = "class_desc_uspecimen4",
		["model"] = "models/Lucifer/helltaker/rstar/Lucifer/Lucifer.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 210",
		},
		[15] = {
		["name"] = "Leo Kasper",
		["icon"] = "icons/kasper.png",
		["description"] = "class_desc_kasper",
		["model"] = "models/svotnik/Leo_Kasper/Leo_Kasper_PM.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 210",
		},
		[16] = {
		["name"] = "Metal Worker",
		["icon"] = "icons/metalworker.png",
		["description"] = "class_desc_metallyst",
		["model"] = "models/materials/humans/group03m/male_08.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 210",
		},
		[17] = {
		["name"] = "the Intruder",
		["icon"] = "icons/icon_intruder.png",
		["description"] = "class_desc_intruder",
		["model"] = "models/steinman/slashers/intruder_pm.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		},
		[18] = {
		["name"] = "the Impostor",
		["icon"] = "icons/amogus.png",
		["description"] = "class_desc_amogus",
		["model"] = "models/josephthekp/amongdrip.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		["joke"] = true
		},
		[19] = {
		["name"] = "White Face",
		["icon"] = "icons/whiteface.png",
		["description"] = "class_desc_whiteface",
		["model"] = "models/imscared/whiteface.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200\nRage Walk/Run Speed = 300",
		},
		[20] = {
		["name"] = "Norman Bates",
		["icon"] = "icons/icon_bates.png",
		["description"] = "class_desc_bates",
		["model"] = "models/steinman/slashers/bates_pm.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		},
		[21] = {
		["name"] = "Tadero the Necromancer",
		["icon"] = "icons/tadero.png",
		["description"] = "class_desc_tadero",
		["model"] = "models/players/an_cc_necromancer.mdl",
		["stats"] = "\nWalk Speed = 160\nRun Speed = 160",
		},
		[22] = {
		["name"] = "SCP-049",
		["icon"] = "icons/scp049.png",
		["description"] = "class_desc_scp049",
		["model"] = "models/lolozaure/scp49.mdl",
		["stats"] = "\nWalk Speed = 200\nRun Speed = 200",
		},
		[23] = {
		["name"] = "the Deerling",
		["icon"] = "icons/deerling.png",
		["description"] = "class_desc_deerling",
		["model"] = "models/bala/monsterboys_pm.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 240",
		},
		[24] = {
		["name"] = "Bacteria",
		["icon"] = "icons/bacteria.png",
		["description"] = "class_desc_bacteria",
		["model"] = "models/player/Bacteria.mdl",
		["stats"] = "\nWalk Speed = 190\nRun Speed = 220",
		},
}

GM.MAP.SURVIVORS = {
	["Trent"] = {
		["icon"] = "icons/icon_sportif.png",
		["description"] = "class_desc_sports",
		["model"] = "models/steinman/slashers/sport_pm.mdl",
		["stats"] = "\nHP = 120\nWalk Speed = 150\nRun Speed = 240\nStamina = 210",
	},
	["Lynda"] = {
		["icon"] = "icons/icon_popular.png",
		["description"] = "class_desc_popular",
		["model"] = "models/steinman/slashers/popular_pm.mdl",
		["stats"] = "\nHP = 80\nWalk Speed = 160\nRun Speed = 240\nStamina = 120",
	},
	["Noah"] = {
		["icon"] = "icons/icon_nerd.png",
		["description"] = "class_desc_nerd",
		["model"] = "models/steinman/slashers/nerd_pm.mdl",
		["stats"] = "\nHP = 100\nWalk Speed = 130\nRun Speed = 240\nStamina = 110",
	},
	["Franklin"] = {
		["icon"] = "icons/icon_fat.png",
		["description"] = "class_desc_fat",
		["model"] = "models/steinman/slashers/fat_pm.mdl",
		["stats"] = "\nHP = 180\nWalk Speed = 130\nRun Speed = 240\nStamina = 80",
	},
	["Sydney"] = {
		["icon"] = "icons/icon_shy.png",
		["description"] = "class_desc_shy",
		["model"] = "models/player/korka007/maxc.mdl",
		["stats"] = "\nHP = 60\nWalk Speed = 140\nRun Speed = 240\nStamina = 140",
	},
	["Audrey"] = {
		["icon"] = "icons/icon_emo.png",
		["description"] = "class_desc_emo",
		["model"] = "models/steinman/slashers/emo_pm.mdl",
		["stats"] = "\nHP = 110\nWalk Speed = 130\nRun Speed = 240\nStamina = 130",
	},
	["Roland"] = {
		["icon"] = "icons/icon_black.png",
		["description"] = "class_desc_black",
		["model"] = "models/player/spike/lamar.mdl",
		["stats"] = "\nHP = 120\nWalk Speed = 140\nRun Speed = 240\nStamina = 130",
	},
	["Gale"] = {
		["icon"] = "icons/icon_sherif.png",
		["description"] = "class_desc_sherif",
		["model"] = "models/steinman/slashers/sheriff_pm.mdl",
		["stats"] = "\nHP = 130\nWalk Speed = 150\nRun Speed = 240\nStamina = 140",
	},
	["Steve Harrington"] = {
		["icon"] = "icons/steve.png",
		["description"] = "class_desc_babysit",
		["model"] = "models/players/mj_dbd_qm.mdl",
		["stats"] = "\nHP = 120\nWalk Speed = 150\nRun Speed = 240\nStamina = 160",
	},
}

hook.Add( "InitPostEntity", "sls_share_killers_list", function()
	net.Start("sls_share_killers_list")
	net.WriteTable(GM.MAP.KILLERS)
	net.SendToServer()
	print("sls_share_killers_list")
hook.Remove("InitPostEntity", "sls_share_killers_list")
end )

local sls_ply_choosen_killer_model
local sls_ply_choosen_killer_description
local sls_ply_choosen_killer_stats

function OpenHUBMENU()
	if IsValid(HUBMENU) then return end --or !(GM.MAP.KILLERS[game.GetMap()]) then return end
HUBMENU = vgui.Create( "DFrame" )
HUBMENU:SetSize( ScrW(), ScrH() )
HUBMENU:SetTitle("")
HUBMENU:Center()
HUBMENU:MakePopup()

function HUBMENU:Paint( w, h )
draw.RoundedBox( 8, 0, 0, w, h, Color( 255, 255, 255 ) )
Derma_DrawBackgroundBlur(self)
end

local sheet = vgui.Create( "DPropertySheet", HUBMENU )
sheet:Dock( FILL )

local sls_killer_Checkbox = HUBMENU:Add( "DCheckBoxLabel" ) -- Create the checkbox
	sls_killer_Checkbox:Dock(TOP)
	sls_killer_Checkbox:SetText(GM.LANG:GetString("hub_killer_checkbox"))					-- Set the text next to the box
	sls_killer_Checkbox:SetFont("ChatFont")
	sls_killer_Checkbox:SetValue( LocalPlayer():GetNWBool("sls_killer_choose", true) )						-- Initial value
	sls_killer_Checkbox:SizeToContents()						-- Make its size the same as the contents
function sls_killer_Checkbox:OnChange( val )
		LocalPlayer():SetNWBool("sls_killer_choose", val)
		net.Start("sls_killer_choose_nw")
		net.WriteBool(val)
		net.SendToServer()
end

local survshow = vgui.Create( "DPanel", sheet )
survshow.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 128, 255, self:GetAlpha() ) ) end 
sheet:AddSheet( GM.LANG:GetString("hub_survivorshow"), survshow, "icon16/vcard.png" )

local killerchoose = vgui.Create( "DPanel", sheet )
killerchoose.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 128, 255, self:GetAlpha() ) ) end 
sheet:AddSheet( GM.LANG:GetString("hub_killerchoose"), killerchoose, "icon16/vcard_edit.png" )

local descriptionpanel = vgui.Create( "DPanel", sheet )
descriptionpanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 128, 255, self:GetAlpha() ) ) end 
sheet:AddSheet( GM.LANG:GetString("hub_description"), descriptionpanel, "icon16/page.png" )

local description = descriptionpanel:Add("RichText")
description:Dock( FILL )

function description:PerformLayout()
	self:SetFontInternal( "Trebuchet18" )
	self:SetBGColor( Color( 0, 16, 32 ) )
end

local modelpanel = vgui.Create( "DPanel", sheet )
modelpanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 128, 255, self:GetAlpha() ) ) end 
sheet:AddSheet( GM.LANG:GetString("hub_model"), modelpanel, "icon16/user_gray.png" )

HUBMENUSSURVCROLL = vgui.Create("DScrollPanel", survshow)
HUBMENUSSURVCROLL:Dock( FILL )

local List2 = HUBMENUSSURVCROLL:Add( "DIconLayout" )
List2:Dock( FILL )
List2:SetSpaceY( 5 )
List2:SetSpaceX( 5 )

for survname, survivor in pairs(GM.MAP.SURVIVORS) do
local DermaImageButton2 = List2:Add( "DImageButton" )
local survnameimage = DermaImageButton2:Add("DLabel")
survnameimage:Dock(TOP)
survnameimage:SetFont("ChatFont")
survnameimage:SetText(survname)
survnameimage:SetContentAlignment(8)
survnameimage:SizeToContents()
survnameimage:SetWrap(true)
survnameimage:SetAutoStretchVertical( true )

DermaImageButton2:SetImage(survivor["icon"])
DermaImageButton2:SetSize(116, 116)
DermaImageButton2.DoClick = function()
if (string.find(GM.LANG:GetString(survivor["description"]), "Unknow")) then
description:SetText(survivor["description"])
description:AppendText(survivor["stats"])
else
description:SetText(GM.LANG:GetString(survivor["description"]))
description:AppendText(survivor["stats"])
end
if IsValid(sls_playermodel) then sls_playermodel:Remove() end
sls_playermodel = modelpanel:Add( "DAdjustableModelPanel" )
sls_playermodel:Dock(FILL)
function sls_playermodel:LayoutEntity( Entity ) return end -- disables default rotation

local clickonme_mdl = sls_playermodel:Add("DLabel")
clickonme_mdl:Dock(TOP)
clickonme_mdl:SetFont("GModNotify")
clickonme_mdl:SetText("Click to show model")
clickonme_mdl:SetTextColor(Color(255, 200, 0))
clickonme_mdl:SetContentAlignment(8)
clickonme_mdl:SizeToContents()

sls_playermodel:SetModel(survivor["model"] )

local headpos = sls_playermodel.Entity:GetBonePosition(sls_playermodel.Entity:LookupBone("ValveBiped.Bip01_Head1"))
sls_playermodel:SetLookAt(headpos)

sls_playermodel:SetCamPos(headpos-Vector(-15, 0, 0))	-- Move cam in front of face

sls_playermodel.Entity:SetEyeTarget(headpos-Vector(-15, 0, 0))
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
sls_killer_random_button_name:Dock(TOP)
sls_killer_random_button_name:SetText(GM.LANG:GetString("hub_killer_random"))
sls_killer_random_button_name:SetFont("ChatFont")
sls_killer_random_button_name:SetContentAlignment(8)
sls_killer_random_button_name:SizeToContents()
sls_killer_random_button_name:SetWrap(true)
sls_killer_random_button_name:SetAutoStretchVertical( true )
sls_killer_random_button:SetImage("icons/no_icon_red.png")
sls_killer_random_button:SetSize(116, 116)
sls_killer_random_button.DoClick = function()
	local rnd_killer
	for number, killer in RandomPairs(GM.MAP.KILLERS) do
		if (killer.map) and killer.map != game.GetMap() then continue end
		if (killer.joke) and GetConVar("slashers_unserious_killers"):GetInt() == 0 and killer.joke == true then continue end
		rnd_killer = number
		net.Start("sls_hub_choosekiller")
		net.WriteInt(rnd_killer, 6)
		net.SendToServer()
	if (string.find(GM.LANG:GetString(killer["description"]), "Unknow")) then
		description:SetText(killer["description"])
		description:AppendText(killer["stats"])
		sls_ply_choosen_killer_description = killer["description"]
		sls_ply_choosen_killer_stats = killer["stats"]
		else
		description:SetText(GM.LANG:GetString(killer["description"]))
		description:AppendText(killer["stats"])
		sls_ply_choosen_killer_description = GM.LANG:GetString(killer["description"])
		sls_ply_choosen_killer_stats = killer["stats"]
		end
		if IsValid(sls_playermodel) then sls_playermodel:Remove() end
		sls_playermodel = modelpanel:Add( "DAdjustableModelPanel" )
		local clickonme_mdl = sls_playermodel:Add("DLabel")
		clickonme_mdl:Dock(TOP)
		clickonme_mdl:SetFont("GModNotify")
		clickonme_mdl:SetText("Click to show model")
		clickonme_mdl:SetTextColor(Color(255, 200, 0))
		clickonme_mdl:SetContentAlignment(8)
		clickonme_mdl:SizeToContents()
		sls_playermodel:Dock(FILL)
		function sls_playermodel:LayoutEntity( Entity ) return end -- disables default rotation
		sls_playermodel:SetModel(killer["model"])
		
		if (sls_playermodel.Entity:LookupBone("ValveBiped.Bip01_Head1")) then
		local headpos = sls_playermodel.Entity:GetBonePosition(sls_playermodel.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		sls_playermodel:SetLookAt(headpos)
		
		sls_playermodel:SetCamPos(headpos-Vector(-15, 0, 0))	-- Move cam in front of face
		
		sls_playermodel.Entity:SetEyeTarget(headpos-Vector(-15, 0, 0))
		end
		
		sls_ply_choosen_killer_model = killer["model"]
	end
end

--if (GM.MAP.KILLERS[game.GetMap()]) then
for k, killer in pairs(GM.MAP.KILLERS) do --pairs(GM.MAP.KILLERS[game.GetMap()]) do
	if (killer.map) and killer.map != game.GetMap() then continue end

local DermaImageButton = List:Add( "DImageButton" )
local killername = DermaImageButton:Add("DLabel")
killername:Dock(TOP)
killername:SetFont("ChatFont")
killername:SetContentAlignment(8)
killername:SetText(killer["name"])
killername:SizeToContents()
killername:SetWrap(true)
killername:SetAutoStretchVertical( true )
DermaImageButton:SetImage(killer["icon"])
DermaImageButton:SetSize(116, 116)

if (sls_ply_choosen_killer_model) and (sls_ply_choosen_killer_description) and (sls_ply_choosen_killer_stats) then
description:SetText(sls_ply_choosen_killer_description)
description:AppendText(sls_ply_choosen_killer_stats)
if IsValid(sls_playermodel) then sls_playermodel:Remove() end
sls_playermodel = modelpanel:Add( "DAdjustableModelPanel" )
sls_playermodel:Dock(FILL)
function sls_playermodel:LayoutEntity( Entity ) return end -- disables default rotation
sls_playermodel:SetModel(sls_ply_choosen_killer_model)

if (sls_playermodel.Entity:LookupBone("ValveBiped.Bip01_Head1")) then
local headpos = sls_playermodel.Entity:GetBonePosition(sls_playermodel.Entity:LookupBone("ValveBiped.Bip01_Head1"))
sls_playermodel:SetLookAt(headpos)

sls_playermodel:SetCamPos(headpos-Vector(-15, 0, 0))	-- Move cam in front of face

sls_playermodel.Entity:SetEyeTarget(headpos-Vector(-15, 0, 0))
end

local clickonme_mdl = sls_playermodel:Add("DLabel")
clickonme_mdl:Dock(TOP)
clickonme_mdl:SetFont("GModNotify")
clickonme_mdl:SetText("Click to show model")
clickonme_mdl:SetTextColor(Color(255, 200, 0))
clickonme_mdl:SetContentAlignment(8)
clickonme_mdl:SizeToContents()
end

DermaImageButton.DoClick = function()
net.Start("sls_hub_choosekiller")
net.WriteInt(k, 6)
net.SendToServer()
if (string.find(GM.LANG:GetString(killer["description"]), "Unknow")) then
description:SetText(killer["description"])
description:AppendText(killer["stats"])
sls_ply_choosen_killer_description = killer["description"]
sls_ply_choosen_killer_stats = killer["stats"]
else
description:SetText(GM.LANG:GetString(killer["description"]))
description:AppendText(killer["stats"])
sls_ply_choosen_killer_description = GM.LANG:GetString(killer["description"])
sls_ply_choosen_killer_stats = killer["stats"]
end
if IsValid(sls_playermodel) then sls_playermodel:Remove() end
sls_playermodel = modelpanel:Add( "DAdjustableModelPanel" )
local clickonme_mdl = sls_playermodel:Add("DLabel")
clickonme_mdl:Dock(TOP)
clickonme_mdl:SetFont("GModNotify")
clickonme_mdl:SetText("Click to show model")
clickonme_mdl:SetTextColor(Color(255, 200, 0))
clickonme_mdl:SetContentAlignment(8)
clickonme_mdl:SizeToContents()
sls_playermodel:Dock(FILL)
function sls_playermodel:LayoutEntity( Entity ) return end -- disables default rotation
sls_playermodel:SetModel(killer["model"])

if (sls_playermodel.Entity:LookupBone("ValveBiped.Bip01_Head1")) then
local headpos = sls_playermodel.Entity:GetBonePosition(sls_playermodel.Entity:LookupBone("ValveBiped.Bip01_Head1"))
sls_playermodel:SetLookAt(headpos)

sls_playermodel:SetCamPos(headpos-Vector(-15, 0, 0))	-- Move cam in front of face

sls_playermodel.Entity:SetEyeTarget(headpos-Vector(-15, 0, 0))
end

sls_ply_choosen_killer_model = killer["model"]
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
util.AddNetworkString("sls_share_killers_list")

hook.Add("ShowSpare2", "sls_hub_ShowSpare2", function(ply)
net.Start("sls_OpenHUB")
net.Send(ply)
end)

net.Receive("sls_hub_choosekiller", function(len, ply)
	ply:SetNWInt("choosen_killer", net.ReadInt(6))
end)

net.Receive("sls_share_killers_list", function(len, ply)
	local GM = GM or GAMEMODE
	GM.MAP.KILLERS = net.ReadTable()
end)

net.Receive("sls_killer_choose_nw", function(len, ply)
ply:SetNWBool("sls_killer_choose", net.ReadBool())
end)

end