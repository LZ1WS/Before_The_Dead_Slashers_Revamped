SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
 
SWEP.PrintName = "Wristblade"
 
SWEP.Slot = 1
SWEP.SlotPos = 1
 
SWEP.Category = "PREDATOR"
 
SWEP.Spawnable = true 
SWEP.AdminSpawnable = true 

SWEP.ViewModelFOV = 70
SWEP.ViewModel = "models/viewmodels/c_pred_wristblade.mdl" 
SWEP.WorldModel = "models/predatorremotemine.mdl" 
SWEP.UseHands			= true	
SWEP.HoldType = "fist"	
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false 

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Damage = 70
SWEP.Primary.Cone = 10
 
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = "none" 
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Damage = 50
SWEP.guardbroken = false
SWEP.Noanim = false
SWEP.guard = false
SWEP.OnLeap = false
SWEP.Cloak = false
SWEP.CloakToggle = false


SWEP.WElements = {
	["Rblade"] = { type = "Model", model = "models/pred_claws.mdl", bone = "ValveBiped.Bip01_R_Forearm", rel = "", pos = Vector(28.791, 1.876, 43.249), angle = Angle(180, 92.115, -51.362), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )

	// other initialize code goes here

	if CLIENT then
	
		// Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) // create worldmodels
		
		// init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				// Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					// we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
					// ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					// however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end

end

function SWEP:Holster()
	
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			// !! WORKAROUND !! //
			// We need to check all model names :/
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	/**************************
		Global utility code
	**************************/

	// Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
	// Does not copy entities of course, only copies their reference.
	// WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end

function SWEP:Think()


if 	self.Owner:OnGround()  then
	--timer.Stop( "LeapAttack" )
	if 	self.Owner.OnLeap == true then
	self.Weapon:SendWeaponAnim( ACT_VM_DRYFIRE )
	self:SetWeaponHoldType( "fist"	)
	self.Owner.OnLeap = false
	end


end
	
	if self.Owner:KeyReleased(IN_ATTACK2) then

	if self.Owner.LeapFinish == true then
	if self.Owner.OnLeap == false then

	self.Weapon:SendWeaponAnim( ACT_VM_THROW )
	self:SetWeaponHoldType( "pistol")	
	self.Owner.LeapFinish = false	

	
local Playeraim = self.Owner:GetAimVector()
--Msg( tostring( Playeraim.x ) .. "\n" )
--Msg( tostring( Playeraim.y ) .. "\n" )
--Msg( tostring( Playeraim.z ) .. "\n" )
	

	PlayeraimX = (Playeraim.x * 1000 )
	PlayeraimY = (Playeraim.y * 1000 )


	self.Owner:SetVelocity( Vector( PlayeraimX, PlayeraimY, 250 ) )

	timer.Create( "LeapAttack", 0.1, 0, function() 
		local trace = self.Owner:GetEyeTrace();
		--if trace.HitNonWorld == true then
		if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 100 then									
                                bullet = {}
                                bullet.Num    = 0
                                bullet.Src    = self.Owner:GetShootPos()
                                bullet.Dir    = self.Owner:GetAimVector()
                                bullet.Spread = Vector(0, 0, 0)
                                bullet.Tracer = 0
                                bullet.Force  = 80
                                bullet.Damage = math.random(150,200)
                        self.Owner:FireBullets(bullet)
						self.Weapon:EmitSound("bladessound1.wav",100, math.random(95,105))
		else
		
        end	
		--end
	end )	
	
	self.Owner.OnLeap = true
 
    end
end	
end
	
	
	if self.Owner:KeyPressed(IN_ATTACK2) then
	
	if self.Owner.OnLeap == false then
	self.Owner.LeapFinish = true	
	self.Weapon:SendWeaponAnim( ACT_VM_DEPLOY )
	self.Owner:ViewPunch( Angle( 4, 0, 0 ) )	 	
	self.Weapon:EmitSound("bladesguard.wav",100, math.random(107,115))
	self:SetWeaponHoldType( "fist"	)		

	end
	
	end
	
	


if self.Owner.Biomask == true then
if CLIENT then
	if input.IsKeyDown( KEY_C ) then
		if self.CloakToggle == false then
		self.CloakToggle = true
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )	
		end
	else
		self.CloakToggle = false
	end	
end	
end	


 if self.Owner.Cloak == true then
	if self.Weapon.Cloak == false then
	self.WElements["Rblade"].color = Color(255,255,255,3)	
	self.WElements["Rblade"].material = "sprites/heatwave"
	end
	self.Weapon.Cloak = true
	else
	if self.Weapon.Cloak == true then	
	self.WElements["Rblade"].color = Color(255,255,255,255)	
	self.WElements["Rblade"].material = "models/glass"	
	end
	self.Weapon.Cloak = false
	end


if self.Owner:KeyDown(IN_ATTACK2) then
	self:SetWeaponHoldType( "magic"	)
else
	self:SetWeaponHoldType( "fist"	)
end



function EntityTakeDamage( target, dmginfo )

for k, v in pairs( player.GetAll( ) ) do

	if ( target:IsPlayer() and dmginfo:IsDamageType(32) ) then

		dmginfo:ScaleDamage( 0 )

	end

end
end


	
hook.Add( "OnPlayerHitGround", "StopLeapAnim", function(ply)


	timer.Stop( "LeapAttack" )
	if 	ply.OnLeap == true then
	self.Weapon:SendWeaponAnim( ACT_VM_DRYFIRE )
	self.Owner:ViewPunch( Angle( -5, 0, 0 ) )	
	self:SetWeaponHoldType( "fist"	)
	
	ply.OnLeap = false
	end

	end )

	if self.Owner:WaterLevel() ~= 0 then
	
	--print("you are in watr")
	timer.Stop( "LeapAttack" )
	if 	self.Owner.OnLeap == true then
	self.Weapon:SendWeaponAnim( ACT_VM_DRYFIRE )
	self:SetWeaponHoldType( "fist"	)
	
	self.Owner.OnLeap = false
	end
	
	end

	
end



function SWEP:PrimaryAttack()

	if self.Owner:KeyDown(IN_ATTACK2) then return end
	
	if self.Owner:KeyDown(IN_USE) then
	
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )	
		
		timer.Simple( 0.55, function() 
		self.Owner:ViewPunch( Angle( -3, 0, 0 ) )		
        local trace = self.Owner:GetEyeTrace();		
        self.Owner:SetAnimation(PLAYER_ATTACK1);								
        if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 100 then									
                                bullet = {}
                                bullet.Num    = 0
                                bullet.Src    = self.Owner:GetShootPos()
                                bullet.Dir    = self.Owner:GetAimVector()
                                bullet.Spread = Vector(0, 0, 0)
                                bullet.Tracer = 0
                                bullet.Force  = 50
                                bullet.Damage = math.random(60,90)
                        self.Owner:FireBullets(bullet)
                        self.Weapon:EmitSound("bladessound1.wav",100, math.random(95,105))
        else
                self.Owner:SetAnimation( PLAYER_ATTACK1 );
                self.Weapon:EmitSound("Weapon_Crowbar.Single",100, math.random(80,85))
        end
		end)		
       
        self.Weapon:SetNextPrimaryFire( CurTime() + 0.7 )
		
		
	else
	
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )	
	       self.Weapon:SetNextPrimaryFire( CurTime() + 0.35 )
       
		timer.Simple( 0.1, function() 
        local trace = self.Owner:GetEyeTrace();
        if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 100 then
                        self.Owner:SetAnimation(PLAYER_ATTACK1);								
                                bullet = {}
                                bullet.Num    = 0
                                bullet.Src    = self.Owner:GetShootPos()
                                bullet.Dir    = self.Owner:GetAimVector()
                                bullet.Spread = Vector(0, 0, 0)
                                bullet.Tracer = 0
                                bullet.Force  = 30
                                bullet.Damage = math.random(55,80)
                        self.Owner:FireBullets(bullet)
                        self.Weapon:EmitSound("bladessound1.wav",100, math.random(95,105))

        else
                self.Owner:SetAnimation( PLAYER_ATTACK1 );
                self.Weapon:EmitSound("Weapon_Crowbar.Single",100, math.random(95,120))
        end
       	end)
		
        self.Weapon:SetNextPrimaryFire( CurTime() + 0.35 )
end
end

function SWEP:SecondaryAttack()

return true
	
end


function SWEP:Deploy()	
	
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )	
timer.Simple( 0.23, function() 
	self.Weapon:EmitSound("bladesout.wav")
end)	
	return true
end

function SWEP:Holster()	


	timer.Stop( "LeapAttack" )
	if 	self.Owner.OnLeap == true then
	self.Owner.OnLeap = false
	end	
	return true
end


function SWEP:OnDrop()	
	
	timer.Stop( "LeapAttack" )
	if 	self.Owner.OnLeap == true then
	self.Owner.OnLeap = false
	end		
	
	if SERVER then
	self.Owner:SetNoTarget(true)	
	self.Owner:SetColor( Color(255, 255, 255, 255) ) 		
	self.Owner:SetMaterial("models/glass")
	self.Weapon:SetMaterial("models/glass")
	self.Weapon:EmitSound("predatoruncloak.wav",100,math.random(90,110))		
	end
	self.Owner.Cloak = false	
end


 