-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _fusion = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "fusion", "src")
local Value = _fusion.Value
local Observer = _fusion.Observer
local HealthSystem
do
	HealthSystem = setmetatable({}, {
		__tostring = function()
			return "HealthSystem"
		end,
	})
	HealthSystem.__index = HealthSystem
	function HealthSystem.new(...)
		local self = setmetatable({}, HealthSystem)
		return self:constructor(...) or self
	end
	function HealthSystem:constructor(humanoid)
		self.maxHealth = Value(6)
		self.health = Value(self.maxHealth:get())
		self.maxShield = Value(3)
		self.shield = Value(self.maxShield:get())
		self.canTakeDamage = false
		self.valid = Value(true)
		self.observers = {
			health = Observer(self.health),
			shield = Observer(self.shield),
			valid = Observer(self.valid),
		}
		self.listeners = {
			health = {},
			shield = {},
			valid = {},
		}
		self.humanoid = humanoid
		self.humanoid.Died:Once(function()
			self.valid:set(false)
		end)
	end
	function HealthSystem:addHealthListener(callback)
		local _health = self.listeners.health
		local _arg0 = {
			callback = callback,
			destroy = self.observers.health:onChange(callback),
		}
		table.insert(_health, _arg0)
	end
	function HealthSystem:addShieldListener(callback)
		local _shield = self.listeners.shield
		local _arg0 = {
			callback = callback,
			destroy = self.observers.shield:onChange(callback),
		}
		table.insert(_shield, _arg0)
	end
	function HealthSystem:addValidListener(callback)
		local _valid = self.listeners.valid
		local _arg0 = {
			callback = callback,
			destroy = self.observers.valid:onChange(callback),
		}
		table.insert(_valid, _arg0)
	end
	function HealthSystem:removeHealthListener(callback)
		local _health = self.listeners.health
		local _arg0 = function(v)
			return v.callback == callback
		end
		-- ▼ ReadonlyArray.find ▼
		local _result
		for _i, _v in _health do
			if _arg0(_v, _i - 1, _health) == true then
				_result = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		local listener = _result
		if listener ~= nil then
			listener.destroy()
			local _health_1 = self.listeners.health
			local _arg0_1 = function(v)
				return v ~= listener
			end
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _length = 0
			for _k, _v in _health_1 do
				if _arg0_1(_v, _k - 1, _health_1) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			self.listeners.health = _newValue
		end
	end
	function HealthSystem:removeShieldListener(callback)
		local _shield = self.listeners.shield
		local _arg0 = function(v)
			return v.callback == callback
		end
		-- ▼ ReadonlyArray.find ▼
		local _result
		for _i, _v in _shield do
			if _arg0(_v, _i - 1, _shield) == true then
				_result = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		local listener = _result
		if listener ~= nil then
			listener.destroy()
			local _shield_1 = self.listeners.shield
			local _arg0_1 = function(v)
				return v ~= listener
			end
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _length = 0
			for _k, _v in _shield_1 do
				if _arg0_1(_v, _k - 1, _shield_1) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			self.listeners.shield = _newValue
		end
	end
	function HealthSystem:removeValidListener(callback)
		local _shield = self.listeners.shield
		local _arg0 = function(v)
			return v.callback == callback
		end
		-- ▼ ReadonlyArray.find ▼
		local _result
		for _i, _v in _shield do
			if _arg0(_v, _i - 1, _shield) == true then
				_result = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		local listener = _result
		if listener ~= nil then
			listener.destroy()
			local _shield_1 = self.listeners.shield
			local _arg0_1 = function(v)
				return v ~= listener
			end
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _length = 0
			for _k, _v in _shield_1 do
				if _arg0_1(_v, _k - 1, _shield_1) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			self.listeners.shield = _newValue
		end
	end
	function HealthSystem:removeAllListeners()
		local _shield = self.listeners.shield
		local _arg0 = function(v)
			return v.destroy()
		end
		for _k, _v in _shield do
			_arg0(_v, _k - 1, _shield)
		end
		local _health = self.listeners.health
		local _arg0_1 = function(v)
			return v.destroy()
		end
		for _k, _v in _health do
			_arg0_1(_v, _k - 1, _health)
		end
		local _valid = self.listeners.valid
		local _arg0_2 = function(v)
			return v.destroy()
		end
		for _k, _v in _valid do
			_arg0_2(_v, _k - 1, _valid)
		end
		table.clear(self.listeners.shield)
		table.clear(self.listeners.health)
		table.clear(self.listeners.valid)
	end
	function HealthSystem:takeDamage(damage)
		if not self.canTakeDamage then
			return nil
		end
		if self.shield:get() > 0 then
			self.shield:set(self.shield:get() - damage)
		else
			self.health:set(self.health:get() - damage)
		end
		if self.health:get() == 0 then
			self.humanoid.Health = 0
		end
	end
end
return {
	default = HealthSystem,
}
