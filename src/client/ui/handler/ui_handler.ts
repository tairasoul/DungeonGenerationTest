import Roact from "@rbxts/roact";
import { Players } from "@rbxts/services";
import { Upgrades } from "../ui_setup/upgrades";
import { upgrade } from "shared/remotes"; 

export = new class UIHandler {
    private screens: { [key: string]: Roact.Tree | void } = {};
    openUpgrades(upgrades: upgrade[]) {
        const elem = Upgrades({upgrades, upgraded: () => this.closeUpgrades()});
        print(elem);
        this.screens["Upgrade"] = Roact.mount(elem, Players.LocalPlayer.WaitForChild("PlayerGui"));
    }

    closeUpgrades() {
        if (this.screens["Upgrade"])
            this.screens["Upgrade"] = Roact.unmount(this.screens["Upgrade"])
    }
}