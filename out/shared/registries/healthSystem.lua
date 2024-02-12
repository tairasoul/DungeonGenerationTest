-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local HealthSystem = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "frameworks", "character", "health").default
local _class
do
	local Registry = setmetatable({}, {
		__tostring = function()
			return "Registry"
		end,
	})
	Registry.__index = Registry
	function Registry.new(...)
		local self = setmetatable({}, Registry)
		return self:constructor(...) or self
	end
	function Registry:constructor()
		self._healthSystems = {}
	end
	function Registry:getSystemForHumanoid(humanoid)
		local __healthSystems = self._healthSystems
		local _arg0 = function(system)
			return system.humanoid == humanoid
		end
		-- ▼ ReadonlyArray.find ▼
		local _result
		for _i, _v in __healthSystems do
			if _arg0(_v, _i - 1, __healthSystems) == true then
				_result = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		return _result
	end
	function Registry:addHumanoid(humanoid)
		local existingSystem = self:getSystemForHumanoid(humanoid)
		if existingSystem then
			return existingSystem
		end
		local system = HealthSystem.new(humanoid)
		system:addValidListener(function()
			self:_removeSystem(system)
		end)
		table.insert(self._healthSystems, system)
		return system
	end
	function Registry:removeHumanoid(humanoid)
		local system = self:getSystemForHumanoid(humanoid)
		if system then
			self:_removeSystem(system)
		end
	end
	function Registry:_removeSystem(system)
		system:removeAllListeners()
		local __healthSystems = self._healthSystems
		local _arg0 = function(existingSystem)
			return existingSystem ~= system
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in __healthSystems do
			if _arg0(_v, _k - 1, __healthSystems) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		self._healthSystems = _newValue
	end
	_class = Registry
end
local default = _class.new()
return {
	default = default,
}
