local GM = GM or GAMEMODE

GM.MAP.Name = "Monolith 10"
GM.MAP.EscapeDuration = 90

GM.MAP.Goal = {
	Jerrican = {
		 {type="sls_jerrican", pos=Vector( 972.468750, -222.968750, 143.312500 ), ang=Angle(0.000, 0.000, 0.000),},
		 {type="sls_jerrican", pos=Vector( 1058.593750, -443.343750, 4.468750 ), ang=Angle(89.813, -112.250, 101.500),},
		 {type="sls_jerrican", pos=Vector( 1646.312500, -294.468750, 399.750000 ), ang=Angle(-21.563, 179.969, 0.000),},
		 {type="sls_jerrican", pos=Vector( 182.593750, -144.156250, 516.468750 ), ang=Angle(-89.969, 144.063, 180.000),},
		 {type="sls_jerrican", pos=Vector( 679.531250, 260.468750, 655.312500 ), ang=Angle(0.000, 90.000, -0.094),},
		 {type="sls_jerrican", pos=Vector( 1421.937500, -414.531250, 933.125000 ), ang=Angle(89.969, 45.625, 180.000),},
		 {type="sls_jerrican", pos=Vector( 361.062500, -238.250000, 1167.562500 ), ang=Angle(-26.219, 147.219, 0.031),},
		 {type="sls_jerrican", pos=Vector( 1988.187500, 148.562500, 143.187500 ), ang=Angle(-0.500, 89.594, 0.031),},
		 {type="sls_jerrican", pos=Vector( 1374.562500, -110.406250, 1452.468750 ), ang=Angle(89.938, 9.906, 180.000),},
		 {type="sls_jerrican", pos=Vector( 677.468750, 71.500000, 191.562500 ), ang=Angle(89.719, -83.438, 96.000),},
		 {type="sls_jerrican", pos=Vector( 983.187500, -408.125000, 1156.406250 ), ang=Angle(-89.844, -91.781, 91.188),},
		 {type="sls_jerrican", pos=Vector( 28.500000, -273.875000, 407.968750 ), ang=Angle(89.906, 61.375, 60.531),},

	},

	Radio = {
		 {type="sls_radio", pos=Vector( 557.156250, -98.000000, 176.468750 ), ang=Angle(0.000, -177.563, 0.000),},
		 {type="sls_radio", pos=Vector( 988.000000, -429.750000, 688.468750 ), ang=Angle(0.000, 65.156, 0.000),},
		 {type="sls_radio", pos=Vector( 296.718750, -437.500000, 809.125000 ), ang=Angle(0.000, 90.031, 0.000),},
		 {type="sls_radio", pos=Vector( 71.875000, -121.125000, 1296.343750 ), ang=Angle(-0.250, -17.656, 0.031),},

	},

	Generator = {
		 {type="sls_generator", pos=Vector( 629.406250, 216.500000, 0.343750 ), ang=Angle(-0.094, 179.938, -0.031),},
		 {type="sls_generator", pos=Vector( 1410.875000, -56.531250, 1408.343750 ), ang=Angle(-0.063, 0.000, 0.000),},
		 {type="sls_generator", pos=Vector( 3564.343750, 403.437500, 128.343750 ), ang=Angle(-0.094, -0.063, 0.031),},
	}
}

GM.MAP.Pages = {
	Page = {
		{type="ent_slender_rising_notepage", pos=Vector(580.468750, -566.531250, 6.781250), ang=Angle(0.000, 89.656, -0.438), spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector(1470.125000, 126.656250, 904.812500), ang=Angle(0.094, -90.406, -1.031),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector(995.281250, 266.593750, 147.812500), ang=Angle(-6.969, 90.000, -1.063),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector(1250.031250, -81.437500, 121.750000), ang=Angle(0.000, -90.344, 0.594),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector(694.500000, -451.562500, 140.125000), ang=Angle(0.000, 179.688, 0.125),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector(117.593750, -58.531250, 1024.593750), ang=Angle(0.031, 89.625, 2.406),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector(524.687500, 137.406250, 789.968750), ang=Angle(0.031, 89.719, -0.031),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector(457.437500, -185.281250, 899.125000), ang=Angle(0.000, -0.375, 0.531),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector(1429.937500, -261.406250, 508.187500), ang=Angle(0.000, -90.219, -0.625),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector(1359.593750, -88.562500, 1427.531250), ang=Angle(0.031, 89.688, 2.188),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector(564.781250, -94.500000, 1285.250000), ang=Angle(0.000, 89.563, 1.188),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector(969.437500, -357.187500, 395.343750), ang=Angle(0.000, -0.313, -0.344),spw = false,},
		{type="ent_slender_rising_notepage", pos=Vector(694.531250, -209.937500, 652.125000), ang=Angle(0.000, 179.625, 0.719),spw = false,},
	}
}
GM.MAP.Shotgun = {
	Shotgun = {
		{type="sr2_sg", pos=Vector(305.687500, -426.750000, 811.000000), ang=Angle(-3.938, 26.219, 82.188),spw = false,},
		{type="sr2_sg", pos=Vector(3600.843750, 312.937500, 185.843750), ang=Angle(-4.125, 95.813, 81.438),spw = false,},
		{type="sr2_sg", pos=Vector(197.468750, -70.343750, 456.343750), ang=Angle(3.406, -176.063, -7.406),spw = false,},
	}
}