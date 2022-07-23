-- Utopia Games - Slashers
--
-- @Author: Vyn
-- @Date:   2017-07-26 00:53:34
-- @Last Modified by:   Vyn
-- @Last Modified time: 2017-07-26 15:21:12

SWEP.Author = "L.Z|W.S"
 
SWEP.Category = "Slashers"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AutoSwitchTo = false
SWEP.PrintName = "Prayer"

SWEP.ViewModel = "models/weapons/rainchu/v_nothing.mdl"
SWEP.WorldModel = "models/weapons/rainchu/w_nothing.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 3
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperRound"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.Delay = 0
SWEP.Used = false

local GM = GM or GAMEMODE

function SWEP:Initialize()
	self:SetHoldType("normal")
	self:SetNWFloat( 'progressBar', 0 )
end

function SWEP:Equip(ply)
	if SERVER then
	local filter = RecipientFilter()
	filter:AddAllPlayers()
	self.PraySFX = CreateSound(ply, "survivors/priest/ability_use.mp3", filter)
	end
end

function SWEP:Tick()
	if self:Ammo1() <= 0 then return end
	if CurTime() < self.Delay then return end
	local owner = self:GetOwner()
	local cmd = owner:GetCurrentCommand()

	if ( cmd:KeyDown( IN_ATTACK ) ) then
	local curswepProgress = self:GetNWFloat('progressBar')
		if (curswepProgress < 1 ) then
			self.Used = true
			self:SetNWFloat( 'progressBar', curswepProgress + 0.003)
			owner:AddFlags(FL_ATCONTROLS)
			if SERVER and !self.PraySFX:IsPlaying() then
				self.PraySFX:Play()
			end
			if SERVER then
			net.Start( "activateProgressionSlasher" )
			net.WriteFloat(curswepProgress)
			net.Send(owner)
			end
		elseif (curswepProgress >= 1 ) then
				self:TakePrimaryAmmo( 1 )
				self.Delay = CurTime() + 30
				self.Used = false
				HolyWeakenPlayer(GM.ROUND.Killer)
				owner:RemoveFlags(FL_ATCONTROLS)
				self:SetNWFloat( 'progressBar', 0)
				if SERVER and self.PraySFX:IsPlaying() then
					self.PraySFX:FadeOut(3)
					owner:EmitSound("survivors/priest/ability_finish.mp3", 511)
					GM.ROUND.Killer:EmitSound("survivors/priest/ability_finish_killer.mp3")
				end
				if SERVER then
				net.Start( "activateProgressionSlasher" )
				net.WriteFloat(2)
				net.Send(owner)
				end
		end
	end
	if ( !cmd:KeyDown( IN_ATTACK ) ) and self.Used then
		self.Used = false
		self.Delay = CurTime() + 5
		owner:RemoveFlags(FL_ATCONTROLS)
		self:SetNWFloat( 'progressBar', 0)
		if SERVER and self.PraySFX:IsPlaying() then
			self.PraySFX:FadeOut(3)
		end
	end


end