import { RoomTypes, RoomInfo } from "../interfaces/room";
import { getRandom } from "shared/utils";
import tileFolderParser from "./tileFolderParser";

export default class TileRandomizer {
    parser: tileFolderParser

    constructor(folder: Folder) {
        this.parser = new tileFolderParser(folder);
    }

    private getValidInstances(roomTypes?: RoomTypes[]): RoomInfo[] {
        const instances: RoomInfo[] = [];
        for (const roomType of roomTypes ?? this.parser.getTypes()) {
            const rooms = this.parser.getRoomsOfType(roomType);
            for (const room of rooms as Model[]) {
                instances.push(
                    {
                        roomModel: room,
                        roomType
                    }
                )
            }
        }
        return instances;
    }

    getRandomTile(): RoomInfo | undefined {
        const validInstances = this.getValidInstances();
        return getRandom(validInstances);
    }

    getTileOfType(roomType: RoomTypes): RoomInfo | undefined {
        const validInstances = this.getValidInstances([roomType]);
        return getRandom(validInstances);
    }

    getTileOfTypes(roomTypes: RoomTypes[]): RoomInfo | undefined {
        const validInstances = this.getValidInstances(roomTypes);
        return getRandom(validInstances);
    }
}