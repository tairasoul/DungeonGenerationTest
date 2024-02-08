import { AttachmentPoint } from "server/interfaces/room";
import { OffsetInfo, TileAttachmentInfo } from "server/interfaces/tile";

export default class Tile {
    private _model: Model;
    private calculatedOffsets: {
        internalParts: OffsetInfo[],
        attachments: OffsetInfo[]
    } = {
        internalParts: [],
        attachments: []
    };
    public attachmentPoints: AttachmentPoint[] = [];
    constructor(model: Model) {
        this._model = model;
        const points = this._model.WaitForChild("centerPoint").WaitForChild("apoints") as Folder;
        for (const child of points.GetChildren() as Part[]) {
            this.attachmentPoints.push(
                {
                    part: child,
                    point: child.CFrame,
                    hasAttachment: false
                }
            )
        }
        this.calculatePartOffsets();
    }

    calculatePartOffsets() {
        const centerPoint = (this._model.WaitForChild("centerPoint") as Part).CFrame;
    
        // Calculate position and rotation offsets for internal parts
        const internalParts = this._model.GetDescendants().filter((v) => !v.IsA("Folder") && !v.IsA("ModuleScript") && !(v.Name === "centerPoint") && v.Parent !== this._model.WaitForChild("centerPoint").WaitForChild("apoints"));
        for (const part of internalParts as Part[]) {
            const offset = centerPoint.ToObjectSpace(part.CFrame);
            this.calculatedOffsets.internalParts.push({
                part,
                position: offset.Position,
                rotation: offset.Rotation.ToEulerAnglesXYZ()
            });
        }
    
        // Calculate position and rotation offsets for attachment points
        const attachmentPoints = this._model.WaitForChild("centerPoint").WaitForChild("apoints").GetChildren() as Part[];
        for (const attachment of attachmentPoints) {
            const offset = centerPoint.ToObjectSpace(attachment.CFrame);
            this.calculatedOffsets.attachments.push({
                part: attachment,
                position: offset.Position,
                rotation: offset.Rotation.ToEulerAnglesXYZ()
            });
        }
    }

    applyOffsets() {
        const centerPoint = (this._model.WaitForChild("centerPoint") as Part).Position;
    
        // Apply position and rotation offsets for internal parts
        for (const offset of this.calculatedOffsets.internalParts) {
            offset.part.Position = centerPoint.add(offset.position);
        }
    
        // Apply position and rotation offsets for attachment points
        for (const offset of this.calculatedOffsets.attachments) {
            offset.part.Position = centerPoint.add(offset.position);
        }
    }

    attachTile(tile: Tile, info: TileAttachmentInfo) {
        const thisAttach = this.attachmentPoints.find((v) => v === info.thisTileAttachment);
        const otherTile = tile.attachmentPoints.find((v) => v === info.attachmentPoint);
        if (thisAttach === undefined) throw `Could not find attachment point ${info.thisTileAttachment} on tile ${this._model.Name}`;
        if (otherTile === undefined) throw `Could not find attachment point ${info.attachmentPoint} on tile ${tile._model.Name}`;
        if (thisAttach.hasAttachment) throw `Attachment point ${info.thisTileAttachment} already has attachment on tile ${this._model.Name}`;
        if (otherTile.hasAttachment) throw `Attachment point ${info.attachmentPoint} already has attachment on tile ${tile._model.Name}`;
        
        const thisOffset = this.calculatedOffsets.attachments.find((v) => v.part === thisAttach.part);
        const otherOffset = tile.calculatedOffsets.attachments.find((v) => v.part === otherTile.part);
        if (!thisOffset || !otherOffset) {
            throw "Offsets not found for attachment points";
        }
        const otherCenter = tile._model.WaitForChild("centerPoint") as Part;
        otherCenter.Position = thisAttach.part.Position.sub(otherOffset.position);
        
        // Apply offsets and update attachment points
        tile.applyOffsets();
        (this.attachmentPoints.find((v) => v === thisAttach) as AttachmentPoint).hasAttachment = true;
        (tile.attachmentPoints.find((v) => v === otherTile) as AttachmentPoint).hasAttachment = true;
    }

    setPosition(position: Vector3, rotation: Vector3) {
        const point = this._model.WaitForChild("centerPoint") as Part;
        point.Position = position;
        if (rotation)
            point.Rotation = rotation;
        this.applyOffsets();
    }
}