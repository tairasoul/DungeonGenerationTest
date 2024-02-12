import { Tile } from "server/tiles/interfaces/parser";
import { RoomTypes } from "server/tiles/interfaces/room";

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
            types: roomInfo,
            originModel: this.model,
            centerPoint,
            validPoints
        };
    }

    private getRoomInfo(): string[] {
        const module = require(this.model.FindFirstChild("validTypes") as ModuleScript) as string[];
        return module;
    }
}
