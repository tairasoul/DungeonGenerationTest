import { RoomInfo, RoomTypes } from "server/tiles/interfaces/room";
import TileRandomizer from "./randomised.tiles";
import TileParser from "./tileParser";
import RoomAttachment from "./room_attachment";

export default class RandomTileAttacher {
    tileRandomizer: TileRandomizer;

    constructor(folder: Folder) {
        this.tileRandomizer = new TileRandomizer(folder);
    }

    public attachTileToPoint(part: Part, tileType: RoomTypes, parent: Instance): RoomInfo | undefined {
        const tile = this.tileRandomizer.getTileOfType(tileType);
        return this.attachTile(part, tile, parent);
    }

    public attachRandomTile(part: Part, parent: Instance): RoomInfo | undefined {
        const tile = this.tileRandomizer.getRandomTile();
        return this.attachTile(part, tile, parent);
    }

    private attachTile(part: Part, tile: RoomInfo | undefined, parent: Instance): RoomInfo | undefined {
        if (!tile) return;

        const clone = tile.roomModel.Clone();
        clone.Parent = parent;

        const parser = new TileParser(clone);
        const tileData = parser.getTileData();

        const attachment = new RoomAttachment(tileData);
        attachment.attachToPart(part);

        return {
            roomType: tile.roomType,
            roomModel: clone
        };
    }
}
