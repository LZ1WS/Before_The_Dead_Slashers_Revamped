AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
function ENT:OnRemove()
	disable(self)
end
function ENT:Initialize()
	self:SetModel("models/predatorbattledisc.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()

	if phys:IsValid() then

		phys:Wake()

	end


end
	

	
function bezier(startVec, control, endVec, ratio)
	return Vector(
		(1-ratio)^2 * startVec[1] + (2 * (1-ratio) * ratio * control[1]) + ratio^2 * endVec[1],
		(1-ratio)^2 * startVec[2] + (2 * (1-ratio) * ratio * control[2]) + ratio^2 * endVec[2],
		(1-ratio)^2 * startVec[3] + (2 * (1-ratio) * ratio * control[3]) + ratio^2 * endVec[3]
		)
end

function flycurve(Start, Modify, Dst, DirectionAng, Ratio)
	local Pitch = DirectionAng.x
	local MPitch = math.Clamp(1-math.Clamp(math.abs(Pitch*1.5) / 90,0,1),0.15,1)
	local Mid = Start-DirectionAng:Right()*(Dst*MPitch)+Modify
	local M2 = Start-DirectionAng:Right()*(Dst*0.05)+DirectionAng:Forward()*Dst*1.5*math.Clamp(MPitch,0.2,1)+Modify/2
	local M1 = Start-DirectionAng:Right()*(Dst*0.5)-DirectionAng:Forward()*Dst+Modify/2
	if Ratio <= 0.5 then
		return bezier(Start-Vector(0,0,2), M2, Mid, Ratio/0.5)
	else
		return bezier(Mid, M1, Start-Vector(0,0,40)+DirectionAng:Right()*25, (Ratio-0.5)*2)
	end
end

function flycurvedown(Start, Modify, Dst, DirectionAng, Ratio, selfe)
	local hotfix = DirectionAng:Right()*35
	local Start = Start + hotfix
	local Dst = math.Clamp(Dst,1200,Dst)
	local durchgang = selfe:GetNWInt('Durchgang')
	local Pitch = DirectionAng.x
	local MPitch = math.Clamp(1-math.Clamp(math.abs(Pitch*1.5) / 90,0,1),0.15,1)
	local Mid = Start-DirectionAng:Right()*(Dst*MPitch)-Vector(0,0,500+durchgang*100)
	local M2 = Start-DirectionAng:Right()*(Dst*0.5)+DirectionAng:Forward()*Dst*1.5*math.Clamp(MPitch,0.2,1)-Vector(0,0,500+durchgang*100)/2
	local M1 = Start-DirectionAng:Right()*(Dst*0.5)-DirectionAng:Forward()*Dst-Vector(0,0,800+durchgang*100)
	if Ratio <= 0.5 then
		return bezier(Start, M2, Mid, Ratio/0.5)
	else
		return bezier(Mid, M1, Start-Vector(0,0,1100+durchgang*100), (Ratio-0.5)*2)
	end
end

function step(Dst,selfe)
	local SDst = 0
	while SDst<=Dst do
	local poslast = flycurve(selfe:GetNWVector('startpos'), Vector(0,0,500),1500,selfe:GetNWAngle('startang'),selfe:GetNWInt('Ratio'))
	local Ratio = selfe:GetNWInt('Ratio')+0.001
	selfe:SetNWInt('Ratio',Ratio)
	local posnow = flycurve(selfe:GetNWVector('startpos'), Vector(0,0,500),1500,selfe:GetNWAngle('startang'),Ratio)
	SDst = SDst + poslast:Distance(posnow)
	end
end

function ENT:PhysicsUpdate( phys )
if oldcurveboomerang then
	local fang = self.Owner:GetNWAngle('startang')
	ziel = self:GetNWVector('startpos') 
	if ziel:IsZero() then do return end end
	local phy = self:GetPhysicsObject()
	local ta = (ziel-self:GetPos()):Angle()
	if self:WaterLevel()>0 then 
	if self:GetNWInt('Bow')<2 then
		disable(self)
		self:SetNWInt('Bow',2)
		self:GetPhysicsObject():EnableGravity(true)
		//self:StopSound("spinloop1.wav")
		
	end
	end

	if self:GetNWInt('Bow')==0 then
		self:GetPhysicsObject():ApplyForceCenter((ta:Forward()+Vector(0,0,0.2)+ta:Right()*(0.3*(math.Clamp(self:GetVelocity():Length()-100,0,200))/100))*phy:GetMass()*3)
		if self:GetVelocity():Length()<230 then
			self:SetNWInt('Bow',1)
			//print("Bow 1")
		end
	elseif self:GetNWInt('Bow')==1 then
	local tfo = self:GetVelocity()*phy:GetMass()
	local tfo = tfo - tfo*2
	if ziel:Distance(self:GetPos())>820 then
	self:GetPhysicsObject():ApplyForceCenter(ta:Forward()*phy:GetMass()*3)	
	else
	self:GetPhysicsObject():ApplyForceCenter(ta:Forward()*phy:GetMass()*5)		
	end
	end

else
	if self:GetNWInt('state')>0 then 
	if self:WaterLevel()>0 then 
	if self:GetNWInt('Bow')<2 then
		disable(self)
	end
	end
	end
	if self:GetNWInt('state')==1 then 
		local owner = self:GetNWEntity('owner')
		local up = self:GetNWAngle('startang'):Up()
		local upz = Vector(0,0,up.z)*40
		local position = flycurve(self:GetNWVector('startpos'), upz,radiusboomerang,self:GetNWAngle('startang'),self:GetNWInt('Ratio'))
		if position:Distance(self:GetPos())<50 then step(curvedetailboom,self) local position = flycurve(self:GetNWVector('startpos'), upz,radiusboomerang,self:GetNWAngle('startang'),self:GetNWInt('Ratio')) end
		local Ratio = self:GetNWInt('Ratio')//+0.002		
		if position:Distance(self:GetPos())<50 then
			//self:SetNWInt('Ratio',Ratio)
		else
			self:GetPhysicsObject():ApplyForceCenter(-self:GetVelocity()*self:GetPhysicsObject():GetMass()*0.05)
		end
		local ta = (position-self:GetPos()):Angle()
		//self:SetPos(self:GetNWVector('startpos'))
		//self:SetPos(flycurve(self:GetNWVector('startpos'), Vector(0,0,500),radiusboomerang,self:GetNWAngle('startang'),0.002))
		self:GetPhysicsObject():ApplyForceCenter(ta:Forward()*self:GetPhysicsObject():GetMass()*0.0491803278*speedboom)
		//owner:ChatPrint(self:GetVelocity():Length())

		if Ratio>=1 then
			self:SetNWInt('state',2)
			self:SetNWInt('Ratio',0.04)
			self:SetNWVector('startpos', self:GetPos())
		end

	end
	if self:GetNWInt('state')==2 then
		local durchgang = self:GetNWInt('Durchgang')
		local owner = self:GetNWEntity('owner')
		local position = flycurvedown(self:GetNWVector('startpos'), Vector(0,0,0),radiusboomerang-100-durchgang*100,self:GetNWAngle('startang'),self:GetNWInt('Ratio'),self)
		if position:Distance(self:GetPos())<50 then step(curvedetailboom,self) local position = flycurvedown(self:GetNWVector('startpos'), Vector(0,0,0),radiusboomerang-100-durchgang*100,self:GetNWAngle('startang'),self:GetNWInt('Ratio'),self) end
		local Ratio = self:GetNWInt('Ratio')//+0.002		
		if position:Distance(self:GetPos())<50 then
			//self:SetNWInt('Ratio',Ratio)
		else
			self:GetPhysicsObject():ApplyForceCenter(-self:GetVelocity()*self:GetPhysicsObject():GetMass()*0.05)
		end
		local ta = (position-self:GetPos()):Angle()
		//self:SetPos(self:GetNWVector('startpos'))
		//self:SetPos(flycurvedown(self:GetNWVector('startpos'), Vector(0,0,0),radiusboomerang-100-durchgang*100,self:GetNWAngle('startang'),0.002,self))
		self:GetPhysicsObject():ApplyForceCenter(ta:Forward()*self:GetPhysicsObject():GetMass()*0.0491803278*speedboom)
		//owner:ChatPrint(self:GetVelocity():Length())

		if Ratio>=1 then
			self:SetNWInt('Ratio',0)
			self:SetNWInt('Durchgang', self:GetNWInt('Durchgang')+1)
			self:SetNWVector('startpos', self:GetPos())			
		end


	end
	//self:GetNWEntity('owner'):ChatPrint(self:GetNWInt('state') )
end

end

function ENT:PhysicsCollide( data, phys)
	if self.Sound  then
		self.Sound:Stop()
		self.Sound=false
	end
	local speed = data["Speed"] //max 900
	if ( data.Speed > 50 ) then self:EmitSound( Sound( "Flashbang.Bounce" ), 100,100,0.0000001) end
	if (self:GetNWInt('thrown')>0 and oldcurveboomerang==true) or self:GetNWInt('state')>0 then
		local hite = data["HitEntity"]
		if hite:IsNPC() or hite:IsPlayer() or hite:GetClass()=="prop_physics" then
			local owner = self:GetNWEntity("owner")
			local swep = self
			local damage = 150
				

			hite:TakeDamage(damage,owner,swep)	

		end
		

		local hite = data["HitEntity"]
		self:SetPos(data["HitPos"])
		
		if hite:GetClass()=="worldspawn" then
			self:SetMoveType(MOVETYPE_NONE)
			self:EmitSound("physics/metal/sawblade_stick1.wav")
			disable(self)	
		elseif not hite:IsNPC() and not hite:IsPlayer() or hite:GetClass()=="prop_physics" then
			self:SetParent(hite)
			self:EmitSound("physics/metal/sawblade_stick1.wav")
		elseif string.find(hite:GetClass(),"npc") or hite:GetClass()=="player" then
			self:EmitSound("physics/flesh/flesh_squishy_impact_hard2.wav")
			
		end

		//self:SetPersistent(true)
		
	
	end


end

function ENT:OnTakeDamage( info )
	if (self:GetNWInt('thrown')>0 and oldcurveboomerang==true) or self:GetNWInt('state')>0 then
		disable(self)
	end
end

function ENT:Use( activator, caller )

	if IsValid( caller ) and caller:IsPlayer() and not caller:HasWeapon('predator_smartdisk') then
		disable(self)
		caller:Give("predator_smartdisk")
		caller:SelectWeapon("predator_smartdisk")
		self:Remove()
	end
end


function disable(selfe)
	if selfe.Sound  then
		selfe.Sound:Stop()
		selfe.Sound=false
	end
	selfe:SetNWAngle( 'startang', Angle(0,0,0))
	selfe:SetNWVector('startpos', Vector(0,0,0))
	selfe:SetNWEntity('owner', Entity(0))
	selfe:SetNWInt('state',0)
	selfe:SetNWInt('Bow',0)
	selfe:GetPhysicsObject():EnableGravity(true)
end