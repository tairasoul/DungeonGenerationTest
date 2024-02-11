import { ServerStorage, RunService } from "@rbxts/services";
import { remotes } from "shared/remotes";
import RandomTileAttacher from "./classes/random_tile_attachment";
import Tile from "./classes/tile";
import TileRandomizer from "./classes/randomised.tiles";
import { benchmark, getNextAfterCondition_Reverse, getRandom, inverseForEach } from "shared/utils";
import { tiles as tileStorage } from "shared/vars/folders";
import make from "@rbxts/make";
import { RoomInfo } from "./interfaces/room";
import tileRegistry from "./classes/tileRegistry";

const folder = ServerStorage.WaitForChild("tiles") as Folder;

const randomizer = new RandomTileAttacher(folder);

const tiles = new TileRandomizer(folder);

const getCharacter = (player: Player) => player.Character || player.CharacterAdded.Wait()[0];

remotes.generateRoom.connect((player, roomT) => {
    print("received request to generate tile, generating");
    const character = getCharacter(player);
    const humanoidRootPart = character.WaitForChild("HumanoidRootPart") as Part;
    const tile = randomizer.attachTileToPoint(humanoidRootPart, roomT) as RoomInfo;
    tileRegistry.tiles.push(new Tile(tile.roomModel, tile));
});

// todo:
// make it so this can't generate anywhere behind the initial tile
// otherwise it has a chance to have the first tile also be connected to a tile behind it

remotes.generateRoomWithDepth.connect((player, depth) => {
    const character = getCharacter(player);
    const humanoidRootPart = character.WaitForChild("Torso") as Part;
    humanoidRootPart.Anchored = true;
    const baseModel = randomizer.attachRandomTile(humanoidRootPart) as RoomInfo;
    let tile = new Tile(baseModel.roomModel, baseModel);
    tileRegistry.tiles.push(tile);    
    print(`generating ${depth} tiles`);
    function genTile() {
        humanoidRootPart.CFrame = tile._model.GetPivot().add(new Vector3(0, 100, 0));
        let randomized = tiles.getTileOfTypes(tile.TileData.types);
        if (!randomized) return;
        let randomThis;
        let attempts = 0;
        while (attempts < 2) {
            randomThis = getRandom(tile.attachmentPoints, (inst) => !inst.FindFirstChild("HasAttachment"));
            if (randomThis) break;
            tile = getNextAfterCondition_Reverse(tileRegistry.tiles, (item) => item === tile) as Tile;
            randomized = tiles.getTileOfTypes(tile.TileData.types); // Get new tile type
            if (!randomized) return;
            attempts++;
        }
        
        if (!randomThis) return;
    
        const clone = randomized.roomModel.Clone();
        clone.Parent = tileStorage;
        const tc = new Tile(clone, randomized);
    
        if (tile.attachTile(tc, randomThis)) {
            const index = tileRegistry.tiles.indexOf(tile) + 1;
            tileRegistry.tiles.insert(index, tc);
            tile = tc;
        } else {
            clone.ClearAllChildren();
            clone.Parent = undefined;
            genTile();
        }
    }
    const genTileBatch = () => {
        for (let i = 0; i < depth - 1; i++) {
            RunService.Heartbeat.Wait();
            genTile();
        }
    };

    const time = benchmark(genTileBatch);
    let timeString = `generation of ${depth} tiles took`;
    if (time.minutes > 0) {
        timeString += ` ${time.minutes} minute${time.minutes > 1 ? "s": ""}`;
    }
    if (time.seconds > 0) {
        timeString += ` ${time.seconds} second${time.seconds > 1 ? "s" : ""}`;
    }
    if (time.milliseconds > 0) {
        timeString += ` ${time.milliseconds} milliseconds`;
    }
    print(timeString);
    humanoidRootPart.Anchored = false;
});

// Reuse children array and batch size
const clearTilesBatch = (children: Instance[], batchSize: number, totalBatches: number) => {
    for (let i = 0; i < totalBatches; i++) {
        RunService.Heartbeat.Wait(); // Yield before processing each batch
        const startIdx = i * batchSize;
        const endIdx = math.min((i + 1) * batchSize, children.size());
        
        for (let j = startIdx; j < endIdx; j++) {
            const child = children[j];
            child.Destroy();
        }
    }
    tileRegistry.tiles.clear();
};

remotes.clearTiles.connect(() => {
    const children = tileStorage.GetChildren();
    const batchSize = 50; // Define batch size
    const totalBatches = math.ceil(children.size() / batchSize);
    const amt = children.size();
    print(`clearing ${children.size()} tiles in ${totalBatches} batches`);
    const time = benchmark(() => clearTilesBatch(children, batchSize, totalBatches));
    let timeString = `cleared ${amt} tiles in ${totalBatches} batches in`;
    if (time.minutes > 0) {
        timeString += ` ${time.minutes} minute${time.minutes > 1 ? "s": ""}`;
    }
    if (time.seconds > 0) {
        timeString += ` ${time.seconds} second${time.seconds > 1 ? "s" : ""}`;
    }
    if (time.milliseconds > 0) {
        timeString += ` ${time.milliseconds} milliseconds`;
    }
    print(timeString);
});


remotes.test.connect((player) => {
    print("test remote called");
    const char = player.Character ?? player.CharacterAdded.Wait()[0];
    const hrp = char.WaitForChild("HumanoidRootPart") as Part;
    const part = make("Part", {Anchored: true, Parent: tileStorage});
    const lookVector = hrp.CFrame.LookVector;
    const offset = new Vector3(10, 0, 20);
    part.Position = hrp.Position.add(lookVector.mul(offset));
});