import { Tile } from "server/tiles/interfaces/parser";
import { RoomTypes } from "server/tiles/interfaces/room";

export default class TileParser {
    private _model: Model;
    constructor(model: Model) {
        this._model = model;
    }

    getTileData() {
        const children = this._model.GetDescendants().filter((v) => v.IsA("Part") && v.Name === "Doorway");
        const roomInfo = require(this._model.FindFirstChild("room.info") as ModuleScript) as {
            "types": RoomTypes[]
        }
        const tileData: Tile = {
            attachmentPoint: this._model.WaitForChild("AttachmentPoint") as Part,
            types: roomInfo.types,
            originModel: this._model,
            centerPoint: this._model.WaitForChild("centerPoint") as Part,
            validPoints: []
        }
        for (const child of children as Part[]) {
            tileData.validPoints.push(child);
        }
        return tileData;
    }
}