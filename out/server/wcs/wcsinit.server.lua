-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players = _services.Players
local ReplicatedStorage = _services.ReplicatedStorage
local _wcs = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "wcs", "out")
local Character = _wcs.Character
local CreateServer = _wcs.CreateServer
local main = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "wcs", "movesets", "main")
local server = CreateServer()
server:RegisterDirectory(ReplicatedStorage.TS.wcs.movesets)
server:RegisterDirectory(ReplicatedStorage.TS.wcs.skills)
server:RegisterDirectory(ReplicatedStorage.TS.wcs.statusEffects)
server:Start()
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(model)
		local wcs = Character.new(model)
		wcs:ApplySkillsFromMoveset(main);
		(model:WaitForChild("Humanoid")).Died:Once(function()
			return wcs:Destroy()
		end)
	end)
end)
