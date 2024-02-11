import TileParser from "./tileParser";
import RoomAttachment from "./room_attachment";
import { RoomInfo } from "../interfaces/room";
import { Tile as ParserData } from "../interfaces/parser";

export default class Tile {
    public _model: Model;
    public attachmentPoints: Part[];
    public TileData: ParserData;
    public info: RoomInfo;

    constructor(model: Model, info: RoomInfo) {
        this._model = model;
        this.info = info;
        const parser = new TileParser(this._model);
        this.TileData = parser.getTileData();
        this.attachmentPoints = this.findAttachmentPoints();
    }

    private findAttachmentPoints(): Part[] {
        return this._model.GetDescendants().filter(
            v => v.IsA("Part") && v.Name === "Doorway"
        ) as Part[];
    }

    public attachTile(tile: Tile, point: Part): boolean {
        const attach = new RoomAttachment(tile.TileData);
        return attach.attachToPart(point);
    }
}
