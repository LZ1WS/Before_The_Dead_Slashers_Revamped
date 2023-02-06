-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-08-09 16:33:11
-- @Last modified by:   Guilhem PECH
-- @Last modified time: 21-Oct-2018

local GM = GM or GAMEMODE

GM.MAP.Name = "Selvage"
GM.MAP.EscapeDuration = 120
GM.MAP.Goal = {
	Jerrican = {
		{type="sls_jerrican", pos=Vector( 	-22.718750, -1.750000, 31.187500	 ), ang=Angle(	0.264, 130.913, -0.088	),},
		{type="sls_jerrican", pos=Vector( 	-2128.093750, -65.156250, 42.468750	 ), ang=Angle(	-0.659, 92.373, 0.000	),},
		{type="sls_jerrican", pos=Vector( 	32.312500, 77.531250, 303.187500	 ), ang=Angle(	0.220, -32.783, -0.088	),},
		{type="sls_jerrican", pos=Vector( 	26.750000, -15.468750, 439.218750	 ), ang=Angle(	-0.176, 15.381, -0.044	),},
		{type="sls_jerrican", pos=Vector( 	-1571.218750, 26.093750, 42.375000	 ), ang=Angle(	-0.176, 160.225, -0.088	),},
		{type="sls_jerrican", pos=Vector( 	1698.062500, 1318.000000, 15.156250	 ), ang=Angle(	0.308, 162.422, -0.088	),},
		{type="sls_jerrican", pos=Vector( 	-2130.500000, 1292.531250, 42.468750	 ), ang=Angle(	0.000, 84.595, 0.396	),},
		{type="sls_jerrican", pos=Vector( 	591.656250, 2252.843750, 16.468750	 ), ang=Angle(	2.505, -57.437, 0.527	),},
		{type="sls_jerrican", pos=Vector( 	-1562.312500, 1261.875000, 42.468750	 ), ang=Angle(	0.571, -139.746, 0.000	),},
		{type="sls_jerrican", pos=Vector( 	-814.156250, 1813.937500, 16.187500	 ), ang=Angle(	-0.308, 42.275, -0.088	),},
		{type="sls_jerrican", pos=Vector( 	-2038.218750, 1886.656250, 15.312500	 ), ang=Angle(	0.000, 170.244, 0.088	),},
		{type="sls_jerrican", pos=Vector( 	-1835.062500, -1205.500000, 16.156250	 ), ang=Angle(	0.527, 138.735, -0.088	),},
		{type="sls_jerrican", pos=Vector( 	476.031250, 1293.156250, 15.031250	 ), ang=Angle(	-0.747, 39.902, -0.044	),},
		{type="sls_jerrican", pos=Vector( 	-934.343750, 941.343750, 16.187500	 ), ang=Angle(	-0.088, -45.571, 0.044	),},
		{type="sls_jerrican", pos=Vector( 	-996.750000, -1449.562500, 15.250000	 ), ang=Angle(	-1.187, 124.980, 0.176	),},
		{type="sls_jerrican", pos=Vector( 	-1035.125000, 269.562500, 15.250000	 ), ang=Angle(	0.923, -93.076, 0.088	),},
		{type="sls_jerrican", pos=Vector( 	218.000000, 1820.906250, 16.281250	 ), ang=Angle(	0.835, 32.344, -0.176	),},
		{type="sls_jerrican", pos=Vector( 	-309.656250, 1814.968750, 16.187500	 ), ang=Angle(	-0.352, 16.260, -0.088	),},
		{type="sls_jerrican", pos=Vector( 	-1279.156250, 1816.406250, 17.312500	 ), ang=Angle(	1.538, 37.529, 1.099	),},
		{type="sls_jerrican", pos=Vector( 	784.843750, -1120.968750, 65.281250	 ), ang=Angle(	-3.691, 15.029, -0.659	),},
		{type="sls_jerrican", pos=Vector( 	-1432.718750, -1383.218750, 16.187500	 ), ang=Angle(	0.264, -154.072, -0.088	),},
		{type="sls_jerrican", pos=Vector( 	-1910.125000, -688.000000, 16.187500	 ), ang=Angle(	0.264, 123.003, -0.088	),},
		{type="sls_jerrican", pos=Vector( 	581.312500, -277.406250, 15.343750	 ), ang=Angle(	0.308, -98.789, -0.835	),},
		{type="sls_jerrican", pos=Vector( 	1301.500000, 1955.375000, 23.156250	 ), ang=Angle(	0.352, -126.431, -0.264	),},

	},


	Generator = {
		{type="sls_generator", pos=Vector( 	-1579.18,-822.45,0.33	 ), ang=Angle(	-0.148,-43.391,0.011	),},
		{type="sls_generator", pos=Vector( 	-1235.22,-780.76,0.66	 ), ang=Angle(	-0.016,101.245,-0.434	),},
		{type="sls_generator", pos=Vector( 	529.88,2080.05,1.25	 ), ang=Angle(	-0.077,0.478,-0.005	),},
		{type="sls_generator", pos=Vector( 	-1094.93,877.88,0.22	 ), ang=Angle(	-0.088,-88.149,0.000	),},
		{type="sls_generator", pos=Vector( 	-1280.27,1848.75,2.64	 ), ang=Angle(	-0.714,-128.655,-1.313	),},
		{type="sls_generator", pos=Vector( 	-2200.02,821.98,9.21	 ), ang=Angle(	1.934,90.379,-1.571	),},
		{type="sls_generator", pos=Vector( 	-846.46,926.66,1.29	 ), ang=Angle(	-0.082,-179.863,-0.038	),},
		{type="sls_generator", pos=Vector( 	1756.17,1139.51,0.20	 ), ang=Angle(	-0.088,-89.995,0.000	),},
		{type="sls_generator", pos=Vector( 	-1666.80,-1133.94,0.24	 ), ang=Angle(	-0.126,89.896,-0.022	),},
		{type="sls_generator", pos=Vector( 	-1802.76,-201.91,0.29	 ), ang=Angle(	-0.005,13.804,0.000	),},
		{type="sls_generator", pos=Vector( 	-640.50,-1504.13,0.27	 ), ang=Angle(	-0.011,90.324,0.038	),},
		{type="sls_generator", pos=Vector( 	794.23,1749.65,0.24	 ), ang=Angle(	-0.077,0.132,-0.011	),},

	},

	Locker = {
		{type="prop_huntress_locker", pos=Vector(-1587.53125, 1757.40625, 1.46875), ang=Angle(0, 0, 0),},
		{type="prop_huntress_locker", pos=Vector(-1587.59375, 1828.375, 2.125), ang=Angle(0.09375, 0.0625, 0.96875),},
		{type="prop_huntress_locker", pos=Vector(-1817.65625, 1384.21875, 2.46875), ang=Angle(0, -89.9375, 0),},
		{type="prop_huntress_locker", pos=Vector(-1719.9375, 1383.4375, 2.4375), ang=Angle(0.03125, -90.03125, -0.125),},
		{type="prop_huntress_locker", pos=Vector(-910.71875, 947.5, 2.5625), ang=Angle(0, -90, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(-824.21875, 947.59375, 2.5625), ang=Angle(0, -90, -0.09375),},
		{type="prop_huntress_locker", pos=Vector(105.3125, 2060.78125, 2.46875), ang=Angle(0, 90.25, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(21.90625, 2060.46875, 2.46875), ang=Angle(0, 89.9375, -0.15625),},
		{type="prop_huntress_locker", pos=Vector(1548.4375, 1488.71875, 1.5), ang=Angle(0, -0.03125, 0.03125),},
		{type="prop_huntress_locker", pos=Vector(1548.375, 1578, 1.5), ang=Angle(0, 0.09375, -0.25),},
		{type="prop_huntress_locker", pos=Vector(20.59375, -81.59375, 17.6875), ang=Angle(-0.09375, 0.21875, 0.15625),},
		{type="prop_huntress_locker", pos=Vector(20.3125, -2.34375, 17.71875), ang=Angle(0, 0, -0.625),},
		{type="prop_huntress_locker", pos=Vector(12.5, 97.21875, 425.59375), ang=Angle(-0.0625, 0.09375, -0.09375),},
		{type="prop_huntress_locker", pos=Vector(12.59375, 29.6875, 425.75), ang=Angle(-0.0625, 0.09375, -0.09375),},
		{type="prop_huntress_locker", pos=Vector(735.375, 316.46875, 9.5625), ang=Angle(0, 89.96875, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(613.71875, 316.5, 9.5625), ang=Angle(0, 90, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(435.5625, 1232.03125, 2.65625), ang=Angle(0.15625, 179.9375, 1.53125),},
		{type="prop_huntress_locker", pos=Vector(435.5625, 1082, 2.1875), ang=Angle(0, 179.9375, -1.15625),},
		{type="prop_huntress_locker", pos=Vector(-879.9375, -652.46875, 9.4375), ang=Angle(0, -90, -0.125),},
		{type="prop_huntress_locker", pos=Vector(-943.90625, -652.375, 9.40625), ang=Angle(0, -89.9375, -0.25),},
		{type="prop_huntress_locker", pos=Vector(-336.34375, 2128.90625, 2.5), ang=Angle(0.03125, -179.96875, 0),},
		{type="prop_huntress_locker", pos=Vector(-336.4375, 2069.78125, 2.53125), ang=Angle(0, 179.875, 0),},
		{type="prop_huntress_locker", pos=Vector(-1508.28125, -1368.46875, 2.53125), ang=Angle(0, -90, 0),},
		{type="prop_huntress_locker", pos=Vector(-1433.15625, -1368.5, 2.5), ang=Angle(-0.03125, -89.78125, 0.0625),},
		{type="prop_huntress_locker", pos=Vector(-2132.09375, -524.5, -2.6875), ang=Angle(0, -89.9375, -0.3125),},
		{type="prop_huntress_locker", pos=Vector(-2029.25, -524.40625, 1.5), ang=Angle(0.03125, -90.09375, -0.0625),},
		},

	Radio = {
		{type="sls_radio", pos=Vector( 	31.81,1029.38,50.84	 ), ang=Angle(	0.044,180.000,0.000	),},
		{type="sls_radio", pos=Vector( 	-482.13,1799.31,50.88	 ), ang=Angle(	0.352,-177.891,-0.044	),},
		{type="sls_radio", pos=Vector( 	-1767.28,1608.22,50.84	 ), ang=Angle(	-0.044,-179.692,0.044	),},
		{type="sls_radio", pos=Vector( 	-763.16,646.91,50.84	 ), ang=Angle(	0.220,-0.044,0.088	),},
		{type="sls_radio", pos=Vector( 	-90.81,109.41,424.41	 ), ang=Angle(	-0.044,179.912,-0.220	),},
		{type="sls_radio", pos=Vector( 	640.31,2025.31,48.53	 ), ang=Angle(	0.044,-90.000,0.000	),},
		{type="sls_radio", pos=Vector( 	-1835.47,-480.56,50.84	 ), ang=Angle(	0.044,0.000,0.000	),},
		{type="sls_radio", pos=Vector( 	-1038.66,-611.44,50.84	 ), ang=Angle(	-0.088,154.600,-0.088	),},
		{type="sls_radio", pos=Vector( 	510.50,1689.53,43.34	 ), ang=Angle(	0.044,90.000,0.000	),},
		{type="sls_radio", pos=Vector( 	673.06,1776.63,50.91	 ), ang=Angle(	-0.044,-90.000,0.044	),},
		{type="sls_radio", pos=Vector( 	-1848.84,-1568.44,48.47	 ), ang=Angle(	-0.088,90.000,-0.044	),},
		{type="sls_radio", pos=Vector( 	-1793.53,-1270.00,50.84	 ), ang=Angle(	0.000,-6.987,0.000	),},

	}
}