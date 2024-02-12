import { Client, Server, createRemotes, remote } from "@rbxts/remo";

export default createRemotes(
    {
        generateDungeon: remote<Server>(),
        clearDungeon: remote<Server>(),
        serverLog: remote<Client, [logString: string, srcFile: string, lineNumber: number, logType: "Warning" | "Error"  | "Message"]>()
    }
);