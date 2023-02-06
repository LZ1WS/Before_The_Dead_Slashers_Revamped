AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "ent_bur_magic_base"
ENT.PrintName = "Lua Magic"
ENT.Author = ""
ENT.Information = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false 

if CLIENT then
	killicon.Add("ent_bur_magic_shock", "vgui/ob_icons/shock", Color(255,255,255,255) )
end