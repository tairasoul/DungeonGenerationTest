import TileParser from "./tileParser";
import RoomAttachment from "./room_attachment";
import { RoomInfo } from "../interfaces/room";
import { Tile as parserData } from "../interfaces/parser";

export default class Tile {
    _model: Model;
    public attachmentPoints: Part[] = [];
    attach: Part;
    TileData: parserData;
    info: RoomInfo
    constructor(model: Model, info: RoomInfo) {
        this._model = model;
        this.info = info;
        const parser = new TileParser(this._model);
        this.TileData = parser.getTileData();
        this.attach = model.WaitForChild("AttachmentPoint") as Part;
        for (const child of this._model.GetDescendants().filter((v) => v.IsA("Part") && v.Name === "Doorway") as Part[]) {
            this.attachmentPoints.push(child)
        }
    }

    attachTile(tile: Tile, point: Part) {
        const attach = new RoomAttachment(tile.TileData);
        if (!attach.attachToPart(point)) {
            return false;
        }
        return true;
    }
}