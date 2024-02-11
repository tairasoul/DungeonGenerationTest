import { Tile } from "server/tiles/interfaces/parser";
import { RoomTypes } from "server/tiles/interfaces/room";

interface RoomInfo {
    types: RoomTypes[];
}

export default class TileParser {
    private model: Model;

    constructor(model: Model) {
        this.model = model;
    }

    public getTileData(): Tile {
        const children = this.model.GetDescendants().filter(v => v.IsA("Part") && v.Name === "Doorway");
        const roomInfo = this.getRoomInfo();
        const attachmentPoint = this.model.WaitForChild("AttachmentPoint") as Part;
        const centerPoint = this.model.WaitForChild("centerPoint") as Part;
        const validPoints = children as Part[];

        return {
            attachmentPoint,
            types: roomInfo.types,
            originModel: this.model,
            centerPoint,
            validPoints
        };
    }

    private getRoomInfo(): RoomInfo {
        const roomInfoModule = this.model.FindFirstChild("room.info") as ModuleScript;
        if (!roomInfoModule) {
            warn(`Room info module not found for model ${this.model.Name}`);
            return { types: [] };
        }

        const roomInfo = require(roomInfoModule) as RoomInfo;
        return roomInfo;
    }
}
