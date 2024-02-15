import { Tile } from "server/tiles/interfaces/parser";
import { PartOffset } from "server/tiles/interfaces/attachment";
import { getDistance, logServer } from "shared/utils";
import make from "@rbxts/make";
import { Workspace } from "@rbxts/services";
import tile from "./tile";
import { $file } from "rbxts-transform-debug";

export default class RoomAttachment {
    _tile: Tile;
    private AttachmentOffset: PartOffset | undefined = undefined;
    constructor(tile: Tile) {
        this._tile = tile;
        this.calculateOffsets();
    }

    calculateOffsets() {
        const centerPoint = this._tile.originModel.GetPivot();
        const ap = this._tile.attachmentPoint;
        const offset = getDistance(centerPoint.Position, ap.Position);
        this.AttachmentOffset = {
            part: ap,
            offset
        }
    }

    attachToPart(part: Part, tileList: tile[]): {result: boolean, tile?: tile} {
        const offset = this.AttachmentOffset;
        if (!offset) return {
            result: false
        }
        const center = this._tile.originModel;
        const pos = offset.offset;
        const lookVector = part.CFrame.LookVector;
        const newPos = new Vector3(pos.X, 0, pos.X).add(new Vector3(pos.Z, 0, pos.Z));
        const result = Workspace.Raycast(part.GetPivot().sub(lookVector.mul(newPos)).add(new Vector3(0, 2, 0)).Position, new Vector3(0, -5, 0));
        if (result !== undefined) {
            logServer(`attachment for ${this._tile.originModel} to ${part} overlaps with a part! ${result.Instance.FindFirstAncestorOfClass("Model")}'s overlapping part: ${result.Instance}`, $file.filePath, $file.lineNumber, "Warning");
            make("BoolValue", {Parent: part, Value: true, Name: "HasAttachment"});
            const tile = tileList.find((v) => v._model.WaitForChild("centerPoint") === result.Instance.FindFirstAncestorOfClass("Model")?.WaitForChild("centerPoint")) as tile;
            if (tile !== undefined) {
                const point = tile.attachmentPoints.filter((v) => !v.FindFirstChild("HasAttachment")).find((v) => getDistance(v.Position, part.Position).Magnitude < 2) as Part;
                if (point !== undefined) {
                    make("BoolValue", {Parent: point, Value: true, Name: "HasAttachment"});
                    make("ObjectValue", {Parent: part, Value: point, Name: "AttachmentPart"});
                    make("ObjectValue", {Parent: point, Value: part, Name: "AttachmentPart"})
                }
                return {
                    result: false,
                    tile
                }
            } 
        }
        center.PivotTo(part.GetPivot().sub(lookVector.mul(newPos)).add(new Vector3(0, pos.Y)));
        if (!part.FindFirstChild("HasAttachment")) make("BoolValue", {Parent: part, Value: true, Name: "HasAttachment"});
        make("BoolValue", {Parent: (offset as PartOffset).part, Value: true, Name: "HasAttachment"});
        make("ObjectValue", {Parent: part, Value: this._tile.attachmentPoint, Name: "AttachmentPart"});
        make("ObjectValue", {Parent: (offset as PartOffset).part, Value: part, Name: "AttachmentPart"});
        return {
            result: true
        }
    }
}