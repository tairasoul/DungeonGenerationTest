import { Server, createRemotes, remote } from "@rbxts/remo";

type RoomTypes = "Hallway" | "Room";

export const remotes = createRemotes(
    {
        generateRoom: remote<Server, [roomType: RoomTypes]>(),
        generateRoomWithDepth: remote<Server, [depth: number]>(),
        clearTiles: remote<Server>(),
        test: remote<Server>()
    }
)