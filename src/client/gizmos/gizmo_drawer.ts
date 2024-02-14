import ceive from "@rbxts/ceive-im-gizmo";
import { Workspace } from "@rbxts/services";

ceive.Init();

export = new class GizmoDrawer {
    DRAW_ATTACHMENT_POINT_DIRECTION = true;
    private loop: thread | undefined;
    private stoploop = false;

    constructor() {
        this.init_loop();
    }

    init_loop() {
        this.stoploop = false;
        this.loop = task.spawn(() => {
            while (task.wait()) {
                if (this.stoploop) {
                    coroutine.yield();
                    break;
                }
                if (this.DRAW_ATTACHMENT_POINT_DIRECTION) {
                    for (const attachmentPoint of Workspace.GetDescendants().filter((v) => v.Name === "AttachmentPoint") as Part[]) {
                        ceive.Arrow.Draw(attachmentPoint.Position.add(new Vector3(0, 10, 0)), attachmentPoint.Position.add(new Vector3(0, 10, 0)).sub(attachmentPoint.CFrame.LookVector.mul(new Vector3(10, 0, 10))), 1, 1, 15)
                    }
                }
            }
        })
    }

    stop_loop() {
        this.stoploop = true;
        if (this.loop) {
            while (coroutine.status(this.loop) !== "suspended") task.wait();
            coroutine.close(this.loop);
        }
    }
}