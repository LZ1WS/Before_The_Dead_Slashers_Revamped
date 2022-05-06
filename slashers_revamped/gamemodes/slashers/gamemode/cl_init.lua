-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-07-25 16:15:45
-- @Last modified by:   Guilhem PECH
-- @Last modified time: 21-Oct-2018

include("shared.lua")
include("config.lua")
include("core/_includes.lua")
include("modulesloader.lua")

local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
	//CHudWeaponSelection = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end

	-- Don't return anything here, it may break other addons that rely on this hook.
end )

-- Enleve le nom des joueurs
function GM:HUDDrawTargetID()

end

function GM:HUDWeaponPickedUp()

end

function GM:HUDAmmoPickedUp()

end

function GM:DrawDeathNotice(x, y)

end

if CLIENT then

  function Pulsate( c )

    return math.abs( math.sin( CurTime() * c ) )

  end

  function Fluctuate( c )

    return ( math.cos( CurTime() * c ) + 1 ) * .5

  end

  local function Health()
if LocalPlayer():Health() <= 0 or LocalPlayer():Team() == TEAM_KILLER then return end
    local screenheight = ScrH()
    local screenwidth = ScrW()
    local localPlayer = LocalPlayer();
    local hp = localPlayer:Health()
    local maxhp = localPlayer:GetMaxHealth()
    surface.SetDrawColor( color_white );
        surface.SetMaterial( Material("nohud/ico_health.png") );
        surface.DrawTexturedRect(93, screenheight-47, 34, 34);
        --draw.RoundedBox( 10, screenheight - 50, 40, 40, 2, Color(255,255,255) )

        surface.SetDrawColor(255, 255, 255, 75);
        surface.DrawOutlinedRect(135, screenheight-44, 211, 28);
        surface.DrawOutlinedRect(90, screenheight-50, 40, 40, 2);

        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( Material("nohud/ico_index2.png") )
        local clamphp = math.Clamp( math.ceil( hp * 16 / maxhp ), 0, 16 )
        for i = 1, clamphp do
          surface.DrawTexturedRect( 137 + ( i - 1 ) * 13, screenheight-42, 12, 24 );
        end


        draw.SimpleText(hp .. " / " .. maxhp, "BudgetLabel", 235, screenheight-29, hp > maxhp * .3 && Color(255,255,255) || ColorAlpha( Color(255,0,0), Pulsate( 4 ) * 210 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);

  end

hook.Add("HUDPaint", "Health", Health)

end
