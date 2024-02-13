import { upgrade } from "shared/remotes";

export default class UpgradeRegistry {
    upgradeInfo: upgrade[] = [];
    private upgradeInfoFolder: Folder;
    constructor(infoFolder: Folder) {
        this.upgradeInfoFolder = infoFolder;
    }

    processFolder() {
        for (const descendant of this.upgradeInfoFolder.GetDescendants().filter((v) => v.IsA("ModuleScript")) as ModuleScript[]) {
            const info = require(descendant) as upgrade;
            this.upgradeInfo.push(info);
        }
    }
}