-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local getDistance = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils").getDistance
local RoomAttachment
do
	RoomAttachment = setmetatable({}, {
		__tostring = function()
			return "RoomAttachment"
		end,
	})
	RoomAttachment.__index = RoomAttachment
	function RoomAttachment.new(...)
		local self = setmetatable({}, RoomAttachment)
		return self:constructor(...) or self
	end
	function RoomAttachment:constructor(tile)
		self.offsets = {}
		self.attachmentOffsets = {}
		self._tile = tile
	end
	function RoomAttachment:calculateOffsets()
		local _exp = self._tile.originModel:GetDescendants()
		local _arg0 = function(v)
			return not v:IsA("Folder") and (not v:IsA("ModuleScript") and not (v.Name == "CenterPoint"))
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
		local descendants = _newValue
		local centerPoint = self._tile.centerPoint.Position
		for _, descendant in descendants do
			local _offsets = self.offsets
			local _arg0_1 = {
				part = descendant,
				offset = getDistance(centerPoint, descendant.Position),
			}
			table.insert(_offsets, _arg0_1)
		end
		for _, attachment in self._tile.attachmentPoints do
			local offset = getDistance(centerPoint, attachment.point.Position)
			local _attachmentOffsets = self.attachmentOffsets
			local _arg0_1 = {
				part = attachment.part,
				offset = offset,
			}
			table.insert(_attachmentOffsets, _arg0_1)
		end
	end
	function RoomAttachment:applyOffsets()
		for _, offset in self.offsets do
			local _position = self._tile.centerPoint.Position
			local _offset = offset.offset
			offset.part.Position = _position - _offset
		end
		for _, attachment in self.attachmentOffsets do
			local _position = self._tile.centerPoint.Position
			local _offset = attachment.offset
			attachment.part.Position = _position - _offset
		end
	end
	function RoomAttachment:attachToPart(part, attachment)
		local _attachmentPoints = self._tile.attachmentPoints
		local _arg0 = function(v)
			return v == attachment
		end
		-- ▼ ReadonlyArray.find ▼
		local _result
		for _i, _v in _attachmentPoints do
			if _arg0(_v, _i - 1, _attachmentPoints) == true then
				_result = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		local point = _result
		local _attachmentOffsets = self.attachmentOffsets
		local _arg0_1 = function(v)
			local _exp = v.part
			local _result_1 = point
			if _result_1 ~= nil then
				_result_1 = _result_1.part
			end
			return _exp == _result_1
		end
		-- ▼ ReadonlyArray.find ▼
		local _result_1
		for _i, _v in _attachmentOffsets do
			if _arg0_1(_v, _i - 1, _attachmentOffsets) == true then
				_result_1 = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		local offset = _result_1
		if offset == nil or point == nil then
			return nil
		end
		local center = self._tile.centerPoint
		local _position = part.Position
		local _offset = offset.offset
		center.Position = _position + _offset
		self:applyOffsets()
		point.part:Destroy()
	end
end
return {
	default = RoomAttachment,
}
