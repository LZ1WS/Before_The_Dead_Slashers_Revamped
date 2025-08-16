-- vim: fdm=marker se sw=4 ts=4 :

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

--{{{1
SWEP.Weight         = 0
SWEP.AutoSwitchTo   = false
SWEP.AutoSwitchFrom = false

-- Resources {{{1
resource.AddFile( "materials/weapons/empty_hands.vmt" )
--resource.AddFile( "materials/weapons/empty_hands.vtf" )

-- Dummy model
resource.AddFile( "models/weapons/rainchu/v_nothing.mdl" )
--resource.AddFile( "models/weapons/rainchu/v_nothing.dx80.vtx" )
--resource.AddFile( "models/weapons/rainchu/v_nothing.dx90.vtx" )
--resource.AddFile( "models/weapons/rainchu/v_nothing.sw.vtx" )
--resource.AddFile( "models/weapons/rainchu/v_nothing.vvd" )

resource.AddFile( "models/weapons/rainchu/w_nothing.mdl" )
--resource.AddFile( "models/weapons/rainchu/w_nothing.dx80.vtx" )
--resource.AddFile( "models/weapons/rainchu/w_nothing.dx90.vtx" )
--resource.AddFile( "models/weapons/rainchu/w_nothing.sw.vtx" )
--resource.AddFile( "models/weapons/rainchu/w_nothing.vvd" )

resource.AddFile( "materials/models/weapons/rainchu/empty_hands/invisible.vmt" )
--resource.AddFile( "materials/models/weapons/rainchu/empty_hands/invisible.vtf" )
--}}}

function SWEP:GetCapabilities() --{{{1
	return 0
end
