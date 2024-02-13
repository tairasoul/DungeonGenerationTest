import { $print } from "rbxts-transform-debug";
import remotes from "shared/remotes";

remotes.pickUpgrade.connect((player, identifier) => {
    $print(`received upgrade pick request from ${player} for upgrade with id ${identifier}`)
})