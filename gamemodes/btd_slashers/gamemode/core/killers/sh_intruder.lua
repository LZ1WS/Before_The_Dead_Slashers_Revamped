local GM = GM or GAMEMODE
local KILLER = KILLER

-- Killer
KILLER.Name = "the Intruder"
KILLER.Model = "models/steinman/slashers/intruder_pm.mdl"
KILLER.WalkSpeed = 200
KILLER.RunSpeed = 200
KILLER.UniqueWeapon = false
KILLER.ExtraWeapons = {"weapon_beartrap", "weapon_alertropes", "weapon_dooraxe"}
KILLER.StartMusic = "sound/slashers/ambient/slasher_start_game_intruder.wav"
KILLER.ChaseMusic = "slashers/ambient/chase_intruder.wav"
KILLER.TerrorMusic = "metalworker/terror/terror.wav"

if CLIENT then
	KILLER.Desc = GM.LANG:GetString("class_desc_intruder")
	KILLER.Icon = Material("icons/icon_intruder.png")
	local trapsEntity = {}
	local function getEntityToDrawHalo()
		trapsEntity = net.ReadTable()
	end
	net.Receive("sls_trapspos",getEntityToDrawHalo)

	hook.Add( "PreDrawHalos", "AddHalos", function()
		if LocalPlayer().ClassID != CLASS_SURV_SHY then return end
		halo.Add( trapsEntity, Color( 255, 0, 0 ), 5, 5, 2 )
	end )
else
	util.AddNetworkString("sls_trapspos")
	local timerTrap = 0
	local function sendTrapProximity()
			if IsValid(GM.ROUND.Killer)  &&   GM.ROUND.Active && timerTrap < CurTime()  then
			if GM.ROUND.Killer:GetNWBool("sls_holy_weaken_effect", false) then return end
			timerTrap = CurTime() + 1
			local shygirl = getSurvivorByClass(CLASS_SURV_SHY)
			if !shygirl or !shygirl:IsPlayer() then return end
			local entsAround = ents.FindInSphere( shygirl:GetPos(), 700 )
			local trapsAround = {}
			for k,v in pairs(entsAround) do
				if v:GetClass() == "beartrap" or  v:GetClass() == "alertropes" or  v.trapeddoor == 1 then
						table.insert( trapsAround, v )
				end
			end
			net.Start("sls_trapspos")
				net.WriteTable(trapsAround)
			net.Send(shygirl)
		end
	end
	hook.Add("Think","sls_detectProximityTraps",sendTrapProximity)
end

KILLER_INTRUDER = KILLER.index