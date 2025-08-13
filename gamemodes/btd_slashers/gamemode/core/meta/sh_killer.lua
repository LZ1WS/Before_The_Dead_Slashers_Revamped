---@meta

sls.meta = sls.meta or {}

local KILLER = sls.meta.killer or {}
KILLER.__index = KILLER

KILLER.Name = "ERROR"
KILLER.Desc = "ERROR"
KILLER.Icon = Material("icons/icon_jason.png")
KILLER.Model = "models/player/mkx_jason.mdl"
KILLER.Joke = false
KILLER.Serious = nil

KILLER.WalkSpeed = 190
KILLER.RunSpeed = 240

KILLER.UniqueWeapon = false
KILLER.ExtraWeapons = {}

KILLER.StartMusic = "sound/slashers/ambient/slashers_start_game_jason.wav"
KILLER.ChaseMusic = "jason/chase/chase.wav"
KILLER.TerrorMusic = "jason/terror/terror.wav"
KILLER.EscapeMusic = nil

KILLER.SpecialRound = "NONE"
KILLER.SpecialGoals = {}

KILLER.Abilities = nil
KILLER.VoiceCallouts = nil

KILLER.UseAbility = nil

sls.meta.killer = KILLER