local GM = GM or GAMEMODE

function sls_music_InitValue()
	if CLIENT then
		local path = (GM.MAP.ChaseMusic and ("sound/" .. GM.MAP.ChaseMusic))

		sound.PlayFile(path, "noplay noblock", function(channel, error, message)
			if (!IsValid(channel)) then
				return
			end

			channel:SetVolume(1)
			channel:EnableLooping(true)
			--channel:Play()

			ChaseSound = channel
		end)

		path = (GM.MAP.EscapeMusic and ("sound/" .. GM.MAP.EscapeMusic))

		sound.PlayFile(path, "noplay noblock", function(channel, error, message)
			if (!IsValid(channel)) then
				return
			end

			channel:SetVolume(1)
			channel:EnableLooping(true)
			--channel:Play()

			EscapeSound = channel
		end)
	end

    for _,ply in ipairs(player.GetAll()) do
		if !IsValid(ply) then return end

		ply.ChaseSoundPlaying = false
		ply.LastViewKillerTime = 0
		ply.LastViewByKillerTime = 0
	end
end
hook.Add("sls_round_PostStart", "sls_music_PostStart", sls_music_InitValue)

hook.Add("sls_round_StartEscape", "sls_music_startescape", function()
	if CLIENT then
		if GM.ROUND.Escape then
			EscapeSound:Play()
		else
			EscapeSound:Pause()
		end
	end
end)

--[[hook.Add("InitPostEntity","sls_lobbymusic_init", function()
	local filter
	if SERVER then
		filter = RecipientFilter()
		filter:AddAllPlayers()
	end

	if GM.MAP.LobbyMusic then
		LobbyMusic = CreateSound( game.GetWorld(), GM.MAP.LobbyMusic, filter)
	else
		LobbyMusic = CreateSound( game.GetWorld(), "lobby/normal" .. math.random(1, 10) .. ".wav", filter)
	end
	LobbyMusic:SetSoundLevel( 0 )
end)]]