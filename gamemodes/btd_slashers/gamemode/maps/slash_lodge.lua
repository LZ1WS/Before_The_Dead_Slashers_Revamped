-- Utopia Games - Slashers
--
-- @Author: Garrus2142
-- @Date:   2017-08-07T18:00:56+02:00
-- @Last Modified by:   Daryl_Winters
-- @Last Modified time: 2017-08-10T16:24:10+02:00

local GM = GM or GAMEMODE

GM.MAP.Name = "Lodge"
GM.MAP.EscapeDuration = 60
GM.MAP.Goal = {
	Jerrican = {
		 {type="sls_jerrican", pos=Vector( -430.8125,-909.71875,15.15625 ), ang=Angle(0.3076171875,40.693359375,-0.087890625),},
		 {type="sls_jerrican", pos=Vector( -554.78125,-410.09375,15.21875 ), ang=Angle(-0.703125,107.841796875,-0.0439453125),},
		 {type="sls_jerrican", pos=Vector( 716.875,494.4375,15.21875 ), ang=Angle(0.263671875,-74.5751953125,-0.0439453125),},
		 {type="sls_jerrican", pos=Vector( 787.71875,-63.875,219.46875 ), ang=Angle(-0.2197265625,173.9794921875,-0.087890625),},
		 {type="sls_jerrican", pos=Vector( -616.21875,-1127.03125,215.1875 ), ang=Angle(0.263671875,-20.390625,-0.087890625),},
		 {type="sls_jerrican", pos=Vector( 501.1875,-457,215.21875 ), ang=Angle(0.2197265625,55.1953125,-0.0439453125),},
		 {type="sls_jerrican", pos=Vector( -128.09375,-291.53125,-160.78125 ), ang=Angle(-0.17578125,139.21875,-0.087890625),},
		 {type="sls_jerrican", pos=Vector( 507.875,-525.78125,-134.5625 ), ang=Angle(-0.1318359375,-169.27734375,-0.087890625),},
		 {type="sls_jerrican", pos=Vector( 793.78125,31.5,-160.75 ), ang=Angle(-0.1318359375,141.9873046875,-0.087890625),},
		 {type="sls_jerrican", pos=Vector( -169.53125,-1200.21875,-160.75 ), ang=Angle(0.263671875,56.337890625,-0.0439453125),},
		 {type="sls_jerrican", pos=Vector( 834.34375,-1197.8125,-134.53125 ), ang=Angle(0.1318359375,84.462890625,-0.0439453125),},
		 {type="sls_jerrican", pos=Vector( 267.28125,-755.1875,-160.75 ), ang=Angle(-0.1318359375,-158.5546875,-0.087890625),},
		 {type="sls_jerrican", pos=Vector( 321.5625,-76.5625,215.21875 ), ang=Angle(-0.1318359375,146.2939453125,-0.0439453125),},
		 {type="sls_jerrican", pos=Vector( 410.6875,-601.125,15.1875 ), ang=Angle(0.3076171875,-35.068359375,-0.087890625),},

	},

	Radio = {
		 {type="sls_radio", pos=Vector( 659,306.34375,42.4375 ), ang=Angle(-0.3955078125,-156.4013671875,0),},
		 {type="sls_radio", pos=Vector( -254.71875,174.0625,26.125 ), ang=Angle(0.3515625,179.6923828125,0),},
		 {type="sls_radio", pos=Vector( -363.90625,-916.0625,41.9375 ), ang=Angle(-0.17578125,90,0),},
		 {type="sls_radio", pos=Vector( 464.875,-1119.4375,25.625 ), ang=Angle(0,24.3896484375,0),},
		 {type="sls_radio", pos=Vector( 229.21875,-367.1875,225.65625 ), ang=Angle(0,-164.00390625,0),},
		 {type="sls_radio", pos=Vector( 498.5625,-346.25,-140.71875 ), ang=Angle(0,-148.271484375,0),},
		 {type="sls_radio", pos=Vector( 500.71875,-831.9375,-149.375 ), ang=Angle(0.0439453125,-135.17578125,0),},
		 {type="sls_radio", pos=Vector( -259.3125,286.78125,241.0625 ), ang=Angle(-0.17578125,-116.279296875,0.17578125),},
		 {type="sls_radio", pos=Vector( 201.625,220.75,236.625 ), ang=Angle(-0.3515625,-83.1884765625,-0.2197265625),},
		 {type="sls_radio", pos=Vector( -659.6875,-206.8125,48.34375 ), ang=Angle(0.0439453125,-13.6669921875,0),},

	},
	
	Locker = {
		{type="prop_huntress_locker", pos=Vector(57.1875, 28.53125, -174.46875), ang=Angle(-0.09375, 90.03125, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(56.6875, -28.625, -174.5), ang=Angle(0, -89.71875, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(547.21875, -28.53125, -174.53125), ang=Angle(0, -90.3125, -0.25),},
		{type="prop_huntress_locker", pos=Vector(547.8125, 28.4375, -174.53125), ang=Angle(0, 90.03125, -0.125),},
		{type="prop_huntress_locker", pos=Vector(-163.5, -720.09375, -174.5), ang=Angle(-0.03125, 0.34375, 0),},
		{type="prop_huntress_locker", pos=Vector(-220.8125, -719.0625, -174.53125), ang=Angle(0, 179.96875, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(763.6875, -871.5, -174.40625), ang=Angle(0, 179.8125, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(820.4375, -873, -174.4375), ang=Angle(-0.03125, 0.25, 0.03125),},
		{type="prop_huntress_locker", pos=Vector(157.53125, 363.125, 1.71875), ang=Angle(-0.65625, 0, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(157.6875, 17.96875, 1.75), ang=Angle(-0.78125, -0.15625, 0.09375),},
		{type="prop_huntress_locker", pos=Vector(-498.375, -8.96875, 1.71875), ang=Angle(-0.75, -0.15625, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(-498.40625, 54.09375, 1.6875), ang=Angle(-0.6875, 0, -0.09375),},
		{type="prop_huntress_locker", pos=Vector(-597.03125, -148.34375, 1.40625), ang=Angle(0, -90, -0.09375),},
		{type="prop_huntress_locker", pos=Vector(52.6875, -1053.9375, 1.40625), ang=Angle(-0.0625, 0.1875, -0.125),},
		{type="prop_huntress_locker", pos=Vector(163.5, -894.96875, 1.53125), ang=Angle(0, 179.96875, 0),},
		{type="prop_huntress_locker", pos=Vector(52.65625, -423.59375, 1.53125), ang=Angle(-0.125, -0.0625, 0.0625),},
		{type="prop_huntress_locker", pos=Vector(163.4375, -589.40625, 1.46875), ang=Angle(0, -179.84375, 0.03125),},
		{type="prop_huntress_locker", pos=Vector(532.46875, -586.03125, 1.5625), ang=Angle(-0.03125, 0.03125, -0.03125),},
		{type="prop_huntress_locker", pos=Vector(643.5, -430.4375, 1.5625), ang=Angle(0, 179.96875, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(532.4375, -907.40625, 1.53125), ang=Angle(0, -0.0625, 0),},
		{type="prop_huntress_locker", pos=Vector(643.5625, -1057.1875, 1.65625), ang=Angle(0, -179.875, -0.625),},
		{type="prop_huntress_locker", pos=Vector(643.5625, -423.65625, 201.53125), ang=Angle(0, 179.96875, -0.03125),},
		{type="prop_huntress_locker", pos=Vector(532.46875, -584.1875, 201.5625), ang=Angle(0, 0, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(532.40625, -901.28125, 201.53125), ang=Angle(0, -0.0625, 0),},
		{type="prop_huntress_locker", pos=Vector(643.53125, -1058.1875, 201.53125), ang=Angle(0, 179.875, 0),},
		{type="prop_huntress_locker", pos=Vector(162.78125, -901.40625, 201.5625), ang=Angle(-0.1875, 178.59375, -0.15625),},
		{type="prop_huntress_locker", pos=Vector(52.40625, -1061.625, 201.5625), ang=Angle(0, 0, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(52.46875, -422.53125, 201.53125), ang=Angle(0, 0, -0.1875),},
		{type="prop_huntress_locker", pos=Vector(163.53125, -583.125, 201.53125), ang=Angle(0.03125, -179.8125, 0),},
		{type="prop_huntress_locker", pos=Vector(-467.5, 291.53125, 201.59375), ang=Angle(-0.15625, -90, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(-412.6875, 290.15625, 201.5), ang=Angle(0.125, -89.03125, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(449.1875, 288.9375, 217.53125), ang=Angle(0.09375, -91.03125, -0.0625),},
		{type="prop_huntress_locker", pos=Vector(542.96875, 289.53125, 217.46875), ang=Angle(0, -89.96875, 0),},
		{type="prop_huntress_locker", pos=Vector(906.40625, 443.78125, 201.71875), ang=Angle(-0.71875, 179.8125, -0.03125),},
		{type="prop_huntress_locker", pos=Vector(677.46875, 442.875, 201.65625), ang=Angle(-0.65625, 0.03125, 0),},
		},

	Generator = {
		 {type="sls_generator", pos=Vector( -541.0625,-1289.0625,0.21875 ), ang=Angle(-0.087890625,-7.91015625,0),},
		 {type="sls_generator", pos=Vector( -325.71875,395.625,200.25 ), ang=Angle(-0.087890625,37.0458984375,0),},
		 {type="sls_generator", pos=Vector( -313,-1327.125,200.21875 ), ang=Angle(-0.087890625,-93.4716796875,-0.0439453125),},
		 {type="sls_generator", pos=Vector( 235.59375,-561.75,-175.75 ), ang=Angle(-0.087890625,-11.5576171875,-0.0439453125),},

	}
}