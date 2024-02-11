import { ServerStorage, RunService } from "@rbxts/services";
import { remotes } from "shared/remotes";
import RandomTileAttacher from "./classes/random_tile_attachment";
import Tile from "./classes/tile";
import TileRandomizer from "./classes/randomised.tiles";
import { getNextAfterCondition_Reverse, getRandom, inverseForEach } from "shared/utils";
import { tiles as tileStorage } from "shared/vars/folders";
import make from "@rbxts/make";
import { RoomInfo } from "./interfaces/room";
import tileRegistry from "./classes/tileRegistry";

const folder = ServerStorage.WaitForChild("tiles") as Folder;

const randomizer = new RandomTileAttacher(folder);

const tiles = new TileRandomizer(folder);

const cameraPart = make("Part", {Parent: game.GetService("Workspace"), Anchored: true, Name: "cameraPart"});

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
        character.PivotTo(tile._model.GetPivot().add(new Vector3(0, 50, 0)));
        cameraPart.Position = tile._model.GetPivot().Position.add(new Vector3(0, 50, 0));
        const randomized = tiles.getTileOfTypes(tile.TileData.types);
        if (randomized === undefined) return;
        let randomThis = getRandom(tile.attachmentPoints, (inst) => !inst.FindFirstChild("HasAttachment"));
        if (randomThis === undefined) {
            tile = getNextAfterCondition_Reverse(tileRegistry.tiles, (item) => item === tile) as Tile;
            genTile();
            return;
        };
        const clone = randomized.roomModel.Clone();
        clone.Parent = tileStorage;
        const tc = new Tile(clone, randomized);
        if (tile.attachTile(tc, randomThis)) {
            tileRegistry.tiles.insert(tileRegistry.tiles.indexOf(tile) + 1, tc);    
            tile = tc;
        }
        else {
            if (getRandom(tile.attachmentPoints, (inst) => !inst.FindFirstChild("HasAttachment")) === undefined) {
                tile = getNextAfterCondition_Reverse(tileRegistry.tiles, (item) => item === tile) as Tile;
            }
            clone.ClearAllChildren();
            clone.Parent = undefined;
            genTile();
        }
    }
    task.spawn(() => {
        const startTime = os.time();
        for (let i = 0; i < depth; i++) {
            RunService.Heartbeat.Wait();
            print(`generating tile ${i}/${depth}`);
            genTile();
        }
        const endTime = os.time();
        const diff = endTime - startTime;
        print(`generation of ${depth} tiles took${diff > 60 ? ` ${math.round(diff / 60)} minutes` : ""}${(diff % 60) !== 0 ? ` ${diff % 60} seconds` : ""}`);
    })
})

remotes.clearTiles.connect(() => {
    print("received request to clear tiles, clearing.");
    const children = tileStorage.GetChildren();
    print(`clearing ${children.size()} tiles`)
    task.spawn(() => {
        inverseForEach(children, (v) => {
            RunService.Heartbeat.Wait();
            v.Destroy();
        });
        tileRegistry.tiles.clear();
    })
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