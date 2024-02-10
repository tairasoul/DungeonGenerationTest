-- Compiled with roblox-ts v2.1.0
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
		self.HealthSystems = {}
	end
	function Registry:getSystemForHumanoid(humanoid)
		for _, system in self.HealthSystems do
			if system.humanoid == humanoid then
				return system
			end
		end
		return nil
	end
	function Registry:addHumanoid(humanoid)
		if self:getSystemForHumanoid(humanoid) then
			return self:getSystemForHumanoid(humanoid)
		end
		local system = HealthSystem.new(humanoid)
		local callback
		callback = function()
			local _healthSystems = self.HealthSystems
			local _arg0 = function(v)
				return v ~= system
			end
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _length = 0
			for _k, _v in _healthSystems do
				if _arg0(_v, _k - 1, _healthSystems) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			self.HealthSystems = _newValue
			system:removeValidListener(callback)
			system:removeAllListeners()
		end
		system:addValidListener(callback)
		table.insert(self.HealthSystems, system)
		return system
	end
	function Registry:removeHumanoid(humanoid)
		local _healthSystems = self.HealthSystems
		local _arg0 = function(v)
			return v.humanoid == humanoid
		end
		-- ▼ ReadonlyArray.some ▼
		local _result = false
		for _k, _v in _healthSystems do
			if _arg0(_v, _k - 1, _healthSystems) then
				_result = true
				break
			end
		end
		-- ▲ ReadonlyArray.some ▲
		if _result then
			local _healthSystems_1 = self.HealthSystems
			local _arg0_1 = function(v)
				return v.humanoid == humanoid
			end
			-- ▼ ReadonlyArray.find ▼
			local _result_1
			for _i, _v in _healthSystems_1 do
				if _arg0_1(_v, _i - 1, _healthSystems_1) == true then
					_result_1 = _v
					break
				end
			end
			-- ▲ ReadonlyArray.find ▲
			local system = _result_1
			system:removeAllListeners()
			local _healthSystems_2 = self.HealthSystems
			local _arg0_2 = function(v)
				return v ~= system
			end
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _length = 0
			for _k, _v in _healthSystems_2 do
				if _arg0_2(_v, _k - 1, _healthSystems_2) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			self.HealthSystems = _newValue
		end
	end
	_class = Registry
end
local default = _class.new()
return {
	default = default,
}
