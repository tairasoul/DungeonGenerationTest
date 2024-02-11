import { Tile } from "server/tiles/interfaces/parser";
import { PartOffset } from "server/tiles/interfaces/attachment";
import { getDistance } from "shared/utils";
import make from "@rbxts/make";
import { Workspace } from "@rbxts/services";
import tileRegistry from "./tileRegistry";
import tile from "./tile";

export default class RoomAttachment {
    _tile: Tile;
    private AttachmentOffset: PartOffset | undefined = undefined;
    constructor(tile: Tile) {
        this._tile = tile;
        this.calculateOffsets();
    }

    calculateOffsets() {
        const centerPoint = this._tile.centerPoint.Position;
        const offset = getDistance(centerPoint, this._tile.attachmentPoint.Position);
        this.AttachmentOffset = {
            part: this._tile.attachmentPoint,
            offset
        }
    }

    attachToPart(part: Part) {
        const offset = this.AttachmentOffset;
        const center = this._tile.originModel;
        const pos = (offset as PartOffset).offset;
        const lookVector = part.CFrame.LookVector;
        const newPos = new Vector3(pos.X, 0, pos.X).add(new Vector3(pos.Z, 0, pos.Z));
        const result = Workspace.Raycast(part.GetPivot().sub(lookVector.mul(newPos)).Position, new Vector3(0, -2, 0));
        if (result !== undefined) {
            make("BoolValue", {Parent: part, Value: true, Name: "HasAttachment"});
            const tile = tileRegistry.tiles.find((v) => v._model.WaitForChild("centerPoint") === result.Instance) as tile;
            const point = tile.attachmentPoints.filter((v) => !v.FindFirstChild("HasAttachment")).find((v) => getDistance(v.Position, part.Position).Magnitude < 2) as Part;
            if (point !== undefined)
                make("BoolValue", {Parent: point, Value: true, Name: "HasAttachment"});
            return false;
        }
        center.PivotTo(part.GetPivot().sub(lookVector.mul(newPos)).sub(new Vector3(0, 1, 0)));
        make("BoolValue", {Parent: part, Value: true, Name: "HasAttachment"});
        make("BoolValue", {Parent: (offset as PartOffset).part, Value: true, Name: "HasAttachment"});
        return true;
    }
}