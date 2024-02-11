import { ServerStorage, Workspace } from "@rbxts/services";
import { remotes } from "shared/remotes";
import RandomTileAttacher from "./classes/random_tile_attachment";
import Tile from "./classes/tile";
import TileRandomizer from "./classes/randomised.tiles";
import { getRandom } from "shared/utils";
import { tiles as tileStorage } from "shared/vars/folders";
import make from "@rbxts/make";
import { RoomInfo } from "./interfaces/room";

const folder = ServerStorage.WaitForChild("tiles") as Folder;

const cameraPart = make("Part", { Parent: Workspace, Transparency: 1, Anchored: true })

const randomizer = new RandomTileAttacher(folder);

const tiles = new TileRandomizer(folder);

const tStorage: Tile[] = [];

remotes.generateRoom.connect((player, roomT) => {
    print("received request to generate tile, generating");
    const character = player.Character ?? player.CharacterAdded.Wait()[0];
    const tile = randomizer.attachTileToPoint(character.WaitForChild("HumanoidRootPart") as Part, roomT) as RoomInfo
    tStorage.push(new Tile(tile.roomModel, tile));
});

// todo:
// make it so this can't generate anywhere behind the initial tile
// otherwise it has a chance to have the first tile also be connected to a tile behind it

remotes.generateRoomWithDepth.connect((player, depth) => {
    print(`received request to generate with depth ${depth}, generating`);
    const character = player.Character ?? player.CharacterAdded.Wait()[0];
    const baseModel = randomizer.attachRandomTile(character.WaitForChild("Torso") as Part) as RoomInfo;
    let tile = new Tile(baseModel.roomModel, baseModel);
    tStorage.push(tile);
    task.spawn(() => {
        for (let i = 0; i < depth; i++) {
            task.wait()
            cameraPart.Position = tile.attach.Position.add(new Vector3(0, 50, 0));
            character.PivotTo(cameraPart.CFrame);
            const randomized = tiles.getTileOfTypes(tile.TileData.types);
            if (randomized === undefined) continue;
            const clone = randomized.roomModel.Clone();
            clone.Parent = tileStorage;
            let tc = new Tile(clone, randomized);
            let randomThis = getRandom(tile.attachmentPoints, (inst) => !inst.FindFirstChild("HasAttachment"));
            if (randomThis === undefined) {
                if (tc.info.roomType === "Room") {
                    clone.ClearAllChildren();
                    clone.Parent = undefined;
                    const random = tiles.getTileOfTypes(["Hallway"]);
                    if (random === undefined) continue;
                    const clone1 = random.roomModel.Clone();
                    clone1.Parent = tileStorage;
                    tc = new Tile(clone1, random);
                }
                else {
                    clone.ClearAllChildren();
                    clone.Parent = undefined;
                    const random = tiles.getTileOfTypes(["Room"]);
                    if (random === undefined) continue;
                    const clone1 = random.roomModel.Clone();
                    clone1.Parent = tileStorage;
                    tc = new Tile(clone1, random);
                }
                const filtered1 = tStorage.filter((v) => v.info.roomType !== tc.info.roomType);
                const filtered = filtered1.filter((v) => v.attachmentPoints.some((part) => !part.FindFirstChild("HasAttachment")));
                randomThis = getRandom(filtered[filtered.size() - 1].attachmentPoints, (inst) => !inst.FindFirstChild("HasAttachment"))
            };
            if (randomThis === undefined) continue;
            if (tile.attachTile(tc, randomThis)) {
                tile = tc;
                tStorage.push(tile);
            }
            else {
                clone.ClearAllChildren();
                clone.Parent = undefined;
            }
        }
    })
})

remotes.clearTiles.connect(() => {
    print("received request to clear tiles, clearing.");
    const children = tileStorage.GetChildren();
    children.forEach((v) => v.Destroy());
    tStorage.clear();
})

remotes.test.connect((player) => {
    print("test remote called");
    const char = player.Character ?? player.CharacterAdded.Wait()[0];
    const hrp = char.WaitForChild("HumanoidRootPart") as Part;
    const part = make("Part", {Anchored: true, Parent: tileStorage});
    const lookVector = hrp.CFrame.LookVector;
    const offset = new Vector3(10, 0, 20);
    part.Position = hrp.Position.add(lookVector.mul(offset));
});