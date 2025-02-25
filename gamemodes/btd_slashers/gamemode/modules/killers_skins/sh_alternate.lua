local GM = GM or GAMEMODE

if !GM.KILLERS[KILLER_IMPOSTOR] then
    GM.KILLERS[KILLER_IMPOSTOR] = {}
end

GM.KILLERS[KILLER_IMPOSTOR].Serious = {}
GM.KILLERS[KILLER_IMPOSTOR].Serious.Name = "the Alternate"
GM.KILLERS[KILLER_IMPOSTOR].Serious.Model = "models/dejtriyev/scaryblackman.mdl"

GM.KILLERS[KILLER_IMPOSTOR].Serious.StartMusic = "sound/alternate/voice/intro.mp3"
GM.KILLERS[KILLER_IMPOSTOR].Serious.ChaseMusic = "alternate/chase/chase.ogg"
GM.KILLERS[KILLER_IMPOSTOR].Serious.Abilities = {"amogus/ability/amogus_transform1.mp3", "amogus/ability/amogus_transform2.mp3", "alternate/ability/alternate_reveal.mp3"}
GM.KILLERS[KILLER_IMPOSTOR].Serious.VoiceCallouts = {"alternate/ability/alternate_callout2.mp3", "alternate/ability/alternate_callout3.mp3", "alternate/ability/alternate_callout4.mp3"}

if CLIENT then
    GM.KILLERS[KILLER_IMPOSTOR].Serious.Desc = GM.LANG:GetString("class_desc_alternate")
    GM.KILLERS[KILLER_IMPOSTOR].Serious.Icon = Material("icons/alternate.png")
end

GM.KILLERS[KILLER_IMPOSTOR].Serious.UseAbility = function(ply)
    if CLIENT then return end

    local info = GM.KILLERS[KILLER_IMPOSTOR].Serious

    if !ply:GetNWBool("sls_killer_disguised", false) then
        local rnd_survivor = GM.ROUND.Survivors[ math.random( #GM.ROUND.Survivors ) ]

        GM.ROUND.Killer:SetModel(rnd_survivor:GetModel())

        ply:SetNWBool("sls_killer_disguised", true)

        ply:EmitSound(info.Abilities[math.random(1,2)])
        ply:SetNWBool("sls_chase_disabled", true)

        hook.Add( "KeyPress", "sls_impostor_disguise_undisguise", function( client, key )
            if client ~= GM.ROUND.Killer then return end

            if key == IN_ATTACK then
                GM.ROUND.Killer:SetModel(info.Model)
                client:EmitSound(info.Abilities[3])
                client:SetNWBool("sls_chase_disabled", nil)
                client:SetNWBool("sls_killer_disguised", nil)
                client:SetNWFloat("sls_killer_ability_cooldown", CurTime() + 20)

                hook.Remove("KeyPress", "sls_impostor_disguise_undisguise")
            end
        end)

    end
end