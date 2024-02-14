import Roact from "@rbxts/roact";
import { UpgradeUI } from "../components/upgrades/upgrade_ui";
import { Upgrade } from "../components/upgrades/upgrade";

type upgrade = {
    name: string;
    icon: string;
    identifier: string;
    description: string;
}

interface UIProps {
    upgrades: upgrade[];
    upgraded: () => unknown;
}

export function Upgrades(props?: UIProps) {
    const elems = [];
    for (const upgrade of props?.upgrades ?? []) {
        elems.push(<Upgrade upgradeName={upgrade.name} upgradeDescription={upgrade.description} identifier={upgrade.identifier} upgradeIcon={upgrade.icon} upgradeEvent={props?.upgraded ?? (() => {})}/>)
    }
    return <UpgradeUI Position={new UDim2(0.5, 0, 0, 20)}>
        {elems}
    </UpgradeUI>
}
