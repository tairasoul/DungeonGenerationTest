import make from "@rbxts/make";

export default class tileFolderParser {
    private folder: Folder;
    constructor(folder: Folder) {
        this.folder = folder;
        this.assignTypes()
    }

    getTypes(): string[] {
        const types: string[] = [];
        for (const typeN of this.folder.GetChildren())
            types.push(typeN.Name);
        return types;
    }

    private assignTypes() {
        for (const typeF of this.folder.GetChildren()) {
            for (const room of typeF.GetChildren()) {
                make("StringValue", {Name: "RoomType", Value: typeF.Name, Parent: room});
            }
        }
    }

    getRoomsOfType(roomType: string) {
        const roomFolder = this.folder.FindFirstChild(roomType);
        if (!roomFolder) throw `Folder for RoomType ${roomType} not found.`;
        return roomFolder.GetChildren();
    }

    getRoomsOfTypes(roomTypes: string[]) {
        const rooms: Model[] = [];
        for (const room of roomTypes) {
            const children = this.getRoomsOfType(room);
            for (const child of children) {
                rooms.push(child as Model);
            }
        }
        return rooms;
    }
}