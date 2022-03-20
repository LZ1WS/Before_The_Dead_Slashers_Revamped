/*--------------------------------
  Necromancer's Wand
  (based on class from gmod9 nox' TeamPlay)
  
  by NECROSSIN
  
  Additional thanks to: 
  
  Clavus and Deluvas - for helping me out with few complicated things :o
  JusticeInACan - for original gui textures and default stats from gmod 9
  
  Better version for workshop + possible crash fix

----------------------------------*/
SWEP.HoldType			= "melee"

if (SERVER) then

	AddCSLuaFile()
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo			= false
	SWEP.AutoSwitchFrom		= false
	
	
	--Add some textures
	resource.AddFile( "materials/necromancer/spellselect.vtf" )
	resource.AddFile( "materials/necromancer/spellselect.vmt" )
	resource.AddFile( "materials/killicon/d_necromancergeneric.vtf" )
	resource.AddFile( "materials/killicon/d_necromancergeneric.vmt" )
	resource.AddFile( "materials/vgui/entities/necromancer_swep.vtf" )
	resource.AddFile( "materials/vgui/entities/necromancer_swep.vmt" )

end

if ( CLIENT ) then

	SWEP.PrintName			= "Necromancer's wand"	
	SWEP.Author				= "NECROSSIN"
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= true
	SWEP.ViewModelFOV			= 75
	SWEP.ViewModelFlip		= false
	
	SWEP.Slot				= 1 
	SWEP.SlotPos			= 1
	
	killicon.Add("necromancer_swep","killicon/d_necromancergeneric",Color(255,255,255))
	SWEP.WepSelectIcon = surface.GetTextureID("killicon/d_necromancergeneric.vtf")
end 

SWEP.Spawnable				= true
SWEP.AdminOnly			= true

SWEP.Purpose        	= ""

SWEP.Category		= "Other"


SWEP.Instructions   	= "Press Reload to see quick instructions!"

SWEP.ViewModel 				= "models/Weapons/V_Stunbaton.mdl"
SWEP.WorldModel 				= "models/Weapons/w_stunbaton.mdl" 

SWEP.Weight					= 5 
SWEP.AutoSwitchTo				= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Ammo				= ""

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Ammo			= "none" 

--Enable or disable small effect for wand
SWEP.EnableWandEffect = true

--Few mana options here (based on original stats from gmod 9)
///////////////////////
SWEP.MaxMana = 100
SWEP.ManaRegenRate = 0.0875//0.175//0.35  same regeneration speed but with more smooth values (needed for hud)
SWEP.ManaRegenAmount = 0.975//1.95//3.9
//////////////////////

//DT ints: 0 - Spell
//DT Floats:  0 - Mana

function SWEP:Initialize()
	if SERVER then
		self:SetDTFloat(0,self.MaxMana)
	end
	if CLIENT then
		
		local fontdata = {font = "Arial",size = ScreenScale(7),weight  = 700}
		surface.CreateFont("ABold5",fontdata)
		//surface.CreateFont("Arial", ScreenScale(7), 700, true, false, "ABold5")
	end
	self:SetWeaponHoldType("melee")
end

function SWEP:Deploy()
	if SERVER then
		self:SetDTInt(1,1)
	end
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:Reload()

	if (self.NextInfo or 0) > CurTime() then return end
	self.NextInfo = CurTime() + 20
	
	self:PrintInfo()
	
end

SWEP.NextPrimary = 0
function SWEP:PrimaryAttack()

	if self.NextPrimary > CurTime() then return end
	self.NextPrimary = CurTime() + 2
	
	if self:GetDTFloat(0) < self.NecromancerSpells[self:GetDTInt(1)].Mana then return end
	
	if SERVER then
	
		self.NecromancerSpells[self:GetDTInt(1)].Action(self.Owner)
		self:SetDTFloat(0, self:GetDTFloat(0)-self.NecromancerSpells[self:GetDTInt(1)].Mana)
		self.NextRegen = CurTime() +0.5
		
	end
	
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:Think()

	if SERVER then
	
	self.LastChange = self.LastChange or 0
	//Check for pressed keys
		for i, stuff in pairs(self.NecromancerSpells) do
			if stuff.Keys then
				if self.Owner:KeyDown(IN_ATTACK2) then
					if self.LastChange > CurTime() then return end
						if #stuff.Keys > 1 then
							if self.Owner:KeyDown(stuff.Keys[1]) and self.Owner:KeyDown(stuff.Keys[2]) then
								self:SetDTInt(1,i)
								self.LastChange = CurTime() + 0.1 //add small delay so we won't accidently switch spells when we are stopped moving or such
								break
							end
						else
							if self.Owner:KeyDown(stuff.Keys[1]) then
								self:SetDTInt(1,i)
								self.LastChange = CurTime() + 0.1
								break
							end
						end
				end
			end
		end
		//Check for regeneration
		self.NextRegen = self.NextRegen or 0 //this one checks that we cant regenerate mana right after using a spell
		if self.NextRegen > CurTime() then return end
		self.NextActualRegen = self.NextActualRegen or 0 //this one for adding a small delay between recharging mana each time
		if self.NextRegen > CurTime() then return end
		self.NextRegen = CurTime() + self.ManaRegenRate
		self:SetDTFloat(0,math.min(self.MaxMana,self.Weapon:GetDTFloat(0)+self.ManaRegenAmount))
			
	end//end of if SERVER
end

if CLIENT then

function SWEP:ViewModelDrawn()
	//drawing effect in here :o
	local vm = self.Owner:GetViewModel()
	
	if !IsValid(vm) then return end
	if not self.EnableWandEffect then return end
	
	if (self.NextEffect or 0) > CurTime() then return end //hopefully prevent crashes
	
	local bone = vm:LookupBone("Dummy15")
	
	if bone then
		local pos, ang = vm:GetBonePosition(bone)
		pos = pos + ang:Up()*12 - ang:Right()*5
		
		local emitter = ParticleEmitter(pos)
		
		local particle = emitter:Add( "particles/smokey", pos )
			particle:SetVelocity( Vector(math.Rand(-4,4)/3,math.Rand(-4,4)/3,1):GetNormal()*math.Rand( 1, 20 ) )
			particle:SetPos(pos+(ang:Up()*3-ang:Up()*particle:GetVelocity().z)*math.random(0,1))
			particle:SetDieTime( math.Rand(0.2,0.55) )
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize( math.Rand( 0, 2 ) )
			particle:SetEndSize( math.Rand( 4, 6 ) )
			particle:SetRoll( math.Rand( -0.7, 0.7 ) )
			particle:SetColor( 20, 20, 20 )
			particle:SetAirResistance(0)
			particle:SetCollide(true)			
			particle:SetBounce( 1 )
		
	end
	self.NextEffect = CurTime() + 0.15
end

local Spells = surface.GetTextureID ( "necromancer/spellselect" )
function SWEP:DrawHUD()

	if self.NecromancerSpells[self:GetDTInt(1)] then
		
		//draw small sweet hud for mana
		local wd,hg = 250, 60
		local sx,sy = ScrW()/2-wd/2, ScrH()-hg+5 //hide bottom border
		
		surface.SetDrawColor( 0, 0, 0, 150)
		surface.DrawRect(sx,sy,wd,hg)
	
		surface.DrawRect(sx+5 , sy+5,  wd-10, hg-10 )	
		
		if self:GetDTFloat(0) < self.NecromancerSpells[self:GetDTInt(1)].Mana then
			surface.SetDrawColor(199,15,15,255)
		else
			surface.SetDrawColor(128,135,136,255)
		end
		
		if not self.mul then self.mul = 0 end
		self.mul = math.Clamp(math.Approach (self.mul,self:GetDTFloat(0)/self.MaxMana,FrameTime() * 1.8),0,1)
		
		surface.DrawRect(sx+5 , sy+5,  (wd-10)*self.mul, hg-10 )	
	
		draw.SimpleTextOutlined(self.NecromancerSpells[self:GetDTInt(1)].Name, "ABold5", ScrW()/2, ScrH()-hg-10, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
		
		//uh. a bit messy but it works
		local sw, sh = surface.GetTextureSize( Spells )
		sw, sh = sw*1.35, sh*1.35
		local boxw,boxh = sw+10,sw+10
		
		if self.NecromancerSpells[self:GetDTInt(1)].SpellGrid then	
			
			local grid = self.NecromancerSpells[self:GetDTInt(1)].SpellGrid
			
			local gridstartX, gridstartY = ScrW()-boxw-10,ScrH()-boxh-10
			local gridX,gridY = grid[1], grid[2]
			
			gridstartX, gridstartY = gridstartX + gridX, gridstartY + gridY
			
			//make spell icons less transparent
			for i=1,#self.NecromancerSpells do
				local gr = self.NecromancerSpells[i].SpellGrid
				draw.RoundedBox(4,ScrW()-boxw-10+gr[1], ScrH()-boxh-10+gr[2],gr[3], gr[4],Color(0, 0, 0, 200))
			end
			
			surface.SetDrawColor( 255, 255, 255, 255)
			
			surface.SetTexture ( Spells )
			surface.DrawTexturedRect ( ScrW()-sw-20, ScrH()-sh-20, sw, sh ) 

			draw.RoundedBox(4,gridstartX, gridstartY,grid[3], grid[4],Color(40, 135, 40, 155))
		
		end
		
	end


end
end

function SWEP:OnRemove()

	if SERVER then
		self:SetDTFloat(0,0)
	end
	
	return true

end

function SWEP:SecondaryAttack()
	return false
end

/*-----------------------------
Actual spells down here

(note: always put spells that use 2 buttons at the beginning
and then spells that use 1 button :/
Because otherwise this spell selection can be messy a bit)
------------------------------*/

SWEP.NecromancerSpells = {}
	
//#1 Hex (curse)
SWEP.NecromancerSpells[1] = 
	{
	Name = "Hex",//name
	Mana = 40,//mana usage
	SpellGrid = {4,3,42,40},// x,y,w,h for spell selection gui
	Keys = {IN_FORWARD,IN_MOVELEFT},//mouse 2 + this key or keys to activate, nox style
	Action = function(pl) //what should it do, 'pl' is owner
	
		local tr = pl:GetEyeTrace()
		if tr.Hit and tr.Entity and tr.Entity:IsPlayer() and pl:GetPos():Distance(tr.Entity:GetPos()) < 400 then
			
			local spell = ents.Create ("spell_hex")
			if spell ~= nil and spell:IsValid() then
				spell:SetPos(tr.Entity:GetPos())		
				spell:SetOwner(pl)
				spell:SetParent(tr.Entity)
				spell:Spawn()
				spell:Activate()
			end
		end
		
	end
	
	}

//#2 Corpse Explosion
SWEP.NecromancerSpells[2] = 
	{
	Name = "Corpse Explosion",
	Mana = 15,
	SpellGrid = {123,4,45,39},
	Keys = {IN_FORWARD,IN_MOVERIGHT},
	Action = function(pl) 
		
		local Corpses = GetPossibleCorpses(pl)
		
		--PrintTable(Corpses)
		
		if #Corpses < 1 then return end
		
		for i, corpsedata in pairs(Corpses) do
			
			local CorpsePos, deadguy = corpsedata[1], corpsedata[2]
		
			local guys = ents.FindInSphere( CorpsePos+Vector(0,0,20), 130 )
			
			for k, guy in pairs(guys) do
				if guy:IsPlayer() then
					
					//exclude this guy from table so we can add it into filter
					local players = player.GetAll()
					local filterplayers = {}
					
					for _,dude in pairs(players) do
						if guy != dude then
							table.insert(filterplayers,dude)
						end
					end
					
					local trace = {}
					trace.start = CorpsePos+Vector(0,0,20)
					trace.endpos = guy:GetPos() + Vector ( 0,0,40 )
					trace.filter = filterplayers
					
					local tr = util.TraceLine( trace )
					
					if tr.Entity:IsValid() and tr.Entity == guy then
						local Dmg = DamageInfo()
						Dmg:SetAttacker(pl)
						Dmg:SetInflictor(pl:GetActiveWeapon())
						Dmg:SetDamage(math.random(20,35))
						Dmg:SetDamageType(DMG_BLAST)
						Dmg:SetDamagePosition(CorpsePos+Vector(0,0,20))	
						Dmg:SetDamageForce(((guy:GetPos()+Vector(0,0,20)) - (CorpsePos+Vector(0,0,20))):GetNormal()*math.random(200,400))
						
						guy:SetVelocity(((guy:GetPos()+Vector(0,0,60)) - (CorpsePos+Vector(0,0,20))):GetNormal()*math.random(200,400))
						
						guy:TakeDamageInfo(Dmg)
					end
				end
			end
			
			local ef = EffectData()
			ef:SetOrigin(CorpsePos+Vector(0,0,20))
			util.Effect("undead_explosion", ef,true,true)
			
			util.ScreenShake( CorpsePos+Vector(0,0,20), math.random(3,6), math.random(3,4), math.random(2,3), 110 )
			
			sound.Play("ambient/explosions/explode_"..math.random(7,9)..".wav",CorpsePos+Vector(0,0,20),90,math.random(80,110))
			
			local ef = EffectData()
			ef:SetOrigin(CorpsePos)
			ef:SetEntity(deadguy)
			util.Effect("corpse_explosion", ef,true,true)
			
			deadguy.DeathPos = nil
			
		end
	end
	}
	

	
//#3 Blood Well (healing ring)
SWEP.NecromancerSpells[3] = 
	{
	Name = "Blood Well",
	Mana = 55,
	SpellGrid = {5,113,41,42},
	Keys = {IN_BACK,IN_MOVELEFT},
	Action = function(pl)
	
		local CorpsePos, deadguy = GetPossibleCorpse(pl)	
		
		if not CorpsePos then return end
		
		local spell = ents.Create ("spell_bloodwall")
		if spell ~= nil and spell:IsValid() then
			spell:SetPos(CorpsePos + Vector(0,0,3))		
			spell:SetOwner(pl)
			spell:Spawn()
			spell:Activate()
			
			local ef = EffectData()
			ef:SetOrigin(CorpsePos)
			ef:SetEntity(deadguy)
			util.Effect("corpse_remove", ef,true,true)
			
			deadguy.DeathPos = nil
		end
		
	end
	
	}


//#4 Power Well
SWEP.NecromancerSpells[4] = 
	{
	Name = "Power Well",
	Mana = 65,
	SpellGrid = {125,113,41,42},
	Keys = {IN_BACK,IN_MOVERIGHT},
	Action = function(pl)
	
		local CorpsePos, deadguy = GetPossibleCorpse(pl)	
		
		if not CorpsePos then return end
		
		local spell = ents.Create ("spell_powerwall")
		if spell ~= nil and spell:IsValid() then
			spell:SetPos(CorpsePos + Vector(0,0,3))		
			spell:SetOwner(pl)
			spell:Spawn()
			spell:Activate()
			
			local ef = EffectData()
			ef:SetOrigin(CorpsePos)
			ef:SetEntity(deadguy)
			util.Effect("corpse_remove", ef,true,true)
			
			deadguy.DeathPos = nil
		end
		
	end
	
	}
	
//#5 Explosion around user
SWEP.NecromancerSpells[5] = 
	{
	Name = "Explosion", 
	Mana = 60, 
	SpellGrid = {64,2,42,40},
	Keys = {IN_FORWARD}, 
	Action = function(pl)
	
		local guys = ents.FindInSphere( pl:GetPos()+Vector(0,0,40), 130 )
		
		for k, guy in pairs(guys) do
			if guy:IsPlayer() and guy ~= pl then
			
				local trace = {}
				trace.start = pl:GetPos()+Vector(0,0,40)
				trace.endpos = guy:GetPos() + Vector ( 0,0,40 )
				trace.filter = pl
				local tr = util.TraceLine( trace )
				
				if tr.Entity:IsValid() and tr.Entity == guy then
					local Dmg = DamageInfo()
					Dmg:SetAttacker(pl)
					Dmg:SetInflictor(pl:GetActiveWeapon())
					Dmg:SetDamage(math.random(10,25))
					Dmg:SetDamageType(DMG_BLAST)
					Dmg:SetDamagePosition(pl:GetPos()+Vector(0,0,40))	
					Dmg:SetDamageForce(((guy:GetPos()+Vector(0,0,20)) - (pl:GetPos() + Vector ( 0,0,60 ))):GetNormal()*math.random(300,450))
					
					guy:SetVelocity(((guy:GetPos()+Vector(0,0,60)) - (pl:GetPos() + Vector ( 0,0,40 ))):GetNormal()*math.random(300,450))
					
					guy:TakeDamageInfo(Dmg)
				end
			end
		end
		
		local ef = EffectData()
		ef:SetOrigin(pl:GetPos()+Vector(0,0,40))
		util.Effect("undead_explosion", ef,true,true)
		
		util.ScreenShake( pl:GetPos()+Vector(0,0,40), math.random(3,6), math.random(3,4), math.random(2,3), 110 )
		
		pl:EmitSound("ambient/explosions/explode_"..math.random(7,9)..".wav",90,math.random(80,110))
	end
	}
	
//#6 Paralyze
SWEP.NecromancerSpells[6] = 
	{
	Name = "Paralyze",
	Mana = 65,
	SpellGrid = {5,56,41,43},
	Keys = {IN_MOVELEFT},
	Action = function(pl)
	
		local tr = pl:GetEyeTrace()
		if tr.Hit and tr.Entity and tr.Entity:IsPlayer() and pl:GetPos():Distance(tr.Entity:GetPos()) < 600 then
			
			local spell = ents.Create ("spell_paralyze")
			if spell ~= nil and spell:IsValid() then
				spell:SetPos(tr.Entity:GetPos())		
				spell:SetOwner(pl)
				spell:SetParent(tr.Entity)
				spell:Spawn()
				spell:Activate()
			end
		end
		
	end
	
	}
	
//#7 Swap Locations
SWEP.NecromancerSpells[7] = 
	{
	Name = "Swap Locations",
	Mana = 30,
	SpellGrid = {123,58,43,42},
	Keys = {IN_MOVERIGHT},
	Action = function(pl)
	
		local tr = pl:GetEyeTrace()
		if tr.Hit and tr.Entity and tr.Entity:IsPlayer() and pl:GetPos():Distance(tr.Entity:GetPos()) < 1000 then
		
			local pos, ang = pl:GetPos(), pl:GetAimVector():Angle()
			
			pl:SetPos(tr.Entity:GetPos())
			pl:SetEyeAngles(tr.Entity:GetAimVector():Angle())

			tr.Entity:SetPos(pos)
			tr.Entity:SetEyeAngles(ang)
			
			local ef = EffectData()
			ef:SetEntity(pl)
			util.Effect("swap_effect", ef,true,true)
			
			pl:EmitSound("ambient/levels/citadel/portal_beam_shoot6.wav",math.random(80,110),math.random(80,110))
		end

	end
	
	}
	
//#8 Raise Undead (here it comes!)
SWEP.NecromancerSpells[8] = 
	{
	Name = "Raise Undead",
	Mana = 50,
	SpellGrid = {65,113,41,42},
	Keys = {IN_BACK},
	Action = function(pl)
	
		local CorpsePos, deadguy = GetPossibleCorpse(pl)	
		
		if not CorpsePos then return end
		
		local ant = ents.Create ("npc_antlionguard")
		if ant ~= nil and ant:IsValid() then
			
			//push nearby players to prevent them from getting stuck
			local guys = ents.FindInSphere( CorpsePos+Vector(0,0,10), 150 )
			for k, guy in pairs(guys) do
				if guy:IsPlayer() then
					guy:SetVelocity(((guy:GetPos()+Vector(0,0,60)) - (CorpsePos + Vector ( 0,0,10 ))):GetNormal()*math.random(300,600))
				end
			end
			
			ant:SetPos(CorpsePos + Vector(0,0,3))
			for k,v in pairs ( player.GetAll() ) do
				if IsValid( v ) then
					ant:AddEntityRelationship(v, D_HT, 99 )
				end
			end
			--ant:SetKeyValue("spawnflags", "512") 
			ant:SetHealth(99999)
			ant:SetColor(Color(40,40,40,255))
			ant:Spawn()
			ant:Activate()
			
			local spell = ents.Create ("spell_raiseundead")
			if spell ~= nil and spell:IsValid() then
				spell:SetPos(ant:GetPos())		
				spell:SetOwner(pl)
				spell:SetParent(ant)
				spell:Spawn()
				spell:Activate()
			end
			
			util.ScreenShake( CorpsePos + Vector(0,0,3), math.random(3,6), math.random(3,4), math.random(2,3), 140 )
			
			local ef = EffectData()
			ef:SetOrigin(CorpsePos)
			ef:SetEntity(deadguy)
			util.Effect("corpse_remove", ef,true,true)
			
			deadguy.DeathPos = nil
		end
		//end
		
	end
	
	}
	

	
//hex effect here
if SERVER then	
	hook.Add("EntityTakeDamage", "IncreaseHexDamage",function(pl, dmginfo) 
		if pl:IsPlayer() then
			if pl.Cursed then
				dmginfo:SetDamage(dmginfo:GetDamage()*1.5) //take 50% more damage
			end
		end

	end)
end

//Some other stuff for 'detecting' dead bodies
//Since there is almost no way to predict on server where clientside corpse will be - i'll try to make a possible location

//Set or remove possible death position
if SERVER then	
	hook.Add("PlayerSpawn", "ResetDeathPosition",function(pl) 
		pl.DeathPos = nil
	end)
end

//Actually set it
if SERVER then	
	hook.Add("DoPlayerDeath", "SetDeathPosition",function(pl) 
		pl.DeathPos = pl:GetPos()
		--print(tostring(pl.DeathPos))
		
		//check if player was in the air
		local traceground = {}
		traceground.start = pl:GetPos()
		traceground.endpos = pl:GetPos() - Vector ( 0,0,30 )
		local tr1 = util.TraceLine( traceground )
		
		//if its true then move position to the ground where corpse possibly can be
		if not tr1.Hit then
			--print("in air")
			local traceground2 = {}
			traceground2.start = pl:GetPos()
			traceground2.endpos = pl:GetPos() - Vector ( 0,0,99999 )
			local tr2 = util.TraceLine( traceground2 )
			
			if tr2.HitWorld or tr2.Entity and not tr2.Entity:IsPlayer() then
				pl.DeathPos = tr2.HitPos + Vector(0,0,1)
			--	print("down to "..tostring(pl.DeathPos))
			end
		
		end
		//if there are any clientside corpses - they will be highlighted
		local ef = EffectData()
		ef:SetOrigin(pl.DeathPos)
		ef:SetEntity(pl)
		util.Effect("corpse_effect", ef,true,true)
	end)
end

//radius around death position where possibly can be clientside corpse and death position
//Note: make this radius a bit bigger than the one in clientside effects
PossibilityRadius = 165
if SERVER then

function GetPossibleCorpse(pl)

	local guys = player.GetAll()
	
	for i, dead in pairs(guys) do
		if not dead:Alive() then
			if dead.DeathPos then
				if pl:GetPos():Distance(dead.DeathPos) < PossibilityRadius then
					return dead.DeathPos,dead
				end
			end
		end
	end
	return nil
end

function GetPossibleCorpses(pl)

	local corpses = {}
	local guys = player.GetAll()
	
	for i, dead in pairs(guys) do
		if not dead:Alive() then
			if dead.DeathPos then
				if pl:GetPos():Distance(dead.DeathPos) < PossibilityRadius then
					table.insert(corpses, {dead.DeathPos,dead})
				end
			end
		end
	end
	return corpses
end

end

//Small function to show some tips

function SWEP:PrintInfo()
	
	if SERVER then
		self.Owner:ChatPrint("Small information about SWEP was printed in console!")
	end
	//uh oh
	if CLIENT then
		print("---Necromancer's Wand----\n")
		print("--------Controls---------\n")
		print("*Cast a spell: Press left mouse button")
		print("*Select a spell: Hold down right mouse button and press WASD keys (you can combine 2 buttons to select spells at the corners!)\n\n")
		print("--------Mana info--------\n")
		print("*Each spell requires a mana that shown as small bar on the bottom part of your screen")
		print("*Obliviously mana regenerates over time\n\n")
		print("--------Spell Tips-------\n")
		print("*Some spells will require you to stand near corpse of player or his death position")
		print("*Both corpse and death position will be highlighted with small stream of smoke")
		print("*Spells like (Hex, Paralyze and Swap Location) should be aimed directly at the other player\n\n")
		print("----Spell Description----\n")
		print("*Explosion: Makes a small explosion around user")
		print("*Swap Locations: Teleports user at the position of selected player")
		print("*Paralyze: Traps selected player in a small box for a short time")
		print("*Hex: Selected player will take 50% more damage for a short time")
		print("*Corpse Explosion: Causes all nearby corpses to explode")
		print("*Blood Well: Creates a healing field for user for a short time")
		print("*Power Well: Creates a magic field that damages any other players inside for a short time\n\n")
		print("--------Other info-------\n")
		print("*This SWEP is designed ONLY for multiplayer and it will work only on/with other players. No NPC support, sorry :<\n")
	end

end
