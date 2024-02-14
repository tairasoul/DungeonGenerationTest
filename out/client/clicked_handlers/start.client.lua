-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = game:GetService("Workspace")
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local Room = Workspace:WaitForChild("StartingRoom")
local button = Room:WaitForChild("Start")
local CD = button:WaitForChild("ClickDetector")
CD.MouseClick:Connect(function()
	remotes.generateDungeon:fire()
end)
