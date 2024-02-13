-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local UpgradeRegistry = TS.import(script, game:GetService("ServerScriptService"), "TS", "frameworks", "upgradeRegistry").default
local ServerStorage = game:GetService("ServerStorage")
local UpgradeDatastore = TS.import(script, game:GetService("ServerScriptService"), "TS", "frameworks", "upgrade.datastore").default
local getRandom = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils").getRandom
local registry = UpgradeRegistry.new(ServerStorage:WaitForChild("Upgrades"))
local UpgradeSystem
do
	UpgradeSystem = setmetatable({}, {
		__tostring = function()
			return "UpgradeSystem"
		end,
	})
	UpgradeSystem.__index = UpgradeSystem
	function UpgradeSystem.new(...)
		local self = setmetatable({}, UpgradeSystem)
		return self:constructor(...) or self
	end
	function UpgradeSystem:constructor(player, datastore)
		self._playerIsPicking = false
		self._playerOptions = {}
		self._player = player
		self._datastore = datastore
	end
	UpgradeSystem.init = TS.async(function(self, player)
		local datastore = TS.await(UpgradeDatastore:init(tostring(player.UserId)))
		return self.new(player, datastore)
	end)
	function UpgradeSystem:pickUpgrades(...)
		local upgrades = { ... }
		self._playerIsPicking = true
		self._playerOptions = upgrades
		remotes.upgradesAvailable:fire(self._player, upgrades)
	end
	UpgradeSystem.upgradePickHandler = TS.async(function(self, _, identifier)
		if not self._playerIsPicking then
			return nil
		end
		self._playerIsPicking = false
		local __playerOptions = self._playerOptions
		local _arg0 = function(v)
			return v.identifier == identifier
		end
		-- ▼ ReadonlyArray.some ▼
		local _result = false
		for _k, _v in __playerOptions do
			if _arg0(_v, _k - 1, __playerOptions) then
				_result = true
				break
			end
		end
		-- ▲ ReadonlyArray.some ▲
		if _result then
			self._datastore:addUpgrades(identifier)
			self._datastore:save()
		end
	end)
	function UpgradeSystem:pickRandomUpgrades()
		local upgs = registry.upgradeInfo
		local upg1 = getRandom(upgs)
		local upg2 = getRandom(upgs)
		local upg3 = getRandom(upgs)
		if not upg1 or (not upg2 or not upg3) then
			return nil
		end
		self:pickUpgrades(upg1, upg2, upg3)
	end
end
return {
	default = UpgradeSystem,
}
