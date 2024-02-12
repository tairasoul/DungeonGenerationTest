-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local Generator = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "dungeon_generation").default
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ServerScriptService = _services.ServerScriptService
local Workspace = _services.Workspace
local generated = false
remotes.generateDungeon:connect(function()
	if generated then
		return nil
	end
	local cfg = require(ServerScriptService:WaitForChild("DungeonConfig"))
	Generator:generate(cfg)
	local door = Workspace:WaitForChild("StartingRoom"):WaitForChild("Door")
	door.Transparency = 1
	door.CanCollide = false
	generated = true
end)
remotes.clearDungeon:connect(function()
	if not generated then
		return nil
	end
	Generator:clear()
	local door = Workspace:WaitForChild("StartingRoom"):WaitForChild("Door")
	door.Transparency = 0
	door.CanCollide = true
	generated = false
end)
