-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
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
local function getRandomWithWeight(array, filter, weights)
	if filter == nil then
		filter = function()
			return true
		end
	end
	if weights == nil then
		weights = {}
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
	-- Apply weights to the filtered array
	local _arg0 = function(element, index)
		local _object = {
			element = element,
		}
		local _left = "weight"
		local _condition = weights[index + 1]
		if not (_condition ~= 0 and (_condition == _condition and _condition)) then
			_condition = 1
		end
		_object[_left] = _condition
		return _object
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue_1 = table.create(#filtered)
	for _k, _v in filtered do
		_newValue_1[_k] = _arg0(_v, _k - 1, filtered)
	end
	-- ▲ ReadonlyArray.map ▲
	local weightedArray = _newValue_1
	-- Calculate total weight
	local _arg0_1 = function(sum, _param)
		local weight = _param.weight
		return sum + weight
	end
	-- ▼ ReadonlyArray.reduce ▼
	local _result = 0
	local _callback = _arg0_1
	for _i = 1, #weightedArray do
		_result = _callback(_result, weightedArray[_i], _i - 1, weightedArray)
	end
	-- ▲ ReadonlyArray.reduce ▲
	local totalWeight = _result
	-- Generate a random number within the total weight range
	local randomWeight = math.random(0, totalWeight)
	-- Select an element based on weighted probability
	for _, _binding in weightedArray do
		local element = _binding.element
		local weight = _binding.weight
		if randomWeight <= weight then
			return element
		end
		randomWeight -= weight
	end
	-- This should never happen, but just in case
	return nil
end
local function getAllBeforeCondition(array, condition)
	if condition == nil then
		condition = function()
			return true
		end
	end
	local newArr = {}
	for _, item in array do
		if condition(item) then
			table.insert(newArr, item)
		else
			break
		end
	end
	return newArr
end
local function inverseForEach(array, callback)
	do
		local i = #array - 1
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i -= 1
			else
				_shouldIncrement = true
			end
			if not (i >= 0) then
				break
			end
			callback(array[i + 1])
		end
	end
end
local function getNextAfterCondition_Reverse(array, condition)
	if condition == nil then
		condition = function()
			return true
		end
	end
	local found = false
	do
		local i = #array - 1
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i -= 1
			else
				_shouldIncrement = true
			end
			if not (i >= 0) then
				break
			end
			local item = array[i + 1]
			if found then
				return item
			end
			if condition(item) then
				found = true
			end
		end
	end
	return nil
end
local function getNextAfterCondition(array, condition)
	if condition == nil then
		condition = function()
			return true
		end
	end
	local found = false
	do
		local i = 0
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i -= 1
			else
				_shouldIncrement = true
			end
			if not (i < #array - 1) then
				break
			end
			local item = array[i + 1]
			if found then
				return item
			end
			if condition(item) then
				found = true
			end
		end
	end
	return nil
end
local function getLastBeforeCondition(array, condition)
	if condition == nil then
		condition = function()
			return true
		end
	end
	do
		local i = #array - 1
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i -= 1
			else
				_shouldIncrement = true
			end
			if not (i >= 0) then
				break
			end
			local item = array[i + 1]
			if condition(item) then
				return item
			end
		end
	end
	return nil
end
local function benchmark(func)
	local startTime = os.clock()
	func()
	local endTime = os.clock()
	local diff = endTime - startTime
	local minutes = math.floor(diff / 60)
	local seconds = math.floor(diff % 60)
	local milliseconds = math.floor((diff - math.floor(diff)) * 1000)
	return {
		minutes = minutes,
		seconds = seconds,
		milliseconds = milliseconds,
	}
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
local function CFrameComponentsSub(components1, components2)
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
			if not (i < #components1) then
				break
			end
			newOffset[i + 1] = components1[i + 1] - components2[i + 1]
		end
	end
	return CFrame.new(newOffset[1], newOffset[2], newOffset[3], newOffset[4], newOffset[5], newOffset[6], newOffset[7], newOffset[8], newOffset[9], newOffset[10], newOffset[11], newOffset[12])
end
local function CFrameComponentsAdd(components1, components2)
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
			if not (i < #components1) then
				break
			end
			newOffset[i + 1] = components1[i + 1] + components2[i + 1]
		end
	end
	return CFrame.new(newOffset[1], newOffset[2], newOffset[3], newOffset[4], newOffset[5], newOffset[6], newOffset[7], newOffset[8], newOffset[9], newOffset[10], newOffset[11], newOffset[12])
end
local function applyOffsetRelativeToPart(part, offsetVector)
	-- Get the part's orientation vector
	local orientationVector = part.CFrame.LookVector
	-- Scale the offset vector by the magnitudes of the part's orientation vectors
	local scaledOffsetVector = Vector3.new(offsetVector.X * orientationVector.X, offsetVector.Y * orientationVector.Y, offsetVector.Z * orientationVector.Z)
	-- Calculate the new position by adding the scaled offset to the part's position
	local newPosition = part.Position + scaledOffsetVector
	return newPosition
end
local function getAllPlayerParts()
	local players = Players:GetPlayers()
	local parts = {}
	for _, player in players do
		local char = player.Character or (player.CharacterAdded:Wait())
		local _exp = char:GetDescendants()
		local _arg0 = function(v)
			return v:IsA("Part")
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in _exp do
			if _arg0(_v, _k - 1, _exp) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		for _1, part in _newValue do
			table.insert(parts, part)
		end
	end
	return parts
end
local function logServer(str, srcFile, lineNumber, logType)
	if logType == nil then
		logType = "Message"
	end
	remotes.serverLog:fireAll(str, srcFile, lineNumber, logType)
end
local function reverseArray(array)
	local reversedArray = {}
	do
		local i = #array - 1
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i -= 1
			else
				_shouldIncrement = true
			end
			if not (i >= 0) then
				break
			end
			local _arg0 = array[i + 1]
			table.insert(reversedArray, _arg0)
		end
	end
	return reversedArray
end
return {
	getRandom = getRandom,
	getRandomWithWeight = getRandomWithWeight,
	getAllBeforeCondition = getAllBeforeCondition,
	inverseForEach = inverseForEach,
	getNextAfterCondition_Reverse = getNextAfterCondition_Reverse,
	getNextAfterCondition = getNextAfterCondition,
	getLastBeforeCondition = getLastBeforeCondition,
	benchmark = benchmark,
	getDistance = getDistance,
	guid = guid,
	eulerToVector = eulerToVector,
	cframeFromComponents = cframeFromComponents,
	CFrameComponentsSub = CFrameComponentsSub,
	CFrameComponentsAdd = CFrameComponentsAdd,
	applyOffsetRelativeToPart = applyOffsetRelativeToPart,
	getAllPlayerParts = getAllPlayerParts,
	logServer = logServer,
	reverseArray = reverseArray,
}
