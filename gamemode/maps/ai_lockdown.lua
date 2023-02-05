local GM = GM or GAMEMODE

GM.MAP.Name = "Lockdown"
GM.MAP.EscapeDuration = 120
GM.MAP.LobbyMusic = "lobby/ai_lockdown.wav"

GM.MAP.Config = {
	["Surv_Spawns"] = {
		[1] = Vector(1440.8171386719, 1679.4190673828, 0.03125),
		[2] = Vector(1192.6893310547, 1646.9860839844, 0.03125),
		[3] = Vector(359.58804321289, 1178.0888671875, 0.03125),
		[4] = Vector(415.96640014648, 585.88641357422, 384.03125),
		[5] = Vector(502.865234375, -59.893054962158, 384.03125),
		[6] = Vector(-9.8572721481323, 509.65118408203, 384.03125),
		[7] = Vector(1922.3828125, -291.98532104492, 0.03125),
		[8] = Vector(-649.45135498047, -996.88122558594, 0.03125),
		[9] = Vector(-646.79370117188, -333.18399047852, 0.03125),
		[10] = Vector(1653.6431884766, -1152.8369140625, 0.03125),
		[11] = Vector(1152.3825683594, 161.04721069336, 32.03125),
	},
	["Kill_Spawns"] = {
		[1] = Vector(357.12536621094, 655.43670654297, -367.96875),
		[2] = Vector(34.806591033936, 461.36575317383, -367.96875),
		[3] = Vector(718.0673828125, 439.91424560547, -367.96875),
	},
	["Escapes"] = {
		[1] = {["pos1"] = Vector(447.96875, 640.40997314453, 511.69375610352), ["pos2"] = Vector(320.35052490234, 743.96875, 387.26470947266)},
		[2] = {["pos1"] = Vector(63.96875, 640.80462646484, 511.53063964844), ["pos2"] = Vector(-63.968742370605, 738.60693359375, 386.51974487305)	},
		[3] = {["pos1"] = Vector(-100.85536956787, -94.142616271973, 127.96875), ["pos2"] = Vector(0.46151924133301, 95.96875, 1.8274993896484)	},
		[4] = {["pos1"] = Vector(1231.5588378906, 958.40454101563, 127.96875), ["pos2"] = Vector(1152.03125, 848.03601074219, 0.42177963256836)	},

	},
	["Camera_Pos"] = Vector(678.047974, -322.470001, 444.996246),
	["Camera_Angle"] = Angle(-1.346772, -15.196017, 0.000000),
	["Exit_Doors_Type"] = "prop_dynamic"
}

GM.MAP.Goal = {
	Generator = {
		{type="sls_generator", pos=Vector(82.875, 74, -367.625), ang=Angle(-0.0625, -24.53125, 0),},
		{type="sls_generator", pos=Vector(1750.03125, -680.9375, 0.21875), ang=Angle(-0.0625, 68.53125, 0),},
		{type="sls_generator", pos=Vector(571.5, 854.8125, 0.3125), ang=Angle(-0.09375, 139.625, 0),},
		{type="sls_generator", pos=Vector(-1046.15625, 986.53125, -747.6875), ang=Angle(11.5, 6.96875, 18.1875),},
		},			

		Jerrican = {
			{type="sls_jerrican", pos=Vector(-181.25, -625.21875, 399.5), ang=Angle(-25.9375, -90.15625, 0.09375),},
			{type="sls_jerrican", pos=Vector(185.96875, -196.78125, 420.46875), ang=Angle(89.78125, -89.9375, 71.3125),},
			{type="sls_jerrican", pos=Vector(914.40625, 353.53125, 42.25), ang=Angle(-1, 166.3125, 90),},
			{type="sls_jerrican", pos=Vector(1193.40625, -638.34375, -75.53125), ang=Angle(89.84375, -41.8125, 8.5),},
			{type="sls_jerrican", pos=Vector(289.375, 155.6875, -203.53125), ang=Angle(-89.78125, -67.5625, -23.15625),},
			{type="sls_jerrican", pos=Vector(-542.9375, -1242.53125, 4.46875), ang=Angle(89.8125, 137.8125, -157.875),},
			{type="sls_jerrican", pos=Vector(-487.34375, 18.875, 7.5), ang=Angle(-79.71875, -84.84375, -34.40625),},
			{type="sls_jerrican", pos=Vector(200.25, -1.875, 15.15625), ang=Angle(-0.1875, 178.84375, -0.09375),},
			{type="sls_jerrican", pos=Vector(370.75, 805.78125, 15.1875), ang=Angle(0.25, 29.25, -0.0625),},
			{type="sls_jerrican", pos=Vector(993.125, 1360.3125, 47.15625), ang=Angle(-0.34375, -103.3125, -0.0625),},
			{type="sls_jerrican", pos=Vector(1458.1875, 1597.71875, -64.1875), ang=Angle(-30.84375, 114.875, 4.125),},
			{type="sls_jerrican", pos=Vector(802.34375, 1.5, -262.125), ang=Angle(-88.09375, 145.71875, 10.96875),},
			{type="sls_jerrican", pos=Vector(1175.84375, 844.5625, -105.3125), ang=Angle(-37.8125, 81.6875, 0),},
			{type="sls_jerrican", pos=Vector(-275.6875, -622.1875, -68.5625), ang=Angle(-59.875, -136.375, 0.53125),},
			{type="sls_jerrican", pos=Vector(-335.09375, -9.96875, -331.46875), ang=Angle(89.96875, -103.6875, 180),},
			},

			Locker = {
				{type="prop_huntress_locker", pos=Vector(496.09375, 712.375, 1.5625), ang=Angle(-0.15625, -178.0625, -0.1875),},
				{type="prop_huntress_locker", pos=Vector(499.53125, 610.40625, 1.5625), ang=Angle(0.03125, 179.96875, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(644.34375, -82.625, 1.53125), ang=Angle(0.09375, 91.09375, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(640.5625, 83.28125, 1.625), ang=Angle(-0.65625, -90.21875, 0.3125),},
				{type="prop_huntress_locker", pos=Vector(812.34375, -1503.4375, 1.53125), ang=Angle(0.1875, -0.03125, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(812.375, -1313.03125, 1.53125), ang=Angle(0.15625, 0, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(1637.28125, -1011.46875, 1.4375), ang=Angle(0, 89.96875, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(1631.28125, -1100.53125, 1.5625), ang=Angle(-0.03125, -89.875, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(1817.34375, -332.46875, 1.5625), ang=Angle(0, -89.9375, -0.03125),},
				{type="prop_huntress_locker", pos=Vector(1826.90625, -243.46875, 1.59375), ang=Angle(0, 90, 0),},
				{type="prop_huntress_locker", pos=Vector(298.40625, -690.15625, 386.15625), ang=Angle(-3, 90.125, -0.03125),},
				{type="prop_huntress_locker", pos=Vector(107.0625, -691.15625, 385.75), ang=Angle(-1.0625, 90.09375, -0.3125),},
				{type="prop_huntress_locker", pos=Vector(-1154.28125, -1036.28125, 1.4375), ang=Angle(0.0625, -89.90625, 0.03125),},
				{type="prop_huntress_locker", pos=Vector(-396.34375, -95.09375, 1.5), ang=Angle(0.3125, -179.90625, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-609.1875, 51.5, 1.5625), ang=Angle(0, -90, -0.0625),},
				},

				Radio = {
					{type="sls_radio", pos=Vector(-454, -1240, 48), ang=Angle(0, -105, 0),},
					{type="sls_radio", pos=Vector(-1254, -1042, 44), ang=Angle(0, -105, 0),},
					{type="sls_radio", pos=Vector(1382, 1602, 48), ang=Angle(0, 74.96875, 0),},
					{type="sls_radio", pos=Vector(-677.28125, -64.65625, 48.3125), ang=Angle(0.03125, 9.75, 0),},
					{type="sls_radio", pos=Vector(1175.15625, 1754.375, -79.625), ang=Angle(0.03125, -38.5, 0),},
					{type="sls_radio", pos=Vector(456.53125, 994.78125, -119.53125), ang=Angle(0, 0.0625, -0.125),},
					},

	}

	GM.MAP.Pages = {
		Page = {
			{type="ent_slender_rising_notepage", pos=Vector(736.28125, 1155.21875, 16.8125), ang=Angle(0, 89.96875, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(897.75, 1312.25, -140.6875), ang=Angle(-0.25, -0.0625, -0.3125),},
			{type="ent_slender_rising_notepage", pos=Vector(980.125, -350.59375, 11.3125), ang=Angle(0.03125, 89.65625, -0.40625),},
			{type="ent_slender_rising_notepage", pos=Vector(1825.09375, -1089.34375, 14.1875), ang=Angle(0, -90.28125, 0.03125),},
			{type="ent_slender_rising_notepage", pos=Vector(1633.1875, -254.53125, 20.25), ang=Angle(0, 89.96875, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(206.53125, -1.375, 12.65625), ang=Angle(0, 179.625, 0.78125),},
			{type="ent_slender_rising_notepage", pos=Vector(686.15625, 254.40625, -369.875), ang=Angle(0.03125, 90, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(689.75, -321.34375, -210.75), ang=Angle(0, -90.3125, 0.40625),},
			{type="ent_slender_rising_notepage", pos=Vector(288.0625, -350.65625, -228.65625), ang=Angle(0.09375, 89.65625, -0.5),},
			{type="ent_slender_rising_notepage", pos=Vector(1087.8125, 513.5, 11.5), ang=Angle(-0.03125, 89.71875, -0.46875),},
			{type="ent_slender_rising_notepage", pos=Vector(193.5625, 529.5625, 417.4375), ang=Angle(-89.40625, 178.25, 92.65625),},
			{type="ent_slender_rising_notepage", pos=Vector(-543.9375, 81.59375, 14.90625), ang=Angle(-2.0625, -89.53125, 0.875),},
			{type="ent_slender_rising_notepage", pos=Vector(-1394.71875, -1115.875, 15.5), ang=Angle(-0.6875, 0.46875, 0.78125),},
			{type="ent_slender_rising_notepage", pos=Vector(1106.03125, 159.4375, 166.6875), ang=Angle(89.65625, -101.125, -101.15625),},
			{type="ent_slender_rising_notepage", pos=Vector(-526.28125, -126.59375, -96.28125), ang=Angle(0, 89.40625, 0.0625),},
			},

	}
	GM.MAP.Shotgun = {
		Shotgun = {
			{type="sr2_sg", pos=Vector(341.65625, 963.40625, 2.40625), ang=Angle(-1.4375, 11.0625, -85.78125),},
			{type="sr2_sg", pos=Vector(1415.5, 1736.5, 50.4375), ang=Angle(-1.625, -94.1875, -85.25),},
			{type="sr2_sg", pos=Vector(1833.96875, -702.75, 2.375), ang=Angle(-0.90625, 93.71875, -86.25),},
			{type="sr2_sg", pos=Vector(483.96875, -1447.8125, 34.46875), ang=Angle(-1.6875, 18, -85.09375),},
			{type="sr2_sg", pos=Vector(203.28125, -365.59375, 418.46875), ang=Angle(-1.75, -4.4375, -84.84375),},
			{type="sr2_sg", pos=Vector(-433.46875, -1264.4375, 50.375), ang=Angle(-1.375, -103.96875, -85.9375),},
			{type="sr2_sg", pos=Vector(-281.15625, -677.1875, -77.5625), ang=Angle(-1.4375, -166.3125, -85.78125),},
			{type="sr2_sg", pos=Vector(1211.6875, 1736.4375, -77.5625), ang=Angle(-1.1875, -32.21875, -85.28125),},
			{type="sr2_sg", pos=Vector(1669.03125, -481.78125, 46.4375), ang=Angle(-1.59375, 27, -85.34375),},
			{type="sr2_sg", pos=Vector(1019.5625, 355, -77.65625), ang=Angle(-3.84375, 92.03125, 82.78125),},
			{type="sr2_sg", pos=Vector(341.96875, -730.1875, -77.5), ang=Angle(-2.28125, 172.71875, -83.40625),},
			{type="sr2_sg", pos=Vector(-1200.84375, -1061.9375, 46.375), ang=Angle(-1.34375, -68.6875, -86.09375),},
			{type="sr2_sg", pos=Vector(-959.40625, 643.3125, -733.59375), ang=Angle(-1.375, 13.875, -85.9375),},
			},
	}

	GM.MAP.Vaccine = {
		Box = {
			{type="sls_vaccine", pos=Vector(-1168.1875, 390.75, -719.1875), ang=Angle(0, -124.40625, 0),},
			{type="sls_vaccine", pos=Vector(865.6875, 98.96875, -367.34375), ang=Angle(-0.03125, -179.90625, 0),},
			{type="sls_vaccine", pos=Vector(-145.6875, 93.5625, -367.09375), ang=Angle(0.28125, 0, 0),},
			{type="sls_vaccine", pos=Vector(1646.25, -488.25, 0.78125), ang=Angle(0.125, -0.03125, 0.03125),},
			{type="sls_vaccine", pos=Vector(1646.25, -856.28125, 0.78125), ang=Angle(0, 0.0625, 0),},
			{type="sls_vaccine", pos=Vector(925.84375, 1.46875, 1.03125), ang=Angle(0.46875, 179.78125, -0.09375),},
			{type="sls_vaccine", pos=Vector(254.0625, 2.5625, 0.78125), ang=Angle(0.4375, 0, 0.03125),},
			{type="sls_vaccine", pos=Vector(1395.5, 1599.1875, 0.65625), ang=Angle(-0.03125, 89.78125, 0),},
			{type="sls_vaccine", pos=Vector(-177.75, -384.71875, 384.75), ang=Angle(0.375, 0, 0),},
			{type="sls_vaccine", pos=Vector(625.84375, 130.53125, 384.78125), ang=Angle(0.6875, 179.96875, -0.09375),},
			{type="sls_vaccine", pos=Vector(-689.90625, -18.875, 0.9375), ang=Angle(0.5625, 0, 0),},
			{type="sls_vaccine", pos=Vector(-1259.84375, -1201.8125, 0.6875), ang=Angle(0.1875, 90.03125, -0.09375),},
			{type="sls_vaccine", pos=Vector(1346.71875, 1761.6875, -79.3125), ang=Angle(0.125, -90, 0.03125),},
			},
	}