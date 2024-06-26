-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "RoactTS")
local Players = game:GetService("Players")
local Upgrades = TS.import(script, script.Parent.Parent, "ui_setup", "upgrades").Upgrades
local _class
do
	local UIHandler = setmetatable({}, {
		__tostring = function()
			return "UIHandler"
		end,
	})
	UIHandler.__index = UIHandler
	function UIHandler.new(...)
		local self = setmetatable({}, UIHandler)
		return self:constructor(...) or self
	end
	function UIHandler:constructor()
		self._screens = {}
	end
	function UIHandler:openUpgrades(upgrades)
		local elem = Upgrades({
			upgrades = upgrades,
			upgraded = function()
				return self:closeUpgrades()
			end,
		})
		print(elem)
		self._screens.Upgrade = Roact.mount(elem, Players.LocalPlayer:WaitForChild("PlayerGui"))
	end
	function UIHandler:closeUpgrades()
		if self._screens.Upgrade then
			self._screens.Upgrade = Roact.unmount(self._screens.Upgrade)
		end
	end
	_class = UIHandler
end
return _class.new()
