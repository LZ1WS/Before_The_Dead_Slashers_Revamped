SWEP.Base = "tfa_nmrimelee_base"
SWEP.Category = "TFA NMRIH"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.PrintName = "Abresive Saw"

SWEP.ViewModel			= "models/weapons/tfa_nmrih/v_me_abrasivesaw.mdl" --Viewmodel path
SWEP.ViewModelFOV = 50

SWEP.WorldModel			= "models/weapons/tfa_nmrih/w_me_abrasivesaw.mdl" --Viewmodel path
SWEP.HoldType = "shotgun"
SWEP.DefaultHoldType = "shotgun"
SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = 0,
        Right = 1,
        Forward = 4,
        },
        Ang = {
        Up = -1,
        Right = -30,
        Forward = 178
        },
		Scale = 1.0
}

SWEP.Primary.Sound = Sound("Weapon_Melee.HatchetLight")
SWEP.Secondary.Sound = Sound("Weapon_Melee.FireaxeHeavy")

SWEP.MoveSpeed = 0.9
SWEP.IronSightsMoveSpeed  = SWEP.MoveSpeed

SWEP.InspectPos = Vector(5.5, 1.424, -3.131)
SWEP.InspectAng = Vector(17.086, 3.938, 14.836)

SWEP.Primary.RPM = 50
SWEP.Primary.Damage = 15


SWEP.Primary.Ammo = "gasoline"
SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 400

SWEP.Primary.Motorized = true
SWEP.Primary.Motorized_ToggleBuffer = 0.1 --Blend time to idle when toggling
SWEP.Primary.Motorized_ToggleTime = 1.5 --Time until we turn on/off, independent of the above
SWEP.Primary.Motorized_IdleSound = Sound("Weapon_AbrasiveSaw.IdleLoop") --Idle sound, when on
SWEP.Primary.Motorized_SawSound = Sound("Weapon_AbrasiveSaw.SawLoop") --Rev sound, when on
SWEP.Primary.Motorized_AmmoConsumption_Idle = 60/120 --Ammo units to consume while idle
SWEP.Primary.Motorized_AmmoConsumption_Saw = 60/15 --Ammo units to consume while sawing
SWEP.Primary.Motorized_RPM = 300
SWEP.Primary.Motorized_Damage = 39 --DPS
SWEP.Primary.Motorized_Reach = 50 --DPS

SWEP.Secondary.BashDelay = 0.15
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.254, 0.09), angle = Angle(15.968, -11.193, 1.437) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.552, 4.526, 0) },
	["Thumb04"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6, 0, 0) },
	["Middle04"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-8.212, 1.121, 1.263) },
	["Pinky05"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(11.793, 4.677, 11.218) }
}