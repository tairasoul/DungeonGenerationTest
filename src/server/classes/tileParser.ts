import { Tile } from "server/interfaces/parser";
import { AttachmentPoint, RoomTypes } from "server/interfaces/room";

export default class TileParser {
    private _model: Model;
    constructor(model: Model) {
        this._model = model;
    }

    getTileData() {
        const folder = this._model.WaitForChild("apoints") as Folder;
        const children = folder.GetChildren();
        const roomInfo = require(this._model.FindFirstChild("room.info") as ModuleScript) as {
            "types": RoomTypes[]
        }
        const tileData: Tile = {
            attachmentPoints: [],
            types: roomInfo.types,
            originModel: this._model,
            centerPoint: this._model.WaitForChild("centerPoint") as Part
        }
        for (const child of children as Part[]) {
            const attachment: AttachmentPoint = {
                part: child,
                point: child.CFrame,
                hasAttachment: false
            }
            tileData.attachmentPoints.push(attachment);
        }
        return tileData;
    }
}