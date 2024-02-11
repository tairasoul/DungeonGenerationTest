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
		self.model = model
	end
	function TileParser:getTileData()
		local _exp = self.model:GetDescendants()
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
		local roomInfo = self:getRoomInfo()
		local attachmentPoint = self.model:WaitForChild("AttachmentPoint")
		local centerPoint = self.model:WaitForChild("centerPoint")
		local validPoints = children
		return {
			attachmentPoint = attachmentPoint,
			types = roomInfo.types,
			originModel = self.model,
			centerPoint = centerPoint,
			validPoints = validPoints,
		}
	end
	function TileParser:getRoomInfo()
		local roomInfoModule = self.model:FindFirstChild("room.info")
		if not roomInfoModule then
			warn("Room info module not found for model " .. self.model.Name)
			return {
				types = {},
			}
		end
		local roomInfo = require(roomInfoModule)
		return roomInfo
	end
end
return {
	default = TileParser,
}
