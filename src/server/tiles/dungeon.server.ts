import remotes from "shared/remotes";
import Generator from ".";
import { ServerScriptService, Workspace } from "@rbxts/services";
import { config } from "./interfaces/dungeon_config";

let generated = false;
const cfg: config = require(ServerScriptService.WaitForChild("DungeonConfig") as ModuleScript) as config;

const gen = new Generator(cfg);

remotes.generateDungeon.connect(() => {
    if (generated) return;
    generated = true;
    gen.generate();
    const door = Workspace.WaitForChild("StartingRoom").WaitForChild("Door") as Part;
    door.Transparency = 1;
    door.CanCollide = false;
})

remotes.clearDungeon.connect(() => {
    if (!generated) return;
    gen.clear();
    const door = Workspace.WaitForChild("StartingRoom").WaitForChild("Door") as Part;
    door.Transparency = 0;
    door.CanCollide = true;
    generated = false;
})