import { AttachmentPoint } from "server/interfaces/room";
import { OffsetInfo, TileAttachmentInfo } from "server/interfaces/tile";

export default class Tile {
    private _model: Model;
    attachmentData: { attachment: AttachmentPoint; offsets: OffsetInfo[] }[] = [];

    constructor(model: Model) {
        this._model = model;
        this.calculateAttachmentOffsets();
    }

    calculateAttachmentOffsets() {
        const attachmentPoints = this._model.WaitForChild("apoints").GetChildren() as Part[];
        for (const attachment of attachmentPoints) {
            const attachmentInfo: AttachmentPoint = {
                part: attachment,
                point: attachment.CFrame,
                hasAttachment: false,
            };
            const offsets: OffsetInfo[] = [];
            const descendants = this._model.GetDescendants().filter((v) => !v.IsA("Folder") && !v.IsA("ModuleScript") && !(v.Name === "centerPoint") && v.Parent !== this._model.WaitForChild("apoints"));
            for (const part of descendants as Part[]) {
                const relativeCFrame = attachment.CFrame.Inverse().mul(part.CFrame);
                offsets.push({
                    part: part,
                    position: relativeCFrame.Position,
                    rotation: relativeCFrame.ToEulerAnglesXYZ(),
                });
            }
            this.attachmentData.push({ attachment: attachmentInfo, offsets: offsets });
        }
    }

    applyOffsets() {
        for (const attachment of this.attachmentData) {
            const attachmentCFrame = attachment.attachment.point;
            for (const offset of attachment.offsets) {
                const partCFrame = attachmentCFrame.add(offset.position).mul(CFrame.Angles(offset.rotation[0], offset.rotation[1], offset.rotation[2]));
                offset.part.CFrame = partCFrame;
            }
        }
    }

    attachTile(tile: Tile, info: TileAttachmentInfo) {
        const thisAttachment = this.attachmentData.find((data) => data.attachment === info.thisTileAttachment);
        const otherAttachment = tile.attachmentData.find((data) => data.attachment === info.attachmentPoint);
        if (!thisAttachment || !otherAttachment) throw `Attachment points not found.`;

        // Apply the position and rotation offsets from otherAttachment to thisAttachment
        const thisCenter = thisAttachment.attachment.point.Position;
        const otherCenter = otherAttachment.attachment.point.Position;
        const offsetVector = otherCenter.sub(thisCenter);

        for (const offsetInfo of thisAttachment.offsets) {
            const newPosition = offsetVector.add(offsetInfo.position);
            const newRotation = offsetInfo.rotation;
            offsetInfo.part.CFrame = new CFrame(newPosition).mul(CFrame.Angles(newRotation[0], newRotation[1], newRotation[2]));
        }

        // Update attachment status
        thisAttachment.attachment.hasAttachment = true;
        otherAttachment.attachment.hasAttachment = true;

        tile.applyOffsets();
    }
}