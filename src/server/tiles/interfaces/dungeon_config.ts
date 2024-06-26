/*import { Workspace } from "@rbxts/services";

const config = {
    TILES: 30,
    STARTING_PART: Workspace.WaitForChild("DungeonStart") as Part
}

export default config;*/

import { RoomTypes } from "./room";

export type config = {
    TILES: number;
    STARTING_PART: Part;
    INITIAL_TILE_TYPE: RoomTypes;
    LAST_ROOM_TYPE: RoomTypes;
    DUNGEON_NAME: string;
}