-- blood poolz
-- now 100% more gamemode compatible

-- change the textures to your liking
BLOOD_POOL_TEXTURES = {
	-- humans, players
	[BLOOD_COLOR_RED] = {
		"decals/gm_bloodstains_001",
		"decals/gm_bloodstains_002",
		"decals/gm_bloodstains_003",
		"decals/gm_bloodstains_004",
		"decals/gm_bloodstains_005",
		"decals/gm_bloodstains_006"
	},
	-- aliens
	[BLOOD_COLOR_YELLOW] = {
		"decals/gm_bloodstains_002_yellow",
		"decals/gm_bloodstains_003_yellow",
		"decals/gm_bloodstains_004_yellow",
		"decals/gm_bloodstains_005_yellow"
	},
	-- zombies, headcrabs
	[BLOOD_COLOR_GREEN] = {
		"decals/gm_bloodstains_002_yellow",
		"decals/gm_bloodstains_003_yellow",
		"decals/gm_bloodstains_004_yellow",
		"decals/gm_bloodstains_005_yellow"
	}
}

function CreateBloodPoolForRagdoll(rag, boneid, color, flags)
	if not IsValid(rag) then return end
	
	local boneid = boneid or 0
	local flags = flags or 0
	local color = color or BLOOD_COLOR_RED

	local effectdata = EffectData()
	effectdata:SetEntity(rag)
	effectdata:SetAttachment(boneid)
	effectdata:SetFlags(flags)
	effectdata:SetColor(color)

	util.Effect("blood_pool", effectdata, true, true)
end

if CLIENT then
	CL_BLOOD_POOL_ITERATION = 1
	
	CreateClientConVar("bloodpool_min_size", 35, true, false, "Minimum size for blood pools.", 0)
	CreateClientConVar("bloodpool_max_size", 60, true, false, "Maximum size for blood pools.", 0)
	CreateClientConVar("bloodpool_lifetime", 180, true, false, "Time before blood pools are cleaned up. Does not apply to TTT.", 10)
	CreateClientConVar("bloodpool_cheap", 0, true, false, "Ignore blood pool size limitations. WARNING: Will result in floating blood!")
	
	concommand.Add("bloodpool_clear", function(ply, cmd, args)
		-- this is what i call a "hack"
		CL_BLOOD_POOL_ITERATION = CL_BLOOD_POOL_ITERATION + 1
	end)
end

if engine.ActiveGamemode() == "terrortown" then
	if SERVER then
		hook.Add("TTTOnCorpseCreated", "TTT_BloodPool", function(rag)	
			-- delaying the effect by a few frames seems to increase reliability immensely
			timer.Simple(0.05, function()
				if not IsValid(rag) then return end
				local boneid = 0
				
				if rag.was_headshot then
					boneid = rag:LookupBone("ValveBiped.Bip01_Head1")
				else
					boneid = rag:LookupBone("ValveBiped.Bip01_Spine")
				end
				
				CreateBloodPoolForRagdoll(rag, boneid, BLOOD_COLOR_RED, 1)
			end)
		end)
	end
else
	if SERVER then
		hook.Add("CreateEntityRagdoll", "BloodPool_Server", function(owner, rag)
			--print("Created Server ragdoll:"); print(rag)
			local boneid = 0
			
			if owner.bloodpool_washeadshot then
				boneid = rag:LookupBone("ValveBiped.Bip01_Head1")
			else
				boneid = rag:LookupBone("ValveBiped.Bip01_Spine")
			end

			CreateBloodPoolForRagdoll(rag, boneid, owner:GetBloodColor())
		end)
		
		hook.Add("ScaleNPCDamage", "BloodPool_LastHitGroup_NPC", function(npc, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then
				npc.bloodpool_washeadshot = true
			else
				npc.bloodpool_washeadshot = false
			end
		end)
	else
		-- for some VERY FUCKING stupid reason, clientside ragdolls created by npc's are not valid, and thus won't work here. player ragdolls however do.
		-- i'm not interested enough in sandbox support for this addon to figure a fix for this. if you know, please tell me.
		hook.Add("CreateClientsideRagdoll", "BloodPool_CS", function(ent, rag)
			--print("Created Clientside ragdoll:"); print(rag)
			local boneid = 0
			
			if ent.bloodpool_washeadshot then
				boneid = rag:LookupBone("ValveBiped.Bip01_Head1")
			else
				boneid = rag:LookupBone("ValveBiped.Bip01_Spine")
			end
			
			CreateBloodPoolForRagdoll(rag, boneid)
		end)
	end
	
	hook.Add("ScalePlayerDamage", "BloodPool_LastHitGroup", function(ply, hitgroup, dmginfo)
		if hitgroup == HITGROUP_HEAD then
			ply.bloodpool_washeadshot = true
		else
			ply.bloodpool_washeadshot = false
		end
	end)
end

-- this is all