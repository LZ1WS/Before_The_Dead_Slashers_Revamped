ENT.Type = "anim"
ENT.AdminOnly			= true
ENT.PrintName			= "Slender Man Page"
ENT.Author			= "[BoZ]Niko663"
ENT.Contact			= "SlenderRising@8pages.com"
ENT.Purpose			= "This is the Slender Note you must find to escape him."
ENT.Instructions			= "Press USE key on it."
ENT.Category			= "Slender Rising"
ENT.Spawnable = true
local GM = GM or GAMEMODE

if SERVER then

AddCSLuaFile( "ent_slender_rising_notepage.lua" )

function ENT:Initialize()

sound.Add({
	name =				"SlenderRising.SignPickUp",
	channel =			CHAN_STATIC,
	volume =			1.0,
	soundlevel =			80,
	sound =				"slender-rising/sign_pickup.wav"
})

sound.Add({
	name =				"SlenderRising.SignWhispers",
	channel =			CHAN_STATIC,
	volume =			1.0,
	soundlevel =			70,
	sound =				"slender-rising/sign_drone8_loop.wav"
})

Sign1 = "models/slender-rising/sign_texture.vmt"
Sign2 = "models/slender-rising/sign_texture_1.vmt"
Sign3 = "models/slender-rising/sign_texture_2.vmt"
Sign4 = "models/slender-rising/sign_texture_3.vmt"
Sign5 = "models/slender-rising/sign_texture_4.vmt"
Sign6 = "models/slender-rising/sign_texture_5.vmt"
Sign7 = "models/slender-rising/sign_texture_6.vmt"
Sign8 = "models/slender-rising/sign_texture_7.vmt"
Sign9 = "models/slender-rising/sign_texture_8.vmt"
Sign10 = "models/slender-rising/sign_texture_9.vmt"
Sign11 = "models/slender-rising/sign_texture_10.vmt"
Sign12 = "models/slender-rising/sign_texture_11.vmt"
Sign13 = "models/slender-rising/sign_texture_12.vmt"
Sign14 = "models/slender-rising/sign_texture_13.vmt"
Sign15 = "models/slender-rising/sign_texture_14.vmt"
Sign16 = "models/slender-rising/sign_texture_15.vmt"
Sign17 = "models/slender-rising/sign_texture_16.vmt"
Sign18 = "models/slender-rising/sign_texture_17.vmt"
Sign19 = "models/slender-rising/sign_texture_18.vmt"
Sign20 = "models/slender-rising/sign_texture_19.vmt"

local Sign = {}
Sign[1] = (Sign1)
Sign[2] = (Sign2)
Sign[3] = (Sign3)
Sign[4] = (Sign4)
Sign[5] = (Sign5)
Sign[6] = (Sign6)
Sign[7] = (Sign7)
Sign[8] = (Sign8)
Sign[9] = (Sign9)
Sign[10] = (Sign10)
Sign[11] = (Sign11)
Sign[12] = (Sign12)
Sign[13] = (Sign13)
Sign[14] = (Sign14)
Sign[15] = (Sign15)
Sign[16] = (Sign16)
Sign[17] = (Sign17)
Sign[18] = (Sign18)
Sign[19] = (Sign19)
Sign[20] = (Sign20)

	self.Entity:SetModel("models/slender-rising/slender_notepage.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow( true )
	self.Entity:SetMaterial( Sign[math.random(1,20)], true )

	self:EmitSound("SlenderRising.SignWhispers")
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
	phys:Wake()
	end
end

function ENT:Use( activator )
if (CurrentObjective == "find_pages" && activator:Team() == TEAM_SURVIVORS) then
if (NbPagesToFound != 0) then
	SafeRemoveEntity(self)
	NbPagesToFound = NbPagesToFound - 1
	activator:StopSound("SlenderRising.SignPickUp")
	activator:EmitSound("SlenderRising.SignPickUp")
	--activator:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 256 ), 1.5, 1.5 )
	self:StopSound("SlenderRising.SignWhispers")
	net.Start( "notificationSlasher" )
	net.WriteTable({"round_mission_pages_found"})
	net.WriteString("safe")
	net.Send(activator)


	net.Start( "modifyObjectiveSlasher" )
	net.WriteTable({"round_mission_pages", NbPagesToFound})
	net.SendOmit(GM.ROUND.Killer)
	GM.ROUND.Killer:SetWalkSpeed(GM.ROUND.Killer:GetWalkSpeed() + 50)
	GM.ROUND.Killer:SetRunSpeed(GM.ROUND.Killer:GetRunSpeed() + 50)
end
		if (NbPagesToFound == 0) then
			net.Start( "objectiveSlasher" )
							 net.WriteTable({"round_mission_shotgun"})
							 net.WriteString("caution")
							 net.SendOmit(GM.ROUND.Killer)

			hook.Call("sls_NextObjective")

		end
		self:EmitSound("player/shove_01.wav",100,100,1,CHAN_AUTO)
		SafeRemoveEntity(self)
end

end

function ENT:Think()
end

function ENT:OnRemove()
self:StopSound("SlenderRising.SignWhispers")
end

if CLIENT then
function ENT:Draw()
	self.Entity:DrawModel()
end
end
end