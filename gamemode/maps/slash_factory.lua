local GM = GM or GAMEMODE

GM.MAP.Name = "Factory"
GM.MAP.EscapeDuration = 60

GM.MAP.Goal = {
	Generator = {
		{type="sls_generator", pos=Vector(845.84375, -2736.125, -255.6875), ang=Angle(-0.0625, -116, 0),},
		{type="sls_generator", pos=Vector(-2699.40625, -1876.78125, -255.25), ang=Angle(-0.4375, 62.78125, 0.0625),},
		{type="sls_generator", pos=Vector(-783.0625, -32.25, -255.6875), ang=Angle(-0.0625, -33.34375, 0),},
		{type="sls_generator", pos=Vector(-1425.65625, -2474.59375, -255.625), ang=Angle(-0.0625, 46.8125, 0),},
		{type="sls_generator", pos=Vector(-131.1875, -5614.46875, -255.6875), ang=Angle(-0.0625, -129.71875, 0),},
		{type="sls_generator", pos=Vector(-1623.4375, -4005.0625, -255.6875), ang=Angle(-0.0625, 59.6875, 0),},
		},		

		Jerrican = {
			{type="sls_jerrican", pos=Vector(-362.5, 306.15625, -60.65625), ang=Angle(0, 0.78125, 0),},
			{type="sls_jerrican", pos=Vector(274.28125, 322.25, -71.5625), ang=Angle(89.71875, -157.09375, 137.875),},
			{type="sls_jerrican", pos=Vector(695.75, -525.03125, -60.71875), ang=Angle(0.0625, 51.09375, 0),},
			{type="sls_jerrican", pos=Vector(-2034.96875, -216.875, -35.5625), ang=Angle(89.96875, 56.3125, 180),},
			{type="sls_jerrican", pos=Vector(-2685.4375, -850.4375, -60.65625), ang=Angle(-0.1875, 83.4375, 0),},
			{type="sls_jerrican", pos=Vector(-2455.6875, -1194.375, -71.53125), ang=Angle(89.53125, 68.59375, 71.3125),},
			{type="sls_jerrican", pos=Vector(-2664.15625, -2995.46875, -60.65625), ang=Angle(0, 90, 0),},
			{type="sls_jerrican", pos=Vector(-2501.40625, -2250.75, -71.5625), ang=Angle(-89.5, 87.09375, 88.3125),},
			{type="sls_jerrican", pos=Vector(-2588.75, -3699.59375, -60.71875), ang=Angle(0, 89.46875, 0),},
			{type="sls_jerrican", pos=Vector(-1454.09375, -130.625, 12.71875), ang=Angle(89.9375, -66.625, 180),},
			{type="sls_jerrican", pos=Vector(900.5, -2365.75, -71.59375), ang=Angle(-89.625, 177.125, -41.125),},
			{type="sls_jerrican", pos=Vector(1140.46875, -2003.75, -65.78125), ang=Angle(0, -179.96875, -89.78125),},
			{type="sls_jerrican", pos=Vector(-715.21875, -5631.3125, -222.84375), ang=Angle(-89.875, -121.5, 29.9375),},
			{type="sls_jerrican", pos=Vector(-980.5, -4140.71875, -240.65625), ang=Angle(0.125, -179.6875, 0.03125),},
			{type="sls_jerrican", pos=Vector(-1684.46875, -1396.84375, -234.03125), ang=Angle(-89.96875, -168.1875, 180),},
			{type="sls_jerrican", pos=Vector(-1076.375, -5439.8125, -240.6875), ang=Angle(-0.46875, 96.625, 0.125),},
			{type="sls_jerrican", pos=Vector(-1222.9375, -5444.6875, -240.78125), ang=Angle(0.21875, 92.25, -0.03125),},
			{type="sls_jerrican", pos=Vector(-131.90625, -5172.8125, -240.75), ang=Angle(0.1875, -84.375, -0.03125),},
			{type="sls_jerrican", pos=Vector(-231.53125, -2365.9375, -200.96875), ang=Angle(0, 179.1875, -0.03125),},
			{type="sls_jerrican", pos=Vector(-1439.46875, -4452.125, -251.53125), ang=Angle(-89.6875, -42.71875, -14.40625),},
			{type="sls_jerrican", pos=Vector(-1174.5, -2996.28125, -201), ang=Angle(0, -90, -0.03125),},
			{type="sls_jerrican", pos=Vector(-1827.96875, -4167.375, -251.53125), ang=Angle(-89.65625, 17.1875, -151.625),},
			{type="sls_jerrican", pos=Vector(-1830.21875, -3073.9375, -220.625), ang=Angle(-89.8125, 150.53125, -60.8125),},
			{type="sls_jerrican", pos=Vector(113.8125, -888.34375, -251.5), ang=Angle(89.96875, 35.9375, 180),},
			{type="sls_jerrican", pos=Vector(-1134.96875, -2333.0625, -231.65625), ang=Angle(-0.5, 64.96875, 0.15625),},
			{type="sls_jerrican", pos=Vector(-583.875, -975.375, -234.0625), ang=Angle(89.71875, 132.0625, -28.78125),},
			{type="sls_jerrican", pos=Vector(-576.59375, -5477.84375, -245.78125), ang=Angle(-1.21875, 143.8125, -90),},
			{type="sls_jerrican", pos=Vector(-394.875, -4411.28125, -240.53125), ang=Angle(-4.5625, 118.3125, -0.0625),},
			{type="sls_jerrican", pos=Vector(-280.71875, -2105.3125, -211.8125), ang=Angle(-89.53125, -77.375, -130.5),},
			},

			Locker = {
				{type="prop_huntress_locker", pos=Vector(-266.3125, 259.5, -74.4375), ang=Angle(0, -90, 0.03125),},
				{type="prop_huntress_locker", pos=Vector(-203.875, 259.5, -74.4375), ang=Angle(0, -90, -0.09375),},
				{type="prop_huntress_locker", pos=Vector(205.40625, 259.5625, -74.375), ang=Angle(0, -90.15625, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(266.40625, 259.53125, -74.4375), ang=Angle(0, -89.875, 0.03125),},
				{type="prop_huntress_locker", pos=Vector(-2158.40625, -266.40625, -74.40625), ang=Angle(0, 0.21875, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-2158.5, 154.15625, -74.40625), ang=Angle(0, 0, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-2158.84375, -156.53125, -74.53125), ang=Angle(0, 0.21875, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-2158.4375, -13.71875, -74.15625), ang=Angle(0, 0, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-2621.9375, -3484.375, -74.4375), ang=Angle(0, -90, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-2625.84375, -3132.5, -74.40625), ang=Angle(0, -90, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-2625.96875, -2780.53125, -74.40625), ang=Angle(-0.03125, -89.875, -0.03125),},
				{type="prop_huntress_locker", pos=Vector(-2623.9375, -2428.46875, -74.40625), ang=Angle(0, -90, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-2625.75, -2076.40625, -74.40625), ang=Angle(0.03125, -90, -0.09375),},
				{type="prop_huntress_locker", pos=Vector(-2626.34375, -1340.46875, -74.40625), ang=Angle(0, -90, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-2622.8125, -988.5625, -74.5625), ang=Angle(0.03125, -89.84375, -0.03125),},
				{type="prop_huntress_locker", pos=Vector(-2627.3125, -636.3125, -74.53125), ang=Angle(0, -89.96875, -0.03125),},
				{type="prop_huntress_locker", pos=Vector(604.3125, -2384.09375, -74.5), ang=Angle(0, 0, -0.125),},
				{type="prop_huntress_locker", pos=Vector(604.53125, -2254.25, -74.4375), ang=Angle(-0.0625, 0.0625, 0.03125),},
				{type="prop_huntress_locker", pos=Vector(604.34375, -1760.875, -74.53125), ang=Angle(-0.03125, 0.0625, -0.03125),},
				{type="prop_huntress_locker", pos=Vector(604.46875, -1621.28125, -74.40625), ang=Angle(0, 0, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-1236.46875, -978, -254.40625), ang=Angle(0, 179.96875, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-1236.3125, -1229.75, -254.25), ang=Angle(0.09375, -179.96875, 0.34375),},
				{type="prop_huntress_locker", pos=Vector(-1836.5, -1002.71875, -254.40625), ang=Angle(0, -179.96875, -0.03125),},
				{type="prop_huntress_locker", pos=Vector(-499.78125, -1492.46875, -254.4375), ang=Angle(0, -89.90625, -0.03125),},
				{type="prop_huntress_locker", pos=Vector(-295.59375, -1492.46875, -254.4375), ang=Angle(0, -90, -0.125),},
				{type="prop_huntress_locker", pos=Vector(-483, -1637.6875, -254.375), ang=Angle(0, 89.9375, 0.40625),},
				{type="prop_huntress_locker", pos=Vector(-37.40625, -2457.9375, -254.40625), ang=Angle(0.09375, 0.03125, 0),},
				{type="prop_huntress_locker", pos=Vector(-37.375, -2379.6875, -254.4375), ang=Angle(0.0625, -0.0625, -0.09375),},
				{type="prop_huntress_locker", pos=Vector(-1216.28125, -3084.15625, -254.375), ang=Angle(0, -90, -0.15625),},
				{type="prop_huntress_locker", pos=Vector(-1140.25, -3084.5, -254.25), ang=Angle(-0.15625, -89.71875, 0),},
				{type="prop_huntress_locker", pos=Vector(-1472.4375, -3484.5, -74.40625), ang=Angle(0, -89.9375, -0.09375),},
				{type="prop_huntress_locker", pos=Vector(-961.40625, -3715.46875, -74.375), ang=Angle(0, 90.0625, -0.15625),},
				{type="prop_huntress_locker", pos=Vector(-886.4375, -3484.5, -74.40625), ang=Angle(0, -89.96875, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-1547.5, -3715.5, -74.40625), ang=Angle(0, 90, -0.09375),},
				{type="prop_huntress_locker", pos=Vector(-179.375, -4203.9375, -254.0625), ang=Angle(0.40625, -90.03125, 0),},
				{type="prop_huntress_locker", pos=Vector(-60.21875, -4379.53125, -254.4375), ang=Angle(-0.0625, 89.9375, -0.09375),},
				{type="prop_huntress_locker", pos=Vector(53.46875, -4204.3125, -254.46875), ang=Angle(0, -90.15625, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-654.09375, -4379.875, -254.40625), ang=Angle(0.25, 89.96875, 0.0625),},
				{type="prop_huntress_locker", pos=Vector(-1191.21875, -4204.25, -254.46875), ang=Angle(0.09375, -90.09375, 0),},
				{type="prop_huntress_locker", pos=Vector(-984.875, -4204.3125, -254.59375), ang=Angle(0, -89.96875, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-1646.03125, -4379.59375, -254.4375), ang=Angle(-0.09375, 90, -0.1875),},
				{type="prop_huntress_locker", pos=Vector(-1773.5625, -4379.78125, -254.40625), ang=Angle(0.125, 90.03125, 0.0625),},
				{type="prop_huntress_locker", pos=Vector(-1907.96875, -4204.375, -254.40625), ang=Angle(0, -89.9375, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(60.4375, -5397.0625, -253.875), ang=Angle(1.875, 89.8125, 0),},
				{type="prop_huntress_locker", pos=Vector(-68.6875, -5220.25, -254.40625), ang=Angle(0.125, -89.90625, 0.03125),},
				{type="prop_huntress_locker", pos=Vector(-543.46875, -5395.5625, -254.4375), ang=Angle(-0.09375, 89.9375, -0.09375),},
				{type="prop_huntress_locker", pos=Vector(-616.0625, -5395.59375, -254.4375), ang=Angle(0, 89.875, 0),},
				{type="prop_huntress_locker", pos=Vector(-966.59375, -5220.3125, -254.40625), ang=Angle(0, -89.90625, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-1294.3125, -5395.78125, -254.4375), ang=Angle(0.125, 89.96875, 0.0625),},
				{type="prop_huntress_locker", pos=Vector(-1642.34375, -5220.3125, -254.40625), ang=Angle(0.0625, -90.125, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-1918.90625, -5395.53125, -254.4375), ang=Angle(-0.09375, 89.90625, 0.0625),},
				{type="prop_huntress_locker", pos=Vector(-2585.8125, -3260.34375, -254.53125), ang=Angle(0, -89.9375, -0.03125),},
				{type="prop_huntress_locker", pos=Vector(-2389.5, -3260.4375, -254.40625), ang=Angle(0, -90.125, 0),},
				{type="prop_huntress_locker", pos=Vector(-2390.3125, -3947.53125, -253.875), ang=Angle(0, 90.125, 0),},
				{type="prop_huntress_locker", pos=Vector(-2584.4375, -3947.5625, -254.5), ang=Angle(0, 89.9375, -0.0625),},
				},

	Radio = {
		{type="sls_radio", pos=Vector(-451.53125, -5044.34375, -215.84375), ang=Angle(-0.125, 6.28125, 0.09375),},
		{type="sls_radio", pos=Vector(1138.46875, -1838.1875, -43.5), ang=Angle(0, -0.03125, 0),},
		{type="sls_radio", pos=Vector(-1609.78125, -268, -18.5), ang=Angle(0, 89.75, 0),},
		{type="sls_radio", pos=Vector(-1526, -1001.59375, -224.625), ang=Angle(0, 57.46875, 0),},
		{type="sls_radio", pos=Vector(-791.65625, -2273.5, -219.28125), ang=Angle(-0.125, 0, 0.03125),},
		{type="sls_radio", pos=Vector(-1341.71875, -5525.09375, -215.90625), ang=Angle(0, -139.21875, 0),},
		{type="sls_radio", pos=Vector(75.40625, -1398.21875, -215.9375), ang=Angle(0, 101.90625, 0),},
	},
			

	}

	GM.MAP.Pages = {
		Page = {
			{type="ent_slender_rising_notepage", pos=Vector(302.5625, 216.9375, -66.875), ang=Angle(-0.03125, 179.875, -0.21875),},
			{type="ent_slender_rising_notepage", pos=Vector(-2569.71875, -854.59375, -55.75), ang=Angle(0.0625, 89.65625, -0.0625),},
			{type="ent_slender_rising_notepage", pos=Vector(366.71875, 457.5, -64.5625), ang=Angle(0.09375, 179.84375, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(-313.3125, 338.46875, -64.28125), ang=Angle(0.03125, -179.96875, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(-1162.125, -2329.65625, -238.0625), ang=Angle(-0.125, 179.71875, -0.4375),},
			{type="ent_slender_rising_notepage", pos=Vector(-858.5, -238.40625, -53.03125), ang=Angle(0, 0, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(-2169.46875, -73.5, -57.1875), ang=Angle(0, 0, -0.03125),},
			{type="ent_slender_rising_notepage", pos=Vector(811.90625, -2558.5625, -45.25), ang=Angle(0, 89.6875, -0.375),},
			{type="ent_slender_rising_notepage", pos=Vector(-2569.625, -1558.71875, -52.65625), ang=Angle(0.125, 89.625, -0.0625),},
			{type="ent_slender_rising_notepage", pos=Vector(-2567.40625, -2646.5, -54.96875), ang=Angle(0, 89.96875, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(-2574.21875, -3350.5625, -51.71875), ang=Angle(0, 89.53125, -0.28125),},
			{type="ent_slender_rising_notepage", pos=Vector(-925.46875, -3694.5, -54.84375), ang=Angle(0, 89.96875, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(-2704.09375, -1942.71875, -258.03125), ang=Angle(0.21875, 89.84375, 0.03125),},
			{type="ent_slender_rising_notepage", pos=Vector(-1573.3125, -1315.4375, -259.46875), ang=Angle(0, -90.3125, -1.5),},
			{type="ent_slender_rising_notepage", pos=Vector(-681.375, -2282.53125, -240.5625), ang=Angle(0, 179.4375, 0.375),},
			{type="ent_slender_rising_notepage", pos=Vector(-1655.25, -742.59375, -252.46875), ang=Angle(0, 89.96875, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(-665.40625, 22.65625, -252.1875), ang=Angle(0, -90.21875, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(-1011.9375, -4481.5, -233.25), ang=Angle(0, -90.34375, 0.21875),},
			{type="ent_slender_rising_notepage", pos=Vector(-115.15625, -5624.5625, -254.5625), ang=Angle(-89.5, -178.46875, 87.90625),},
			{type="ent_slender_rising_notepage", pos=Vector(-1820.34375, -5519.71875, -254.59375), ang=Angle(-89.71875, -78.875, 79.40625),},
			{type="ent_slender_rising_notepage", pos=Vector(-2604.53125, -3249.4375, -248.25), ang=Angle(0, -90.34375, -0.03125),},
			},

			Shotgun = {
				{type="sr2_sg", pos=Vector(-1572.5, -271.78125, -43.625), ang=Angle(-1.03125, -178.25, -85.96875),},
				{type="sr2_sg", pos=Vector(-1546.96875, -3944.8125, -244.59375), ang=Angle(-46.875, 35.6875, 7.46875),},
				{type="sr2_sg", pos=Vector(903.375, -778.15625, -43.4375), ang=Angle(-1.875, -95.53125, -84.4375),},
				{type="sr2_sg", pos=Vector(-410.71875, -5106, -253.625), ang=Angle(-1.5625, 164.125, -84.34375),},
				{type="sr2_sg", pos=Vector(-1255.0625, -2459.71875, -203.78125), ang=Angle(-1.46875, -109.28125, -84.96875),},
				{type="sr2_sg", pos=Vector(-693.03125, -5635.90625, -208.75), ang=Angle(-1.65625, 0.875, -84.25),},
				{type="sr2_sg", pos=Vector(-1262.0625, -4954.21875, -208.84375), ang=Angle(-1.59375, 60.75, -84.375),},
				{type="sr2_sg", pos=Vector(-2506.9375, -787.15625, -41.375), ang=Angle(-3.625, -95.59375, 82.3125),},
				{type="sr2_sg", pos=Vector(131.25, -10.4375, -52.9375), ang=Angle(-1.125, -38.25, -85.1875),},
				{type="sr2_sg", pos=Vector(1114.6875, -2072.96875, -41.5625), ang=Angle(-1.75, 93.65625, -84.4375),},
				},


	}

	GM.MAP.Vaccine = {
		Box = {
			{type="sls_vaccine", pos=Vector(224.84375, -273.8125, -75.09375), ang=Angle(0.28125, 90.09375, 0),},
			{type="sls_vaccine", pos=Vector(-224.25, -273.875, -75.09375), ang=Angle(0.375, 90.03125, -0.03125),},
			{type="sls_vaccine", pos=Vector(-1615.65625, 161.78125, -75.34375), ang=Angle(0.03125, -89.96875, 0),},
			{type="sls_vaccine", pos=Vector(-1956.15625, 161.6875, -75.125), ang=Angle(0.3125, -89.96875, 0.03125),},
			{type="sls_vaccine", pos=Vector(-883.375, -3486.21875, -75.09375), ang=Angle(0.3125, -90.0625, 0),},
			{type="sls_vaccine", pos=Vector(-2513.5625, -990.09375, -75.1875), ang=Angle(0.375, -89.9375, -0.0625),},
			{type="sls_vaccine", pos=Vector(-737.71875, -2202.34375, -251.21875), ang=Angle(0, -90, 0.03125),},
			{type="sls_vaccine", pos=Vector(-2326.25, -1788.40625, -255.125), ang=Angle(0.3125, -179.9375, 0),},
			{type="sls_vaccine", pos=Vector(-740.15625, -4535.71875, -255.1875), ang=Angle(0, 179.90625, 0),},
			{type="sls_vaccine", pos=Vector(-1764.3125, -1398.3125, -237.78125), ang=Angle(0, -89.9375, 0),},
			{type="sls_vaccine", pos=Vector(-1575.875, -1398.125, -237.8125), ang=Angle(0, -90.0625, 0),},
			{type="sls_vaccine", pos=Vector(-1885.25, -5222.3125, -215.5), ang=Angle(-0.03125, -90, 0),},
			{type="sls_vaccine", pos=Vector(-1829.75, -4136.71875, -203.40625), ang=Angle(-0.03125, 90, 0.03125),},
			{type="sls_vaccine", pos=Vector(4.25, -5819.96875, -251.59375), ang=Angle(0, -177.09375, 0),},
			{type="sls_vaccine", pos=Vector(-74.875, -4037.03125, -215.5), ang=Angle(-0.0625, 91.0625, 0),},
			{type="sls_vaccine", pos=Vector(-578.6875, -981.0625, -237.90625), ang=Angle(0.53125, -59.3125, -0.03125),},
			{type="sls_vaccine", pos=Vector(-551.5, -772.90625, -220.125), ang=Angle(0, -90.09375, 0),},
			{type="sls_vaccine", pos=Vector(-2519.9375, -2078.25, -75.125), ang=Angle(0.21875, -89.875, 0),},
			{type="sls_vaccine", pos=Vector(-1178.125, -3016.9375, -215.5), ang=Angle(0, 179.46875, 0),},
			{type="sls_vaccine", pos=Vector(-469.21875, -3071.78125, -215.4375), ang=Angle(0.21875, 179.78125, 0),},
			{type="sls_vaccine", pos=Vector(910.875, -596.15625, -75.125), ang=Angle(0.25, 90.03125, 0),},
			{type="sls_vaccine", pos=Vector(926.34375, -2242.46875, -75.1875), ang=Angle(0, 0, 0),},
			{type="sls_vaccine", pos=Vector(926.125, -1762.53125, -75.125), ang=Angle(0.34375, 0, -0.0625),},
			{type="sls_vaccine", pos=Vector(-2517.5, -3134.21875, -75.1875), ang=Angle(0.28125, -89.90625, -0.1875),},
			},
	}