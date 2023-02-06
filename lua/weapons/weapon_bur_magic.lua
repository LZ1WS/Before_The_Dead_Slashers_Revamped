SWEP.PrintName 				= "Oblivion Magic"
SWEP.Author 				= "Burger" 
SWEP.Contact 				= "" 
SWEP.Category 				= "TES: Oblivion"
SWEP.Instructions 			= ""
SWEP.Purpose 				= ""

SWEP.Base 					= "weapon_base"	
SWEP.ViewModel 				= "models/weapons/c_arms_citizen.mdl" 
SWEP.WorldModel 			= ""
SWEP.HoldType 				= "normal" 
SWEP.ViewModelFlip 			= true
SWEP.UseHands				= false	

SWEP.Spawnable 				= true 
SWEP.AdminSpawnable 		= true                   			

SWEP.DrawCrosshair 			= false                        		
SWEP.DrawAmmo 				= true                                
                                	
SWEP.SlotPos 				= 0                                    	
SWEP.Slot 					= 1                                     

SWEP.Primary.Ammo         	= "HelicopterGun"
SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Automatic   	= true					

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.CanSwitch 				= true
SWEP.WeaponSlot 			= 1


SWEP.Skill = 50

SWEP.NextChangeTime = 0

if CLIENT then

	language.Add("HelicopterGun_ammo","Mana")

	surface.CreateFont( "Oblivion", {
	font = "oblivion-font",
	size = 32,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
	} )
	
end

function SWEP:Initialize()

end


function SWEP:Deploy()

	self:UpdateSpell()

	return true
	
end

function SWEP:Holster()
	return true
end

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + 2 )
	
	self:EmitEffects()
	
	local ManaCost = ( self.SpellSlot[self.WeaponSlot].BaseCost / 10) * (self.SpellSlot[self.WeaponSlot].Damage ^ 1.28) * ( self.SpellSlot[self.WeaponSlot].Duration ) * (self.SpellSlot[self.WeaponSlot].Radius * 0.15) * ( 1.4 - (0.012 * self.Skill) )
	
	
	if ManaCost <= self:Clip1() then
	
		self.RegenTime = CurTime() + 2.25
		self.NextChangeTime = CurTime() + 1.05
		
		timer.Simple(1, function()
			
			if SERVER then

				self.Weapon:TakePrimaryAmmo(ManaCost)
				self.CastWhen = CurTime()
				
				if self.SpellSlot[self.WeaponSlot].Method == "target" then
					self:SpellTarget()
				elseif self.SpellSlot[self.WeaponSlot].Method == "touch" then
					self:SpellTouch()
				elseif self.SpellSlot[self.WeaponSlot].Method == "self" then
					self:SpellSelf()
				end
				
			end	
			
		end)
		
	end
end

function SWEP:Think()

	self:RegenThink()
	self:CheckInputs()
	self:UpdateSpell()
	
	self:HealThink()
	self:ShieldThink()
	self:ConjureThink()

end

function SWEP:RegenThink()

	if SERVER then
		if self.RegenTime == nil then return end
		if self.RegenTime > CurTime() then return end
		
		if self.Weapon:Clip1() < 100 then
			self.RegenTime = CurTime() + 0.12
			self.Weapon:SetClip1(self.Weapon:Clip1()+1)
		end
	end

end


function SWEP:CheckInputs()

	if self.NextChangeTime >= CurTime() then return end


	if CLIENT then
		if self.Owner:KeyDown( IN_ATTACK2 ) then
			if self.Owner:KeyDown( IN_FORWARD ) and self.Owner:KeyDown( IN_MOVELEFT ) then
			
				self:SendSpellToServer(8)

			elseif self.Owner:KeyDown( IN_FORWARD ) and self.Owner:KeyDown( IN_MOVERIGHT ) then
			
				self:SendSpellToServer(2)

			elseif self.Owner:KeyDown( IN_BACK ) and self.Owner:KeyDown( IN_MOVELEFT ) then

				self:SendSpellToServer(6)

			elseif self.Owner:KeyDown( IN_BACK ) and self.Owner:KeyDown( IN_MOVERIGHT ) then
			
				self:SendSpellToServer(4)

			elseif self.Owner:KeyDown( IN_FORWARD ) then

				self:SendSpellToServer(1)

			elseif self.Owner:KeyDown( IN_MOVELEFT ) then

				self:SendSpellToServer(7)

			elseif self.Owner:KeyDown( IN_MOVERIGHT ) then

				self:SendSpellToServer(3)

			elseif self.Owner:KeyDown( IN_BACK ) then

				self:SendSpellToServer(5)
			
			end
		end
	end

end

if SERVER then
	util.AddNetworkString( "CLTOSV_Spells" )
	util.AddNetworkString( "SVTOCL_Spells" )
end


function SWEP:SendSpellToServer(spell)
	
	self.WeaponSlot = spell

	net.Start("CLTOSV_Spells")
		net.WriteFloat(spell)
	net.SendToServer()
	
end

if SERVER then

	net.Receive("CLTOSV_Spells", function(len,ply)

		local spell = net.ReadFloat()
	
		if IsValid(ply:GetActiveWeapon()) then
		
			if ply:GetActiveWeapon():GetClass() == "weapon_bur_magic" then
	
				ply:GetActiveWeapon().WeaponSlot = spell
				
			end
			
		end

	end)


end

local Wheel = Material("vgui/ob_wheel/wheel")
local WheelBackground = Material("vgui/ob_wheel/background")
local Selector = Material("vgui/ob_wheel/selector")

function SWEP:DrawHUD()
	local BaseX = ScrW()*0.25
	local BaseY = ScrH()*0.90
	local BaseTrig = 1
	local ConVert = math.pi/180
	local Size = 64
	--local Icon = self:GetNWString("damagetype","nil")
	local Icon = self.SpellSlot[self.WeaponSlot].DamageType
	local HelpText = self.Text or "ass"
	local HelpText2 = self.Text2 or "titties"
	--local HelpText = self:GetNWString("helptext","gg noob")
	
	if CanSwitch == true then
		helper = 255
	else
		helper = 0
	end
	
	if Icon == nil then return end
	if HelpText == nil then return end
	if HelpText2 == nil then return end
	
	surface.SetMaterial( Material("vgui/ob_crosshair/crosshair") )
	surface.SetDrawColor(255,200,helper,1)
	surface.DrawTexturedRectRotated(ScrW()/2,ScrH()/2,32 + 8,32 + 8,0)

	if not LocalPlayer().HasOblivionHUD then
	
		surface.SetMaterial( Material("vgui/ob_icons/"..Icon) )
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRectRotated(BaseX,BaseY,Size,Size,0)
		
	end
	
	
	
	
	if LocalPlayer():KeyDown(IN_ATTACK2) then
	
	
		surface.SetFont( "Oblivion" )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( ScrW()*0.35 , ScrH()*0.5 ) 
		surface.DrawText( HelpText )
	
		surface.SetFont( "Oblivion" )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( ScrW()*0.35,  ScrH()*0.50 + 60 ) 
		surface.DrawText( HelpText2 )
	
	
	
		surface.SetDrawColor( Color(255,255,255,255) )
		surface.SetMaterial( WheelBackground )
		surface.DrawTexturedRectRotated( ScrW()*0.25 ,  ScrH()*0.5 , 512 , 512, 0  )
		

		
		for i=1, 8 do
			
			local StoredIcon = self.SpellSlot[i].DamageType
			
			local Edit = math.rad( ( (i+3) / 8) * 360  )
			
			
			XOffset = -math.sin(Edit)*100 - 1
			YOffset = math.cos(Edit)*100
			
			
			
			surface.SetDrawColor( Color(255,255,255,255) )
			surface.SetMaterial( Material("vgui/ob_icons/"..StoredIcon) )
			surface.DrawTexturedRectRotated( ScrW()*0.25 + XOffset ,  ScrH()*0.5 + YOffset , 64 , 64, 0  )
		
		
		end
		
		surface.SetDrawColor( Color(255,255,255,255) )
		surface.SetMaterial( Wheel )
		surface.DrawTexturedRectRotated( ScrW()*0.25 ,  ScrH()*0.5 , 512 , 512, 0  )
		
		
		surface.SetDrawColor( Color(255,255,255,255) )
		surface.SetMaterial( Selector )
		surface.DrawTexturedRectRotated( ScrW()*0.25 ,  ScrH()*0.5 , 512 , 512, 90 -(360/8) * self.WeaponSlot  )
	
	
	end
	
	
	
end

function SWEP:UpdateSpell()

	if CLIENT then
	
		local ManaCost = ( self.SpellSlot[self.WeaponSlot].BaseCost / 10) * (self.SpellSlot[self.WeaponSlot].Damage ^ 1.28) * ( self.SpellSlot[self.WeaponSlot].Duration ) * (self.SpellSlot[self.WeaponSlot].Radius * 0.15) * ( 1.4 - (0.012 * self.Skill) )						
	
	
	
		self.Text = self.SpellSlot[self.WeaponSlot].DamageType .. " " .. self.SpellSlot[self.WeaponSlot].Damage .. "pts "
			
		if self.SpellSlot[self.WeaponSlot].Radius >= 2 then
			self.Text = self.Text .. "in " .. self.SpellSlot[self.WeaponSlot].Radius .. "ft "
		end
			
		if self.SpellSlot[self.WeaponSlot].Duration >= 2 then
			self.Text = self.Text .. "for " .. self.SpellSlot[self.WeaponSlot].Duration .. "sec "
		end
			
		self.Text = self.Text .. "on " .. self.SpellSlot[self.WeaponSlot].Method
		self.Text2 = math.ceil(ManaCost) .. " mana"
		
	end
	
end

function SWEP:SpellTarget()

	if SERVER then
	
		local MagicType
		
		if self.SpellSlot[self.WeaponSlot].DamageType == "fire" then
			MagicType = "fire"
		elseif self.SpellSlot[self.WeaponSlot].DamageType == "frost" then
			MagicType = "frost"
		elseif self.SpellSlot[self.WeaponSlot].DamageType == "shock" then
			MagicType = "shock"
		elseif self.SpellSlot[self.WeaponSlot].DamageType == "pure" then
			MagicType = "pure"
		else
			MagicType = "base"
		end
	
	
		local ent = ents.Create ("ent_bur_magic_" .. MagicType);	
		
			ent:SetPos(self.Owner:GetShootPos() - Vector(0,0,5))
			ent:SetAngles(self.Owner:EyeAngles())
			ent:SetOwner(self.Owner)	
			ent.Cost = self.SpellSlot[self.WeaponSlot].Cost
			ent.Method = self.SpellSlot[self.WeaponSlot].Method
			ent.DamageType = self.SpellSlot[self.WeaponSlot].DamageType
			ent.Damage = self.SpellSlot[self.WeaponSlot].Damage
			ent.Duration = self.SpellSlot[self.WeaponSlot].Duration
			ent.Radius = self.SpellSlot[self.WeaponSlot].Radius * 16
			ent.CollisionRadius = self.SpellSlot[self.WeaponSlot].CollisionRadius
			ent.VelMul = self.SpellSlot[self.WeaponSlot].VelMul
			ent.LoopSound = self.SpellSlot[self.WeaponSlot].LoopSound
			ent.RColor = self.SpellSlot[self.WeaponSlot].RColor
			ent.GColor = self.SpellSlot[self.WeaponSlot].GColor
			ent.BColor = self.SpellSlot[self.WeaponSlot].BColor
			ent.AColor = self.SpellSlot[self.WeaponSlot].AColor
			ent.TrailLength = self.SpellSlot[self.WeaponSlot].TrailLength
			ent.TrailWidthStart = self.SpellSlot[self.WeaponSlot].TrailWidthStart
			ent.TrailWidthEnd = self.SpellSlot[self.WeaponSlot].TrailWidthEnd
			ent.TrailTexture = self.SpellSlot[self.WeaponSlot].TrailTexture
			ent.Effect = self.SpellSlot[self.WeaponSlot].Effect
			ent.TravelDamage = self.SpellSlot[self.WeaponSlot].TravelDamage
			ent.FranticEffect = self.SpellSlot[self.WeaponSlot].FranticEffect
			ent.ExplosionEffect = self.SpellSlot[self.WeaponSlot].ExplosionEffect						
		ent:Spawn()

		local phys = ent:GetPhysicsObject()
		
		if IsValid(phys) then
			phys:SetVelocity((self.Owner:EyeAngles():Forward() * 800 * self.SpellSlot[self.WeaponSlot].VelMul))
			phys:AddAngleVelocity(Vector(20000,20000,20000))
		end
		
	end
	
end


function SWEP:SpellSelf()

	if self.SpellSlot[self.WeaponSlot].DamageType == "heal" then
		self:SpellHeal()
	elseif self.SpellSlot[self.WeaponSlot].DamageType == "armor" then
		self:SpellShield()
	elseif self.SpellSlot[self.WeaponSlot].DamageType == "conjure" then
		self:SpellConjure()
	end
	
end

SWEP.HealValue = 0
SWEP.HealDuration = 0
SWEP.NextHealTick = 0


SWEP.ShieldValue = 0
SWEP.ShieldDuration = 0

SWEP.MinionDuration = 0


function SWEP:SpellHeal()

	self.HealValue = self.SpellSlot[self.WeaponSlot].Damage
	self.HealDuration = self.SpellSlot[self.WeaponSlot].Duration + CurTime()
	
end

function SWEP:HealThink()

	if CLIENT then return end

	if not IsValid(self.Owner) then
		return 
	elseif not self.Owner:Alive() then
		return
	end

	
	
	if self.HealDuration >= CurTime() then
	
		if self.NextHealTick <= CurTime() then
		
			local tick = 1
		
			self.Owner:SetHealth(math.Clamp(self.Owner:Health() + self.HealValue*tick,0,self.Owner:GetMaxHealth()))
			
			self.NextHealTick = CurTime() + tick
			
		end

	end

end

function SWEP:SpellConjure()

	self.MinionHealth = self.SpellSlot[self.WeaponSlot].Damage
	self.MinionDuration = self.SpellSlot[self.WeaponSlot].Duration + CurTime()
	
	
	for k,v in pairs(ents.FindByClass("npc_fastzombie")) do
		if v:GetOwner() == self.Owner then v:Remove() end
	end
				
	local minion = ents.Create("npc_fastzombie")
		minion:SetPos(self.Owner:GetPos() + self.Owner:GetForward()*50)
		minion:SetAngles(self.Owner:GetAngles())
		minion:SetOwner(self.Owner)
		minion:AddEntityRelationship(self.Owner, D_LI, 99 )
		minion:Spawn()
		minion:SetHealth(self.MinionHealth)
		minion:SetLastPosition( self.Owner:GetEyeTrace().HitPos + Vector(0,0,25) )
		minion:SetSchedule( SCHED_FORCED_GO_RUN )
	
end

function SWEP:ConjureThink()

	if CLIENT then return end

	if not IsValid(self.Owner) then
		minion:Remove()
		return 
	elseif not self.Owner:Alive() then
		minion:Remove()
		return
	end

	if self.MinionDuration <= CurTime() then
		if IsValid(minion) then 
			minion:Remove()
		end
	end

end

function SWEP:SpellShield()
	
	self.ShieldValue = self.SpellSlot[self.WeaponSlot].Damage
	self.ShieldDuration = CurTime() + self.SpellSlot[self.WeaponSlot].Duration
	
end

function SWEP:ShieldThink()

	if CLIENT then return end

	if not IsValid(self.Owner) then
		return 
	elseif not self.Owner:Alive() then
		return
	end


	if self.ShieldDuration >= CurTime() then
	
		self.Owner:SetArmor(self.ShieldValue)

	else
	
		self.Owner:SetArmor(0)
		
	end

end

function SWEP:EmitEffects()

	local ManaCost = ( self.SpellSlot[self.WeaponSlot].BaseCost / 10) * (self.SpellSlot[self.WeaponSlot].Damage ^ 1.28) * ( self.SpellSlot[self.WeaponSlot].Duration ) * (self.SpellSlot[self.WeaponSlot].Radius * 0.15) * ( 1.4 - (0.012 * self.Skill) )			

	if ManaCost >= self.Weapon:Clip1() then
		self:EmitSound("fx/spl/fail/spl_destruction_fail.wav",500,100)
	return end

	if self.SpellSlot[self.WeaponSlot].DamageType == "fire" then
		self.CastSound = "fx/spl/spl_fireball_cast.wav"
	elseif self.SpellSlot[self.WeaponSlot].DamageType == "frost" then
		self.CastSound = "fx/spl/spl_frost_cast.wav"
	elseif self.SpellSlot[self.WeaponSlot].DamageType == "shock" then
		self.CastSound = "fx/spl/spl_shock_cast.wav"
	elseif self.SpellSlot[self.WeaponSlot].DamageType == "heal" then
		self.CastSound = "fx/spl/spl_restoration_cast.wav"
	elseif self.SpellSlot[self.WeaponSlot].DamageType == "pure" then
		self.CastSound = "fx/spl/spl_destruction_cast.wav"
	elseif self.SpellSlot[self.WeaponSlot].DamageType == "unlock" then
		self.CastSound = "fx/spl/spl_alteration_cast.wav"
	elseif self.SpellSlot[self.WeaponSlot].DamageType == "conjure" then
		self.CastSound = "fx/spl/spl_conjuration_cast.wav"
	elseif self.SpellSlot[self.WeaponSlot].DamageType == "armor" then
		self.CastSound = "fx/spl/spl_alteration_cast.wav"
	else end
	
	self.SoundRand = math.Rand(-5,5)
	self:EmitSound(self.CastSound, 500, 100 + self.SoundRand )
	
end

function SWEP:SecondaryAttack()

end

function SWEP:Reload()

end

	print("Setting up Spells...")

	SWEP.SpellSlot = {}
	
	SWEP.SpellSlot[1] = {}
	SWEP.SpellSlot[2] = {}
	SWEP.SpellSlot[3] = {}
	SWEP.SpellSlot[4] = {}
	SWEP.SpellSlot[5] = {}
	SWEP.SpellSlot[6] = {}
	SWEP.SpellSlot[7] = {}
	SWEP.SpellSlot[8] = {}

	-- W Top Offensive

	SWEP.SpellSlot[1].BaseCost = 7.5
	SWEP.SpellSlot[1].Method = "target"
	SWEP.SpellSlot[1].DamageType = "fire"
	SWEP.SpellSlot[1].Damage = 25
	SWEP.SpellSlot[1].Duration = 1
	SWEP.SpellSlot[1].Radius = 10
	SWEP.SpellSlot[1].CollisionRadius = 2
	SWEP.SpellSlot[1].VelMul = 0.9
	SWEP.SpellSlot[1].LoopSound = "fx/spl/spl_fireball_travel_lp.wav"
	SWEP.SpellSlot[1].RColor = 255
	SWEP.SpellSlot[1].GColor = 200
	SWEP.SpellSlot[1].BColor = 0
	SWEP.SpellSlot[1].AColor = 255
	SWEP.SpellSlot[1].TrailLength = 0.25
	SWEP.SpellSlot[1].TrailWidthStart = 50
	SWEP.SpellSlot[1].TrailWidthEnd = 1
	SWEP.SpellSlot[1].TrailTexture = "trails/laser.vmt"
	SWEP.SpellSlot[1].Effect = "sentry_rocket_fire"
	SWEP.SpellSlot[1].TravelDamage = false
	SWEP.SpellSlot[1].FranticEffect = false
	SWEP.SpellSlot[1].ExplosionEffect = true

	-- WD Top Right Offensive
	SWEP.SpellSlot[2].BaseCost = 7.4
	SWEP.SpellSlot[2].Method = "target"
	SWEP.SpellSlot[2].DamageType = "frost"
	SWEP.SpellSlot[2].Damage = 5
	SWEP.SpellSlot[2].Duration = 10
	SWEP.SpellSlot[2].Radius = 5
	SWEP.SpellSlot[2].CollisionRadius = 5
	SWEP.SpellSlot[2].VelMul = 0.5
	SWEP.SpellSlot[2].LoopSound = "fx/spl/spl_frost_travel_lp.wav"
	SWEP.SpellSlot[2].RColor = 0
	SWEP.SpellSlot[2].GColor = 255
	SWEP.SpellSlot[2].BColor = 255
	SWEP.SpellSlot[2].AColor = 255
	SWEP.SpellSlot[2].TrailLength = 0.5
	SWEP.SpellSlot[2].TrailWidthStart = 100
	SWEP.SpellSlot[2].TrailWidthEnd = 0
	SWEP.SpellSlot[2].TrailTexture = "trails/laser.vmt"
	SWEP.SpellSlot[2].Effect = "critical_rocket_blue"
	SWEP.SpellSlot[2].TravelDamage = true
	SWEP.SpellSlot[2].FranticEffect = false
	SWEP.SpellSlot[2].ExplosionEffect = false

	-- D Right Blink
	SWEP.SpellSlot[3].BaseCost = 4.3
	SWEP.SpellSlot[3].Method = "target"
	SWEP.SpellSlot[3].DamageType = "unlock"
	SWEP.SpellSlot[3].Damage = 100
	SWEP.SpellSlot[3].Duration = 1
	SWEP.SpellSlot[3].Radius = 1
	SWEP.SpellSlot[3].CollisionRadius = 1
	SWEP.SpellSlot[3].VelMul = 1
	SWEP.SpellSlot[3].LoopSound = "fx/spl/spl_alteration_travel_lp.wav"
	SWEP.SpellSlot[3].RColor = 255
	SWEP.SpellSlot[3].GColor = 255
	SWEP.SpellSlot[3].BColor = 0
	SWEP.SpellSlot[3].AColor = 255
	SWEP.SpellSlot[3].TrailLength = 0.1
	SWEP.SpellSlot[3].TrailWidthStart = 10
	SWEP.SpellSlot[3].TrailWidthEnd = 1
	SWEP.SpellSlot[3].TrailTexture = "trails/laser.vmt"
	SWEP.SpellSlot[3].Effect = "community_sparkle"
	SWEP.SpellSlot[3].TravelDamage = false
	SWEP.SpellSlot[3].FranticEffect = false
	SWEP.SpellSlot[3].ExplosionEffect = true

	-- SD Bottom Right Defensive
	SWEP.SpellSlot[4].BaseCost = 16/100
	SWEP.SpellSlot[4].Method = "self"
	SWEP.SpellSlot[4].DamageType = "conjure"
	SWEP.SpellSlot[4].Damage = 100
	SWEP.SpellSlot[4].Duration = 30
	SWEP.SpellSlot[4].Radius = 1
	SWEP.SpellSlot[4].CollisionRadius = nil
	SWEP.SpellSlot[4].VelMul = nil
	SWEP.SpellSlot[4].LoopSound = nil
	SWEP.SpellSlot[4].RColor = nil
	SWEP.SpellSlot[4].GColor = nil
	SWEP.SpellSlot[4].BColor = nil
	SWEP.SpellSlot[4].AColor = nil
	SWEP.SpellSlot[4].TrailLength = nil
	SWEP.SpellSlot[4].TrailWidthStart = nil
	SWEP.SpellSlot[4].TrailWidthEnd = nil
	SWEP.SpellSlot[4].TrailTexture = nil
	SWEP.SpellSlot[4].Effect = nil
	SWEP.SpellSlot[4].TravelDamage = nil
	SWEP.SpellSlot[4].FranticEffect = nil
	SWEP.SpellSlot[4].ExplosionEffect = nil

	-- S Bottom Heal
	SWEP.SpellSlot[5].BaseCost = 100
	SWEP.SpellSlot[5].Method = "self"
	SWEP.SpellSlot[5].DamageType = "heal"
	SWEP.SpellSlot[5].Damage = 5
	SWEP.SpellSlot[5].Duration = 5
	SWEP.SpellSlot[5].Radius = 1
	SWEP.SpellSlot[5].CollisionRadius = nil
	SWEP.SpellSlot[5].VelMul = nil
	SWEP.SpellSlot[5].LoopSound = nil
	SWEP.SpellSlot[5].RColor = nil
	SWEP.SpellSlot[5].GColor = nil
	SWEP.SpellSlot[5].BColor = nil
	SWEP.SpellSlot[5].AColor = nil
	SWEP.SpellSlot[5].TrailLength = nil
	SWEP.SpellSlot[5].TrailWidthStart = nil
	SWEP.SpellSlot[5].TrailWidthEnd = nil
	SWEP.SpellSlot[5].TrailTexture = nil
	SWEP.SpellSlot[5].Effect = nil
	SWEP.SpellSlot[5].TravelDamage = nil
	SWEP.SpellSlot[5].FranticEffect = nil
	SWEP.SpellSlot[5].ExplosionEffect = nil

	-- SA Bottom Left Defensive
	SWEP.SpellSlot[6].BaseCost = 0.45
	SWEP.SpellSlot[6].Method = "self"
	SWEP.SpellSlot[6].DamageType = "armor"
	SWEP.SpellSlot[6].Damage = 100
	SWEP.SpellSlot[6].Duration = 15
	SWEP.SpellSlot[6].Radius = 1
	SWEP.SpellSlot[6].CollisionRadius = nil
	SWEP.SpellSlot[6].VelMul = nil
	SWEP.SpellSlot[6].LoopSound = nil
	SWEP.SpellSlot[6].RColor = nil
	SWEP.SpellSlot[6].GColor = nil
	SWEP.SpellSlot[6].BColor = nil
	SWEP.SpellSlot[6].AColor = nil
	SWEP.SpellSlot[6].TrailLength = nil
	SWEP.SpellSlot[6].TrailWidthStart = nil
	SWEP.SpellSlot[6].TrailWidthEnd = nil
	SWEP.SpellSlot[6].TrailTexture = nil
	SWEP.SpellSlot[6].Effect = nil
	SWEP.SpellSlot[6].TravelDamage = nil
	SWEP.SpellSlot[6].FranticEffect = nil
	SWEP.SpellSlot[6].ExplosionEffect = nil

	-- A Left Dash
	SWEP.SpellSlot[7].BaseCost = 12
	SWEP.SpellSlot[7].Method = "target"
	SWEP.SpellSlot[7].DamageType = "pure"
	SWEP.SpellSlot[7].Damage = 100
	SWEP.SpellSlot[7].Duration = 1
	SWEP.SpellSlot[7].Radius = 1
	SWEP.SpellSlot[7].CollisionRadius = 5
	SWEP.SpellSlot[7].VelMul = 0.75
	SWEP.SpellSlot[7].LoopSound = "fx/spl/spl_destruction_travel_lp.wav"
	SWEP.SpellSlot[7].RColor = 255
	SWEP.SpellSlot[7].GColor = 255
	SWEP.SpellSlot[7].BColor = 255
	SWEP.SpellSlot[7].AColor = 255
	SWEP.SpellSlot[7].TrailLength = 0.5
	SWEP.SpellSlot[7].TrailWidthStart = 32
	SWEP.SpellSlot[7].TrailWidthEnd = 1
	SWEP.SpellSlot[7].TrailTexture = "trails/laser.vmt"
	SWEP.SpellSlot[7].Effect = "critical_rocket_red"
	SWEP.SpellSlot[7].TravelDamage = false
	SWEP.SpellSlot[7].FranticEffect = false
	SWEP.SpellSlot[7].ExplosionEffect = true
	
	-- WA Top Left Offensive
	SWEP.SpellSlot[8].BaseCost = 7.8
	SWEP.SpellSlot[8].Method = "target"
	SWEP.SpellSlot[8].DamageType = "shock"
	SWEP.SpellSlot[8].Damage = 50
	SWEP.SpellSlot[8].Duration = 3
	SWEP.SpellSlot[8].Radius = 1
	SWEP.SpellSlot[8].CollisionRadius = 1
	SWEP.SpellSlot[8].VelMul = 2
	SWEP.SpellSlot[8].LoopSound = "fx/spl/spl_shock_travel_lp.wav"
	SWEP.SpellSlot[8].RColor = 255
	SWEP.SpellSlot[8].GColor = 255
	SWEP.SpellSlot[8].BColor = 255
	SWEP.SpellSlot[8].AColor = 255
	SWEP.SpellSlot[8].TrailLength = 1
	SWEP.SpellSlot[8].TrailWidthStart = 5
	SWEP.SpellSlot[8].TrailWidthEnd = 5
	SWEP.SpellSlot[8].TrailTexture = "trails/electric.vmt"
	SWEP.SpellSlot[8].Effect = "critical_rocket_blue"
	SWEP.SpellSlot[8].TravelDamage = false
	SWEP.SpellSlot[8].FranticEffect = true
	SWEP.SpellSlot[8].ExplosionEffect = true






