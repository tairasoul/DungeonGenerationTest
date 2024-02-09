import { Tile } from "server/interfaces/parser";
import { PartOffset } from "server/interfaces/attachment";
import { getDistance } from "shared/utils";
import { AttachmentPoint } from "server/interfaces/room";

export default class RoomAttachment {
    _tile: Tile;
    private offsets: PartOffset[] = [];
    private attachmentOffsets: PartOffset[] = [];
    constructor(tile: Tile) {
        this._tile = tile;
    }

    calculateOffsets() {
        const descendants = this._tile.originModel.GetDescendants().filter((v) => !v.IsA("Folder") && !v.IsA("ModuleScript") && !(v.Name === "CenterPoint"))
        const centerPoint = this._tile.centerPoint.Position;
        for (const descendant of descendants) {
            this.offsets.push({
                part: descendant as Part,
                offset: getDistance(centerPoint, (descendant as Part).Position)
            })
        }

        for (const attachment of this._tile.attachmentPoints) {
            const offset = getDistance(centerPoint, attachment.point.Position);
            this.attachmentOffsets.push(
                {
                    part: attachment.part,
                    offset
                }
            )
        }
    }

    applyOffsets() {
        for (const offset of this.offsets) {
            offset.part.Position = this._tile.centerPoint.Position.sub(offset.offset);
        }

        for (const attachment of this.attachmentOffsets) {
            attachment.part.Position = this._tile.centerPoint.Position.sub(attachment.offset);
        }
    }

    attachToPart(part: Part, attachment: AttachmentPoint) {
        const point = this._tile.attachmentPoints.find((v) => v === attachment);
        const offset = this.attachmentOffsets.find((v) => v.part === point?.part);
        if (offset === undefined || point === undefined) return;
        const center = this._tile.originModel;
        const pos = offset.offset;
        const lookVector = part.CFrame.LookVector;
        const newPos = new Vector3(pos.X, 0, pos.X).add(new Vector3(pos.Z, 0, pos.Z));
        print(lookVector.mul(newPos));
        print(part.GetPivot());
        print(part.GetPivot().sub(lookVector.mul(newPos)).sub(new Vector3(0, 3, 0)))
        center.PivotTo(part.GetPivot().sub(lookVector.mul(newPos)).sub(new Vector3(0, 3, 0)));
        //this.applyOffsets();
        point.part.Destroy();
    }
}