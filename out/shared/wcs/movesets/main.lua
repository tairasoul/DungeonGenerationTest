-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local CreateMoveset = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "wcs", "out").CreateMoveset
local Dodge = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "wcs", "skills", "dodge").Dodge
return CreateMoveset("Main", { Dodge })
