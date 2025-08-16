CreateClientConVar( "shaky_flashlight_material", "models/shaky/fleshlight/flashlight001", true, false, "which material display as flashlight" )
CreateClientConVar( "shaky_flashlight_fov", 55, true, false, "which FOV should light be drawn", 0 )
CreateClientConVar( "shaky_flashlight_farz", 2555, true, false, "how far should light be drawn", 0 )
CreateClientConVar( "shaky_flashlight_brightness", 1, true, false, "brightness of the light", 0.1 )
CreateClientConVar( "shaky_flashlight_flickerlight", 1, true, false, "make light flicker", 0, 1 )
CreateClientConVar( "shaky_flashlight_dynamiclight", 1, true, false, "make light around you when flashlight is on", 0, 1 )
CreateClientConVar( "shaky_flashlight_flickintervalmin", 25, true, false, "flick delay (in milliseconds)" )
CreateClientConVar( "shaky_flashlight_flickintervalmax", 45, true, false, "flick delay (in milliseconds)" )
CreateClientConVar( "shaky_flashlight_flicksize", 0.8, true, false, "how strong the light should flick", 0, 1 )
CreateClientConVar( "shaky_flashlight_animatecamera", 1, true, false, "Animate camera movement", 0, 1 )
CreateClientConVar( "shaky_flashlight_lightfollowcenter", 0, true, false, "Make light be centered perfectly", 0, 1 )
CreateClientConVar( "shaky_flashlight_lightorigincenter", 0, true, false, "Make lights origin be centered perfectly", 0, 1 )
CreateClientConVar( "shaky_flashlight_animspeed", 35, true, false, "Light Texture Animation Speed", 0, 120 )

CreateConVar("shaky_flashlight_enablepunch", 1, FCVAR_ARCHIVE, "enables ability to punch", 0, 1)
CreateConVar("shaky_flashlight_damagemultiply", 1, FCVAR_ARCHIVE, "damage multiply", 0)
CreateConVar("shaky_flashlight_chargespeedmultiply", 1, FCVAR_ARCHIVE, "charge speed", 0)

CreateClientConVar( "shaky_flashlight_r", 255, true, false, "Light color R", 0, 255 )
CreateClientConVar( "shaky_flashlight_g", 255, true, false, "Light color G", 0, 255 )
CreateClientConVar( "shaky_flashlight_b", 255, true, false, "Light color B", 0, 255 )

list.Set("LampTextures", "models/shaky/fleshlight/flashlight001", {
	Name = "shaky flashlight default",
})

if CLIENT then


	hook.Add( "AddToolMenuCategories", "shaky_flashlight_category", function()
		spawnmenu.AddToolCategory( "Utilities", "shakyflashlight", "Shaky's Flashlight" )
	end )

	hook.Add( "PopulateToolMenu", "shaky_flashlight_settungs", function()
		spawnmenu.AddToolMenuOption( "Utilities", "shakyflashlight", "settings", "Settings", "", "", function( panel )
			panel:ClearControls()

			local botun = panel:Button("Reset", "nuthing")

			local convars_to_reset = {
				["shaky_flashlight_material"] = "models/shaky/fleshlight/flashlight001",
				["shaky_flashlight_fov"] = 55,
				["shaky_flashlight_farz"] = 2555,
				["shaky_flashlight_brightness"] = 1,
				["shaky_flashlight_flickerlight"] = 1,
				["shaky_flashlight_dynamiclight"] = 1,
				["shaky_flashlight_flickintervalmin"] = 25,
				["shaky_flashlight_flickintervalmax"] = 45,
				["shaky_flashlight_flicksize"] = 0.8,
				["shaky_flashlight_animatecamera"] = 1,
				["shaky_flashlight_lightfollowcenter"] = 0,
				["shaky_flashlight_animspeed"] = 35,
				["shaky_flashlight_r"] = 255,
				["shaky_flashlight_g"] = 255,
				["shaky_flashlight_b"] = 255,
			}

			botun.DoClick = function(self)

				for cmd, val in pairs(convars_to_reset) do
							
					RunConsoleCommand(cmd, val)

				end

			end

			panel:CheckBox( "Animate Camera", "shaky_flashlight_animatecamera" ):SetValue(GetConVar("shaky_flashlight_animatecamera"):GetBool())	

			panel:Help("Flicker")
			panel:CheckBox( "Enable light flickering", "shaky_flashlight_flickerlight" ):SetValue(GetConVar("shaky_flashlight_flickerlight"):GetBool())
			panel:NumberWang( "Flick Interval Min", "shaky_flashlight_flickintervalmin", 0, math.huge ):SetValue(GetConVar("shaky_flashlight_flickintervalmin"):GetFloat())
			panel:NumberWang( "Flick Interval Max", "shaky_flashlight_flickintervalmax", 0, math.huge ):SetValue(GetConVar("shaky_flashlight_flickintervalmax"):GetFloat())
			panel:NumSlider( "Flick Size", "shaky_flashlight_flicksize", 0.1, 1 ):SetValue(GetConVar("shaky_flashlight_flicksize"):GetFloat())

			panel:Help("Light")
			--panel:TextEntry("Light Material", "shaky_flashlight_material")
			--[[
			local MatSelect = panel:MatSelect( "shaky_flashlight_material", nil, false, 0.33, 0.33 )
			MatSelect.Height = 0.3
	
			for k, v in pairs( list.Get( "lamp_texture" ) ) do
				print(v)
				MatSelect:AddMaterial( v.Name or k, k )
			end]]

			local MatSelect = panel:MatSelect( "shaky_flashlight_material", nil, false, 0.33, 0.33 )
			MatSelect.Height = 4

			for k, v in pairs( list.Get( "LampTextures" ) ) do
				MatSelect:AddMaterial( v.Name or k, k )
			end
			panel:AddControl( "Color",  {
				Label	= "Light Color",
				Red			= "shaky_flashlight_r",
				Green		= "shaky_flashlight_g",
				Blue		= "shaky_flashlight_b",
				ShowAlpha	= 0,
				ShowHSV		= 1,
				ShowRGB 	= 1,
				Multiplier	= 255 }
			)

			panel:NumberWang( "Light Length", "shaky_flashlight_farz", 0, math.huge ):SetValue(GetConVar("shaky_flashlight_farz"):GetFloat())
			panel:NumberWang( "Light Size", "shaky_flashlight_fov", 0, math.huge):SetValue(GetConVar("shaky_flashlight_fov"):GetFloat())
			panel:NumSlider( "Light AnimSpeed", "shaky_flashlight_animspeed", 0, 120 ):SetValue(GetConVar("shaky_flashlight_animspeed"):GetFloat())
			panel:NumSlider( "Light Brightness", "shaky_flashlight_brightness", 0.1, 10):SetValue(GetConVar("shaky_flashlight_brightness"):GetFloat())	
			panel:CheckBox( "Dynamic light", "shaky_flashlight_dynamiclight" ):SetValue(GetConVar("shaky_flashlight_dynamiclight"):GetBool())
			panel:CheckBox( "Should follow center", "shaky_flashlight_lightfollowcenter" ):SetValue(GetConVar("shaky_flashlight_lightfollowcenter"):GetBool())
			panel:CheckBox( "Center light origin", "shaky_flashlight_lightorigincenter" ):SetValue(GetConVar("shaky_flashlight_lightorigincenter"):GetBool())

			panel:Help("Server Settings")

			panel:CheckBox( "Enable Punch", "shaky_flashlight_enablepunch" ):SetValue(GetConVar("shaky_flashlight_enablepunch"):GetBool())	
			panel:NumSlider( "Charge Speed", "shaky_flashlight_chargespeedmultiply", 0, 10 ):SetValue(GetConVar("shaky_flashlight_chargespeedmultiply"):GetFloat())
			panel:NumSlider( "Damage Multiply", "shaky_flashlight_damagemultiply", 0, 10 ):SetValue(GetConVar("shaky_flashlight_damagemultiply"):GetFloat())


		end )
	end )
end