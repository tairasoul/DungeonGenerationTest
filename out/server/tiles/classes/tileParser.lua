-- Compiled with roblox-ts v2.3.0
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
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _callback = function(v)
			return v:IsA("Part") and v.Name == "Doorway"
		end
		local _length = 0
		for _k, _v in _exp do
			if _callback(_v, _k - 1, _exp) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		local children = _newValue
		local roomInfo = self:_getRoomInfo()
		local attachmentPoint = self._model:WaitForChild("AttachmentPoint")
		local centerPoint = self._model:WaitForChild("centerPoint")
		local validPoints = children
		return {
			attachmentPoint = attachmentPoint,
			types = roomInfo,
			originModel = self._model,
			centerPoint = centerPoint,
			validPoints = validPoints,
		}
	end
	function TileParser:_getRoomInfo()
		local module = require(self._model:FindFirstChild("validTypes"))
		return module
	end
end
return {
	default = TileParser,
}
