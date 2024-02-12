import { RunService, ServerStorage } from "@rbxts/services";
import tileRegistry from "./classes/tileRegistry";
import RandomTileAttacher from "./classes/random_tile_attachment";
import TileRandomizer from "./classes/randomised.tiles";
import { config } from "./dungeon_config";
import { benchmark, getNextAfterCondition_Reverse, getRandom, logServer } from "shared/utils";
import { tiles as tileStorage } from "shared/vars/folders";
import Tile from "./classes/tile";
import { RoomInfo } from "./interfaces/room";

const folder = ServerStorage.WaitForChild("tiles") as Folder;

const randomizer = new RandomTileAttacher(folder);

const tiles = new TileRandomizer(folder);

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

export default new class Generator {
    clear() {
        const children = tileStorage.GetChildren();
        const batchSize = 50; // Define batch size
        const totalBatches = math.ceil(children.size() / batchSize);
        const amt = children.size();
        logServer(`clearing ${children.size()} tiles in ${totalBatches} batches`);
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
        logServer(timeString);
    }

    generate(cfg: config) {
        const baseModel = randomizer.attachRandomTile(cfg.STARTING_PART) as RoomInfo;
        let tile = new Tile(baseModel.roomModel, baseModel);
        tileRegistry.tiles.push(tile);    
        logServer(`generating ${cfg.TILES} tiles`);
        function genTile() {
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
            for (let i = 0; i < cfg.TILES - 1; i++) {
                RunService.Heartbeat.Wait();
                genTile();
            }
        };

        const time = benchmark(genTileBatch);
        let timeString = `generation of ${cfg.TILES} tiles took`;
        if (time.minutes > 0) {
            timeString += ` ${time.minutes} minute${time.minutes > 1 ? "s": ""}`;
        }
        if (time.seconds > 0) {
            timeString += ` ${time.seconds} second${time.seconds > 1 ? "s" : ""}`;
        }
        if (time.milliseconds > 0) {
            timeString += ` ${time.milliseconds} milliseconds`;
        }
        logServer(timeString);
    }
}