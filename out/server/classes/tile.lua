-- Compiled with roblox-ts v2.1.0
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
	function Tile:constructor(model)
		self.calculatedOffsets = {
			internalParts = {},
			attachments = {},
		}
		self.attachmentPoints = {}
		self._model = model
		local points = self._model:WaitForChild("apoints")
		for _, child in points:GetChildren() do
			local _attachmentPoints = self.attachmentPoints
			local _arg0 = {
				part = child,
				point = child.CFrame,
				hasAttachment = false,
			}
			table.insert(_attachmentPoints, _arg0)
		end
		self:calculatePartOffsets()
	end
	function Tile:calculatePartOffsets()
		local centerPoint = (self._model:WaitForChild("centerPoint")).CFrame
		-- Calculate position and rotation offsets for internal parts
		local _exp = self._model:GetDescendants()
		local _arg0 = function(v)
			return not v:IsA("Folder") and (not v:IsA("ModuleScript") and (not (v.Name == "centerPoint") and v.Parent ~= self._model:WaitForChild("apoints")))
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
		local internalParts = _newValue
		for _, part in internalParts do
			local offset = centerPoint:ToObjectSpace(part.CFrame)
			local _internalParts = self.calculatedOffsets.internalParts
			local _arg0_1 = {
				part = part,
				position = offset.Position,
				rotation = { offset.Rotation:ToEulerAnglesXYZ() },
			}
			table.insert(_internalParts, _arg0_1)
		end
		-- Calculate position and rotation offsets for attachment points
		local attachmentPoints = self._model:WaitForChild("apoints"):GetChildren()
		for _, attachment in attachmentPoints do
			local offset = centerPoint:ToObjectSpace(attachment.CFrame)
			local _attachments = self.calculatedOffsets.attachments
			local _arg0_1 = {
				part = attachment,
				position = offset.Position,
				rotation = { offset.Rotation:ToEulerAnglesXYZ() },
			}
			table.insert(_attachments, _arg0_1)
		end
	end
	function Tile:applyOffsets()
		local centerPoint = (self._model:WaitForChild("centerPoint")).CFrame
		-- Apply position and rotation offsets for internal parts
		for _, offset in self.calculatedOffsets.internalParts do
			local _cFrame = CFrame.new(centerPoint.Position)
			local _position = offset.position
			local partCFrame = _cFrame + _position
			local _arg0 = CFrame.Angles(offset.rotation[1], offset.rotation[2], offset.rotation[3])
			offset.part.CFrame = partCFrame * _arg0
		end
		-- Apply position and rotation offsets for attachment points
		for _, offset in self.calculatedOffsets.attachments do
			local _cFrame = CFrame.new(centerPoint.Position)
			local _position = offset.position
			local partCFrame = _cFrame + _position
			local _arg0 = CFrame.Angles(offset.rotation[1], offset.rotation[2], offset.rotation[3])
			offset.part.CFrame = partCFrame * _arg0
		end
	end
	function Tile:attachTile(tile, info)
		local _attachmentPoints = self.attachmentPoints
		local _arg0 = function(v)
			return v == info.thisTileAttachment
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
		local thisAttach = _result
		local _attachmentPoints_1 = tile.attachmentPoints
		local _arg0_1 = function(v)
			return v == info.attachmentPoint
		end
		-- ▼ ReadonlyArray.find ▼
		local _result_1
		for _i, _v in _attachmentPoints_1 do
			if _arg0_1(_v, _i - 1, _attachmentPoints_1) == true then
				_result_1 = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		local otherTile = _result_1
		if thisAttach == nil then
			error("Could not find attachment point " .. (tostring(info.thisTileAttachment) .. (" on tile " .. self._model.Name)))
		end
		if otherTile == nil then
			error("Could not find attachment point " .. (tostring(info.attachmentPoint) .. (" on tile " .. tile._model.Name)))
		end
		if thisAttach.hasAttachment then
			error("Attachment point " .. (tostring(info.thisTileAttachment) .. (" already has attachment on tile " .. self._model.Name)))
		end
		if otherTile.hasAttachment then
			error("Attachment point " .. (tostring(info.attachmentPoint) .. (" already has attachment on tile " .. tile._model.Name)))
		end
		local _object = {}
		local _left = "this"
		local _attachments = self.calculatedOffsets.attachments
		local _arg0_2 = function(v)
			return v.part == thisAttach.part
		end
		-- ▼ ReadonlyArray.find ▼
		local _result_2
		for _i, _v in _attachments do
			if _arg0_2(_v, _i - 1, _attachments) == true then
				_result_2 = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		_object[_left] = _result_2
		local _left_1 = "other"
		local _attachments_1 = tile.calculatedOffsets.attachments
		local _arg0_3 = function(v)
			return v.part == otherTile.part
		end
		-- ▼ ReadonlyArray.find ▼
		local _result_3
		for _i, _v in _attachments_1 do
			if _arg0_3(_v, _i - 1, _attachments_1) == true then
				_result_3 = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		_object[_left_1] = _result_3
		local offsets = _object
		local otherCenter = tile._model:WaitForChild("centerPoint")
		local _position = thisAttach.part.Position
		local _position_1 = offsets.other.position
		otherCenter.Position = _position - _position_1
		tile:applyOffsets()
		local _attachmentPoints_2 = self.attachmentPoints
		local _arg0_4 = function(v)
			if v.part == thisAttach.part then
				local copy = v
				copy.hasAttachment = true
				return copy
			end
			return v
		end
		-- ▼ ReadonlyArray.map ▼
		local _newValue = table.create(#_attachmentPoints_2)
		for _k, _v in _attachmentPoints_2 do
			_newValue[_k] = _arg0_4(_v, _k - 1, _attachmentPoints_2)
		end
		-- ▲ ReadonlyArray.map ▲
		self.attachmentPoints = _newValue
		local _attachmentPoints_3 = tile.attachmentPoints
		local _arg0_5 = function(v)
			if v.part == otherTile.part then
				local copy = v
				copy.hasAttachment = true
				return copy
			end
			return v
		end
		-- ▼ ReadonlyArray.map ▼
		local _newValue_1 = table.create(#_attachmentPoints_3)
		for _k, _v in _attachmentPoints_3 do
			_newValue_1[_k] = _arg0_5(_v, _k - 1, _attachmentPoints_3)
		end
		-- ▲ ReadonlyArray.map ▲
		tile.attachmentPoints = _newValue_1
	end
end
return {
	default = Tile,
}
