import { RoomTypes, RoomInfo } from "../interfaces/room";
import { getRandom, randomChance } from "shared/utils";
import tileFolderParser from "./tileFolderParser";
import TileParser from "./tileParser";

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
                        roomType,
                        chance: tonumber(room.Name.split("%")[1]) ?? 100
                    }
                )
            }
        }
        return instances;
    }

    getRandomTile(recursions: number = 0): RoomInfo | undefined {
        const validInstances = this.getValidInstances();
        const rnd = getRandom(validInstances, (inst) => randomChance(inst.chance));
        if (!rnd && recursions < 10) return this.getRandomTile(++recursions);
        return rnd;
    }

    getTileOfType(roomType: RoomTypes, recursions: number = 0): RoomInfo | undefined {
        const validInstances = this.getValidInstances([roomType]);
        const rnd = getRandom(validInstances, (inst) => randomChance(inst.chance));
        if (!rnd && recursions < 10) return this.getTileOfType(roomType, ++recursions);
        return rnd;
    }

    getTileOfTypes(roomTypes: RoomTypes[], recursions: number = 0): RoomInfo | undefined {
        const validInstances = this.getValidInstances(roomTypes);
        const rnd = getRandom(validInstances, (inst) => randomChance(inst.chance));
        if (!rnd && recursions < 10) return this.getTileOfTypes(roomTypes);
        return rnd;
    }
}