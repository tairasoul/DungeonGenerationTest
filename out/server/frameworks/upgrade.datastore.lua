-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local quicksave = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "quicksave", "src", "Quicksave")
local t = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local UpgradeSchema = quicksave.createCollection("UpgradeData", {
	schema = {
		upgrades = t.array(t.string),
	},
	defaultData = {
		upgrades = {},
	},
})
local UpgradeDatastore
do
	UpgradeDatastore = setmetatable({}, {
		__tostring = function()
			return "UpgradeDatastore"
		end,
	})
	UpgradeDatastore.__index = UpgradeDatastore
	function UpgradeDatastore.new(...)
		local self = setmetatable({}, UpgradeDatastore)
		return self:constructor(...) or self
	end
	function UpgradeDatastore:constructor(document)
		self._document = document
	end
	UpgradeDatastore.init = TS.async(function(self, name)
		local document = TS.await(UpgradeSchema:getDocument(name))
		return self.new(document)
	end)
	function UpgradeDatastore:getUpgrades()
		return self._document:get("upgrades")
	end
	function UpgradeDatastore:addUpgrades(...)
		local upg = { ... }
		local upgrades = self:getUpgrades()
		local _fn = self._document
		local _array = {}
		local _length = #_array
		local _upgradesLength = #upgrades
		table.move(upgrades, 1, _upgradesLength, _length + 1, _array)
		_length += _upgradesLength
		table.move(upg, 1, #upg, _length + 1, _array)
		_fn:set("upgrades", _array)
	end
	function UpgradeDatastore:removeUpgrades(...)
		local upg = { ... }
		local upgrades = self:getUpgrades()
		local _fn = self._document
		local _arg0 = function(v)
			local _upg = upg
			local _v = v
			return not (table.find(_upg, _v) ~= nil)
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in upgrades do
			if _arg0(_v, _k - 1, upgrades) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		_fn:set("upgrades", _newValue)
	end
	UpgradeDatastore.save = TS.async(function(self)
		self._document:save()
	end)
end
return {
	default = UpgradeDatastore,
}
