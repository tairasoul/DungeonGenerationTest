import { Workspace } from "@rbxts/services";
import remotes from "shared/remotes";

const Room = Workspace.WaitForChild("StartingRoom");
const button = Room.WaitForChild("Clear");
const CD = button.WaitForChild("ClickDetector") as ClickDetector;

CD.MouseClick.Connect(() => {
    remotes.clearDungeon.fire();
})