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
local function eulerToVector(euler)
	return Vector3.new(euler[1], euler[2], euler[3])
end
local function cframeFromComponents(xyz, components)
	local cframe = CFrame.new(xyz.X, xyz.Y, xyz.Z, components[4], components[5], components[6], components[7], components[8], components[9], components[10], components[11], components[12])
	return cframe
end
local function CFRameComponentOffset(components1, components2)
	local newOffset = {}
	do
		local i = 0
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i += 1
			else
				_shouldIncrement = true
			end
			if not (i < components1.length) then
				break
			end
			newOffset[i + 1] = components1[i + 1] - components2[i + 1]
		end
	end
	return CFrame.new(newOffset[1], newOffset[2], newOffset[3], newOffset[4], newOffset[5], newOffset[6], newOffset[7], newOffset[8], newOffset[9], newOffset[10], newOffset[11], newOffset[12])
end
return {
	getRandom = getRandom,
	getDistance = getDistance,
	guid = guid,
	eulerToVector = eulerToVector,
	cframeFromComponents = cframeFromComponents,
	CFRameComponentOffset = CFRameComponentOffset,
}
