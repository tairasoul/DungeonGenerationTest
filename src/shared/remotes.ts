import { Server, createRemotes, remote } from "@rbxts/remo";

export const remotes = createRemotes(
    {
        generateRoom: remote<Server>(),
        generateRoomWithDepth: remote<Server, [depth: number]>(),
        clearTiles: remote<Server>()
    }
)