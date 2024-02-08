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
		local folder = self._model:WaitForChild("centerPoint"):WaitForChild("apoints")
		local children = folder:GetChildren()
		local roomInfo = require(self._model:FindFirstChild("room.info"))
		local tileData = {
			attachmentPoints = {},
			types = roomInfo.types,
			originModel = self._model,
			centerPoint = self._model:WaitForChild("centerPoint"),
		}
		for _, child in children do
			local attachment = {
				part = child,
				point = child.CFrame,
				hasAttachment = false,
			}
			table.insert(tileData.attachmentPoints, attachment)
		end
		return tileData
	end
end
return {
	default = TileParser,
}
