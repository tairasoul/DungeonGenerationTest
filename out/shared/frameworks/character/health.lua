-- Compiled with roblox-ts v2.3.0
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
		self._valid = Value(true)
		self._observers = {
			health = Observer(self.health),
			shield = Observer(self.shield),
			valid = Observer(self._valid),
		}
		self._listeners = {
			health = {},
			shield = {},
			valid = {},
		}
		self.humanoid = humanoid
		self.humanoid.Died:Once(function()
			self._valid:set(false)
		end)
	end
	function HealthSystem:addHealthListener(callback)
		local _health = self._listeners.health
		local _arg0 = {
			callback = callback,
			destroy = self._observers.health:onChange(callback),
		}
		table.insert(_health, _arg0)
	end
	function HealthSystem:addShieldListener(callback)
		local _shield = self._listeners.shield
		local _arg0 = {
			callback = callback,
			destroy = self._observers.shield:onChange(callback),
		}
		table.insert(_shield, _arg0)
	end
	function HealthSystem:addValidListener(callback)
		local _valid = self._listeners.valid
		local _arg0 = {
			callback = callback,
			destroy = self._observers.valid:onChange(callback),
		}
		table.insert(_valid, _arg0)
	end
	function HealthSystem:removeHealthListener(callback)
		local _exp = self._listeners.health
		-- ▼ ReadonlyArray.find ▼
		local _callback = function(v)
			return v.callback == callback
		end
		local _result
		for _i, _v in _exp do
			if _callback(_v, _i - 1, _exp) == true then
				_result = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		local listener = _result
		if listener ~= nil then
			listener.destroy()
			local _exp_1 = self._listeners.health
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _callback_1 = function(v)
				return v ~= listener
			end
			local _length = 0
			for _k, _v in _exp_1 do
				if _callback_1(_v, _k - 1, _exp_1) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			self._listeners.health = _newValue
		end
	end
	function HealthSystem:removeShieldListener(callback)
		local _exp = self._listeners.shield
		-- ▼ ReadonlyArray.find ▼
		local _callback = function(v)
			return v.callback == callback
		end
		local _result
		for _i, _v in _exp do
			if _callback(_v, _i - 1, _exp) == true then
				_result = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		local listener = _result
		if listener ~= nil then
			listener.destroy()
			local _exp_1 = self._listeners.shield
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _callback_1 = function(v)
				return v ~= listener
			end
			local _length = 0
			for _k, _v in _exp_1 do
				if _callback_1(_v, _k - 1, _exp_1) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			self._listeners.shield = _newValue
		end
	end
	function HealthSystem:removeValidListener(callback)
		local _exp = self._listeners.shield
		-- ▼ ReadonlyArray.find ▼
		local _callback = function(v)
			return v.callback == callback
		end
		local _result
		for _i, _v in _exp do
			if _callback(_v, _i - 1, _exp) == true then
				_result = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		local listener = _result
		if listener ~= nil then
			listener.destroy()
			local _exp_1 = self._listeners.shield
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _callback_1 = function(v)
				return v ~= listener
			end
			local _length = 0
			for _k, _v in _exp_1 do
				if _callback_1(_v, _k - 1, _exp_1) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			self._listeners.shield = _newValue
		end
	end
	function HealthSystem:removeAllListeners()
		local _exp = self._listeners.shield
		-- ▼ ReadonlyArray.forEach ▼
		local _callback = function(v)
			return v.destroy()
		end
		for _k, _v in _exp do
			_callback(_v, _k - 1, _exp)
		end
		-- ▲ ReadonlyArray.forEach ▲
		local _exp_1 = self._listeners.health
		-- ▼ ReadonlyArray.forEach ▼
		local _callback_1 = function(v)
			return v.destroy()
		end
		for _k, _v in _exp_1 do
			_callback_1(_v, _k - 1, _exp_1)
		end
		-- ▲ ReadonlyArray.forEach ▲
		local _exp_2 = self._listeners.valid
		-- ▼ ReadonlyArray.forEach ▼
		local _callback_2 = function(v)
			return v.destroy()
		end
		for _k, _v in _exp_2 do
			_callback_2(_v, _k - 1, _exp_2)
		end
		-- ▲ ReadonlyArray.forEach ▲
		table.clear(self._listeners.shield)
		table.clear(self._listeners.health)
		table.clear(self._listeners.valid)
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
	function HealthSystem:healHealth(hp)
		if hp > self.maxHealth:get() then
			hp = self.maxHealth:get()
		end
		self.health:set(hp)
	end
	function HealthSystem:healShield(sp)
		if sp > self.maxShield:get() then
			sp = self.maxShield:get()
		end
		self.shield:set(sp)
	end
end
return {
	default = HealthSystem,
}
