-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local TileParser = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tileParser").default
local RoomAttachment = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "room_attachment").default
local getDistance = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils").getDistance
local Tile
do
	Tile = setmetatable({}, {
		__tostring = function()
			return "Tile"
		end,
	})
	Tile.__index = Tile
	function Tile.new(...)
		local self = setmetatable({}, Tile)
		return self:constructor(...) or self
	end
	function Tile:constructor(info)
		self._model = info.roomModel
		self.info = info
		local parser = TileParser.new(self._model)
		self.TileData = parser:getTileData()
		self.attachmentPoints = self:_findAttachmentPoints()
		self.connections = {}
	end
	function Tile:_findAttachmentPoints()
		local _exp = self._model:GetDescendants()
		local _arg0 = function(v)
			return v:IsA("Part") and v.Name == "Doorway"
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
		return _newValue
	end
	function Tile:attachTile(tile, point, tileList)
		local attach = RoomAttachment.new(tile.TileData)
		local couldAttach = attach:attachToPart(point, tileList)
		if couldAttach.result then
			self:addConnection(tile)
		elseif couldAttach.tile then
			self:addConnection(couldAttach.tile)
		end
		return couldAttach.result
	end
	function Tile:addConnection(tile)
		local distance = getDistance(self.TileData.centerPoint.Position, tile.TileData.centerPoint.Position).Magnitude
		local _connections = self.connections
		local _tile = tile
		_connections[_tile] = distance
	end
end
return {
	default = Tile,
}
