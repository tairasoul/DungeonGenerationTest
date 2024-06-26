-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _utils = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils")
local getDistance = _utils.getDistance
local logServer = _utils.logServer
local make = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "make")
local Workspace = game:GetService("Workspace")
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
		self._AttachmentOffset = nil
		self._tile = tile
		self:calculateOffsets()
	end
	function RoomAttachment:calculateOffsets()
		local centerPoint = self._tile.originModel:GetPivot()
		local ap = self._tile.attachmentPoint
		local offset = getDistance(centerPoint.Position, ap.Position)
		self._AttachmentOffset = {
			part = ap,
			offset = offset,
		}
	end
	function RoomAttachment:attachToPart(part, tileList)
		local offset = self._AttachmentOffset
		if not offset then
			return {
				result = false,
			}
		end
		local center = self._tile.originModel
		local pos = offset.offset
		local lookVector = part.CFrame.LookVector
		local _vector3 = Vector3.new(pos.X, 0, pos.X)
		local _vector3_1 = Vector3.new(pos.Z, 0, pos.Z)
		local newPos = _vector3 + _vector3_1
		local _fn = Workspace
		local _exp = part:GetPivot()
		local _arg0 = lookVector * newPos
		local _vector3_2 = Vector3.new(0, 2, 0)
		local result = _fn:Raycast((_exp - _arg0 + _vector3_2).Position, Vector3.new(0, -5, 0))
		if result ~= nil then
			logServer(`attachment for {self._tile.originModel} to {part} overlaps with a part! {result.Instance:FindFirstAncestorOfClass("Model")}'s overlapping part: {result.Instance}`, "src/server/tiles/classes/room_attachment.ts", 38, "Warning")
			make("BoolValue", {
				Parent = part,
				Value = true,
				Name = "HasAttachment",
			})
			-- ▼ ReadonlyArray.find ▼
			local _callback = function(v)
				local _exp_1 = v._model:WaitForChild("centerPoint")
				local _result = result.Instance:FindFirstAncestorOfClass("Model")
				if _result ~= nil then
					_result = _result:WaitForChild("centerPoint")
				end
				return _exp_1 == _result
			end
			local _result
			for _i, _v in tileList do
				if _callback(_v, _i - 1, tileList) == true then
					_result = _v
					break
				end
			end
			-- ▲ ReadonlyArray.find ▲
			local tile = _result
			if tile ~= nil then
				local _exp_1 = tile.attachmentPoints
				-- ▼ ReadonlyArray.filter ▼
				local _newValue = {}
				local _callback_1 = function(v)
					return not v:FindFirstChild("HasAttachment")
				end
				local _length = 0
				for _k, _v in _exp_1 do
					if _callback_1(_v, _k - 1, _exp_1) == true then
						_length += 1
						_newValue[_length] = _v
					end
				end
				-- ▲ ReadonlyArray.filter ▲
				-- ▼ ReadonlyArray.find ▼
				local _callback_2 = function(v)
					return getDistance(v.Position, part.Position).Magnitude < 2
				end
				local _result_1
				for _i, _v in _newValue do
					if _callback_2(_v, _i - 1, _newValue) == true then
						_result_1 = _v
						break
					end
				end
				-- ▲ ReadonlyArray.find ▲
				local point = _result_1
				if point ~= nil then
					make("BoolValue", {
						Parent = point,
						Value = true,
						Name = "HasAttachment",
					})
					make("ObjectValue", {
						Parent = part,
						Value = point,
						Name = "AttachmentPart",
					})
					make("ObjectValue", {
						Parent = point,
						Value = part,
						Name = "AttachmentPart",
					})
				end
				return {
					result = false,
					tile = tile,
				}
			end
		end
		local _fn_1 = center
		local _exp_1 = part:GetPivot()
		local _arg0_1 = lookVector * newPos
		local _vector3_3 = Vector3.new(0, pos.Y)
		_fn_1:PivotTo(_exp_1 - _arg0_1 + _vector3_3)
		if not part:FindFirstChild("HasAttachment") then
			make("BoolValue", {
				Parent = part,
				Value = true,
				Name = "HasAttachment",
			})
		end
		make("BoolValue", {
			Parent = offset.part,
			Value = true,
			Name = "HasAttachment",
		})
		make("ObjectValue", {
			Parent = part,
			Value = self._tile.attachmentPoint,
			Name = "AttachmentPart",
		})
		make("ObjectValue", {
			Parent = offset.part,
			Value = part,
			Name = "AttachmentPart",
		})
		return {
			result = true,
		}
	end
end
return {
	default = RoomAttachment,
}
