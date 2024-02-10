import { ServerStorage } from "@rbxts/services";
import { RoomInfo } from "server/tiles/interfaces/room";

const info: RoomInfo = {
    roomType: "Hallway",
    roomModel: ServerStorage.FindFirstChild("RoomModels")?.FindFirstChild("StraightHall") as Model
}

export const roomExport = info;