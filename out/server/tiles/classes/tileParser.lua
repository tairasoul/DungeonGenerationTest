-- Compiled with roblox-ts v2.1.0
local TileParser
do
	TileParser = setmetatable({}, {
		__tostring = function()
			return "TileParser"
		end,
	})
	TileParser.__index = TileParser
	function TileParser.new(...)
		local self = setmetatable({}, TileParser)
		return self:constructor(...) or self
	end
	function TileParser:constructor(model)
		self._model = model
	end
	function TileParser:getTileData()
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
		local children = _newValue
		local roomInfo = require(self._model:FindFirstChild("room.info"))
		local tileData = {
			attachmentPoint = self._model:WaitForChild("AttachmentPoint"),
			types = roomInfo.types,
			originModel = self._model,
			centerPoint = self._model:WaitForChild("centerPoint"),
			validPoints = {},
		}
		for _, child in children do
			table.insert(tileData.validPoints, child)
		end
		return tileData
	end
end
return {
	default = TileParser,
}
