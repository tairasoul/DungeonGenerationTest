import ceive from "@rbxts/ceive-im-gizmo";
import { Workspace } from "@rbxts/services";

ceive.Init();

export default new class GizmoDrawer {
    DRAW_ATTACHMENT_POINT_DIRECTION = false;

    constructor() {
        task.spawn(() => {
            while (task.wait()) {
                if (this.DRAW_ATTACHMENT_POINT_DIRECTION) {
                    for (const attachmentPoint of Workspace.GetDescendants().filter((v) => v.Name === "AttachmentPoint") as Part[]) {
                        ceive.Arrow.Draw(attachmentPoint.Position.add(new Vector3(0, 10, 0)), attachmentPoint.Position.add(new Vector3(0, 10, 0)).sub(attachmentPoint.CFrame.LookVector.mul(new Vector3(10, 0, 10))), 2, 2, 50)
                    }
                }
            }
        })
    }
}