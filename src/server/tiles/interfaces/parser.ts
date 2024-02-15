import { RoomTypes } from "./room"

export type Tile = {
    attachmentPoint: Part;
    types: RoomTypes[];
    originModel: Model;
    centerPoint: Part;
    validPoints: Part[];
    chance: number;
}