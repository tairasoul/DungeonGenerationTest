-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local tileFolder = Instance.new("Folder", Workspace)
tileFolder.Name = "Tiles"
local tiles = tileFolder
return {
	tiles = tiles,
}
