import remotes from "shared/remotes";
import Generator from "./dungeon_generation";
import { ServerScriptService, Workspace } from "@rbxts/services";
import { config } from "./dungeon_config";

let generated = false;

remotes.generateDungeon.connect(() => {
    if (generated) return;
    const cfg: config = require(ServerScriptService.WaitForChild("DungeonConfig") as ModuleScript) as config;
    Generator.generate(cfg);
    const door = Workspace.WaitForChild("StartingRoom").WaitForChild("Door") as Part;
    door.Transparency = 1;
    door.CanCollide = false;
    generated = true;
})

remotes.clearDungeon.connect(() => {
    if (!generated) return;
    Generator.clear();
    const door = Workspace.WaitForChild("StartingRoom").WaitForChild("Door") as Part;
    door.Transparency = 0;
    door.CanCollide = true;
    generated = false;
})