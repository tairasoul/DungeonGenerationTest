import { ServerStorage } from "@rbxts/services";
import { RoomInfo } from "server/interfaces/room";

const info: RoomInfo = {
    roomType: "Hallway",
    roomModel: ServerStorage.FindFirstChild("RoomModels")?.FindFirstChild("StraightHall") as Model
}

export const roomExport = info;