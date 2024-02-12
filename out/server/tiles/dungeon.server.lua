-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local Generator = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "dungeon_generation").default
local Workspace = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local generated = false
remotes.generateDungeon:connect(function()
	if generated then
		return nil
	end
	local cfg = {
		STARTING_PART = Workspace:FindFirstChild("RoomStart", true),
		TILES = 30,
	}
	Generator:generate(cfg)
	Workspace:WaitForChild("StartingRoom"):WaitForChild("Door"):Destroy()
	generated = true
end)
