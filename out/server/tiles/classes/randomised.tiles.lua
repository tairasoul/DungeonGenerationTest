-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local getRandom = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils").getRandom
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
		self.tileFolder = folder
	end
	function TileRandomizer:getValidInstances(roomTypes)
		local children = self.tileFolder:GetChildren()
		local validInstances = {}
		for _, child in children do
			local module = child:FindFirstChildOfClass("ModuleScript")
			if module ~= nil then
				local info = require(module)
				local roomExport = info.roomExport
				local _condition = not roomTypes
				if not _condition then
					local _roomTypes = roomTypes
					local _roomType = roomExport.roomType
					_condition = table.find(_roomTypes, _roomType) ~= nil
				end
				if _condition then
					table.insert(validInstances, roomExport)
				end
			end
		end
		return validInstances
	end
	function TileRandomizer:getRandomTile()
		local validInstances = self:getValidInstances()
		return getRandom(validInstances)
	end
	function TileRandomizer:getTileOfType(roomType)
		local validInstances = self:getValidInstances({ roomType })
		return getRandom(validInstances)
	end
	function TileRandomizer:getTileOfTypes(roomTypes)
		local validInstances = self:getValidInstances(roomTypes)
		return getRandom(validInstances)
	end
end
return {
	default = TileRandomizer,
}
