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
		self.attachmentOffsets = {}
		self._tile = tile
		self:calculateOffsets()
	end
	function RoomAttachment:calculateOffsets()
		local centerPoint = self._tile.centerPoint.Position
		for _, attachment in self._tile.attachmentPoints do
			local offset = getDistance(centerPoint, attachment.point.Position)
			local _attachmentOffsets = self.attachmentOffsets
			local _arg0 = {
				part = attachment.part,
				offset = offset,
			}
			table.insert(_attachmentOffsets, _arg0)
		end
	end
	function RoomAttachment:attachToPart(part, attachment)
		local _attachmentPoints = self._tile.attachmentPoints
		local _arg0 = function(v)
			return v.part == attachment.part
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
		local center = self._tile.originModel
		local pos = offset.offset
		local lookVector = part.CFrame.LookVector
		local _vector3 = Vector3.new(pos.X, 0, pos.X)
		local _vector3_1 = Vector3.new(pos.Z, 0, pos.Z)
		local newPos = _vector3 + _vector3_1
		print(lookVector)
		local _fn = center
		local _exp = part:GetPivot()
		local _arg0_2 = lookVector * newPos
		local _vector3_2 = Vector3.new(0, 1, 0)
		_fn:PivotTo(_exp - _arg0_2 - _vector3_2)
		-- this.applyOffsets();
		point.part:Destroy()
	end
end
return {
	default = RoomAttachment,
}
