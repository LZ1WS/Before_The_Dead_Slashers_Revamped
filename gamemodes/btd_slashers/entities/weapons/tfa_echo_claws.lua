SWEP.Category				= "TFA Echo"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.PrintName				= "Raptor claws"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 0				-- Slot in the weapon selection menu
SWEP.SlotPos				= 27			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.usechands			= false		-- set false if you want no crosshair
SWEP.DrawCrosshair			= false		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "melee"		-- how others view you carrying the weapon
-- normal melee melee2 fist claws smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.SlashTable = {"slash_1", "slash_2", "slash_3"} --Table of possible hull sequences
SWEP.StabTable = {"slash_heavy"} --Table of possible hull sequences
SWEP.StabMissTable = {"slash_heavy"} --Table of possible hull sequences

SWEP.Primary.Length = 100
SWEP.Secondary.Length = 100

SWEP.Primary.Delay = 0.15 --Delay for hull (primary)
SWEP.Secondary.Delay = 0.17 --Delay for hull (secondary)

SWEP.Primary.Damage = 30
SWEP.Secondary.Damage = 50
SWEP.Primary.Sound = Sound("TFA_echo.claws.1") 
SWEP.clawsShink = Sound("TFA_echo.claws.1")
SWEP.clawsSlash = Sound("TFA_echo.claws.1")
SWEP.clawsStab = Sound("TFA_echo.claws.1")
SWEP.Primary.Sound_Miss = Sound("TFA_echo.claws.1")

SWEP.ViewModelFOV = 100
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/tfa_echo/c_claws.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/tfa_echo/c_claws.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= false
SWEP.Base				= "tfa_knife_base"
SWEP.Spawnable				= true
SWEP.UseHands = false
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = true

SWEP.SprintAnimation = {
	["in"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "idle to sprint" --Number for act, String/Number for sequence
	},
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint", --Number for act, String/Number for sequence
		["is_idle"] = true
	},
	["out"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint to idle" --Number for act, String/Number for sequence
	}
}


SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
	Pos = {
		Up = -2,
		Right = 0.964,
		Forward = 3.796
	},
	Ang = {
		Up = 0,
		Right = -90,
		Forward = 180
	},
		Scale = 1.0
}

SWEP.ViewModelBoneMods = {
	["echo_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -34.445) },
	["echo_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -23.334) },
	["echo_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -40) },
	["echo_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10, -1.111, 16.666) },
	["clawsPoint"] = { scale = Vector(1, 1, 1), pos = Vector(0.555, -0.186, -0.401), angle = Angle(0, 0, 0) },
	["echo_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -34.445) }
}

SWEP.AllowViewAttachment = true --Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS.
SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.Sights_Mode = TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation
SWEP.Idle_Mode = TFA.Enum.IDLE_BOTH --TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend = 0 --Start an idle this far early into the end of a transition
SWEP.Idle_Smooth = 0 --Start an idle this far early into the end of another animation
SWEP.SprintBobMult = 0
function SWEP:ThrowKnife()
	return false
end