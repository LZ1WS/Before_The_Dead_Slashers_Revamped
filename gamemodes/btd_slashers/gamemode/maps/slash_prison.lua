local GM = GM or GAMEMODE

GM.MAP.Name = "Prison"
GM.MAP.EscapeDuration = 105

GM.MAP.Goal = {
	Generator = {
		{type="sls_generator", pos=Vector(527.28125, 41.25, 16.21875), ang=Angle(-0.0625, -127, -0.09375),},
		{type="sls_generator", pos=Vector(-368.5625, -883.78125, -143.6875), ang=Angle(-0.09375, 27.25, 0),},
		{type="sls_generator", pos=Vector(-85.125, 332.53125, -143.75), ang=Angle(-0.09375, 89.375, 0),},
		},

		Jerrican = {
			{type="sls_jerrican", pos=Vector(132.90625, 869.25, 351.21875), ang=Angle(0.15625, 50.8125, 0.375),},
			{type="sls_jerrican", pos=Vector(-305.125, 868.4375, 387.25), ang=Angle(-31.625, -170.28125, 0),},
			{type="sls_jerrican", pos=Vector(-662.5, 692.0625, 358.78125), ang=Angle(-16.90625, -12.375, 0),},
			{type="sls_jerrican", pos=Vector(1213.84375, 115.5, 351.34375), ang=Angle(0.25, -90.125, 0),},
			{type="sls_jerrican", pos=Vector(478.71875, -381.90625, 198.21875), ang=Angle(0.03125, 104.8125, -0.21875),},
			{type="sls_jerrican", pos=Vector(-817.65625, 1385, 375.34375), ang=Angle(-89.9375, -15.0625, 180),},
			{type="sls_jerrican", pos=Vector(-125.28125, 1337.75, 389.65625), ang=Angle(-42.375, -179.90625, -0.03125),},
			{type="sls_jerrican", pos=Vector(233.71875, 364.84375, -256.75), ang=Angle(1.21875, -99.9375, -0.09375),},
			{type="sls_jerrican", pos=Vector(-150.21875, 871, 198.15625), ang=Angle(-0.1875, -13.96875, 0),},
			{type="sls_jerrican", pos=Vector(-381.96875, 178.34375, -264.875), ang=Angle(79.65625, 57.625, 0),},
			{type="sls_jerrican", pos=Vector(50.15625, 577.75, -251), ang=Angle(89.71875, 162.71875, -179.96875),},
			{type="sls_jerrican", pos=Vector(253.84375, 1505.375, -128.8125), ang=Angle(-0.0625, 78.96875, 0.0625),},
			{type="sls_jerrican", pos=Vector(-1008.5, -48.46875, 191.25), ang=Angle(-0.34375, 20.28125, 0.34375),},
			{type="sls_jerrican", pos=Vector(-1005.125, 288.90625, 31.21875), ang=Angle(0.4375, 71.71875, -0.125),},
			{type="sls_jerrican", pos=Vector(-681.875, 269.84375, 198.65625), ang=Angle(-20.28125, 152.15625, 0),},
			{type="sls_jerrican", pos=Vector(355.34375, 670.28125, 191.3125), ang=Angle(1.0625, 101.375, -0.4375),},
			{type="sls_jerrican", pos=Vector(-434.8125, 256.15625, 199.1875), ang=Angle(-14.8125, -25.28125, 0.9375),},
			{type="sls_jerrican", pos=Vector(597.71875, -453.28125, 36.96875), ang=Angle(89.78125, 89.96875, 179.96875),},
			{type="sls_jerrican", pos=Vector(18.53125, 23.40625, 191.3125), ang=Angle(0, 41.25, 0),},
			{type="sls_jerrican", pos=Vector(-117.21875, -652.4375, 351.3125), ang=Angle(-0.0625, -89.6875, 0),},
			{type="sls_jerrican", pos=Vector(93.625, -13.90625, 373.625), ang=Angle(89.65625, -109.5, 70.4375),},
			{type="sls_jerrican", pos=Vector(1211.3125, 70.375, 191.25), ang=Angle(-0.84375, -167.625, 0.34375),},
			{type="sls_jerrican", pos=Vector(805.03125, -1085.0625, 183.5625), ang=Angle(-4.25, 43.21875, -0.125),},
			{type="sls_jerrican", pos=Vector(499.28125, 696.25, 31.1875), ang=Angle(0.3125, -17.03125, -0.0625),},
			{type="sls_jerrican", pos=Vector(131.21875, -1478.90625, 180.40625), ang=Angle(89.75, -145.125, -107.84375),},
			{type="sls_jerrican", pos=Vector(843.5, -1809.15625, 279.3125), ang=Angle(0, 0, 0),},
			{type="sls_jerrican", pos=Vector(-91.4375, 204.53125, -121.65625), ang=Angle(0.03125, -89.5625, 0),},
			{type="sls_jerrican", pos=Vector(22.5625, -1103.40625, 348.6875), ang=Angle(-52.4375, 0.03125, -0.1875),},
			{type="sls_jerrican", pos=Vector(125.53125, -1251.1875, 198.125), ang=Angle(-0.1875, -0.0625, -0.09375),},
			},

			Locker = {
				{type="prop_huntress_locker", pos=Vector(-499.5, 1333.8125, 337.5), ang=Angle(0, 0, -0.21875),},
				{type="prop_huntress_locker", pos=Vector(-802.15625, 453.03125, 17.5625), ang=Angle(0, 1, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-803.46875, 557.90625, 17.53125), ang=Angle(0, -0.34375, 0.0625),},
				{type="prop_huntress_locker", pos=Vector(771.5, -1122.625, 169.53125), ang=Angle(0.03125, -179.9375, 0.03125),},
				{type="prop_huntress_locker", pos=Vector(771.5625, -942.5, 169.5), ang=Angle(0, 179.9375, -0.15625),},
				{type="prop_huntress_locker", pos=Vector(459.6875, -1033.46875, 177.5), ang=Angle(0.0625, -179.96875, -0.15625),},
				{type="prop_huntress_locker", pos=Vector(-20.40625, 1042.84375, -142.5), ang=Angle(0, -179.9375, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-20.46875, 902.25, -142.34375), ang=Angle(0, 179.96875, -0.40625),},
				{type="prop_huntress_locker", pos=Vector(-275.5625, -828.46875, 177.5), ang=Angle(0, -90, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-189.78125, -828.46875, 177.5625), ang=Angle(0, -90, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(184, -1412.53125, 177.53125), ang=Angle(-0.03125, -90.125, -0.21875),},
				{type="prop_huntress_locker", pos=Vector(277.21875, -1412.46875, 177.5625), ang=Angle(0, -90, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(960.78125, 539.5, 177.59375), ang=Angle(-0.03125, -90, -0.25),},
				{type="prop_huntress_locker", pos=Vector(1027.5, 489.9375, 177.5625), ang=Angle(0, -179.96875, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(204.46875, -231.0625, 177.5625), ang=Angle(0, 0, -0.03125),},
				{type="prop_huntress_locker", pos=Vector(287.59375, -283.46875, 177.5625), ang=Angle(-0.03125, 89.90625, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(1027.53125, 486.15625, 337.5625), ang=Angle(0, 179.96875, -0.03125),},
				{type="prop_huntress_locker", pos=Vector(975.46875, 539.53125, 337.4375), ang=Angle(-0.03125, -90.0625, -0.03125),},
				{type="prop_huntress_locker", pos=Vector(204.46875, -235.28125, 337.5625), ang=Angle(0, 0, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(261.4375, -283.4375, 337.4375), ang=Angle(0, 89.96875, -0.03125),},
				{type="prop_huntress_locker", pos=Vector(1027.53125, -223.8125, 17.5625), ang=Angle(0.03125, 179.96875, -0.03125),},
				{type="prop_huntress_locker", pos=Vector(975.4375, -283.5, 17.5625), ang=Angle(0, 89.96875, -0.125),},
				{type="prop_huntress_locker", pos=Vector(204.375, 480.46875, 17.5625), ang=Angle(0, 0.03125, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(260.21875, 539.5, 17.5625), ang=Angle(0, -90.0625, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-427.5625, -576.75, 337.5625), ang=Angle(0.03125, 0, -0.3125),},
				{type="prop_huntress_locker", pos=Vector(-427.5625, -488.59375, 337.5625), ang=Angle(0.03125, 0.03125, 0),},
				{type="prop_huntress_locker", pos=Vector(-275.34375, 692.375, 337.5), ang=Angle(0, 90, -0.09375),},
				{type="prop_huntress_locker", pos=Vector(-385.8125, 692.46875, 337.53125), ang=Angle(0, 90, 0),},
				{type="prop_huntress_locker", pos=Vector(-1083.59375, 1083.0625, 337.53125), ang=Angle(0.03125, 0.03125, 0),},
				{type="prop_huntress_locker", pos=Vector(-977.875, 988.4375, 337.5), ang=Angle(0, 90.125, -0.03125),},
				{type="prop_huntress_locker", pos=Vector(343.15625, 1499.5, -142.40625), ang=Angle(0, -90, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(486.78125, 1499.5, -142.40625), ang=Angle(0, -90, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-147.5, -762.15625, -142.40625), ang=Angle(0, 0, -0.03125),},
				{type="prop_huntress_locker", pos=Vector(-147.5, -680.25, -142.40625), ang=Angle(0, 0.03125, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-316.46875, -451.28125, 17.5625), ang=Angle(0.03125, -179.90625, -0.0625),},
				{type="prop_huntress_locker", pos=Vector(-316.46875, -350.375, 17.5625), ang=Angle(0, 179.96875, -0.0625),},
				},

				Radio = {
					{type="sls_radio", pos=Vector(-502.96875, -874.3125, 300.4375), ang=Angle(0, 4.5625, 0),},
					{type="sls_radio", pos=Vector(-905.625, 1259.9375, 369.5), ang=Angle(0, -1.65625, 0),},
					{type="sls_radio", pos=Vector(109.4375, -904.125, 356), ang=Angle(0.0625, -90.8125, -0.21875),},
					{type="sls_radio", pos=Vector(113.09375, -329.71875, 210.5), ang=Angle(0, -90.875, 0.03125),},
					{type="sls_radio", pos=Vector(635.96875, -1840.1875, 209.03125), ang=Angle(0, 87.15625, 0),},
					},

	}

	GM.MAP.Pages = {
		Page = {
			{type="ent_slender_rising_notepage", pos=Vector(-158.5625, -1631.96875, 201.65625), ang=Angle(0, 0, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(729.25, -1854.6875, 211.03125), ang=Angle(0.0625, 89.6875, 0.125),},
			{type="ent_slender_rising_notepage", pos=Vector(-169.40625, -973.3125, 27.125), ang=Angle(0, 179.5625, -0.0625),},
			{type="ent_slender_rising_notepage", pos=Vector(-113.40625, 1206.28125, 352.4375), ang=Angle(0, 179.5625, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(-9.34375, -595.5625, -120.21875), ang=Angle(0, 179.65625, 0.0625),},
			{type="ent_slender_rising_notepage", pos=Vector(1222.53125, 178.96875, 200.3125), ang=Angle(0, 179.65625, -0.09375),},
			{type="ent_slender_rising_notepage", pos=Vector(-164.4375, 1134.6875, 351.4375), ang=Angle(0.03125, -90.0625, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(658.53125, 734.53125, 346.65625), ang=Angle(0, -90.375, -0.3125),},
			{type="ent_slender_rising_notepage", pos=Vector(-438.5625, -402.6875, 358.59375), ang=Angle(0, 0, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(481.3125, -1029.71875, 184.21875), ang=Angle(0.09375, -0.25, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(9.46875, -926.3125, 360.4375), ang=Angle(0, 0, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(535.625, -646.53125, 198.375), ang=Angle(0, 89.96875, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(-1014.5625, 137.15625, 200.9375), ang=Angle(0, -0.46875, 0.15625),},
			{type="ent_slender_rising_notepage", pos=Vector(-105.25, 122.03125, 46.875), ang=Angle(0, 179.5625, -0.125),},
			{type="ent_slender_rising_notepage", pos=Vector(-1014.59375, -198.1875, 38.9375), ang=Angle(0, -0.53125, 0),},
			{type="ent_slender_rising_notepage", pos=Vector(-61.75, 1510.53125, -113.8125), ang=Angle(0, -90.34375, -0.3125),},
			{type="ent_slender_rising_notepage", pos=Vector(244.375, -37.1875, -245.25), ang=Angle(0.78125, -179.71875, 1.21875),},
			{type="ent_slender_rising_notepage", pos=Vector(243.34375, 312.90625, -250.59375), ang=Angle(-0.21875, 179.40625, 0.0625),},
			{type="ent_slender_rising_notepage", pos=Vector(-411.875, 494.46875, -250.875), ang=Angle(0.0625, -1.625, 0.09375),},
			{type="ent_slender_rising_notepage", pos=Vector(676.5, 734.40625, 201.65625), ang=Angle(-0.0625, -90.1875, -0.375),},
			{type="ent_slender_rising_notepage", pos=Vector(876, -478.46875, 39.96875), ang=Angle(-0.0625, 89.59375, -0.125),},
			{type="ent_slender_rising_notepage", pos=Vector(9.28125, 24.5, 40.96875), ang=Angle(0.03125, -0.21875, -0.0625),},
			{type="ent_slender_rising_notepage", pos=Vector(-1094.46875, 1138.71875, 361.125), ang=Angle(0, 0, 0),},
			},

			Shotgun = {
				{type="sr2_sg", pos=Vector(392.09375, 729.59375, 21.59375), ang=Angle(57.84375, -2.78125, -124.1875),},
				{type="sr2_sg", pos=Vector(-900.40625, 1238.8125, 371.5), ang=Angle(-1.90625, 43.25, -83.96875),},
				{type="sr2_sg", pos=Vector(-373.375, 920.5625, 371.53125), ang=Angle(-1.59375, 143.03125, -84.65625),},
				{type="sr2_sg", pos=Vector(-45.75, -1058.46875, -108.96875), ang=Angle(-1.78125, -175.71875, -84.25),},
				{type="sr2_sg", pos=Vector(1153.03125, 211.15625, 338.40625), ang=Angle(-1.46875, -145.40625, -85.6875),},
				{type="sr2_sg", pos=Vector(-132.375, -803.46875, 232.4375), ang=Angle(-1.46875, -156.46875, -84.8125),},
				{type="sr2_sg", pos=Vector(115.25, -902.96875, 358.125), ang=Angle(-1.28125, -1.6875, -84.75),},
				{type="sr2_sg", pos=Vector(-58.59375, -1840.25, 274.90625), ang=Angle(-1.21875, -153.15625, -85.5625),},
				},

	}

	GM.MAP.Vaccine = {
		Box = {
			{type="sls_vaccine", pos=Vector(-513.8125, -1024.5625, 264.8125), ang=Angle(0.4375, 0.125, 0.15625),},
			{type="sls_vaccine", pos=Vector(-182.15625, -876.9375, 16.90625), ang=Angle(0.46875, 179.875, 0),},
			{type="sls_vaccine", pos=Vector(-182.3125, -1041.21875, 16.78125), ang=Angle(0.0625, -179.96875, 0.03125),},
			{type="sls_vaccine", pos=Vector(52.25, 577.84375, -204.96875), ang=Angle(0.21875, -89.96875, 0),},
			{type="sls_vaccine", pos=Vector(753.6875, 656.09375, 16.75), ang=Angle(0.375, 179.96875, -0.1875),},
			{type="sls_vaccine", pos=Vector(-255.34375, 238.25, 16.71875), ang=Angle(0.15625, 90, -0.03125),},
			{type="sls_vaccine", pos=Vector(558.09375, -465.75, 16.84375), ang=Angle(0.25, 89.96875, 0),},
			{type="sls_vaccine", pos=Vector(1209.6875, 395.15625, 176.8125), ang=Angle(0.15625, 179.84375, 0),},
			{type="sls_vaccine", pos=Vector(22.21875, 180.03125, 176.78125), ang=Angle(0.40625, 0, 0.15625),},
			{type="sls_vaccine", pos=Vector(753.875, -410.75, 212.75), ang=Angle(0.21875, 179.96875, -0.03125),},
			{type="sls_vaccine", pos=Vector(249.65625, 997.4375, 336.78125), ang=Angle(0, 179.96875, 0),},
			{type="sls_vaccine", pos=Vector(478.25, -342.59375, 176.6875), ang=Angle(0, 0, 0.21875),},
			{type="sls_vaccine", pos=Vector(409.53125, -452.125, 336.875), ang=Angle(-0.03125, 142, 0.5),},
			{type="sls_vaccine", pos=Vector(-704.375, 1158.21875, 336.84375), ang=Angle(0.3125, 90.0625, -0.0625),},
			{type="sls_vaccine", pos=Vector(102.34375, -9.71875, 403.125), ang=Angle(0.09375, 90.0625, 0.03125),},
			{type="sls_vaccine", pos=Vector(37, 332.6875, 336.78125), ang=Angle(0, 45.03125, 0),},
			{type="sls_vaccine", pos=Vector(22.3125, -957.1875, 336.78125), ang=Angle(0.03125, -0.125, 0.03125),},
			{type="sls_vaccine", pos=Vector(665.625, -1739.875, 176.75), ang=Angle(0.09375, 179.9375, 0),},
			{type="sls_vaccine", pos=Vector(-864.375, 25.4375, 176.78125), ang=Angle(-0.25, -89.96875, 0.15625),},
			{type="sls_vaccine", pos=Vector(231.3125, -1414.34375, 176.78125), ang=Angle(0, -90.03125, 0),},
			{type="sls_vaccine", pos=Vector(-864.4375, 361.5625, 176.78125), ang=Angle(-0.03125, -89.96875, 0),},
			{type="sls_vaccine", pos=Vector(-864.46875, 193.5625, 16.71875), ang=Angle(0, -89.96875, -0.09375),},
			{type="sls_vaccine", pos=Vector(-126.15625, 1206.5625, 336.90625), ang=Angle(0.4375, 179.96875, 0),},
			{type="sls_vaccine", pos=Vector(411.46875, 1497.875, -143.0625), ang=Angle(0.5, -89.9375, 0),},
			},
	}