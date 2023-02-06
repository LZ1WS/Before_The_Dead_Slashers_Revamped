if ( SERVER ) then

	SWEP.Weight = 5
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom = true
	
end

if( CLIENT ) then

	SWEP.PrintName = "Claws Glove"
	SWEP.Slot = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

end

-- Main --
SWEP.Author			= "Double Damage"
SWEP.Contact		= ""
SWEP.Category		= "Slashers"
SWEP.Instructions	= "LMB - Attack(only for those who are in a dream). RMB- Put to sleep(6 seconds.) "
SWEP.Spawnable			= true
SWEP.AdminOnly			= true
SWEP.AutoSwitchTo	= true
SWEP.AutoSwitchFrom = true
SWEP.HoldType 		= "normal"
SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false
SWEP.ViewModel 				= "models/weapons/ddsuck.mdl"
SWEP.WorldModel     = ""
SWEP.UseHands 		= true
SWEP.Secondary.Automatic = false

function SWEP:Deploy()
self.Owner:EmitSound( "weapons/knife/pickclaws.mp3" ) 
end

function SWEP:PrimaryAttack()
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
self.Weapon:SetNextPrimaryFire(CurTime() + 1.5)
self.Owner:EmitSound( "weapons/knife/swing.mp3" ) 
		local ent = self.Owner:GetEyeTrace().Entity
		if not (ent:GetPos():Distance(self.Owner:GetPos()) < 175) then return end
		if not ent:IsPlayer() then return end
		if not ent:GetNWInt( "Valera", true) then return end
		if SERVER then 
		ent:TakeDamage ( math.random(25,50), self.Owner, self.Owner:GetActiveWeapon() )
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	end
end


function SWEP:SecondaryAttack()
self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
		local haker = self.Owner:GetEyeTrace().Entity
		local old_walk = haker:GetWalkSpeed()
		local old_run = haker:GetRunSpeed()
		if not (haker:GetPos():Distance(self.Owner:GetPos()) < 500) then return end
		if not IsFirstTimePredicted() then return end
		self.Owner:EmitSound( "weapons/knife/freddy.mp3" ) 
		if not haker:IsPlayer() then return end
		self.Owner:ChatPrint("You're trying to force him into your dream world")
		timer.Create( "feduk" .. haker:Nick(), 6, 1, function() 
		self.Owner:ChatPrint("You've forced him into your dream world")
			haker:SetNWInt( 'Valera', true )
			haker:EmitSound( "weapons/knife/whispering.mp3" ) 
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	timer.Create("undream" .. haker:Nick(), 15, 1, function()
		if !haker:Alive() or !self.Owner:Alive() then return end
		self.Owner:ChatPrint(haker:Nick() .. " escaped your dream world")
		haker:SetNWInt( 'Valera', false )
		haker:SetWalkSpeed(old_walk)
		haker:SetRunSpeed(old_run)
		haker:StopSound("weapons/knife/whispering.mp3")
	end)
			end)
		end

hook.Add("sls_round_OnTeamWin", "sls_nightmare_dream_End", function()
	for _,v in ipairs(player.GetAll()) do
			timer.Remove("undream" .. v:Nick())
			timer.Remove("feduk" .. v:Nick())
	end
			hook.Remove("sls_round_OnTeamWin", "sls_dreamers_dream_End")
end)

function SWEP:DrawHUD()
local freddi = Material("vgui/baldi.png")
surface.SetDrawColor( 255, 255, 255, 120 ) 
surface.SetMaterial( freddi )
surface.DrawTexturedRect( 0, 0, 9000, 9000 ) 
					for k, v in ipairs( ents.GetAll() ) do
						if v:GetNWInt( 'Valera', true ) then
						if  v:IsPlayer() then
	local Position = ( v:GetPos() + Vector( 0,0,80 ) ):ToScreen()
		draw.DrawText( v:Name(), "Trebuchet24", Position.x, Position.y, Color( 255, 255, 255, 255 ), 1 )
		end
		end
end
end

function SWEP:IsLookingAt( ply )
	local yes = ply:GetAimVector():Dot( ( self.Owner:GetPos() - ply:GetPos() + Vector( 70 ) ):GetNormalized() )
	return (yes > 0.39)
end

function SWEP:Think()
	if not SERVER then return end
	local watching = false
	for k,v in pairs(player.GetAll()) do
		if not IsValid(v) or not v:Alive() then continue end

		local wep = v:GetActiveWeapon()
		
								if v:GetNWInt( 'Valera', true ) then
		local tr_eyes = util.TraceLine( {
				start = v:EyePos() + v:EyeAngles():Forward() * 15,
				endpos = self.Owner:EyePos(),
			} )
			local tr_center = util.TraceLine( {
				start = v:LocalToWorld( v:OBBCenter() ),
				endpos = self.Owner:LocalToWorld( self.Owner:OBBCenter() ),
				filter = v
			} )
		if tr_eyes.Entity == self.Owner or tr_center.Entity == self.Owner then
			if self:IsLookingAt( v ) then

				watching = true
				break -- Optimalization :)
			end
		end
	end
	end
	if watching and self.Owner:Alive() then
self.Owner:SetNoDraw( false )
	else
self.Owner:SetNoDraw( true )
		end
end