-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ServerScriptService = _services.ServerScriptService
local ServerStorage = _services.ServerStorage
local FolderMerger = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "folderMerger").default
local make = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "make")
local nonts = ServerStorage:WaitForChild("tiles.non-ts")
local tsTiles = ServerScriptService:WaitForChild("TS"):WaitForChild("tiles"):WaitForChild("tiles", 10)
local folder = ServerStorage:FindFirstChild("tiles") or make("Folder", {
	Name = "tiles",
	Parent = ServerStorage,
})
local merger = FolderMerger.new(folder)
merger:merge(nonts, tsTiles)
