function EFFECT:Init(data)

	HumanGibs = {"models/gibs/HGIBS.mdl",
	"models/gibs/HGIBS_spine.mdl",
	"models/gibs/HGIBS_rib.mdl",
	"models/gibs/HGIBS_scapula.mdl",
	}

	local modelid = table.Count( HumanGibs )
	self.Entity:SetModel(HumanGibs[ math.random( modelid ) ])

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )


	if modelid > 4 then
		self.Entity:SetMaterial("models/flesh")
	end

	local phys = self.Entity:GetPhysicsObject()
	if ( phys && phys:IsValid() ) then
	
		phys:Wake()
		phys:SetAngles( Angle( math.random(0,359), math.random(0,359), math.random(0,359) ) )
		phys:SetVelocity( (data:GetNormal() * 2 + VectorRand() * 1/4 + Vector(0,0,math.random(0,3)) * 3/8) *  math.random( 50, 200 ) )
	
	end
	self.Time = CurTime() + math.random(8, 10)
end

function EFFECT:Think()
	if CurTime() > self.Time then
		return false
	end
	return true
end

function EFFECT:Render()
	self.Entity:DrawModel()
end
