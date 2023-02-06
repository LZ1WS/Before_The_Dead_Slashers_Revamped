
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
local ShouldSetOwner = true
ENT.Deployed = 0
ENT.Exploded = false
ENT.LASER = 1
ENT.Setup        = false

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create( "predator_thrown_lasermine" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent:GetOwner(self.MineOwner)

	return ent
	
end

function ENT:Initialize()
	
	self.Entity:SetModel( "models/predatorremotemine.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow(false)
--	self.Entity:SetModelScale( 0.5, 0 )
	 
	local phys = self.Entity:GetPhysicsObject()
	
		  if (phys:IsValid()) then
			phys:Wake()
		  end
		self.Hit = false
		
	self:SetDTFloat( 0, math.Rand( 0.5, 1.3 ) )
	self:SetDTFloat( 1, math.Rand( 0.3, 1.2 ) )
	
end

function ENT:SetupDataTables()

	self:DTVar( "Float", 0, "RotationSeed1" )
	self:DTVar( "Float", 1, "RotationSeed2" )

end

function ENT:Explode()

	self.Entity:EmitSound( "ambient/explosions/explode_4.wav" )
	self.Entity:SetOwner(self.MineOwner)
	self.Deployed = 0	


	
	local detonate = ents.Create( "env_explosion" )
		detonate:SetOwner(self.MineOwner)
		detonate:SetPos( self.Entity:GetPos() )
		detonate:SetKeyValue( "iMagnitude", "135" )
		detonate:Spawn()
		detonate:Activate()
		detonate:Fire( "Explode", "", 0 )
	
	local shake = ents.Create( "env_shake" )
		shake:SetOwner( self.Owner )
		shake:SetPos( self.Entity:GetPos() )
		shake:SetKeyValue( "amplitude", "2000" )
		shake:SetKeyValue( "radius", "400" )
		shake:SetKeyValue( "duration", "2.5" )
		shake:SetKeyValue( "frequency", "255" )
		shake:SetKeyValue( "spawnflags", "4" )
		shake:Spawn()
		shake:Activate()
		shake:Fire( "StartShake", "", 0 )
	local minepos = self.Entity:GetPos()

	self.Entity:Remove()	
		for k,v in pairs(ents.FindInSphere(minepos,100)) do
		if v:GetClass() == "predator_thrown_lasermine" then
			if !v:GetOwner():IsValid() then
				timer.Simple(0.1,function()
					if (type(v.Explode) == "function") then
						v:Explode()
					end
				end)
			end	
		end
	end
end

	function ENT:PhysicsCollide(data,phys)	
	self:EmitSound("weapons/slam/mine_mode.wav")
	timer.Simple( 0.4, function() 
	self:EmitSound("buttons/button5.wav")
	end)	
	self.Deployed = 1	

	
		if self:IsValid() && !self.Hit then
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			self.Hit = true
		end	
		
		if data.HitEntity:IsWorld() == false and data.HitEntity:GetClass() ~= "predator_thrown_lasermine" and data.HitEntity:IsNPC() == false and data.HitEntity:IsPlayer() == false and  data.HitEntity:IsValid() then
		self:SetSolid(SOLID_NONE)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetParent(data.HitEntity)
		self.Stuck = true
		self.Hit = true
		end
		
		if data.HitEntity:IsWorld() then
				self:SetMoveType(MOVETYPE_NONE)
		end
		
		local angs = self:GetAngles()
	--	self:SetAngles(Angle(0,0,0))
		local ang = data.HitNormal:Angle()
        ang.p = ang.p + 90		
		self:SetPos(data.HitPos + ((data.HitNormal / 5) * -11))
		local pos = self.MineOwner:GetPos() - self:GetPos()
		local normalized = pos:Angle()
		if (ang.p == 180 and ang.y == 0 and ang.r == 0) or (ang.p == 360 and ang.y == 0 and ang.r == 0) then
			self:SetAngles(Angle(0,normalized.y,0))
		else
			self:SetAngles(ang)
		end
		timer.Simple(.001,function() 
		local get = self:GetPos()
		-- print(math.Round(get.x,-2))
		-- local rounded = math.Round(get.x,-2)
		-- self:SetPos(Vector(rounded,get.y,get.z))
		
		local getx = get.x
		local gety = get.y
		local getz = get.z
		
		local roundx = math.Round(get.x,-2)
		local roundy = math.Round(get.y)
		local roundz = math.Round(get.z)
		
		 -- if roundy > roundx and roundy > roundz then
		-- self:SetPos(Vector(getx,roundy,getz))
		 -- elseif roundx > roundy and roundx > roundz then
		 -- self:SetPos(Vector(roundx,gety,getz))
		-- elseif self:GetAngles() == Angle(360,0,0) then
		-- self:SetPos(oldpos + Vector(0,0,8))
		-- elseif self:GetAngles() == Angle(90,90,0) then
		-- self:SetPos(oldpos + Vector(0,15,0))
		-- elseif self:GetAngles() == Angle(90,270,0) then
		-- self:SetPos(oldpos + Vector(0,-18,0))
		-- elseif self:GetAngles() == Angle(90,180,0) then
		-- self:SetPos(oldpos + Vector(-15,0,0))
--		 end
--		print(self:GetAngles())
		
		
		end)
	end

function ENT:OnTakeDamage( dmginfo )
	self.Entity:TakePhysicsDamage( dmginfo )
	
end

function ENT:Touch(ent)
		if IsValid(ent) && !self.Stuck then
		if ent == self.MineOwner then return false end
			if ent:IsNPC() || (ent:IsPlayer() && ent != self:GetOwner()) || ent:IsVehicle() then
				self:SetSolid(SOLID_NONE)
				self:SetMoveType(MOVETYPE_NONE)
				self:SetParent(ent)
				self.Stuck = true
				self.Hit = true
				self.Deployed = 1
			end
		end
end


function ENT:Use( activator, caller )
-- if activator == self.MineOwner then
-- self.Hit = false
-- self.Stuck = false
-- self:Remove()
-- if activator:HasWeapon("cod-c4") == false then activator:Give("cod-c4") end
-- activator:GiveAmmo(1,"slam")
-- end
end

function ENT:Think()




local pos = self:GetPos()
local ang = Angle(self:GetAngles().x,self:GetAngles().y,self:GetAngles().z) + Angle(0,-90,0)
local tracedata = {}
tracedata.start = pos
tracedata.endpos = self:GetPos() + self:GetRight() * -100
tracedata.filter = self
local trace = util.TraceLine(tracedata)

local pos1 = self:GetPos()
local ang1 = Angle(self:GetAngles().x,self:GetAngles().y,self:GetAngles().z) + Angle(0,-90,0)
local tracedata1 = {}
tracedata1.start = pos1
tracedata1.endpos = self:GetPos() + self:GetUp() * -130 + self:GetForward() * 80 + self:GetRight() * 70 + Vector(0,0,11)
tracedata1.filter = self
local trace1 = util.TraceLine(tracedata1)

local pos2 = self:GetPos()
local ang2 = Angle(self:GetAngles().x,self:GetAngles().y,self:GetAngles().z) + Angle(0,-90,0)
local tracedata2 = {}
tracedata2.start = pos2
tracedata2.endpos = self:GetPos() + self:GetUp() * -150 + self:GetForward() * -70 + Vector(0,0,11)
tracedata2.filter = self
local trace2 = util.TraceLine(tracedata2)

local pos3 = self:GetPos()
local ang3 = Angle(self:GetAngles().x,self:GetAngles().y,self:GetAngles().z) + Angle(0,-90,0)
local tracedata3 = {}
tracedata3.start = pos3
tracedata3.endpos = self:GetPos() + self:GetUp() * -130 + self:GetForward() * 80 + self:GetRight() * -70 + Vector(0,0,11)
tracedata3.filter = self
local trace3 = util.TraceLine(tracedata3)

if self.Deployed == 1 then
	if trace2.HitNonWorld or trace1.HitNonWorld or trace3.HitNonWorld or trace.HitNonWorld then
   target3 = trace3.Entity 
   target2 = trace2.Entity 
   target1 = trace1.Entity 
   target = trace.Entity
	if target2:IsValid() or target1:IsValid() or target3:IsValid() or target:IsValid() then
		if target1 ~= self.MineOwner and target2 ~= self.MineOwner and target3 ~= self.MineOwner and target ~= self.MineOwner then

		self:Explode()

		end
	end
	end
	else return end


   self:NextThink( CurTime() + 0.001 )
    return true

end