-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-07-25 16:15:46
-- @Last Modified by:   Daryl_Winters
-- @Last Modified time: 2017-08-10T14:33:00+02:00

local GM = GM or GAMEMODE

GM.CLASS = {}
GM.CLASS.Survivors = {}
GM.KILLERS = {}

GM.CLASS.Survivors[CLASS_SURV_SPORTS] = {}
GM.CLASS.Survivors[CLASS_SURV_SPORTS].name = "Sports"
GM.CLASS.Survivors[CLASS_SURV_SPORTS].walkspeed = 150
GM.CLASS.Survivors[CLASS_SURV_SPORTS].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_SPORTS].life = 120
GM.CLASS.Survivors[CLASS_SURV_SPORTS].stamina = 210
GM.CLASS.Survivors[CLASS_SURV_SPORTS].model = "models/steinman/slashers/sport_pm.mdl"
GM.CLASS.Survivors[CLASS_SURV_SPORTS].die_sound = "slashers/effects/scream_man_1.wav"
GM.CLASS.Survivors[CLASS_SURV_SPORTS].weapons = {"weapon_nessbat(normal)"}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_SPORTS].dispname = "Trent"
	GM.CLASS.Survivors[CLASS_SURV_SPORTS].description = GM.LANG:GetString("class_desc_sports")
	GM.CLASS.Survivors[CLASS_SURV_SPORTS].icon = Material("icons/icon_sportif.png")
end

GM.CLASS.Survivors[CLASS_SURV_POPULAR] = {}
GM.CLASS.Survivors[CLASS_SURV_POPULAR].name = "Popular girl"
GM.CLASS.Survivors[CLASS_SURV_POPULAR].walkspeed = 160
GM.CLASS.Survivors[CLASS_SURV_POPULAR].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_POPULAR].life = 80
GM.CLASS.Survivors[CLASS_SURV_POPULAR].stamina = 120
GM.CLASS.Survivors[CLASS_SURV_POPULAR].model = "models/steinman/slashers/popular_pm.mdl"
GM.CLASS.Survivors[CLASS_SURV_POPULAR].die_sound = "slashers/effects/scream_girl_1.wav"
GM.CLASS.Survivors[CLASS_SURV_POPULAR].weapons = {}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_POPULAR].dispname = "Lynda"
	GM.CLASS.Survivors[CLASS_SURV_POPULAR].description = GM.LANG:GetString("class_desc_popular")
	GM.CLASS.Survivors[CLASS_SURV_POPULAR].icon = Material("icons/icon_popular.png")
end

GM.CLASS.Survivors[CLASS_SURV_NERD] = {}
GM.CLASS.Survivors[CLASS_SURV_NERD].name = "Nerd"
GM.CLASS.Survivors[CLASS_SURV_NERD].walkspeed = 130
GM.CLASS.Survivors[CLASS_SURV_NERD].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_NERD].life = 100
GM.CLASS.Survivors[CLASS_SURV_NERD].stamina = 110
GM.CLASS.Survivors[CLASS_SURV_NERD].model = "models/steinman/slashers/nerd_pm.mdl"
GM.CLASS.Survivors[CLASS_SURV_NERD].die_sound = "slashers/effects/scream_man_1.wav"
GM.CLASS.Survivors[CLASS_SURV_NERD].weapons = {"tim_detector"}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_NERD].dispname = "Noah"
	GM.CLASS.Survivors[CLASS_SURV_NERD].description = GM.LANG:GetString("class_desc_nerd")
	GM.CLASS.Survivors[CLASS_SURV_NERD].icon = Material("icons/icon_nerd.png")
end

GM.CLASS.Survivors[CLASS_SURV_FAT] = {}
GM.CLASS.Survivors[CLASS_SURV_FAT].name = "Fat boy"
GM.CLASS.Survivors[CLASS_SURV_FAT].walkspeed = 130
GM.CLASS.Survivors[CLASS_SURV_FAT].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_FAT].life = 180
GM.CLASS.Survivors[CLASS_SURV_FAT].stamina = 80
GM.CLASS.Survivors[CLASS_SURV_FAT].model = "models/steinman/slashers/fat_pm.mdl"
GM.CLASS.Survivors[CLASS_SURV_FAT].die_sound = "slashers/effects/scream_man_1.wav"
GM.CLASS.Survivors[CLASS_SURV_FAT].weapons = {"item_hamburger"}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_FAT].dispname = "Franklin"
	GM.CLASS.Survivors[CLASS_SURV_FAT].description = GM.LANG:GetString("class_desc_fat")
	GM.CLASS.Survivors[CLASS_SURV_FAT].icon = Material("icons/icon_fat.png")
end

GM.CLASS.Survivors[CLASS_SURV_SHY] = {}
GM.CLASS.Survivors[CLASS_SURV_SHY].name = "Shy girl"
GM.CLASS.Survivors[CLASS_SURV_SHY].walkspeed = 140
GM.CLASS.Survivors[CLASS_SURV_SHY].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_SHY].life = 60
GM.CLASS.Survivors[CLASS_SURV_SHY].stamina = 140
GM.CLASS.Survivors[CLASS_SURV_SHY].model = "models/player/korka007/maxc.mdl"
GM.CLASS.Survivors[CLASS_SURV_SHY].die_sound = "slashers/effects/scream_girl_1.wav"
GM.CLASS.Survivors[CLASS_SURV_SHY].weapons = {}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_SHY].dispname = "Sydney"
	GM.CLASS.Survivors[CLASS_SURV_SHY].description = GM.LANG:GetString("class_desc_shy")
	GM.CLASS.Survivors[CLASS_SURV_SHY].icon = Material("icons/icon_shy.png")
end

GM.CLASS.Survivors[CLASS_SURV_JUNKY] = {}
GM.CLASS.Survivors[CLASS_SURV_JUNKY].name = "Junky"
GM.CLASS.Survivors[CLASS_SURV_JUNKY].walkspeed = 130
GM.CLASS.Survivors[CLASS_SURV_JUNKY].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_JUNKY].life = 110
GM.CLASS.Survivors[CLASS_SURV_JUNKY].stamina = 120
GM.CLASS.Survivors[CLASS_SURV_JUNKY].model = "models/steinman/slashers/junky_pm.mdl"
GM.CLASS.Survivors[CLASS_SURV_JUNKY].die_sound = "slashers/effects/scream_man_1.wav"
GM.CLASS.Survivors[CLASS_SURV_JUNKY].weapons = {}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_JUNKY].name = "Junky"
	GM.CLASS.Survivors[CLASS_SURV_JUNKY].dispname = "Marty"
	GM.CLASS.Survivors[CLASS_SURV_JUNKY].description = GM.LANG:GetString("class_desc_junky")
	GM.CLASS.Survivors[CLASS_SURV_JUNKY].icon = Material("icons/icon_junky.png")
end

GM.CLASS.Survivors[CLASS_SURV_EMO] = {}
GM.CLASS.Survivors[CLASS_SURV_EMO].name = "Emo"
GM.CLASS.Survivors[CLASS_SURV_EMO].walkspeed = 130
GM.CLASS.Survivors[CLASS_SURV_EMO].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_EMO].life = 110
GM.CLASS.Survivors[CLASS_SURV_EMO].stamina = 130
GM.CLASS.Survivors[CLASS_SURV_EMO].model = "models/steinman/slashers/emo_pm.mdl"
GM.CLASS.Survivors[CLASS_SURV_EMO].die_sound = "slashers/effects/scream_girl_1.wav"
GM.CLASS.Survivors[CLASS_SURV_EMO].weapons = {}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_EMO].dispname = "Audrey"
	GM.CLASS.Survivors[CLASS_SURV_EMO].description = GM.LANG:GetString("class_desc_emo")
	GM.CLASS.Survivors[CLASS_SURV_EMO].icon = Material("icons/icon_emo.png")
end

GM.CLASS.Survivors[CLASS_SURV_BLACK] = {}
GM.CLASS.Survivors[CLASS_SURV_BLACK].name = "Black"
GM.CLASS.Survivors[CLASS_SURV_BLACK].walkspeed = 140
GM.CLASS.Survivors[CLASS_SURV_BLACK].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_BLACK].life = 120
GM.CLASS.Survivors[CLASS_SURV_BLACK].stamina = 130
GM.CLASS.Survivors[CLASS_SURV_BLACK].model = "models/player/spike/lamar.mdl"
GM.CLASS.Survivors[CLASS_SURV_BLACK].die_sound = "slashers/effects/scream_man_1.wav"
GM.CLASS.Survivors[CLASS_SURV_BLACK].weapons = {"weapon_keys"}
GM.CLASS.Survivors[CLASS_SURV_BLACK].keysNumber = 3
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_BLACK].dispname = "Roland"
	GM.CLASS.Survivors[CLASS_SURV_BLACK].description = GM.LANG:GetString("class_desc_black")
	GM.CLASS.Survivors[CLASS_SURV_BLACK].icon = Material("icons/icon_black.png")
end

GM.CLASS.Survivors[CLASS_SURV_SHERIF] = {}
GM.CLASS.Survivors[CLASS_SURV_SHERIF].name = "Sherif"
GM.CLASS.Survivors[CLASS_SURV_SHERIF].walkspeed = 150
GM.CLASS.Survivors[CLASS_SURV_SHERIF].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_SHERIF].life = 130
GM.CLASS.Survivors[CLASS_SURV_SHERIF].stamina = 140
GM.CLASS.Survivors[CLASS_SURV_SHERIF].model = "models/steinman/slashers/sheriff_pm.mdl"
GM.CLASS.Survivors[CLASS_SURV_SHERIF].die_sound = "slashers/effects/scream_girl_1.wav"
GM.CLASS.Survivors[CLASS_SURV_SHERIF].weapons = {"stun_gun"}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_SHERIF].dispname = "Gale"
	GM.CLASS.Survivors[CLASS_SURV_SHERIF].description = GM.LANG:GetString("class_desc_sherif")
	GM.CLASS.Survivors[CLASS_SURV_SHERIF].icon = Material("icons/icon_sherif.png")
end

GM.CLASS.Survivors[CLASS_SURV_BABYSIT] = {}
GM.CLASS.Survivors[CLASS_SURV_BABYSIT].name = "Babysit"
GM.CLASS.Survivors[CLASS_SURV_BABYSIT].walkspeed = 150
GM.CLASS.Survivors[CLASS_SURV_BABYSIT].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_BABYSIT].life = 120
GM.CLASS.Survivors[CLASS_SURV_BABYSIT].stamina = 160
GM.CLASS.Survivors[CLASS_SURV_BABYSIT].model = "models/players/mj_dbd_qm.mdl"
GM.CLASS.Survivors[CLASS_SURV_BABYSIT].die_sound = "slashers/effects/scream_man_1.wav"
GM.CLASS.Survivors[CLASS_SURV_BABYSIT].weapons = {}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_BABYSIT].dispname = "Steve"
	GM.CLASS.Survivors[CLASS_SURV_BABYSIT].description = GM.LANG:GetString("class_desc_babysit")
	GM.CLASS.Survivors[CLASS_SURV_BABYSIT].icon = Material("icons/steve.png")
end

GM.CLASS.Survivors[CLASS_SURV_HIPPY] = {}
GM.CLASS.Survivors[CLASS_SURV_HIPPY].name = "Hippy"
GM.CLASS.Survivors[CLASS_SURV_HIPPY].walkspeed = 140
GM.CLASS.Survivors[CLASS_SURV_HIPPY].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_HIPPY].life = 110
GM.CLASS.Survivors[CLASS_SURV_HIPPY].stamina = 110
GM.CLASS.Survivors[CLASS_SURV_HIPPY].model = "models/players/mj_dbd_quentin.mdl"
GM.CLASS.Survivors[CLASS_SURV_HIPPY].die_sound = "slashers/effects/scream_man_1.wav"
GM.CLASS.Survivors[CLASS_SURV_HIPPY].weapons = {"swep_smokenade"}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_HIPPY].dispname = "Mitch"
	GM.CLASS.Survivors[CLASS_SURV_HIPPY].description = GM.LANG:GetString("class_desc_hippy")
	GM.CLASS.Survivors[CLASS_SURV_HIPPY].icon = Material("icons/hippy.png")
end

GM.CLASS.Survivors[CLASS_SURV_RANGER] = {}
GM.CLASS.Survivors[CLASS_SURV_RANGER].name = "Ranger"
GM.CLASS.Survivors[CLASS_SURV_RANGER].walkspeed = 150
GM.CLASS.Survivors[CLASS_SURV_RANGER].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_RANGER].life = 140
GM.CLASS.Survivors[CLASS_SURV_RANGER].stamina = 160
GM.CLASS.Survivors[CLASS_SURV_RANGER].model = "models/v92/characters/park_ranger/bm/rogers/player.mdl"
GM.CLASS.Survivors[CLASS_SURV_RANGER].die_sound = "slashers/effects/scream_man_1.wav"
GM.CLASS.Survivors[CLASS_SURV_RANGER].weapons = {"weapon_survivor_beartrap"}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_RANGER].dispname = "Sheldon"
	GM.CLASS.Survivors[CLASS_SURV_RANGER].description = GM.LANG:GetString("class_desc_ranger")
	GM.CLASS.Survivors[CLASS_SURV_RANGER].icon = Material("icons/ranger.png")
end

GM.CLASS.Survivors[CLASS_SURV_DREAMER] = {}
GM.CLASS.Survivors[CLASS_SURV_DREAMER].name = "Dreamer"
GM.CLASS.Survivors[CLASS_SURV_DREAMER].walkspeed = 130
GM.CLASS.Survivors[CLASS_SURV_DREAMER].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_DREAMER].life = 120
GM.CLASS.Survivors[CLASS_SURV_DREAMER].stamina = 110
GM.CLASS.Survivors[CLASS_SURV_DREAMER].model = "models/h-d/2sg/simonplayer.mdl"
GM.CLASS.Survivors[CLASS_SURV_DREAMER].die_sound = "slashers/effects/scream_man_1.wav"
GM.CLASS.Survivors[CLASS_SURV_DREAMER].weapons = {"dreamers_dream"}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_DREAMER].dispname = "Simon"
	GM.CLASS.Survivors[CLASS_SURV_DREAMER].description = GM.LANG:GetString("class_desc_dreamer")
	GM.CLASS.Survivors[CLASS_SURV_DREAMER].icon = Material("icons/dreamer.png")
end

GM.CLASS.Survivors[CLASS_SURV_PHARMACIST] = {}
GM.CLASS.Survivors[CLASS_SURV_PHARMACIST].name = "Pharmacist"
GM.CLASS.Survivors[CLASS_SURV_PHARMACIST].walkspeed = 150
GM.CLASS.Survivors[CLASS_SURV_PHARMACIST].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_PHARMACIST].life = 130
GM.CLASS.Survivors[CLASS_SURV_PHARMACIST].stamina = 140
GM.CLASS.Survivors[CLASS_SURV_PHARMACIST].model = "models/taggart/police02/male_02.mdl"
GM.CLASS.Survivors[CLASS_SURV_PHARMACIST].die_sound = "slashers/effects/scream_man_1.wav"
GM.CLASS.Survivors[CLASS_SURV_PHARMACIST].weapons = {"weapon_medkit"}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_PHARMACIST].dispname = "Theodore"
	GM.CLASS.Survivors[CLASS_SURV_PHARMACIST].description = GM.LANG:GetString("class_desc_pharmacist")
	GM.CLASS.Survivors[CLASS_SURV_PHARMACIST].icon = Material("icons/pharmacist.png")
end

GM.CLASS.Survivors[CLASS_SURV_RAPPER] = {}
GM.CLASS.Survivors[CLASS_SURV_RAPPER].name = "Rapper"
GM.CLASS.Survivors[CLASS_SURV_RAPPER].walkspeed = 140
GM.CLASS.Survivors[CLASS_SURV_RAPPER].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_RAPPER].life = 120
GM.CLASS.Survivors[CLASS_SURV_RAPPER].stamina = 130
GM.CLASS.Survivors[CLASS_SURV_RAPPER].model = "models/sentry/gtav/ballas/ogbalpm.mdl"
GM.CLASS.Survivors[CLASS_SURV_RAPPER].die_sound = "slashers/effects/scream_man_1.wav"
GM.CLASS.Survivors[CLASS_SURV_RAPPER].weapons = {"weapon_boombox"}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_RAPPER].dispname = "Drake"
	GM.CLASS.Survivors[CLASS_SURV_RAPPER].description = GM.LANG:GetString("class_desc_rapper")
	GM.CLASS.Survivors[CLASS_SURV_RAPPER].icon = Material("icons/rapper.png")
end

GM.CLASS.Survivors[CLASS_SURV_JOURNALIST] = {}
GM.CLASS.Survivors[CLASS_SURV_JOURNALIST].name = "Journalist"
GM.CLASS.Survivors[CLASS_SURV_JOURNALIST].walkspeed = 150
GM.CLASS.Survivors[CLASS_SURV_JOURNALIST].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_JOURNALIST].life = 130
GM.CLASS.Survivors[CLASS_SURV_JOURNALIST].stamina = 140
GM.CLASS.Survivors[CLASS_SURV_JOURNALIST].model = "models/anotheronel/playerupshur.mdl"
GM.CLASS.Survivors[CLASS_SURV_JOURNALIST].die_sound = "slashers/effects/scream_man_1.wav"
GM.CLASS.Survivors[CLASS_SURV_JOURNALIST].weapons = {"weapon_camera"}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_JOURNALIST].dispname = "Daniel"
	GM.CLASS.Survivors[CLASS_SURV_JOURNALIST].description = GM.LANG:GetString("class_desc_journalist")
	GM.CLASS.Survivors[CLASS_SURV_JOURNALIST].icon = Material("icons/journalist.png")
end

GM.CLASS.Survivors[CLASS_SURV_PRIEST] = {}
GM.CLASS.Survivors[CLASS_SURV_PRIEST].name = "Priest"
GM.CLASS.Survivors[CLASS_SURV_PRIEST].walkspeed = 150
GM.CLASS.Survivors[CLASS_SURV_PRIEST].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_PRIEST].life = 130
GM.CLASS.Survivors[CLASS_SURV_PRIEST].stamina = 140
GM.CLASS.Survivors[CLASS_SURV_PRIEST].model = "models/player/monk.mdl"
GM.CLASS.Survivors[CLASS_SURV_PRIEST].die_sound = "vo/ravenholm/madlaugh03.wav"
GM.CLASS.Survivors[CLASS_SURV_PRIEST].weapons = {"weapon_priest_book"}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_PRIEST].dispname = "David"
	GM.CLASS.Survivors[CLASS_SURV_PRIEST].description = GM.LANG:GetString("class_desc_priest")
	GM.CLASS.Survivors[CLASS_SURV_PRIEST].icon = Material("icons/priest.png")
end

GM.CLASS.Survivors[CLASS_SURV_ADDICTED] = {}
GM.CLASS.Survivors[CLASS_SURV_ADDICTED].name = "Addicted"
GM.CLASS.Survivors[CLASS_SURV_ADDICTED].walkspeed = 150
GM.CLASS.Survivors[CLASS_SURV_ADDICTED].runspeed = 240
GM.CLASS.Survivors[CLASS_SURV_ADDICTED].life = 80
GM.CLASS.Survivors[CLASS_SURV_ADDICTED].stamina = 140
GM.CLASS.Survivors[CLASS_SURV_ADDICTED].model = "models/player/hostage/hostage_04.mdl"
GM.CLASS.Survivors[CLASS_SURV_ADDICTED].die_sound = "slashers/effects/scream_man_1.wav"
GM.CLASS.Survivors[CLASS_SURV_ADDICTED].weapons = {"item_adrenaline"}
if CLIENT then
	GM.CLASS.Survivors[CLASS_SURV_ADDICTED].dispname = "Lucas"
	GM.CLASS.Survivors[CLASS_SURV_ADDICTED].description = GM.LANG:GetString("class_desc_addicted")
	GM.CLASS.Survivors[CLASS_SURV_ADDICTED].icon = Material("icons/addicted.png")
end

local function StartRound()
	for _, v in ipairs(player.GetAll()) do
		v.ClassID = nil
	end
end
hook.Add("sls_round_PreStart", "sls_class_PreStart", StartRound)