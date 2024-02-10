-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local TileParser = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tileParser").default
local RoomAttachment = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "room_attachment").default
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
	function Tile:constructor(model, info)
		self.attachmentPoints = {}
		self._model = model
		self.info = info
		local parser = TileParser.new(self._model)
		self.TileData = parser:getTileData()
		self.attach = model:WaitForChild("AttachmentPoint")
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
		for _, child in _newValue do
			table.insert(self.attachmentPoints, child)
		end
	end
	function Tile:attachTile(tile, point)
		local attach = RoomAttachment.new(tile.TileData)
		if not attach:attachToPart(point) then
			return false
		end
		return true
	end
end
return {
	default = Tile,
}
