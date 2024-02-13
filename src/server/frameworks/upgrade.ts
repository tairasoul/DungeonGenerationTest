import remotes, { upgrade } from "shared/remotes";
import UpgradeRegistry from "./upgradeRegistry";
import { ServerStorage } from "@rbxts/services";
import UpgradeDatastore from "./upgrade.datastore";
import { getRandom } from "shared/utils";

const registry = new UpgradeRegistry(ServerStorage.WaitForChild("Upgrades") as Folder);

export default class UpgradeSystem {
    private player: Player;
    private playerIsPicking: boolean = false;
    private playerOptions: upgrade[] = [];
    private datastore: UpgradeDatastore;
    static async init(player: Player) {
        const datastore = await UpgradeDatastore.init(tostring(player.UserId));
        return new this(player, datastore);
    }

    private constructor(player: Player, datastore: UpgradeDatastore) {
        this.player = player;
        this.datastore = datastore;
    }

    pickUpgrades(...upgrades: upgrade[]) {
        this.playerIsPicking = true;
        this.playerOptions = upgrades;
        remotes.upgradesAvailable.fire(this.player, upgrades);
    }

    async upgradePickHandler(_: unknown, identifier: string) {
        if (!this.playerIsPicking) return;
        this.playerIsPicking = false;
        if (this.playerOptions.some((v) => v.identifier === identifier)) {
            this.datastore.addUpgrades(identifier);
            this.datastore.save();
        }
    }

    pickRandomUpgrades() {
        const upgs = registry.upgradeInfo;
        const upg1 = getRandom(upgs);
        const upg2 = getRandom(upgs);
        const upg3 = getRandom(upgs);
        if (!upg1 || !upg2 || !upg3) return;
        this.pickUpgrades(upg1, upg2, upg3);
    }
}