import { Client, Server, createRemotes, remote, throttleMiddleware } from "@rbxts/remo";

export type upgrade = {
    name: string;
    icon: string;
    identifier: string;
    description: string;
}

export default createRemotes(
    {
        generateDungeon: remote<Server>(),
        clearDungeon: remote<Server>(),
        serverLog: remote<Client, [logString: string, srcFile: string, lineNumber: number, logType: "Warning" | "Error"  | "Message"]>(),
        upgradesAvailable: remote<Client, [upgrades: upgrade[]]>(),
        pickUpgrade: remote<Server, [identifier: string]>().middleware(throttleMiddleware({throttle: 2}))
    }
);