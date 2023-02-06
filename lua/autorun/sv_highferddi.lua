hook.Add("Think", "freddi", function()
for k, v in pairs(player.GetAll()) do
if v:GetNWInt( "Valera", true) then
	local old_walk = v:GetWalkSpeed()
	local old_run = v:GetRunSpeed()
v:SetWalkSpeed(old_walk - 60)
v:SetRunSpeed(old_run - 60)
hook.Add("HUDPaint", "Lmaxl", function()
if LocalPlayer():GetNWInt( "Valera", true) then
local freddi = Material("vgui/baldi.png")
surface.SetDrawColor( 255, 255, 255, 120 ) 
surface.SetMaterial( freddi )
surface.DrawTexturedRect( 0, 0, 9000, 9000 )
end
	end)
	end
end
end)

hook.Add("PlayerDeath","valerafalse",function(ply)
ply:SetNWInt( "Valera", false)
ply:StopSound("weapons/knife/whispering.mp3")
	end)
	

hook.Add("PlayerInitialSpawn", "dk", function(p)
p:SetNWInt( "Valera", false)
end)
hook.Add("PlayerSpawn", "danya", function(ply)
ply:SetNWInt( "Valera", false)
end)