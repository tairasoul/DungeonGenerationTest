-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _utils = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils")
local getRandom = _utils.getRandom
local randomChance = _utils.randomChance
local tileFolderParser = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tileFolderParser").default
local TileRandomizer
do
	TileRandomizer = setmetatable({}, {
		__tostring = function()
			return "TileRandomizer"
		end,
	})
	TileRandomizer.__index = TileRandomizer
	function TileRandomizer.new(...)
		local self = setmetatable({}, TileRandomizer)
		return self:constructor(...) or self
	end
	function TileRandomizer:constructor(folder)
		self.parser = tileFolderParser.new(folder)
	end
	function TileRandomizer:_getValidInstances(roomTypes)
		local instances = {}
		for _, roomType in roomTypes or self.parser:getTypes() do
			local rooms = self.parser:getRoomsOfType(roomType)
			for _1, room in rooms do
				local _object = {
					roomModel = room,
					roomType = roomType,
				}
				local _left = "chance"
				local _condition = tonumber(string.split(room.Name, "%")[2])
				if _condition == nil then
					_condition = 100
				end
				_object[_left] = _condition
				table.insert(instances, _object)
			end
		end
		return instances
	end
	function TileRandomizer:getRandomTile(recursions)
		if recursions == nil then
			recursions = 0
		end
		local validInstances = self:_getValidInstances()
		local rnd = getRandom(validInstances, function(inst)
			return randomChance(inst.chance)
		end)
		if not rnd and recursions < 10 then
			local _fn = self
			recursions += 1
			return _fn:getRandomTile(recursions)
		end
		return rnd
	end
	function TileRandomizer:getTileOfType(roomType, recursions)
		if recursions == nil then
			recursions = 0
		end
		local validInstances = self:_getValidInstances({ roomType })
		local rnd = getRandom(validInstances, function(inst)
			return randomChance(inst.chance)
		end)
		if not rnd and recursions < 10 then
			local _fn = self
			local _exp = roomType
			recursions += 1
			return _fn:getTileOfType(_exp, recursions)
		end
		return rnd
	end
	function TileRandomizer:getTileOfTypes(roomTypes, recursions)
		if recursions == nil then
			recursions = 0
		end
		local validInstances = self:_getValidInstances(roomTypes)
		local rnd = getRandom(validInstances, function(inst)
			return randomChance(inst.chance)
		end)
		if not rnd and recursions < 10 then
			return self:getTileOfTypes(roomTypes)
		end
		return rnd
	end
end
return {
	default = TileRandomizer,
}
