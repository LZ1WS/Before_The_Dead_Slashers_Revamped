local GM = GM or GAMEMODE

GM.KILLERS[KILLER_NORMANBATES] = {}

-- Killer
GM.KILLERS[KILLER_NORMANBATES].Name = "Norman Bates"
GM.KILLERS[KILLER_NORMANBATES].Model = "models/steinman/slashers/bates_pm.mdl"
GM.KILLERS[KILLER_NORMANBATES].WalkSpeed = 200
GM.KILLERS[KILLER_NORMANBATES].RunSpeed = 200
GM.KILLERS[KILLER_NORMANBATES].UniqueWeapon = false
GM.KILLERS[KILLER_NORMANBATES].ExtraWeapons = {"weapon_batesmother"}
GM.KILLERS[KILLER_NORMANBATES].StartMusic = "sound/slashers/ambient/slashers_start_game_bates.wav"
GM.KILLERS[KILLER_NORMANBATES].ChaseMusic = "slashers/ambient/chase_bates.wav"
GM.KILLERS[KILLER_NORMANBATES].TerrorMusic = "defaultkiller/terror/terror.wav"

if CLIENT then
	GM.KILLERS[KILLER_NORMANBATES].Desc = GM.LANG:GetString("class_desc_bates")
	GM.KILLERS[KILLER_NORMANBATES].Icon = Material("icons/icon_bates.png")
end

-- Convars
CreateConVar("slashers_bates_far_radius", 400, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Set the first radius (far).")
CreateConVar("slashers_bates_medium_radius", 200, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Set the second radius (medium).")
CreateConVar("slashers_bates_close_radius", 100, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Set the third radius (close).")

-- Ability
-------------------The other part of the ability code is in the 'Mother' entity code
if CLIENT then
	function GM:playSoundMother(file)
		if IsValid(GM.SoundPlayed) then
			GM.SoundPlayed:Stop()
		end
		sound.PlayFile( file, "", function( station,num,err )
			if ( IsValid( station ) ) then
				station:Play()
				station:EnableLooping(true)
				GM.SoundPlayed = station
			end
		end)
	end

	function autoEnd()
		if IsValid(GM.SoundPlayed) then
			GM.SoundPlayed:Stop()
		end
	end
	hook.Add('sls_round_End',"sls_musicEndRound", autoEnd)
	hook.Add('sls_round_End',"sls_musicEndRound", autoEnd)

	function GM:SoundToPlay(level)
		if(LocalPlayer():Team() == 1) then return end
		if level == 3 then
			GM:playSoundMother("sound/slashers/effects/whisper_loop_high.wav")
		elseif level == 2 then
			GM:playSoundMother("sound/slashers/effects/whisper_loop_medium.wav")
		elseif level == 1 then
			GM:playSoundMother("sound/slashers/effects/whisper_loop_small.wav")
		else
			if GM.SoundPlayed then
				GM.SoundPlayed:Stop()
			end
		end
	end

	net.Receive( "sls_motherradar", function( len, ply )
		local distLevel = net.ReadUInt(2)
		if GM.oldLevel != distLevel then
			GM.oldLevel = distLevel
			GM:SoundToPlay(distLevel)
		end
	end)
end