local path = "weapons/tfa_echo/claws/"
local pref = "TFA_echo.Claws"
local hudcolor = Color(255, 80, 0, 191)

TFA.AddFireSound(pref .. ".1", path .. "slash1.wav", "slash2.wav", "slash3.wav", "slash4.wav", false, ")")

TFA.AddWeaponSound(pref .. ".Draw", path .. "draw.wav")
TFA.AddWeaponSound(pref .. ".DrawFirst", path .. "draw_first.wav")
TFA.AddWeaponSound(pref .. ".Holster", path .. "holster.wav")

