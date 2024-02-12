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
        const centerPoint = this._tile.centerPoint.Position;
        const offset = getDistance(centerPoint, this._tile.attachmentPoint.Position);
        this.AttachmentOffset = {
            part: this._tile.attachmentPoint,
            offset
        }
    }

    attachToPart(part: Part, tileList: tile[]) {
        const offset = this.AttachmentOffset;
        const center = this._tile.originModel;
        const pos = (offset as PartOffset).offset;
        const lookVector = part.CFrame.LookVector;
        const newPos = new Vector3(pos.X, 0, pos.X).add(new Vector3(pos.Z, 0, pos.Z));
        const result = Workspace.Blockcast(part.GetPivot().sub(lookVector.mul(newPos)).add(new Vector3(0, 10, 0)), center.GetBoundingBox()[1], new Vector3(0, -15, 0));
        if (result !== undefined) {
            logServer(`attachment for ${this._tile.originModel} to ${part} overlaps with a part! ${result.Instance.FindFirstAncestorOfClass("Model")}`, $file.filePath, $file.lineNumber, "Warning");
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
        center.PivotTo(part.GetPivot().sub(lookVector.mul(newPos)).sub(new Vector3(0, 1, 0)));
        if (!part.FindFirstChild("HasAttachment")) make("BoolValue", {Parent: part, Value: true, Name: "HasAttachment"});
        make("BoolValue", {Parent: (offset as PartOffset).part, Value: true, Name: "HasAttachment"});
        make("ObjectValue", {Parent: part, Value: this._tile.attachmentPoint, Name: "AttachmentPart"});
        make("ObjectValue", {Parent: (offset as PartOffset).part, Value: part, Name: "AttachmentPart"});
        return {
            result: true
        }
    }
}