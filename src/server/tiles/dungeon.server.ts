import remotes from "shared/remotes";
import Generator from "./dungeon_generation";
import { Workspace } from "@rbxts/services";
import { config } from "./dungeon_config";

let generated = false;

remotes.generateDungeon.connect(() => {
    if (generated) return;
    const cfg: config = {
        STARTING_PART: Workspace.FindFirstChild("RoomStart", true) as Part,
        TILES: 30
    }
    Generator.generate(cfg);
    Workspace.WaitForChild("StartingRoom").WaitForChild("Door").Destroy();
    generated = true;
})