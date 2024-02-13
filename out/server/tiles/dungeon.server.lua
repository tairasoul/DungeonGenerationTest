-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local Generator = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "dungeon_generation").default
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")
local generated = false
local cfg = require(ServerScriptService:WaitForChild("DungeonConfig"))
local gen = Generator.new(cfg)
remotes.generateDungeon:connect(function()
	if generated then
		return nil
	end
	generated = true
	gen:generate()
	local door = Workspace:WaitForChild("StartingRoom"):WaitForChild("Door")
	door.Transparency = 1
	door.CanCollide = false
end)
remotes.clearDungeon:connect(function()
	if not generated then
		return nil
	end
	gen:clear()
	local door = Workspace:WaitForChild("StartingRoom"):WaitForChild("Door")
	door.Transparency = 0
	door.CanCollide = true
	generated = false
end)
