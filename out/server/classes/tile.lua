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
		self.attachmentData = {}
		self._model = model
		self:calculateAttachmentOffsets()
	end
	function Tile:calculateAttachmentOffsets()
		local attachmentPoints = self._model:WaitForChild("apoints"):GetChildren()
		for _, attachment in attachmentPoints do
			local attachmentInfo = {
				part = attachment,
				point = attachment.CFrame,
				hasAttachment = false,
			}
			local offsets = {}
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
			local descendants = _newValue
			for _1, part in descendants do
				local _exp_1 = attachment.CFrame:Inverse()
				local _cFrame = part.CFrame
				local relativeCFrame = _exp_1 * _cFrame
				local _arg0_1 = {
					part = part,
					position = relativeCFrame.Position,
					rotation = { relativeCFrame:ToEulerAnglesXYZ() },
				}
				table.insert(offsets, _arg0_1)
			end
			local _attachmentData = self.attachmentData
			local _arg0_1 = {
				attachment = attachmentInfo,
				offsets = offsets,
			}
			table.insert(_attachmentData, _arg0_1)
		end
	end
	function Tile:applyOffsets()
		for _, attachment in self.attachmentData do
			local attachmentCFrame = attachment.attachment.point
			for _1, offset in attachment.offsets do
				local _position = offset.position
				local _exp = attachmentCFrame + _position
				local _arg0 = CFrame.Angles(offset.rotation[1], offset.rotation[2], offset.rotation[3])
				local partCFrame = _exp * _arg0
				offset.part.CFrame = partCFrame
			end
		end
	end
	function Tile:attachTile(tile, info)
		local _attachmentData = self.attachmentData
		local _arg0 = function(data)
			return data.attachment == info.thisTileAttachment
		end
		-- ▼ ReadonlyArray.find ▼
		local _result
		for _i, _v in _attachmentData do
			if _arg0(_v, _i - 1, _attachmentData) == true then
				_result = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		local thisAttachment = _result
		local _attachmentData_1 = tile.attachmentData
		local _arg0_1 = function(data)
			return data.attachment == info.attachmentPoint
		end
		-- ▼ ReadonlyArray.find ▼
		local _result_1
		for _i, _v in _attachmentData_1 do
			if _arg0_1(_v, _i - 1, _attachmentData_1) == true then
				_result_1 = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		local otherAttachment = _result_1
		if not thisAttachment or not otherAttachment then
			error("Attachment points not found.")
		end
		-- Apply the position and rotation offsets from otherAttachment to thisAttachment
		local thisCenter = thisAttachment.attachment.point.Position
		local otherCenter = otherAttachment.attachment.point.Position
		local offsetVector = otherCenter - thisCenter
		for _, offsetInfo in thisAttachment.offsets do
			local _position = offsetInfo.position
			local newPosition = offsetVector + _position
			local newRotation = offsetInfo.rotation
			local _cFrame = CFrame.new(newPosition)
			local _arg0_2 = CFrame.Angles(newRotation[1], newRotation[2], newRotation[3])
			offsetInfo.part.CFrame = _cFrame * _arg0_2
		end
		-- Update attachment status
		thisAttachment.attachment.hasAttachment = true
		otherAttachment.attachment.hasAttachment = true
		tile:applyOffsets()
	end
end
return {
	default = Tile,
}
