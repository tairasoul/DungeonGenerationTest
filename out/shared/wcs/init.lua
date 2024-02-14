-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local main = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "wcs", "movesets", "main")
local Dodge = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "wcs", "skills", "dodge").Dodge
return {
	movesets = {
		main = main,
	},
	skills = {
		Dodge = Dodge,
	},
	statusEffects = {},
}
