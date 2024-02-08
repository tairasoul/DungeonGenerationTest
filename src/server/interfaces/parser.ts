import { AttachmentPoint, RoomTypes } from "./room"

export type Tile = {
    attachmentPoints: AttachmentPoint[];
    types: RoomTypes[];
    originModel: Model;
    centerPoint: Part;
}