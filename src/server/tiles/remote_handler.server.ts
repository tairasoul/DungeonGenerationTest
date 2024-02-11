import { ServerStorage, RunService } from "@rbxts/services";
import { remotes } from "shared/remotes";
import RandomTileAttacher from "./classes/random_tile_attachment";
import Tile from "./classes/tile";
import TileRandomizer from "./classes/randomised.tiles";
import { getAllBeforeCondition, getRandom } from "shared/utils";
import { tiles as tileStorage } from "shared/vars/folders";
import make from "@rbxts/make";
import { RoomInfo } from "./interfaces/room";
import tileRegistry from "./classes/tileRegistry";

const folder = ServerStorage.WaitForChild("tiles") as Folder;

const randomizer = new RandomTileAttacher(folder);

const tiles = new TileRandomizer(folder);

remotes.generateRoom.connect((player, roomT) => {
    print("received request to generate tile, generating");
    const character = player.Character ?? player.CharacterAdded.Wait()[0];
    const tile = randomizer.attachTileToPoint(character.WaitForChild("HumanoidRootPart") as Part, roomT) as RoomInfo
    tileRegistry.tiles.push(new Tile(tile.roomModel, tile));
});

// todo:
// make it so this can't generate anywhere behind the initial tile
// otherwise it has a chance to have the first tile also be connected to a tile behind it

remotes.generateRoomWithDepth.connect((player, depth) => {
    print(`received request to generate with depth ${depth}, generating`);
    const character = player.Character ?? player.CharacterAdded.Wait()[0];
    const baseModel = randomizer.attachRandomTile(character.WaitForChild("Torso") as Part) as RoomInfo;
    let tile = new Tile(baseModel.roomModel, baseModel);
    tileRegistry.tiles.push(tile);
    function genTile() {
        const randomized = tiles.getTileOfTypes(tile.TileData.types);
        if (randomized === undefined) return;
        const clone = randomized.roomModel.Clone();
        clone.Parent = tileStorage;
        let tc = new Tile(clone, randomized);
        let randomThis = getRandom(tile.attachmentPoints, (inst) => !inst.FindFirstChild("HasAttachment"));
        if (randomThis === undefined) {
            clone.ClearAllChildren();
            clone.Parent = undefined;
            const beforeTile = getAllBeforeCondition(tileRegistry.tiles, (item) => item !== tile);
            tile = beforeTile[beforeTile.size() - 1];
            genTile();
            return;
        };
        if (tile.attachTile(tc, randomThis)) {
            tile = tc;
            tileRegistry.tiles.push(tile);
        }
        else {
            clone.ClearAllChildren();
            clone.Parent = undefined;
        }
    }
    task.spawn(() => {
        for (let i = 0; i < depth; i++) {
            RunService.Heartbeat.Wait();
            genTile();
        }
    })
})

remotes.clearTiles.connect(() => {
    print("received request to clear tiles, clearing.");
    const children = tileStorage.GetChildren();
    print(`clearing ${children.size()} tiles`)
    children.forEach((v) => v.Destroy());
    tileRegistry.tiles.clear();
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