-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local getRandom = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils").getRandom
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
				local _arg0 = {
					roomModel = room,
					roomType = roomType,
				}
				table.insert(instances, _arg0)
			end
		end
		return instances
	end
	function TileRandomizer:getRandomTile()
		local validInstances = self:_getValidInstances()
		return getRandom(validInstances)
	end
	function TileRandomizer:getTileOfType(roomType)
		local validInstances = self:_getValidInstances({ roomType })
		return getRandom(validInstances)
	end
	function TileRandomizer:getTileOfTypes(roomTypes)
		local validInstances = self:_getValidInstances(roomTypes)
		return getRandom(validInstances)
	end
end
return {
	default = TileRandomizer,
}
