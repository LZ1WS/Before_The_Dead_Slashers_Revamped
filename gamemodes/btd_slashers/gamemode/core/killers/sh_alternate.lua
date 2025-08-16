local GM = GM or GAMEMODE
local KILLER = KILLER

KILLER.Name = "the Alternate"
KILLER.Model = "models/dejtriyev/scaryblackman.mdl"

KILLER.StartMusic = "sound/alternate/voice/intro.mp3"
KILLER.ChaseMusic = "alternate/chase/chase.ogg"
KILLER.Abilities = {"amogus/ability/amogus_transform1.mp3", "amogus/ability/amogus_transform2.mp3", "alternate/ability/alternate_reveal.mp3"}
KILLER.VoiceCallouts = {"alternate/ability/alternate_callout2.mp3", "alternate/ability/alternate_callout3.mp3", "alternate/ability/alternate_callout4.mp3"}

if CLIENT then
    KILLER.Desc = GM.LANG:GetString("class_desc_alternate")
    KILLER.Icon = Material("icons/alternate.png")
end

function KILLER:UseAbility(ply)
    if CLIENT then return end

    if !ply:GetNWBool("sls_killer_disguised", false) then
        local rnd_survivor = GM.ROUND.Survivors[ math.random( #GM.ROUND.Survivors ) ]

        GM.ROUND.Killer:SetModel(rnd_survivor:GetModel())

        ply:SetNWBool("sls_killer_disguised", true)

        ply:EmitSound(self.Abilities[math.random(1,2)])
        ply:SetNWBool("sls_chase_disabled", true)

        hook.Add( "KeyPress", "sls_impostor_disguise_undisguise", function( client, key )
            if client ~= GM.ROUND.Killer then return end

            if key == IN_ATTACK then
                GM.ROUND.Killer:SetModel(self.Model)
                client:EmitSound(self.Abilities[3])
                client:SetNWBool("sls_chase_disabled", nil)
                client:SetNWBool("sls_killer_disguised", nil)
                client:SetNWFloat("sls_killer_ability_cooldown", CurTime() + 20)

                hook.Remove("KeyPress", "sls_impostor_disguise_undisguise")
            end
        end)

    end
end

KILLER_ALTERNATE = KILLER.index