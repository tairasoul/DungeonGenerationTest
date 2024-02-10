import { RoomTypes, RoomInfo } from "../interfaces/room";
import { getRandom } from "shared/utils";

export default class TileRandomizer {
    private TileFolder: Folder;
    constructor(folder: Folder) {
        this.TileFolder = folder;
    }

    getRandomTile() {
        const children = this.TileFolder.GetChildren();
        const instances: RoomInfo[] = []
        for (const child of children) {
            const module = child.FindFirstChildOfClass("ModuleScript");
            if (module !== undefined) {
                const info = require(module) as  {
                    "roomExport": RoomInfo;
                }
                instances.push(info["roomExport"])
            }
        }
        return getRandom(instances);
    }

    getTileOfType(roomType: RoomTypes) {
        const children = this.TileFolder.GetChildren();
        const validInstances: RoomInfo[] = [];
        for (const child of children) {
            const module = child.FindFirstChildOfClass("ModuleScript");
            if (module !== undefined) {
                const info = require(module) as  {
                    "roomExport": RoomInfo;
                }
                if (info["roomExport"].roomType === roomType) {
                    validInstances.push(info["roomExport"]);
                }
            }
        }
        return getRandom(validInstances);
    }

    getTileOfTypes(roomTypes: RoomTypes[]) {
        const children = this.TileFolder.GetChildren();
        const validInstances: RoomInfo[] = [];
        for (const child of children) {
            const module = child.FindFirstChildOfClass("ModuleScript");
            if (module !== undefined) {
                const info = require(module) as  {
                    "roomExport": RoomInfo;
                }
                if (roomTypes.includes(info["roomExport"].roomType)) {
                    validInstances.push(info["roomExport"]);
                }
            }
        }
        return getRandom(validInstances);
    }
}