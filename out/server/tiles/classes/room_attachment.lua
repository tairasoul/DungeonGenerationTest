-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local getDistance = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils").getDistance
local make = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "make")
local Workspace = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
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
		self.AttachmentOffset = nil
		self._tile = tile
		self:calculateOffsets()
	end
	function RoomAttachment:calculateOffsets()
		local centerPoint = self._tile.centerPoint.Position
		local offset = getDistance(centerPoint, self._tile.attachmentPoint.Position)
		self.AttachmentOffset = {
			part = self._tile.attachmentPoint,
			offset = offset,
		}
	end
	function RoomAttachment:attachToPart(part)
		local offset = self.AttachmentOffset
		local center = self._tile.originModel
		local pos = offset.offset
		local lookVector = part.CFrame.LookVector
		local _vector3 = Vector3.new(pos.X, 0, pos.X)
		local _vector3_1 = Vector3.new(pos.Z, 0, pos.Z)
		local newPos = _vector3 + _vector3_1
		local _fn = Workspace
		local _exp = part:GetPivot()
		local _arg0 = lookVector * newPos
		local result = _fn:Raycast((_exp - _arg0).Position, Vector3.new(0, -2, 0))
		print(result)
		if result ~= nil then
			make("BoolValue", {
				Parent = part,
				Value = true,
				Name = "HasAttachment",
			})
			return false
		end
		local _fn_1 = center
		local _exp_1 = part:GetPivot()
		local _arg0_1 = lookVector * newPos
		local _vector3_2 = Vector3.new(0, 1, 0)
		_fn_1:PivotTo(_exp_1 - _arg0_1 - _vector3_2)
		make("BoolValue", {
			Parent = part,
			Value = true,
			Name = "HasAttachment",
		})
		make("BoolValue", {
			Parent = offset.part,
			Value = true,
			Name = "HasAttachment",
		})
		return true
	end
end
return {
	default = RoomAttachment,
}
