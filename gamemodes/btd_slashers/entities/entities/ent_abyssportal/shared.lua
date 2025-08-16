ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Demogorgon Portal"
ENT.AutomaticFrameAdvance = true -- important thingy actually for sequences
ENT.Spawnable = false
ENT.Category = "Other"

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "Active" )
	self:NetworkVar( "Float", 0, "HealthPortal" )

end

function ENT:GetOffset()
	return self:GetNWVector( "Offset" )
end

list.Set( "UpsideDownEffect", "magicabyss", {
	thruster_effect = "magicsparks",
	effectThink = function( self )

		local vOffset = self:LocalToWorld( self:GetOffset() )
		local vNormal = ( vOffset - self:GetPos() ):GetNormalized()

		local size = self:OBBMaxs() - self:OBBMins()

		vOffset = vOffset + VectorRand() * math.min( size.x, size.y ) / 5

		local emitter = self:GetEmitter( vOffset, false )
		if ( !IsValid( emitter ) ) then return end

		local particle = emitter:Add( "sprites/gmdm_pickups/light", vOffset )
		if ( !particle ) then return end

		particle:SetVelocity( vNormal + vector_up * 10)
		particle:SetDieTime( 2 )
		particle:SetColor( 255, 125, 0)
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 255 )
		particle:SetStartSize( math.Rand( 1, 3 ) )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( -0.2, 0.2 ) )

	end
} )

function ENT:Initialize()

	if SERVER then
		self:SetActive( false )
	end

	self:SetSequence( 1 ) -- well i guess thats work fine, if ignore some fact that other anims doesnt play

	self.ScanningSound = CreateSound(self, "weapons/demo/sfx_qatar_portal_idle_loop_02.ogg")
	self.RepeatSound = 0

end

function ENT:Draw()

	if SERVER then return end
	
	if !IsValid(LocalPlayer():GetActiveWeapon()) then return end
	
	self:DrawShadow(false)
	
	if self:GetActive() or LocalPlayer():GetActiveWeapon():GetClass() == "demogorgon_claws" then
		self:DrawModel()
		self:DrawShadow()
	end
	
	
	
end

if ( CLIENT ) then
	--[[---------------------------------------------------------
		Use the same emitter, but get a new one every 2 seconds
			This will fix any draw order issues
	-----------------------------------------------------------]]
	function ENT:GetEmitter( Pos, b3D )

		if ( self.Emitter ) then
			if ( self.EmitterIs3D == b3D && self.EmitterTime > CurTime() ) then
				return self.Emitter
			end
		end

		if ( IsValid( self.Emitter ) ) then
			self.Emitter:Finish()
		end

		self.Emitter = ParticleEmitter( Pos, b3D )
		self.EmitterIs3D = b3D
		self.EmitterTime = CurTime() + 2
		return self.Emitter

	end
end

function ENT:Think()
	
	if ( SERVER ) then -- Only set this stuff on the server
		self:NextThink( CurTime() ) -- Set the next think for the serverside hook to be the next frame/tick
		return true -- Return true to let the game know we want to apply the self:NextThink() call
	end
	
	if SERVER then return end -- Well, Im not sure is it right to trust there a CLIENT, but i think its better for optimisation, so we wont disturb SERVER so much
	
	if !self:GetActive() then return end
	
	if IsValid(LocalPlayer():GetActiveWeapon()) then 
		if LocalPlayer():GetActiveWeapon():GetClass() == "demogorgon_claws" then
		
			if CurTime() < LocalPlayer():GetActiveWeapon():GetNextTraverse() then return end
		
		end
	end

	for id, t in pairs( list.GetForEdit( "UpsideDownEffect" ) ) do

		t.effectThink( self )

		break
	end
	
	if self.RepeatSound <= CurTime() then
		self.ScanningSound:Stop() 
		self.RepeatSound = CurTime() + 14
	end
	
	self.ScanningSound:PlayEx(0.55, 100)
	
	--if !self:GetActive() then return end
	
	for k,v in pairs (ents.GetAll()) do	
		if v:IsPlayer() or v:IsNPC() then
			if ((self:GetPos() - v:GetPos()):Length()) < 256 then
				v.CloseToTheAbyss = true
			else
				v.CloseToTheAbyss = nil
			end
		end
	end
	/*for k,v in pairs (ents.GetAll()) do
		v.CloseToTheAbyss = nil -- well there we are nilling if ent gonna be far from portal
		hook.Remove( "RenderScreenspaceEffects", "FishEyeEffect")
	end
	
	for k,v in pairs (ents.FindInSphere(self:GetPos(), 128)) do 
		if v:IsPlayer() or v:IsNPC() then
			v.CloseToTheAbyss = true
			print(self)
			if v:IsPlayer() then 
			hook.Add( "RenderScreenspaceEffects", "FishEyeEffect", function()

				DrawMaterialOverlay( "models/props_combine/com_shield001a", 0 )

			end )

			end
		end
	end*/

end

function ENT:OnRemove()

	if CLIENT then
		
		self.ScanningSound:Stop()
		LocalPlayer():EmitSound("weapons/demo/sfx_qatar_portal_destroyed_warning_01.ogg")
		LocalPlayer():EmitSound("weapons/demo/sfx_qatar_portal_destroyed_warning_02.ogg")
		
	else
		
		local owner = self:GetOwner()
		
		local wpn = owner:GetWeapon( "demogorgon_claws" )
		
		wpn:SetPortalsLeft(wpn:GetPortalsLeft() + 1)

	end

end