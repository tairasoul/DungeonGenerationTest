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
		self.TileFolder = folder
	end
	function TileRandomizer:getRandomTile()
		local children = self.TileFolder:GetChildren()
		local instances = {}
		for _, child in children do
			local module = child:FindFirstChildOfClass("ModuleScript")
			if module ~= nil then
				local info = require(module)
				local _roomModel = info.roomExport.roomModel
				table.insert(instances, _roomModel)
			end
		end
		return getRandom(instances)
	end
	function TileRandomizer:getTileOfType(roomType)
		local children = self.TileFolder:GetChildren()
		local validInstances = {}
		for _, child in children do
			local module = child:FindFirstChildOfClass("ModuleScript")
			if module ~= nil then
				local info = require(module)
				if info.roomExport.roomType == roomType then
					local _roomModel = info.roomExport.roomModel
					table.insert(validInstances, _roomModel)
				end
			end
		end
		return getRandom(validInstances)
	end
	function TileRandomizer:getTileOfTypes(roomTypes)
		local children = self.TileFolder:GetChildren()
		local validInstances = {}
		for _, child in children do
			local module = child:FindFirstChildOfClass("ModuleScript")
			if module ~= nil then
				local info = require(module)
				local _roomTypes = roomTypes
				local _roomType = info.roomExport.roomType
				if table.find(_roomTypes, _roomType) ~= nil then
					local _roomModel = info.roomExport.roomModel
					table.insert(validInstances, _roomModel)
				end
			end
		end
		return getRandom(validInstances)
	end
end
return {
	default = TileRandomizer,
}
