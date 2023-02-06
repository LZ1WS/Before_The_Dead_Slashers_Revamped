function EFFECT:Init( data )

	local pos = data:GetOrigin()
	pos = pos +Vector(0,0,10)
	
	local emitter = ParticleEmitter(pos)
	
	local speed = math.Rand(200, 450)
	
	for i=1, math.random(30,40) do
		local rad = math.random(0,360)
		local arrivepos = pos
		
		arrivepos = Vector(arrivepos.x + math.sin( CurTime()*3+math.rad( rad ) ) * 45,arrivepos.y + math.cos( CurTime()*3+math.rad( rad) ) * 45,arrivepos.z+10)
		
		pos.z = pos.z + math.random(-1,1) + i/math.random(4,6)
		
		local particle = emitter:Add("particle/smokestack", pos + VectorRand() * 3)
		local dir = (pos - arrivepos):GetNormal()
		particle:SetVelocity(dir * speed )
		particle:SetDieTime(math.Rand(2.0, 4.25))
		particle:SetColor(20,20,20)
		particle:SetStartAlpha(250)
		particle:SetEndAlpha(10)
		particle:SetStartSize(math.random(12,16))
		particle:SetEndSize(math.random(30,60))
		particle:SetRoll(math.Rand(-360, 360))
		particle:SetRollDelta(math.Rand(-3, 3))
		particle:SetAirResistance(84)
		particle:SetGravity(Vector(0, 0, -60))
	end

end

function EFFECT:Think()
return false
end

function EFFECT:Render()
return false
end