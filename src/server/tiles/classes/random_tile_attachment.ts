import { RoomInfo, RoomTypes } from "server/tiles/interfaces/room";
import TileRandomizer from "./randomised.tiles";
import TileParser from "./tileParser";
import RoomAttachment from "./room_attachment";
import { tiles } from "shared/vars/folders";

export default class RandomTileAttacher {
    private tileRandomizer: TileRandomizer;

    constructor(folder: Folder) {
        this.tileRandomizer = new TileRandomizer(folder);
    }

    public attachTileToPoint(part: Part, tileType: RoomTypes): RoomInfo | undefined {
        const tile = this.tileRandomizer.getTileOfType(tileType);
        return this.attachTile(part, tile);
    }

    public attachRandomTile(part: Part): RoomInfo | undefined {
        const tile = this.tileRandomizer.getRandomTile();
        return this.attachTile(part, tile);
    }

    private attachTile(part: Part, tile: RoomInfo | undefined): RoomInfo | undefined {
        if (!tile) return;

        const clone = tile.roomModel.Clone();
        clone.Parent = tiles;

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
