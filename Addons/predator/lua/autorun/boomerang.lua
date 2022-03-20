resource.AddFile ("materials/models/boomerang/boomerang_texture.vmt")

resource.AddFile ("models/boomerang/boomerang.mdl")

resource.AddFile ("materials/models/boomerang/boomerang_texture.001.vmt")

resource.AddFile ("models/boomerang/w_boomerang.mdl")

resource.AddFile ("materials/models/boomerang/blade.vmt")

resource.AddFile ("models/boomerang/combat.mdl")

resource.AddFile ("materials/vgui/hud/blade_boomerang.vmt")

resource.AddFile ("materials/entities/blade_boomerang.png")

resource.AddFile ("materials/entities/blade_boomerang_thrower.png")

resource.AddFile ("materials/entities/boomerang_thrower.png")

resource.AddFile ("models/boomerang/magma.mdl")

resource.AddFile ("materials/models/help_needed/magma.vmt")

resource.AddFile ("materials/models/boomerang/magma.vmt")

function boomerang_setspeed(player,command,args)
	if not oldcurveboomerang then
	if isnumber(tonumber(args[1])) then 
       speedboom = tonumber(args[1])
    end
	else
	print("You cant change this while boomerang_curve_oldcurve is true.")
	end

end

function boomerang_setspeedautocomplete(commandName,args)
    return {tostring(speedboom)}
end


function boomerang_curve_detail(player,command,args)
	if not oldcurveboomerang then
	if isnumber(tonumber(args[1])) then 
       curvedetailboom = tonumber(args[1])
    end
	else
    	print("You cant change this while boomerang_curve_oldcurve is true.")
	end

end

function boomerang_curve_detailautocomplete(commandName,args)
    return {tostring(curvedetailboom)}
end


function boomerang_curve_oldcurve(player,command,args)
	if args[1]=="true" then
		oldcurveboomerang=true
		concommand.Remove("boomerang_setspeed")
    	concommand.Remove("boomerang_curve_stepdistance")
	end
	if args[1]=="false" then
		speedboom = 610
		oldcurveboomerang=false
		concommand.Add("boomerang_setspeed",boomerang_setspeed,boomerang_setspeedautocomplete)
		curvedetailboom = 220
		concommand.Add("boomerang_curve_stepdistance",boomerang_curve_detail,boomerang_curve_detailautocomplete)
	end	
end

function boomerang_curve_oldcurveautocomplete(commandName,args)
    if oldcurveboomerang then 
    	return {"true"} 
    else 
    	return {"false"} 
    end
end

function boomerang_curve_oldcurve(player,command,args)
	if args[1]=="true" then
		oldcurveboomerang=true
		concommand.Remove("boomerang_setspeed")
    	concommand.Remove("boomerang_curve_stepdistance")
    	concommand.Remove("boomerang_curve_radius")
	end
	if args[1]=="false" then
		speedboom = 610
		oldcurveboomerang=false
		concommand.Add("boomerang_setspeed",boomerang_setspeed,boomerang_setspeedautocomplete)
		curvedetailboom = 220
		concommand.Add("boomerang_curve_stepdistance",boomerang_curve_detail,boomerang_curve_detailautocomplete)
		radiusboomerang = 1500
		concommand.Add("boomerang_curve_radius",boomerang_curve_radius,boomerang_curve_radiusautocomplete)
	end	
end

function boomerang_curve_oldcurveautocomplete(commandName,args)
    if oldcurveboomerang then 
    	return {"true"} 
    else 
    	return {"false"} 
    end
end

function boomerang_curve_radius(player,command,args)
	if isnumber(tonumber(args[1])) then 
       radiusboomerang = tonumber(args[1])
    end
end

function boomerang_curve_radiusautocomplete(commandName,args)
    return {tostring(radiusboomerang)}
end


if not Firsttick then
Firsttick = 1
Loops={}
speedboom = 610
concommand.Add("boomerang_setspeed",boomerang_setspeed,boomerang_setspeedautocomplete)

curvedetailboom = 220
concommand.Add("boomerang_curve_stepdistance",boomerang_curve_detail,boomerang_curve_detailautocomplete)

oldcurveboomerang = false
concommand.Add("boomerang_curve_oldcurve",boomerang_curve_oldcurve,boomerang_curve_oldcurveautocomplete)

radiusboomerang = 1500
concommand.Add("boomerang_curve_radius",boomerang_curve_radius,boomerang_curve_radiusautocomplete)
print("Boomerang´s loaded.")
end
