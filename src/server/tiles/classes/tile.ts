import TileParser from "./tileParser";
import RoomAttachment from "./room_attachment";
import { RoomInfo } from "../interfaces/room";
import { Tile as ParserData } from "../interfaces/parser";
import { getDistance } from "shared/utils";

export default class Tile {
    public _model: Model;
    public attachmentPoints: Part[];
    public TileData: ParserData;
    public info: RoomInfo;
    public connections: Map<Tile, number>; // Map of connected tiles and their distances

    constructor(model: Model, info: RoomInfo) {
        this._model = model;
        this.info = info;
        const parser = new TileParser(this._model);
        this.TileData = parser.getTileData();
        this.attachmentPoints = this.findAttachmentPoints();
        this.connections = new Map();
    }

    private findAttachmentPoints(): Part[] {
        return this._model.GetDescendants().filter(
            v => v.IsA("Part") && v.Name === "Doorway"
        ) as Part[];
    }

    public attachTile(tile: Tile, point: Part, tileList: Tile[]): boolean {
        const attach = new RoomAttachment(tile.TileData);
        const couldAttach = attach.attachToPart(point, tileList);
        if (couldAttach.result)
            this.addConnection(tile);
        else if (couldAttach.tile) {
            this.addConnection(couldAttach.tile)
        }
        return couldAttach.result
    }

    public addConnection(tile: Tile) {
        const distance = getDistance(this.TileData.centerPoint.Position, tile.TileData.centerPoint.Position).Magnitude;
        this.connections.set(tile, distance);
    }
}
