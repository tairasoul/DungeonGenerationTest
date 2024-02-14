import Roact from "@rbxts/roact";
import { Players } from "@rbxts/services";
import { Upgrades } from "../ui_setup/upgrades";
import { upgrade } from "shared/remotes";

//const mounted = Roact.mount(Upgrades(), );

export = new class UIHandler {
    private screens: { [key: string]: Roact.Tree | void } = {};
    openUpgrades(upgrades: upgrade[]) {
        this.screens["Upgrade"] = Roact.mount(Upgrades({upgrades, upgraded: () => this.closeUpgrades()}), Players.LocalPlayer.WaitForChild("PlayerGui"));
    }

    closeUpgrades() {
        if (this.screens["Upgrade"])
            this.screens["Upgrade"] = Roact.unmount(this.screens["Upgrade"])
    }
}