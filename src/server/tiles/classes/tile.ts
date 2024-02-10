import TileParser from "./tileParser";
import RoomAttachment from "./room_attachment";

export default class Tile {
    _model: Model;
    public attachmentPoints: Part[] = [];
    attach: Part;
    constructor(model: Model) {
        this._model = model;
        //const points = this._model.WaitForChild("apoints") as Folder;
        this.attach = model.WaitForChild("AttachmentPoint") as Part;
        for (const child of this._model.GetDescendants().filter((v) => v.IsA("Part") && v.Name === "Doorway") as Part[]) {
            this.attachmentPoints.push(child)
        }
    }

    attachTile(tile: Tile, point: Part) {
        const parser = new TileParser(tile._model);
        const tInfo = parser.getTileData();
        const attach = new RoomAttachment(tInfo);
        attach.attachToPart(point);
        /*const thisAttach = this.attachmentPoints.find((v) => v === info.thisTileAttachment);
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
        */

        /*const pos = tileOffset.CFrameOffset.Position;
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
        //tile.applyOffsets();*/
        /*(this.attachmentPoints.find((v) => v === thisAttach) as AttachmentPoint).hasAttachment = true;
        (tile.attachmentPoints.find((v) => v === otherTile) as AttachmentPoint).hasAttachment = true;*/
    }

    setPosition(position: Vector3, rotation: Vector3) {
        const point = this._model.WaitForChild("centerPoint") as Part;
        point.Position = position;
        if (rotation)
            point.Rotation = rotation;
        //this.applyOffsets();
    }
}