-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local TileParser = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tileParser").default
local RoomAttachment = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "room_attachment").default
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
	end
	function Tile:attachTile(tile, info)
		local parser = TileParser.new(tile._model)
		local tInfo = parser:getTileData()
		local attach = RoomAttachment.new(tInfo)
		attach:attachToPart(info.thisTileAttachment.part, info.attachmentPoint)
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
		_result.hasAttachment = true
		--[[
			const thisAttach = this.attachmentPoints.find((v) => v === info.thisTileAttachment);
			const otherTile = tile.attachmentPoints.find((v) => v === info.attachmentPoint);
			if (thisAttach === undefined) throw `Could not find attachment point ${info.thisTileAttachment} on tile ${this._model.Name}`;
			if (otherTile === undefined) throw `Could not find attachment point ${info.attachmentPoint} on tile ${tile._model.Name}`;
			if (thisAttach.hasAttachment) throw `Attachment point ${info.thisTileAttachment} already has attachment on tile ${this._model.Name}`;
			if (otherTile.hasAttachment) throw `Attachment point ${info.attachmentPoint} already has attachment on tile ${tile._model.Name}`;
			const tileOffset = tile.calculatedOffsets.find((v) => v.part === otherTile.part) as OffsetInfo;
			//tileOffset.part.CFrame = thisAttach.part.CFrame;
			/*
			const pos = offset.offset;
			const lookVector = part.CFrame.LookVector;
			const newPos = new Vector3(pos.X, 0, pos.X).add(new Vector3(pos.Z, 0, pos.Z));
			print(lookVector.mul(newPos));
			print(part.GetPivot());
			print(part.GetPivot().sub(lookVector.mul(newPos)).sub(new Vector3(0, 3, 0)))
			center.PivotTo(part.GetPivot().sub(lookVector.mul(newPos)).sub(new Vector3(0, 3, 0)));
		]]
		--[[
			const pos = tileOffset.CFrameOffset.Position;
			const lookVector = thisAttach.part.CFrame.LookVector;
			const newPos = new Vector3(pos.X > pos.Z ? pos.X : pos.Z, 0, pos.X > pos.Z ? pos.X : pos.Z)//.add(new Vector3(pos.Z, 0, pos.Z));
			tile._model.PivotTo(info.thisTileAttachment.part.GetPivot().sub(lookVector.mul(newPos)).sub(new Vector3(0, 1, 0)));
			//tile.applyOffsets(otherTile);
			/*const thisOffset = this.calculatedOffsets.attachments.find((v) => v.part === thisAttach.part);
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
		--[[
			(this.attachmentPoints.find((v) => v === thisAttach) as AttachmentPoint).hasAttachment = true;
			(tile.attachmentPoints.find((v) => v === otherTile) as AttachmentPoint).hasAttachment = true;
		]]
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
