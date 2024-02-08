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
        const points = this._model.WaitForChild("apoints") as Folder;
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
        const internalParts = this._model.GetDescendants().filter((v) => !v.IsA("Folder") && !v.IsA("ModuleScript") && !(v.Name === "centerPoint") && v.Parent !== this._model.WaitForChild("apoints"));
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
    }

    applyOffsets() {
        const centerPoint = (this._model.WaitForChild("centerPoint") as Part).CFrame;
    
        // Apply position and rotation offsets for internal parts
        for (const offset of this.calculatedOffsets.internalParts) {
            const partCFrame = new CFrame(centerPoint.Position).add(offset.position);
            offset.part.CFrame = partCFrame.mul(CFrame.Angles(offset.rotation[0], offset.rotation[1], offset.rotation[2]));
        }
    
        // Apply position and rotation offsets for attachment points
        for (const offset of this.calculatedOffsets.attachments) {
            const partCFrame = new CFrame(centerPoint.Position).add(offset.position);
            offset.part.CFrame = partCFrame.mul(CFrame.Angles(offset.rotation[0], offset.rotation[1], offset.rotation[2]));
        }
    }

    attachTile(tile: Tile, info: TileAttachmentInfo) {
        const thisAttach = this.attachmentPoints.find((v) => v === info.thisTileAttachment);
        const otherTile = tile.attachmentPoints.find((v) => v === info.attachmentPoint);
        if (thisAttach === undefined) throw `Could not find attachment point ${info.thisTileAttachment} on tile ${this._model.Name}`;
        if (otherTile === undefined) throw `Could not find attachment point ${info.attachmentPoint} on tile ${tile._model.Name}`;
        if (thisAttach.hasAttachment) throw `Attachment point ${info.thisTileAttachment} already has attachment on tile ${this._model.Name}`;
        if (otherTile.hasAttachment) throw `Attachment point ${info.attachmentPoint} already has attachment on tile ${tile._model.Name}`;
        const offsets = {
            this: this.calculatedOffsets.attachments.find((v) => v.part === thisAttach.part) as OffsetInfo,
            other: tile.calculatedOffsets.attachments.find((v) => v.part === otherTile.part) as OffsetInfo
        }
        const otherCenter = tile._model.WaitForChild("centerPoint") as Part;
        otherCenter.Position = thisAttach.part.Position.sub(offsets.other.position);
        tile.applyOffsets();
        this.attachmentPoints = this.attachmentPoints.map((v) => {
            if (v.part === thisAttach.part) {
                const copy = v;
                copy.hasAttachment = true;
                return copy;
            }
            return v;
        })
        tile.attachmentPoints = tile.attachmentPoints.map((v) => {
            if (v.part === otherTile.part) {
                const copy = v;
                copy.hasAttachment = true;
                return copy;
            }
            return v;
        })
    }
}