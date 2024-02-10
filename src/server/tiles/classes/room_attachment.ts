import { Tile } from "server/tiles/interfaces/parser";
import { PartOffset } from "server/tiles/interfaces/attachment";
import { getDistance } from "shared/utils";
import { AttachmentPoint } from "server/tiles/interfaces/room";

export default class RoomAttachment {
    _tile: Tile;
    private attachmentOffsets: PartOffset[] = [];
    constructor(tile: Tile) {
        this._tile = tile;
        this.calculateOffsets();
    }

    calculateOffsets() {
        const centerPoint = this._tile.centerPoint.Position;
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

    attachToPart(part: Part, attachment: AttachmentPoint) {
        const point = this._tile.attachmentPoints.find((v) => v.part === attachment.part);
        const offset = this.attachmentOffsets.find((v) => v.part === point?.part);
        if (offset === undefined || point === undefined) return;
        const center = this._tile.originModel;
        const pos = offset.offset;
        const lookVector = part.CFrame.LookVector;
        const newPos = new Vector3(pos.X, 0, pos.X).add(new Vector3(pos.Z, 0, pos.Z));
        print(lookVector);
        center.PivotTo(part.GetPivot().sub(lookVector.mul(newPos)).sub(new Vector3(0, 1, 0)));
        //this.applyOffsets();
        point.part.Destroy();
    }
}