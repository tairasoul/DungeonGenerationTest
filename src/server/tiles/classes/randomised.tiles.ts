import { RoomTypes, RoomInfo } from "../interfaces/room";
import { getRandom } from "shared/utils";

interface TileModule {
    roomExport: RoomInfo;
}

export default class TileRandomizer {
    private tileFolder: Folder;

    constructor(folder: Folder) {
        this.tileFolder = folder;
    }

    private getValidInstances(roomTypes?: RoomTypes[]): RoomInfo[] {
        const children = this.tileFolder.GetChildren();
        const validInstances: RoomInfo[] = [];
        
        for (const child of children) {
            const module = child.FindFirstChildOfClass("ModuleScript");
            if (module !== undefined) {
                const info = require(module) as TileModule;
                const roomExport = info.roomExport;

                if (!roomTypes || roomTypes.includes(roomExport.roomType)) {
                    validInstances.push(roomExport);
                }
            }
        }
        
        return validInstances;
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