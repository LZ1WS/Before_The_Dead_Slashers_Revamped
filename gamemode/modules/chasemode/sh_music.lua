local GM = GM or GAMEMODE
function sls_music_InitValue()
    local filter
	if SERVER then
		filter = RecipientFilter()
		filter:AddAllPlayers()
	end
	ChaseSound = CreateSound( game.GetWorld(), GM.MAP.ChaseMusic, filter)
    TerrorSound = CreateSound( game.GetWorld(), GM.MAP.TerrorMusic, filter)
	ChaseSound:SetSoundLevel( 0 )
	TerrorSound:SetSoundLevel( 0 )
    for _,ply in ipairs(player.GetAll()) do
	if !IsValid(ply) then return end
	ply.ChaseSoundPlaying = false
	ply.TerrorSoundPlaying = false
    ply.LastViewKillerTime = 0
    ply.LastViewByKillerTime = 0

end
end
hook.Add("sls_round_PostStart", "sls_music_PostStart", sls_music_InitValue)