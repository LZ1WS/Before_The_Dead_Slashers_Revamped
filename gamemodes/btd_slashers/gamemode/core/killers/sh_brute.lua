local GM = GM or GAMEMODE
local KILLER = KILLER

KILLER.Name = "Brute"
KILLER.Model = "models/sirris/SergeiKozin.mdl"
KILLER.WalkSpeed = 200
KILLER.RunSpeed = 200
KILLER.UniqueWeapon = true
KILLER.ExtraWeapons = {"tfa_nmrih_sledge"}
KILLER.StartMusic = "sound/brute/voice/intro.ogg"
KILLER.ChaseMusic = "brute/chase/chase.ogg"
KILLER.TerrorMusic = "brute/terror/terror.wav"
KILLER.AbilityCooldown = 15

if CLIENT then
    KILLER.Desc = GM.LANG:GetString("class_desc_brute")
    KILLER.Icon = Material("icons/brute.png")
end

local function Bash_Door(ent, wep)

    if ent:GetClass() == "func_door_rotating" or ent:GetClass() == "prop_door_rotating" then
        ent:EmitSound("ambient/materials/door_hit1.wav", 100, math.random(80, 120))

        ent:SetKeyValue("Speed", "500")
        ent:SetKeyValue("Open Direction", "Both directions")
        ent:SetKeyValue("opendir", "0")
        ent:Fire("unlock", "", .01)
        ent:Fire("openawayfrom", newname, .01)

        timer.Simple(0.3, function()
            if IsValid(ent) then
                ent:SetKeyValue("Speed", "100")
            end
        end)
    end

end

function KILLER:UseAbility(ply)
    if CLIENT then return end

    ply:SetNWBool("sls_ram_killer", true)
    timer.Simple(ply:SequenceDuration(ply:LookupSequence( "wos_l4d_getup_from_pounced" )), function()
        ply:SetNWBool("sls_ram_killer", false)
    end)

    local charges = 0

    ply:AddFlags(FL_ATCONTROLS)

    timer.Create("brute_dash_forward", 0, 0, function()
        local forward = ply:GetAimVector()
        forward.z = 0

        ply:SetVelocity( forward * (50 + charges) )
        charges = charges + 5

        for _, v in ipairs(ents.FindInCone(ply:EyePos(), ply:GetAimVector(), 50, math.cos( math.rad( 45 ) ))) do

            if (v:IsPlayer() or v:IsNextBot()) && v:Team() == TEAM_SURVIVORS && !v:GetNWBool("sls_ram_victim", false) then
                --v:TakeDamage(math.random(25, 45), ply, ply:GetActiveWeapon())
                v:SetVelocity(ply:GetAimVector() * 1500)
                v:SetNWBool("sls_ram_victim", true)
                v:EmitSound(Sound("TFA.BashFlesh"))
                v:AddFlags(FL_ATCONTROLS)
                timer.Simple(v:SequenceDuration(v:LookupSequence( "wos_l4d_getup_from_pounced" )), function()
                v:RemoveFlags(FL_ATCONTROLS)
                    v:SetNWBool("sls_ram_victim", false)
                end)
                break
            elseif v:GetClass() == "prop_door_rotating" or v:GetClass() == "func_door_rotating" then Bash_Door(v, ply:GetActiveWeapon())
            end

        end
    end)

    timer.Simple(0.55, function()
        timer.Remove("brute_dash_forward")
        ply:RemoveFlags(FL_ATCONTROLS)
    end)

end

hook.Add( "CalcMainActivity", "sls_brute_fallover", function( ply )
	if GM.MAP:GetKillerIndex() ~= KILLER.index then return end

    if ply:GetNWBool("sls_ram_killer", false) then
        local seq = ply:LookupSequence( "ACT_HL2MP_RUN_CHARGING" )

        if seq < 0 then return end
        return -1, seq
    end

    if ply:GetNWBool("sls_ram_victim", false) then
    local seq = ply:LookupSequence( "wos_l4d_getup_from_pounced" )

    if seq < 0 then return end
    return -1, seq
end
end )

hook.Add("sls_round_End", "sls_bruteabil_End", function()
	if GM.MAP:GetKillerIndex() ~= KILLER.index then return end

    timer.Remove("brute_dash_forward")
end)

KILLER_BRUTE = KILLER.index