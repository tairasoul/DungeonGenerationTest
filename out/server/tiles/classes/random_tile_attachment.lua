-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local TileRandomizer = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "randomised.tiles").default
local TileParser = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tileParser").default
local RoomAttachment = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "room_attachment").default
local getRandom = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils").getRandom
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
		self.tileRandomiser = TileRandomizer.new(folder)
	end
	function RandomTileAttacher:attachTileToPoint(part, tileType)
		local tile = self.tileRandomiser:getTileOfType(tileType)
		if tile == nil then
			return nil
		end
		local clone = tile:Clone()
		clone.Parent = tiles
		local parser = TileParser.new(clone)
		local tileData = parser:getTileData()
		local attachment = RoomAttachment.new(tileData)
		local point = getRandom(tileData.attachmentPoints)
		if point == nil then
			return nil
		end
		attachment:attachToPart(part, point)
		return clone
	end
	function RandomTileAttacher:attachRandomTile(part)
		local tile = self.tileRandomiser:getRandomTile()
		if tile == nil then
			return nil
		end
		local clone = tile:Clone()
		clone.Parent = tiles
		local parser = TileParser.new(clone)
		local tileData = parser:getTileData()
		local attachment = RoomAttachment.new(tileData)
		local point = getRandom(tileData.attachmentPoints)
		if point == nil then
			return nil
		end
		attachment:attachToPart(part, point)
		return clone
	end
end
return {
	default = RandomTileAttacher,
}
