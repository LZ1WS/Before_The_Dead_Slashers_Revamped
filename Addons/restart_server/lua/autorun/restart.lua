if SERVER then
concommand.Add("restartserver", function()
	PrintMessage(4, "РЕСТАРТ ЧЕРЕЗ 10 СЕКУНД!")
		timer.Simple(5, function()
	PrintMessage(4, "РЕСТАРТ ЧЕРЕЗ 5 СЕКУНД!")
end)
	timer.Create("restart", 9, 1, function()
		PrintMessage(4, "РЕСТАРТ!")
		engine.CloseServer()
end)
end)
end