SWEP.Base = "tfa_nmrimelee_base"
SWEP.Category = "TFA NMRIH"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.PrintName = "Entrenching Tool"

SWEP.ViewModel			= "models/weapons/tfa_nmrih/v_me_etool.mdl" --Viewmodel path
SWEP.ViewModelFOV = 50

SWEP.WorldModel			= "models/weapons/tfa_nmrih/w_me_etool.mdl" --Viewmodel path
SWEP.HoldType = "melee2"
SWEP.DefaultHoldType = "melee2"
SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -6,
        Right = 1,
        Forward = 3,
        },
        Ang = {
        Up = -1,
        Right = -4,
        Forward = 178
        },
		Scale = 1.0
}

SWEP.Primary.Sound = ""--Sound("Weapon_Etool.SwingLight")
SWEP.Secondary.Sound = ""--Sound("Weapon_Etool.SwingHeavy")

SWEP.Primary.Blunt = true
SWEP.Primary.Damage = 30
SWEP.Primary.Reach = 55
SWEP.Primary.RPM = 80
SWEP.Primary.SoundDelay = 0.1
SWEP.Primary.Delay = 0.425
SWEP.Primary.Window = 0.3

SWEP.Secondary.Blunt = true
SWEP.Secondary.RPM = 55 -- Delay = 60/RPM, this is only AFTER you release your heavy attack
SWEP.Secondary.Damage = 40
SWEP.Secondary.Reach = 50
SWEP.Secondary.SoundDelay = 0.05
SWEP.Secondary.Delay = 0.2

SWEP.Secondary.BashDamage = 50
SWEP.Secondary.BashDelay = 0.4
SWEP.Secondary.BashLength = 60
SWEP.Secondary.BashDamageType = DMG_CLUB

SWEP.MoveSpeed = 0.9
SWEP.IronSightsMoveSpeed  = SWEP.MoveSpeed

SWEP.InspectPos = Vector(0.009, -8.242, -10.7)
SWEP.InspectAng = Vector(25.326, -33.065, 28.141)

SWEP.Primary.RPM = 50
SWEP.Primary.Damage = 70
SWEP.Secondary.BashDelay = 0.3
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.254, 0.09), angle = Angle(15.968, -11.193, 1.437) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.552, 4.526, 0) },
	["Thumb04"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(6, 0, 0) },
	["Middle04"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-8.212, 1.121, 1.263) },
	["Pinky05"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(11.793, 4.677, 11.218) }
}