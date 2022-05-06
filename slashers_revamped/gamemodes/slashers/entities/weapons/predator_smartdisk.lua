
if SERVER then 

	AddCSLuaFile ("predator_smartdisk.lua")
 
	SWEP.Weight = 5

	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
 
elseif CLIENT then 


	SWEP.PrintName = "Smartdisk"
 
	SWEP.Slot = 3
	SWEP.SlotPos = 1
 
	SWEP.DrawAmmo = true
	SWEP.DrawCrosshair = false

end
 
SWEP.Category = "PREDATOR"
 
SWEP.Spawnable = true 
SWEP.AdminSpawnable = true 

SWEP.UseHands	= true	
SWEP.HoldType = "slam"	
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/viewmodels/c_pred_disk.mdl" 
SWEP.WorldModel = "models/predatorremotemine.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.WElements = {
	["disk"] = { type = "Model", model = "models/predatorbattledisc.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 2.757, -0.075), angle = Angle(101.457, -67.248, -27.894), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
 
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = "none" 
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Cloak = false
local diskthrown = false
 

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

 if self.Owner.Cloak == true then
	if self.Weapon.Cloak == false then
	self.WElements["disk"].color = Color(255,255,255,3)	
	self.WElements["disk"].material = "sprites/heatwave"
	end
	self.Weapon.Cloak = true
	else
	if self.Weapon.Cloak == true then	
	self.WElements["disk"].color = Color(255,255,255,255)	
	self.WElements["disk"].material = "models/glass"	
	end
	self.Weapon.Cloak = false
	end

if self.Owner:KeyPressed(IN_ATTACK2) then
	self:SetWeaponHoldType( "duel"	)
	if diskthrown == false then
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	 self.Weapon:EmitSound("Diskthrow.wav")	
	elseif diskthrown == true then
	return end
	
end
	
	
if self.Owner:KeyReleased(IN_ATTACK2) then
	self.Owner:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE, true )
	self.Owner:ViewPunch( Angle( 0, -5, 0 ) )	
	self.WElements["disk"].color = Color(255,255,255,0)		
	if diskthrown == false then
	self.Weapon:SendWeaponAnim( ACT_VM_THROW )	
	 self.Weapon:EmitSound("Diskdeploy.wav")
	self:throw_attack("models/predatorbattledisc.mdl")
	diskthrown = true
	timer.Simple( 0.4, function()  
	if SERVER then
	self.Owner:StripWeapon( "predator_smartdisk" )
	end
	end )
	
	elseif diskthrown == true then
	return end
	
	end


end


function SWEP:throw_attack (model_file)
 
 local priority = {}
priority["Jeff"]=8
priority["Peter"]=17
priority["Shay"]=0

 local TABLE = {
	{ "Jeff", 8 },
	{ "Peter", 17 },
	{ "Shay", 0 },
	{ "Janine", 1 }

}

local array = {1,2,0,0,3,1,2,9}

function swap(a, b, table)

    if table[a] == nil or table[b] == nil then
        return false
    end

    if table[a] > table[b] then
        table[a], table[b] = table[b], table[a]
        return true
    end

    return false

end


function bubblesort(array)

    for i=1,table.maxn(array) do

        local ci = i
        ::redo::
        if swap(ci, ci+1, array) then
            ci = ci - 1
            goto redo
        end
    end
end

bubblesort(array)

PrintTable(array)

if oldcurveboomerang then
	if (!SERVER) then return end
 
	local ent = ents.Create( "predator_thrown_smartdisk" )
	ent:SetModel(model_file)

	ent:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 16))
	ent:SetAngles(self.Owner:EyeAngles())
	ent:Spawn()
	ent:SetNWAngle( 'startang', self:GetAngles())
	ent:SetNWVector('startpos', self:GetPos())
	ent:GetPhysicsObject():EnableGravity(false)
	ent:SetNWEntity('owner', self.Owner)
	ent:SetNWInt('thrown', 1)
	spinloop=CreateSound(ent,"spinloop1.wav")
	spinloop:Play()
	ent:EmitSound("throw.wav")
	ent.Sound = spinloop
	//Loops[ent] = spinloop
	ent:GetPhysicsObject():AddAngleVelocity(Vector(0,0,800)) //spin
	local phys = ent:GetPhysicsObject()
	if !(phys && IsValid(phys)) then ent:Remove() return end
	phys:ApplyForceCenter((self.Owner:GetAimVector():GetNormalized()+self.Owner:EyeAngles():Right()*0) *  ent:GetPhysicsObject():GetMass() * 280 * 2)

else

	if (!SERVER) then return end
 
	local ent = ents.Create( "predator_thrown_smartdisk" )
	ent:SetModel(model_file)

	ent:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 35))
	ent:SetAngles(self.Owner:EyeAngles())
	ent:Spawn()
	ent:SetNWEntity('owner', self.Owner)
	ent:SetNWAngle( 'startang', self:GetAngles())
	ent:SetNWVector('startpos', self.Owner:EyePos() + (self.Owner:GetAimVector() * 35))
	ent:SetNWEntity('owner', self.Owner)
	if math.Clamp(1-math.Clamp((self.Owner:EyeAngles().x*1.5) / 90,0,1),0.15,1)>0.67110713322957 then
		ent:SetNWInt('state',1)
	else
		ent:SetNWInt('state',4)
		ent:GetPhysicsObject():ApplyForceCenter(self.Owner:GetAimVector():GetNormalized() *  ent:GetPhysicsObject():GetMass() * 280 * 2)
	end
	ent:GetPhysicsObject():EnableGravity(false)
	ent:GetPhysicsObject():AddAngleVelocity(Vector(0,0,800)) //spin
	spinloop=CreateSound(ent,"spinloop1.wav")
	spinloop:Play()
	ent:EmitSound("throw.wav")
	ent.Sound = spinloop
	//Loops[ent] = spinloop
	local phys = ent:GetPhysicsObject()
	if !(phys && IsValid(phys)) then ent:Remove() return end

end
end

function SWEP:PrimaryAttack()

	if self.Owner:KeyDown(IN_ATTACK2) then return end
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )	
	       self.Weapon:SetNextPrimaryFire( CurTime() + 0.6 )
		self.Owner:ViewPunch( Angle( -3, -10, 0 ) )
        local trace = self.Owner:GetEyeTrace();
        if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 90 then
                        self.Owner:SetAnimation(PLAYER_ATTACK1);
						timer.Simple( 0.3, function() 
                                bullet = {}
                                bullet.Num    = 1
                                bullet.Src    = self.Owner:GetShootPos()
                                bullet.Dir    = self.Owner:GetAimVector()
                                bullet.Spread = Vector(0, 0, 0)
                                bullet.Tracer = 0
                                bullet.Force  = 1
                                bullet.Damage = math.random(105,130)
                        self.Owner:FireBullets(bullet)
                        self.Weapon:EmitSound("Disksound.wav",100,math.random(95,110))   
						end)						
        else
                self.Owner:SetAnimation( PLAYER_ATTACK1 );
                self.Weapon:EmitSound("Weapon_Crowbar.Single")
        end
       
        self.Weapon:SetNextPrimaryFire( CurTime() + 0.8 )
	

end

function SWEP:SecondaryAttack()

return true
	
end


function SWEP:Deploy()	
	diskthrown = false
	self.WElements["disk"].color = Color(255,255,255,255)		
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )	
	self.Weapon:EmitSound("Diskdraw.wav",100,90)
	return true
end

function SWEP:Holster()				
	return true
end
 