-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local CFrameComponentsSub = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils").CFrameComponentsSub
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
		self.calculatedOffsets = {}
		self.attachmentPoints = {}
		self._model = model
		-- const points = this._model.WaitForChild("apoints") as Folder;
		local _exp = self._model:GetDescendants()
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
		for _, child in _newValue do
			local _attachmentPoints = self.attachmentPoints
			local _arg0_1 = {
				part = child,
				point = child.CFrame,
				hasAttachment = false,
			}
			table.insert(_attachmentPoints, _arg0_1)
		end
		self:calculatePartOffsets()
	end
	function Tile:calculatePartOffsets()
		local _exp = self._model:GetDescendants()
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
		local attachments = _newValue
		local _exp_1 = self._model:GetDescendants()
		local _arg0_1 = function(v)
			return v:IsA("Part")
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue_1 = {}
		local _length_1 = 0
		for _k, _v in _exp_1 do
			if _arg0_1(_v, _k - 1, _exp_1) == true then
				_length_1 += 1
				_newValue_1[_length_1] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		local parts = _newValue_1
		for _, attachment in attachments do
			for _1, part in parts do
				-- Get the difference in CFrames between attachment and part
				local offset = CFrameComponentsSub({ attachment.CFrame:GetComponents() }, { part.CFrame:GetComponents() })
				local _calculatedOffsets = self.calculatedOffsets
				local _object = {
					part = part,
					CFrameOffset = offset,
				}
				local _left = "from"
				local _attachmentPoints = self.attachmentPoints
				local _arg0_2 = function(v)
					return v.part == attachment
				end
				-- ▼ ReadonlyArray.find ▼
				local _result
				for _i, _v in _attachmentPoints do
					if _arg0_2(_v, _i - 1, _attachmentPoints) == true then
						_result = _v
						break
					end
				end
				-- ▲ ReadonlyArray.find ▲
				_object[_left] = _result
				table.insert(_calculatedOffsets, _object)
			end
		end
		--[[
			const centerPoint = (this._model.WaitForChild("centerPoint") as Part).CFrame;
			// Calculate position and rotation offsets for internal parts
			const internalParts = this._model.GetDescendants().filter((v) => !(v.Name === "centerPoint") && v.Parent !== this._model.WaitForChild("apoints") && v.IsA("Part"));
			for (const part of internalParts as Part[]) {
			const offset = centerPoint.ToObjectSpace(part.CFrame);
			this.calculatedOffsets.internalParts.push({
			part,
			position: offset.Position,
			rotation: offset.Rotation.ToEulerAnglesXYZ()
			});
			}
			// Calculate position and rotation offsets for attachment points
			const attachmentPoints = this._model.WaitForChild("apoints").GetChildren() as Part[];
			for (const attachment of attachmentPoints) {
			const offset = centerPoint.ToObjectSpace(attachment.CFrame);
			this.calculatedOffsets.attachments.push({
			part: attachment,
			position: offset.Position,
			rotation: offset.Rotation.ToEulerAnglesXYZ()
			});
			}
		]]
	end
	function Tile:applyOffsets(attachment)
		local _calculatedOffsets = self.calculatedOffsets
		local _arg0 = function(v)
			return v.from == attachment
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in _calculatedOffsets do
			if _arg0(_v, _k - 1, _calculatedOffsets) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		local offsetsForAttachment = _newValue
		for _, offset in offsetsForAttachment do
			if offset.part == attachment.part then
				continue
			end
			-- Add offset onto attachment cframe
			local newPos = offset.CFrameOffset
			offset.part.CFrame = newPos
		end
		--[[
			const centerPoint = (this._model.WaitForChild("centerPoint") as Part).Position;
			// Apply position and rotation offsets for internal parts
			for (const offset of this.calculatedOffsets.internalParts) {
			offset.part.Position = centerPoint.add(offset.position);
			}
			// Apply position and rotation offsets for attachment points
			for (const offset of this.calculatedOffsets.attachments) {
			offset.part.Position = centerPoint.add(offset.position);
			}
		]]
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
		local _calculatedOffsets = tile.calculatedOffsets
		local _arg0_2 = function(v)
			return v.part == otherTile.part
		end
		-- ▼ ReadonlyArray.find ▼
		local _result_2
		for _i, _v in _calculatedOffsets do
			if _arg0_2(_v, _i - 1, _calculatedOffsets) == true then
				_result_2 = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		local tileOffset = _result_2
		-- tileOffset.part.CFrame = thisAttach.part.CFrame;
		--[[
			const pos = offset.offset;
			const lookVector = part.CFrame.LookVector;
			const newPos = new Vector3(pos.X, 0, pos.X).add(new Vector3(pos.Z, 0, pos.Z));
			print(lookVector.mul(newPos));
			print(part.GetPivot());
			print(part.GetPivot().sub(lookVector.mul(newPos)).sub(new Vector3(0, 3, 0)))
			center.PivotTo(part.GetPivot().sub(lookVector.mul(newPos)).sub(new Vector3(0, 3, 0)));
		]]
		local pos = tileOffset.CFrameOffset.Position
		local lookVector = thisAttach.part.CFrame.LookVector
		local newPos = Vector3.new(if pos.X > pos.Z then pos.X else pos.Z, 0, if pos.X > pos.Z then pos.X else pos.Z)
		local _fn = tile._model
		local _exp = info.thisTileAttachment.part:GetPivot()
		local _arg0_3 = lookVector * newPos
		local _vector3 = Vector3.new(0, 1, 0)
		_fn:PivotTo(_exp - _arg0_3 - _vector3)
		-- tile.applyOffsets(otherTile);
		--[[
			const thisOffset = this.calculatedOffsets.attachments.find((v) => v.part === thisAttach.part);
			const otherOffset = tile.calculatedOffsets.attachments.find((v) => v.part === otherTile.part);
			if (!thisOffset || !otherOffset) {
			throw "Offsets not found for attachment points";
			}
			const otherCenter = tile._model;
			const newPosition = thisOffset.part.CFrame.add(otherOffset.position).sub(new Vector3(0, 2, 0));
			const pos = newPosition.Position;
			const centerPos = (this._model.WaitForChild("centerPoint") as Part).Position;
			otherCenter.PivotTo(new CFrame(pos, new Vector3(centerPos.X, pos.Y, centerPos.Z)));
			//otherCenter.PivotTo();
			// Apply offsets and update attachment points
			//tile.applyOffsets();
		]]
		local _attachmentPoints_2 = self.attachmentPoints
		local _arg0_4 = function(v)
			return v == thisAttach
		end
		-- ▼ ReadonlyArray.find ▼
		local _result_3
		for _i, _v in _attachmentPoints_2 do
			if _arg0_4(_v, _i - 1, _attachmentPoints_2) == true then
				_result_3 = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		_result_3.hasAttachment = true
		local _attachmentPoints_3 = tile.attachmentPoints
		local _arg0_5 = function(v)
			return v == otherTile
		end
		-- ▼ ReadonlyArray.find ▼
		local _result_4
		for _i, _v in _attachmentPoints_3 do
			if _arg0_5(_v, _i - 1, _attachmentPoints_3) == true then
				_result_4 = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		_result_4.hasAttachment = true
	end
	function Tile:setPosition(position, rotation)
		local point = self._model:WaitForChild("centerPoint")
		point.Position = position
		if rotation then
			point.Rotation = rotation
		end
		-- this.applyOffsets();
	end
end
return {
	default = Tile,
}
