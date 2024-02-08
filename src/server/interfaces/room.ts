export type RoomTypes = "Hallway" | "Room";

export type RoomInitData = {
    validAttachments: RoomTypes;
    attachmentPoints: AttachmentPoint[];
}

export type AttachmentPoint = {
    part: Part;
    point: CFrame;
    hasAttachment: boolean;
}

export type RoomInfo = {
    roomType: RoomTypes;
    roomModel: Model;
}