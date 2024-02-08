-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local HttpService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local function getRandom(array, filter)
	if filter == nil then
		filter = function()
			return true
		end
	end
	local _array = array
	local _filter = filter
	-- ▼ ReadonlyArray.filter ▼
	local _newValue = {}
	local _length = 0
	for _k, _v in _array do
		if _filter(_v, _k - 1, _array) == true then
			_length += 1
			_newValue[_length] = _v
		end
	end
	-- ▲ ReadonlyArray.filter ▲
	local filtered = _newValue
	if #filtered == 0 then
		return nil
	end
	local random = math.random(1, #filtered)
	return filtered[random - 1 + 1]
end
local function getDistance(vector1, vector2)
	local _vector1 = vector1
	local _vector2 = vector2
	return _vector1 - _vector2
end
local function guid()
	return HttpService:GenerateGUID()
end
return {
	getRandom = getRandom,
	getDistance = getDistance,
	guid = guid,
}
