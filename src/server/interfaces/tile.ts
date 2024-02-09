import { AttachmentPoint } from "./room"

export type TileAttachmentInfo = {
    thisTileAttachment: AttachmentPoint;
    attachmentPoint: AttachmentPoint;
}

export type OffsetInfo = {
    part: Part;
    CFrameOffset: CFrame
    from: AttachmentPoint;
}