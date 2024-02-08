import { AttachmentPoint } from "./room"

export type TileAttachmentInfo = {
    thisTileAttachment: AttachmentPoint;
    attachmentPoint: AttachmentPoint;
}

export type OffsetInfo = {
    part: Part;
    position: Vector3;
    rotation: LuaTuple<[number, number, number]>;
}