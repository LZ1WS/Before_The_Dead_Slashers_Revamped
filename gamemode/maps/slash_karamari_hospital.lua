local GM = GM or GAMEMODE

GM.MAP.Name = "Karamari Hospital"
GM.MAP.EscapeDuration = 90

GM.MAP.Goal = {
	Jerrican = {
		 {type="sls_jerrican", pos=Vector( 1202.500488, 590.742981, 79.257881 ), ang=Angle(-0.112, 178.479, -0.061),},
		 {type="sls_jerrican", pos=Vector( 412.101654, -662.728088, 104.499802 ), ang=Angle(-90.000, 136.520, 180.000),},
		 {type="sls_jerrican", pos=Vector( -608.839111, -573.455872, 79.332787 ), ang=Angle(-0.007, 2.261, -0.003),},
		 {type="sls_jerrican", pos=Vector( -1779.837524, 64.121086, 79.292671 ), ang=Angle(0.238, 5.592, -0.136),},
		 {type="sls_jerrican", pos=Vector( 1023.672852, -1231.678345, -11.583842 ), ang=Angle(-89.834, 139.909, 131.303),},
		 {type="sls_jerrican", pos=Vector( -865.440308, 478.654083, 79.295715 ), ang=Angle(0.000, 179.146, 0.217),},
		 {type="sls_jerrican", pos=Vector( 1853.344360, -249.551346, 79.323524 ), ang=Angle(0.083, 34.978, -0.013),},
		 {type="sls_jerrican", pos=Vector( 624.726563, 428.655518, -34.804615 ), ang=Angle(-0.205, -176.642, -0.109),},
		 {type="sls_jerrican", pos=Vector( 1877.500244, -905.682434, 79.311447 ), ang=Angle(0.000, 180.000, 0.125),},
		 {type="sls_jerrican", pos=Vector( 785.436646, -1503.792847, 79.181374 ), ang=Angle(0.396, 95.978, -0.024),},
		 {type="sls_jerrican", pos=Vector( 540.771729, 368.424316, -232.618149 ), ang=Angle(-89.958, -75.531, 180.000),},
		 {type="sls_jerrican", pos=Vector( 3220.353027, -1016.017578, -312.548035 ), ang=Angle(89.756, -29.507, -10.028),},
		 {type="sls_jerrican", pos=Vector( 1129.766235, -1454.510376, 79.641663 ), ang=Angle(-22.780, -4.196, -0.304),},
		 {type="sls_jerrican", pos=Vector( 946.259338, -39.342052, -34.188316 ), ang=Angle(-15.593, -1.452, -0.151),},
		 {type="sls_jerrican", pos=Vector( -1818.204590, 372.499786, 79.332787 ), ang=Angle(0.000, 90.000, 0.000),},

	},

	Radio = {
		 {type="sls_radio", pos=Vector( 541.100769, 84.935715, -12.503160 ), ang=Angle(-0.018, 87.866, -0.002),},
		 {type="sls_radio", pos=Vector( -738.430298, -784.320862, 104.798630 ), ang=Angle(0.039, 137.281, -0.012),},
		 {type="sls_radio", pos=Vector( 1663.868408, -501.911621, 114.354301 ), ang=Angle(0.193, 92.673, 0.015),},
		 {type="sls_radio", pos=Vector( 708.762695, 240.745224, -279.527008 ), ang=Angle(-0.013, 90.450, 0.004),},

	},

	Locker = {
		{type="prop_huntress_locker", pos=Vector(3433.96875, -1412.125, -315.3125), ang=Angle(0, 90, 0),},
		{type="prop_huntress_locker", pos=Vector(3350.84375, -1413, -315.1875), ang=Angle(-0.34375, 90.65625, 0.0625),},
		{type="prop_huntress_locker", pos=Vector(571.0625, 664.5, -315.4375), ang=Angle(-0.03125, -90.0625, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(640.65625, 664.59375, -315.5), ang=Angle(0, -89.96875, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(284.71875, 319.40625, -48.375), ang=Angle(0.1875, 0.3125, -0.28125),},
		{type="prop_huntress_locker", pos=Vector(284.5, 390.5625, -48.40625), ang=Angle(0, 0, -0.03125),},
		{type="prop_huntress_locker", pos=Vector(1190.34375, -706.53125, -48.46875), ang=Angle(-0.03125, -89.90625, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(853.03125, -706.5625, -48.4375), ang=Angle(-0.03125, -90, -0.09375),},
		{type="prop_huntress_locker", pos=Vector(1193.03125, -1507.59375, -48.53125), ang=Angle(0, 90.03125, -0.1875),},
		{type="prop_huntress_locker", pos=Vector(859.78125, -1507.46875, -48.5), ang=Angle(-0.03125, 90.15625, 0.125),},
		{type="prop_huntress_locker", pos=Vector(1063.09375, -1232.15625, 65.5625), ang=Angle(0, -0.59375, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(913.46875, -904.78125, 65.53125), ang=Angle(0, 179.71875, 0.34375),},
		{type="prop_huntress_locker", pos=Vector(964.5625, -1507.375, 65.5), ang=Angle(-0.0625, 89.9375, -0.1875),},
		{type="prop_huntress_locker", pos=Vector(837.90625, -1507.34375, 65.5), ang=Angle(0.03125, 90.03125, -0.125),},
		{type="prop_huntress_locker", pos=Vector(509.5625, -910.0625, 65.53125), ang=Angle(0, -179.9375, 0),},
		{type="prop_huntress_locker", pos=Vector(411.53125, 382.1875, 65.5625), ang=Angle(-0.03125, 179.78125, 0),},
		{type="prop_huntress_locker", pos=Vector(815.46875, 385.96875, 65.59375), ang=Angle(-0.03125, 179.90625, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(1219.4375, 392.4375, 65.53125), ang=Angle(-0.03125, -179.84375, 0),},
		{type="prop_huntress_locker", pos=Vector(964.5625, 65.0625, 65.53125), ang=Angle(-0.03125, 0.0625, 0.0625),},
		{type="prop_huntress_locker", pos=Vector(857.53125, 72.3125, 65.53125), ang=Angle(0, 179.84375, 0),},
		{type="prop_huntress_locker", pos=Vector(156.5, 69.71875, 65.53125), ang=Angle(0, 0.03125, 0),},
		{type="prop_huntress_locker", pos=Vector(1588.5625, -507.59375, 65.53125), ang=Angle(0, 90.03125, 0),},
		{type="prop_huntress_locker", pos=Vector(1270.28125, -252.46875, 65.5625), ang=Angle(0, -89.96875, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(1586.71875, -1007.46875, 65.53125), ang=Angle(0, 90, 0),},
		},		

	Generator = {
		 {type="sls_generator", pos=Vector( 853.548096, -760.307983, -49.713272 ), ang=Angle(-0.103, -89.944, 0.030),},
		 {type="sls_generator", pos=Vector( 3255.507568, -222.560364, -315.009491 ), ang=Angle(-2.000, -90.011, 0.000),},
		 {type="sls_generator", pos=Vector( 937.622864, -1488.448120, 64.255753 ), ang=Angle(-0.007, 179.903, 0.016),},
		 {type="sls_generator", pos=Vector( 774.660645, 87.774857, -49.650146 ), ang=Angle(-0.098, -95.503, -0.033),},
	}
}