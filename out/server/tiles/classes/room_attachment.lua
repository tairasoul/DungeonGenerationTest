-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local getDistance = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils").getDistance
local make = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "make")
local Workspace = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local tileRegistry = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tileRegistry").default
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
		if result ~= nil then
			make("BoolValue", {
				Parent = part,
				Value = true,
				Name = "HasAttachment",
			})
			local _tiles = tileRegistry.tiles
			local _arg0_1 = function(v)
				local _exp_1 = v._model:WaitForChild("centerPoint")
				local _result = result.Instance:FindFirstAncestorOfClass("Model")
				if _result ~= nil then
					_result = _result:WaitForChild("centerPoint")
				end
				return _exp_1 == _result
			end
			-- ▼ ReadonlyArray.find ▼
			local _result
			for _i, _v in _tiles do
				if _arg0_1(_v, _i - 1, _tiles) == true then
					_result = _v
					break
				end
			end
			-- ▲ ReadonlyArray.find ▲
			local tile = _result
			local _attachmentPoints = tile.attachmentPoints
			local _arg0_2 = function(v)
				return not v:FindFirstChild("HasAttachment")
			end
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _length = 0
			for _k, _v in _attachmentPoints do
				if _arg0_2(_v, _k - 1, _attachmentPoints) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			local _arg0_3 = function(v)
				return getDistance(v.Position, part.Position).Magnitude < 2
			end
			-- ▼ ReadonlyArray.find ▼
			local _result_1
			for _i, _v in _newValue do
				if _arg0_3(_v, _i - 1, _newValue) == true then
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
			end
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
