SWEP.Base = "tfa_melee_base"
DEFINE_BASECLASS(SWEP.Base)

SWEP.Author = "YuRaNnNzZZ"
SWEP.Category = "TFA COD:IW"
SWEP.PrintName = "Combat Knife"
SWEP.ViewModel = "models/weapons/yurie_cod/iw7/tactical_knife_iw7_vm.mdl"
SWEP.ViewModelFOV = 65
SWEP.VMPos = Vector(0, 0, 0)
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/yurie_cod/iw7/tactical_knife_iw7_wm.mdl"
SWEP.HoldType = "knife"
SWEP.Spawnable = TFA_BASE_VERSION and TFA_BASE_VERSION >= 4.7
SWEP.AdminOnly = false
SWEP.DrawCrosshair = true

if TFA and TFA.AddSound then
	TFA.AddSound("YURIE_COD.IW7.Melee_Pull_Lower", CHAN_WEAPON, 1, 60, 100, "weapons/yurie_cod/iw7/melee/melee_pull_away_lower.wav")
	TFA.AddSound("YURIE_COD.IW7.Melee.H2H_Knife_Swing", CHAN_WEAPON, .45, 60, 100, {"weapons/yurie_cod/iw7/melee/h2h_knife_swing1.wav", "weapons/yurie_cod/iw7/melee/h2h_knife_swing2.wav"})
	TFA.AddSound("YURIE_COD.IW7.Melee.H2H_Knife_Impact_Other", CHAN_STATIC, 1, 90, 100, {"weapons/yurie_cod/iw7/melee/h2h_knife_impact_other1.wav", "weapons/yurie_cod/iw7/melee/h2h_knife_impact_other2.wav", "weapons/yurie_cod/iw7/melee/h2h_knife_impact_other3.wav"})
	TFA.AddSound("YURIE_COD.IW7.Melee.H2H_Knife_Slice", CHAN_STATIC, 1, 90, 100, {"weapons/yurie_cod/iw7/melee/h2h_knife_slice1.wav", "weapons/yurie_cod/iw7/melee/h2h_knife_slice2.wav"})
end

if killicon and killicon.Add then
	killicon.Add("tfa_iw7_tactical_knife", "vgui/killicons/tfa_iw7_tactical_knife", Color(255, 80, 0, 191))
end

SWEP.EventTable = {
	[ACT_VM_DRAW] = {
		{time = 0, type = "sound", value = Sound("YURIE_COD.IW7.Melee_Pull_Lower")}
	}
}

SWEP.ImpactDecal = ""

SWEP.Primary.Damage = 45
SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_HITRIGHT,
		["len"] = 48,
		["src"] = Vector(0, 0, 0),
		["dir"] = Vector(0, 12, 0),
		["dmg"] = SWEP.Primary.Damage,
		["dmgtype"] = DMG_SLASH,
		["delay"] = 4 / 30,
		["snd"] = Sound("YURIE_COD.IW7.Melee.H2H_Knife_Swing"),
		["snd_delay"] = 1 / 30,
		["hitflesh"] = Sound("YURIE_COD.IW7.Melee.H2H_Knife_Slice"),
		["hitworld"] = Sound("YURIE_COD.IW7.Melee.H2H_Knife_Impact_Other"),
		["viewpunch"] = Angle(0, 2.5, 0.5),
		["end"] = 17 / 30,
		["hull"] = 10,
	}
}
SWEP.Primary.RPM = 60 / 0.56
SWEP.Primary.RPM_Displayed = 666

SWEP.AllowSprintAttack = false
SWEP.Secondary.CanBash = false

SWEP.Primary.MaxCombo = 0
SWEP.Secondary.MaxCombo = 0

SWEP.Offset = {
	Pos = {
		Up = 0,
		Right = 1,
		Forward = 2.5
	},
	Ang = {
		Up = 0,
		Right = 90,
		Forward = 0
	},
	Scale = 1
}

SWEP.InspectPos = Vector(2, -12, 1.75)
SWEP.InspectAng = Vector(22, 45, 16)

SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_ANI
SWEP.SprintAnimation = {
	["in"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ,
		["value"] = "vm_knifeonly_sprint_in",
		["transition"] = true
	},
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ,
		["value"] = "vm_knifeonly_sprint_loop",
		["is_idle"] = true
	},
	["out"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ,
		["value"] = "vm_knifeonly_sprint_out",
		["transition"] = true
	}
}

function SWEP:SecondaryAttack()
end

SWEP.AltAttack = false
