import { RoomTypes } from "server/interfaces/room";
import TileRandomizer from "./randomised.tiles";
import TileParser from "./tileParser";
import RoomAttachment from "./room_attachment";
import { getRandom } from "shared/utils";
import { tiles } from "shared/vars/folders";

export default class RandomTileAttacher {
    private tileRandomiser: TileRandomizer;
    constructor(folder: Folder) {
        this.tileRandomiser = new TileRandomizer(folder);
    }

    attachTileToPoint(part: Part, tileType: RoomTypes) {
        const tile = this.tileRandomiser.getTileOfType(tileType);
        if (tile === undefined) return;
        const clone = tile.Clone();
        clone.Parent = tiles;
        const parser = new TileParser(clone);
        const tileData = parser.getTileData();
        const attachment = new RoomAttachment(tileData);
        const point = getRandom(tileData.attachmentPoints);
        if (point === undefined) return;
        attachment.attachToPart(part, point);
        return clone;
    }

    attachRandomTile(part: Part) {
        const tile = this.tileRandomiser.getRandomTile();
        if (tile === undefined) return;
        const clone = tile.Clone();
        clone.Parent = tiles;
        const parser = new TileParser(clone);
        const tileData = parser.getTileData();
        const attachment = new RoomAttachment(tileData);
        const point = getRandom(tileData.attachmentPoints);
        if (point === undefined) return;
        attachment.attachToPart(part, point);
        return clone;
    }
}