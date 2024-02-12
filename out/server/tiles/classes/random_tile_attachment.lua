-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local TileRandomizer = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "randomised.tiles").default
local TileParser = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tileParser").default
local RoomAttachment = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "room_attachment").default
local tiles = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "vars", "folders").tiles
local RandomTileAttacher
do
	RandomTileAttacher = setmetatable({}, {
		__tostring = function()
			return "RandomTileAttacher"
		end,
	})
	RandomTileAttacher.__index = RandomTileAttacher
	function RandomTileAttacher.new(...)
		local self = setmetatable({}, RandomTileAttacher)
		return self:constructor(...) or self
	end
	function RandomTileAttacher:constructor(folder)
		self._tileRandomizer = TileRandomizer.new(folder)
	end
	function RandomTileAttacher:attachTileToPoint(part, tileType)
		local tile = self._tileRandomizer:getTileOfType(tileType)
		return self:_attachTile(part, tile)
	end
	function RandomTileAttacher:attachRandomTile(part)
		local tile = self._tileRandomizer:getRandomTile()
		return self:_attachTile(part, tile)
	end
	function RandomTileAttacher:_attachTile(part, tile)
		if not tile then
			return nil
		end
		local clone = tile.roomModel:Clone()
		clone.Parent = tiles
		local parser = TileParser.new(clone)
		local tileData = parser:getTileData()
		local attachment = RoomAttachment.new(tileData)
		attachment:attachToPart(part)
		return {
			roomType = tile.roomType,
			roomModel = clone,
		}
	end
end
return {
	default = RandomTileAttacher,
}
