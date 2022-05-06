function EFFECT:Init( data )

	//instead of env_explosion or 'Explosion' effect lets make our own
	local pos = data:GetOrigin()
	local originalpos = pos
	
	local emitter = ParticleEmitter(pos)
	
	local speed = math.Rand(200, 400)
	
	//some repeating code below
	for i=1, math.random(25,40) do
		local rad = math.random(0,360)
		local arrivepos = pos
		
		arrivepos = Vector(arrivepos.x + math.sin( CurTime()*3+math.rad( rad ) ) * 45,arrivepos.y + math.cos( CurTime()*3+math.rad( rad) ) * 45,arrivepos.z)
		
		pos.z = pos.z + math.random(-6,6)
		
		local particle = emitter:Add("effects/fire_cloud"..math.random(1,2), pos + VectorRand() * 3)
		local dir = (pos - arrivepos):GetNormal()
		particle:SetVelocity(dir * speed )
		particle:SetDieTime(math.Rand(2.0, 3.25))
		particle:SetStartAlpha(220)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(30,60))
		particle:SetEndSize(10)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetAirResistance(124)
		particle:SetGravity(Vector(0,0,-9))
	end
	for i=1, math.random(10,20) do
		local rad = math.random(0,360)
		local arrivepos = pos
		
		arrivepos = Vector(arrivepos.x + math.sin( CurTime()*3+math.rad( rad ) ) * 45,arrivepos.y + math.cos( CurTime()*3+math.rad( rad) ) * 45,arrivepos.z)

		pos.z = pos.z + math.random(-6,6)
		
		local particle = emitter:Add("effects/fire_embers"..math.random(1,2), pos + VectorRand() * 3)
		local dir = (pos - arrivepos):GetNormal()
		particle:SetVelocity(dir * speed )
		particle:SetDieTime(math.Rand(2.0, 3.25))
		particle:SetStartAlpha(220)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(30,40))
		particle:SetEndSize(5)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetAirResistance(124)
		particle:SetGravity(Vector(0,0,-9))
	end
	for i=1, math.random(15, 20) do
		local rad = math.random(0,360)
		local arrivepos = pos
		
		arrivepos = Vector(arrivepos.x + math.sin( CurTime()*3+math.rad( rad ) ) * 45,arrivepos.y + math.cos( CurTime()*3+math.rad( rad) ) * 45,arrivepos.z)

		pos.z = pos.z + math.random(-6,6)
	
		local particle = emitter:Add("particle/smokestack", pos)
		local dir = (pos - arrivepos):GetNormal()
		particle:SetVelocity(dir * (speed*0.8))
		particle:SetDieTime(math.Rand(2.7, 3.0))
		particle:SetStartAlpha(220)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(20,40))
		particle:SetEndSize(4)
		particle:SetColor(20, 20, 20)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetAirResistance(124)
	end
	

end

function EFFECT:Think()
return false
end

function EFFECT:Render()
return false
end