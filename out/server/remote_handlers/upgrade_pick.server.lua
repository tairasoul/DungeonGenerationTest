-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
remotes.pickUpgrade:connect(function(player, identifier)
	print("[src/server/remote_handlers/upgrade_pick.server.ts:5]", `received upgrade pick request from {player} for upgrade with id {identifier}`)
end)
