import { ServerStorage } from "@rbxts/services";
import { RoomInfo } from "server/interfaces/room";

const info: RoomInfo = {
    roomType: "Room",
    roomModel: ServerStorage.FindFirstChild("RoomModels")?.FindFirstChild("Room") as Model
}

export const roomExport = info;