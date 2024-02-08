import { Server, createRemotes, remote } from "@rbxts/remo";

export const remotes = createRemotes(
    {
        async: remote<Server>()
    }
)