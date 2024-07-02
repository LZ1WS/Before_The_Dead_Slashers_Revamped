local GM = GM or GAMEMODE

surface.CreateFont( "Roboto F4", {
	font = "Roboto Bold", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function OpenHUBMENU()
	if IsValid(HUBMENU) then HUBMENU:Remove() return end

	HUBMENU = vgui.Create( "slsHubMain" )

end

net.Receive("sls_OpenHUB", OpenHUBMENU)