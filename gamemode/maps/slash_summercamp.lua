-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-08-09 13:41:40
-- @Last Modified by:   Garrus2142
-- @Last Modified time: 2017-08-09 13:41:40

local GM = GM or GAMEMODE

GM.MAP.Name = "Summercamp"
GM.MAP.EscapeDuration = 240
GM.MAP.Goal = {
	Generator = {
		{type="sls_generator", pos=Vector( 	1678.174683, 5552.737305, 215.173004	 ), ang=Angle(	-0.483, 6.740, -0.121	),spw=false ,},
		{type="sls_generator", pos=Vector( 	-2755.215576, -1942.527344, 27.788239	 ), ang=Angle(	3.708, -36.244, -0.005	),spw=false,},
		{type="sls_generator", pos=Vector( 	6499.022461, -1667.111450, 11.305360	 ), ang=Angle(	0.297, 41.523, 0.176	),spw=false,},
	},

	Jerrican = {
		{type="sls_jerrican", pos=Vector( 	986.629150, 1900.260864, 275.224335	 ), ang=Angle(	-31.284, 3.741, -0.192	), spw = false,},
		{type="sls_jerrican", pos=Vector( 	132.203217, 1687.506958, 275.231934	 ), ang=Angle(	-0.148, -179.006, -0.115	),spw = false,},
		{type="sls_jerrican", pos=Vector( 	-198.006714, 3428.893799, 275.202301	 ), ang=Angle(	0.577, -0.022, -0.115	),spw = false,},
		{type="sls_jerrican", pos=Vector( 	1155.607666, 1691.713379, 275.225677	 ), ang=Angle(	0.472, -0.027, -0.093	),spw = false,},
		{type="sls_jerrican", pos=Vector( 	835.292908, 3425.746338, 275.231995	 ), ang=Angle(	0.445, -0.027, -0.088	),spw = false,},
		{type="sls_jerrican", pos=Vector( 	3954.628174, 3936.639893, 265.443634	 ), ang=Angle(	-0.236, -0.044, 0.401	),spw = false,},
		{type="sls_jerrican", pos=Vector( 	1055.940552, 5541.725098, 275.162415	 ), ang=Angle(	0.066, 44.324, 0.000	),spw = false,},
		{type="sls_jerrican", pos=Vector( 	-2709.210693, -1529.358643, 73.433403	 ), ang=Angle(	0.797, 0.000, -0.088	),spw = false,},
		{type="sls_jerrican", pos=Vector( 	829.121765, 355.968048, 79.252518	 ), ang=Angle(	-0.352, 0.027, -0.071	),spw = false,},
		{type="sls_jerrican", pos=Vector( 	-194.238800, 354.712860, 79.294006	 ), ang=Angle(	-0.170, 0.027, -0.033	),spw = false,},
		{type="sls_jerrican", pos=Vector( 	-870.087891, -610.642456, 79.196129	 ), ang=Angle(	0.604, -0.022, -0.121	),spw = false,},
		{type="sls_jerrican", pos=Vector( 	131.326981, -1380.994995, 79.235001	 ), ang=Angle(	0.434, -0.027, -0.082	),spw = false,},
		{type="sls_jerrican", pos=Vector( 	1152.339355, -1376.056885, 79.235016	 ), ang=Angle(	0.428, -0.027, -0.082	),spw = false,},
		{type="sls_jerrican", pos=Vector( 	-780.021362, -929.935791, 19.447821	 ), ang=Angle(	1.807, 56.799, 0.324	),spw = false,},
		{type="sls_jerrican", pos=Vector( 	8045.914551, -1821.616089, 32.290798	 ), ang=Angle(	0.593, -39.265, 0.000	),spw = false,},
		{type="sls_jerrican", pos=Vector( 	5475.315918, 3365.187500, 223.280289	 ), ang=Angle(	-0.747, 7.454, -0.005	),spw = false,},
		{type="sls_jerrican", pos=Vector( 	-792.936462, 5763.221191, 263.126678	 ), ang=Angle(	82.183, -179.995,169.547	),spw = false,},
	},
	Locker = {
		{type="prop_huntress_locker", pos=Vector(-762.96875, -380.4375, 65.5625), ang=Angle(0, -90.0625, -0.03125),},
		{type="prop_huntress_locker", pos=Vector(-235.25, 317.65625, 65.5625), ang=Angle(0.125, 0.09375, -0.3125),},
		{type="prop_huntress_locker", pos=Vector(788.59375, 322.5, 65.5625), ang=Angle(0, -0.3125, -0.09375),},
		{type="prop_huntress_locker", pos=Vector(1195.46875, -1346.59375, 65.5), ang=Angle(-0.03125, 179.90625, 0.09375),},
		{type="prop_huntress_locker", pos=Vector(171.46875, -1346.34375, 65.46875), ang=Angle(0.03125, -179.9375, 0),},
		{type="prop_huntress_locker", pos=Vector(-763.8125, 2691.625, 261.4375), ang=Angle(0, -90.03125, 0.0625),},
		{type="prop_huntress_locker", pos=Vector(-235.40625, 3394.5, 261.46875), ang=Angle(0, 0.03125, -0.21875),},
		{type="prop_huntress_locker", pos=Vector(789, 3392.40625, 261.5), ang=Angle(0, -0.15625, -0.125),},
		{type="prop_huntress_locker", pos=Vector(1195, 1725.46875, 261.46875), ang=Angle(0, 179.9375, 0),},
		{type="prop_huntress_locker", pos=Vector(171.53125, 1727.46875, 261.53125), ang=Angle(0.21875, -179.96875, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(1053.375, 5097.0625, 202.875), ang=Angle(-0.65625, -89.34375, -0.46875),},
		{type="prop_huntress_locker", pos=Vector(1148.59375, 5098.09375, 202.03125), ang=Angle(-0.65625, -89.34375, -0.46875),},
		{type="prop_huntress_locker", pos=Vector(1044.53125, 5158.1875, 261.46875), ang=Angle(-0.03125, 0.0625, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(1641.125, 5478.28125, 261.4375), ang=Angle(-0.40625, -90.40625, -0.09375),},
		{type="prop_huntress_locker", pos=Vector(1694.0625, 5477.875, 261.34375), ang=Angle(-0.40625, -90.40625, -0.09375),},
		{type="prop_huntress_locker", pos=Vector(3870.625, 3875.53125, 205.84375), ang=Angle(-2.09375, 179.84375, 0.40625),},
		{type="prop_huntress_locker", pos=Vector(3870.5, 3809.5625, 206.34375), ang=Angle(-2.09375, 179.84375, 0.40625),},
		{type="prop_huntress_locker", pos=Vector(3840.28125, 5011.59375, 225.46875), ang=Angle(0, -90.09375, 0.03125),},
		{type="prop_huntress_locker", pos=Vector(3840.75, 5228.40625, 225.53125), ang=Angle(-0.03125, 89.96875, -0.34375),},
		{type="prop_huntress_locker", pos=Vector(6431.4375, -1605.875, 10.65625), ang=Angle(0.125, 135.8125, 0.46875),},
		{type="prop_huntress_locker", pos=Vector(6381.875, -1656.90625, 11.28125), ang=Angle(0.125, 135.8125, 0.46875),},
		{type="prop_huntress_locker", pos=Vector(-2547.5, -1535.375, 12.96875), ang=Angle(0.34375, -0.09375, 0.71875),},
		{type="prop_huntress_locker", pos=Vector(-2547.65625, -1617.03125, 11.90625), ang=Angle(0.34375, -0.09375, 0.71875),},
		},
		

	Radio = {
		{type="sls_radio", pos=Vector( 	1226.423584, 5450.633301, 304.424774	 ), ang=Angle(	-0.137, -43.237, 0.044	),spw = false,},
		{type="sls_radio", pos=Vector( 	7130.218262, -1156.360596, 28.896412	 ), ang=Angle(	0.247, 14.738, -0.033	),spw = false,},
		{type="sls_radio", pos=Vector( 	4618.899902, -671.850220, 31.748055	 ), ang=Angle(	1.165, 101.294, 0.220	),spw = false,},
	}
}

GM.MAP.Pages = {
	Page = {
		{type="ent_slender_rising_notepage", pos=Vector( 	986.629150, 1900.260864, 275.224335	 ), ang=Angle(	-31.284, 3.741, -0.192	), spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector( 	132.203217, 1687.506958, 275.231934	 ), ang=Angle(	-0.148, -179.006, -0.115	),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector( 	-198.006714, 3428.893799, 275.202301	 ), ang=Angle(	0.577, -0.022, -0.115	),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector( 	1155.607666, 1691.713379, 275.225677	 ), ang=Angle(	0.472, -0.027, -0.093	),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector( 	835.292908, 3425.746338, 275.231995	 ), ang=Angle(	0.445, -0.027, -0.088	),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector( 	3954.628174, 3936.639893, 265.443634	 ), ang=Angle(	-0.236, -0.044, 0.401	),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector( 	1055.940552, 5541.725098, 275.162415	 ), ang=Angle(	0.066, 44.324, 0.000	),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector( 	-2709.210693, -1529.358643, 73.433403	 ), ang=Angle(	0.797, 0.000, -0.088	),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector( 	829.121765, 355.968048, 79.252518	 ), ang=Angle(	-0.352, 0.027, -0.071	),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector( 	-194.238800, 354.712860, 79.294006	 ), ang=Angle(	-0.170, 0.027, -0.033	),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector( 	-870.087891, -610.642456, 79.196129	 ), ang=Angle(	0.604, -0.022, -0.121	),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector( 	131.326981, -1380.994995, 79.235001	 ), ang=Angle(	0.434, -0.027, -0.082	),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector( 	1152.339355, -1376.056885, 79.235016	 ), ang=Angle(	0.428, -0.027, -0.082	),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector( 	-780.021362, -929.935791, 19.447821	 ), ang=Angle(	1.807, 56.799, 0.324	),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector( 	8045.914551, -1821.616089, 32.290798	 ), ang=Angle(	0.593, -39.265, 0.000	),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector( 	5475.315918, 3365.187500, 223.280289	 ), ang=Angle(	-0.747, 7.454, -0.005	),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector( 	-792.936462, 5763.221191, 263.126678	 ), ang=Angle(	82.183, -179.995,169.547	),spw = false,},
	}
}
GM.MAP.Shotgun = {
	Shotgun = {
		{type="sr2_sg", pos=Vector( 	1226.423584, 5450.633301, 304.424774	 ), ang=Angle(	-0.137, -43.237, 0.044	),spw = false,},
		{type="sr2_sg", pos=Vector( 	7130.218262, -1156.360596, 28.896412	 ), ang=Angle(	0.247, 14.738, -0.033	),spw = false,},
		{type="sr2_sg", pos=Vector( 	4618.899902, -671.850220, 31.748055	 ), ang=Angle(	1.165, 101.294, 0.220	),spw = false,},
	}
}