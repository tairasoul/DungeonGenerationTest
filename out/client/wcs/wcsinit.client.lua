-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local _wcs = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "wcs", "out")
local Character = _wcs.Character
local CreateClient = _wcs.CreateClient
local dodge = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "wcs", "skills", "dodge").Dodge
local client = CreateClient()
client:RegisterDirectory(ReplicatedStorage.TS.wcs.movesets)
client:RegisterDirectory(ReplicatedStorage.TS.wcs.skills)
client:RegisterDirectory(ReplicatedStorage.TS.wcs.statusEffects)
client:Start()
local function getCurrentWCS_Character()
	local characterModel = Players.LocalPlayer.Character
	if not characterModel then
		return nil
	end
	return Character:GetCharacterFromInstance_TS(characterModel)
end
UserInputService.JumpRequest:Connect(function()
	((Players.LocalPlayer.Character or (Players.LocalPlayer.CharacterAdded:Wait())):WaitForChild("Humanoid")).Jump = false
end)
UserInputService.JumpRequest:Connect(function()
	local char = getCurrentWCS_Character()
	local _result = char
	if _result ~= nil then
		_result = _result:GetSkillFromConstructor(dodge)
		if _result ~= nil then
			_result:Start()
		end
	end
end)
