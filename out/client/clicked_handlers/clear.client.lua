-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local Room = Workspace:WaitForChild("StartingRoom")
local button = Room:WaitForChild("Clear")
local CD = button:WaitForChild("ClickDetector")
CD.MouseClick:Connect(function()
	remotes.clearDungeon:fire()
end)
