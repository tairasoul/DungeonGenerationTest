-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local HealthSystem = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "frameworks", "character", "health")
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
		local _exp = self._healthSystems
		-- ▼ ReadonlyArray.find ▼
		local _callback = function(system)
			return system.humanoid == humanoid
		end
		local _result
		for _i, _v in _exp do
			if _callback(_v, _i - 1, _exp) == true then
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
		local _exp = self._healthSystems
		table.insert(_exp, system)
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
		local _exp = self._healthSystems
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _callback = function(existingSystem)
			return existingSystem ~= system
		end
		local _length = 0
		for _k, _v in _exp do
			if _callback(_v, _k - 1, _exp) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		self._healthSystems = _newValue
	end
	_class = Registry
end
return _class.new()
