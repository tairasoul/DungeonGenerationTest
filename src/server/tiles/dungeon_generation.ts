import { RunService, ServerStorage } from "@rbxts/services";
import tileRegistry from "./classes/tileRegistry";
import RandomTileAttacher from "./classes/random_tile_attachment";
import TileRandomizer from "./classes/randomised.tiles";
import { config } from "./dungeon_config";
import { benchmark, getNextAfterCondition_Reverse, getRandom, logServer } from "shared/utils";
import { tiles as tileStorage } from "shared/vars/folders";
import Tile from "./classes/tile";
import { RoomInfo } from "./interfaces/room";
import { $file, $print } from "rbxts-transform-debug";
import { findFurthestTileFromSpecificTile } from "./pathfinding/findFurthest";

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
        logServer(`clearing ${children.size()} tiles in ${totalBatches} batches`, $file.filePath, $file.lineNumber);
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
        logServer(timeString, $file.filePath, $file.lineNumber);
    }

    generate(cfg: config) {
        const baseModel = randomizer.attachTileToPoint(cfg.STARTING_PART, cfg.INITIAL_TILE_TYPE) as RoomInfo;
        let tile = new Tile(baseModel.roomModel, baseModel);
        const firstTile = tile;
        tileRegistry.tiles.push(tile);    
        function genTile(maxRetries: number = 5) {
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
                const cframe = tc._model.GetPivot();
                if (cframe.X < cfg.STARTING_PART.Position.X || cframe.Z < cfg.STARTING_PART.Position.Z) {
                    clone.ClearAllChildren();
                    clone.Parent = undefined;
                    if (maxRetries !== 0) genTile(maxRetries - 1)
                    return;
                }
                const index = tileRegistry.tiles.indexOf(tile) + 1;
                tileRegistry.tiles.insert(index, tc);
                tile = tc;
            } else {
                clone.ClearAllChildren();
                clone.Parent = undefined;
                if (maxRetries !== 0) genTile(maxRetries - 1);
            }
        }

        const genTileBatch = () => {
            for (let i = 0; i < cfg.TILES - 1; i++) {
                RunService.Heartbeat.Wait();
                genTile(20);
            }
        };

        const genFurthestTile = () => {
            const furthestTile = findFurthestTileFromSpecificTile(firstTile);
            if (!furthestTile) return;
        
            const randomizedTile = tiles.getTileOfType(cfg.LAST_ROOM_TYPE);
            if (!randomizedTile) return;
        
            let randomAttachmentPoint;
            let attempts = 0;
            while (attempts < 2) {
                randomAttachmentPoint = getRandom(furthestTile.attachmentPoints, inst => !inst.FindFirstChild("HasAttachment"));
                if (randomAttachmentPoint) break;
                attempts++;
            }
            if (!randomAttachmentPoint) return;
        
            const clone = randomizedTile.roomModel.Clone();
            clone.Parent = tileStorage;
            const newTile = new Tile(clone, randomizedTile);
        
            if (furthestTile.attachTile(newTile, randomAttachmentPoint)) {
                const index = tileRegistry.tiles.indexOf(furthestTile) + 1;
                tileRegistry.tiles.insert(index, newTile);
            } else {
                clone.ClearAllChildren();
                clone.Parent = undefined;
                genFurthestTile();
            }
        }

        logServer(`generating ${cfg.TILES} tiles`, $file.filePath, $file.lineNumber);
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

        logServer(timeString, $file.filePath, $file.lineNumber);

        const furthestTime = benchmark(genFurthestTile);
        let furthestTimeString = `generation of ${cfg.LAST_ROOM_TYPE} room at furthest tile took`;
        if (furthestTime.minutes > 0) {
            furthestTimeString += ` ${furthestTime.minutes} minute${furthestTime.minutes > 1 ? "s": ""}`;
        }
        if (furthestTime.seconds > 0) {
            furthestTimeString += ` ${furthestTime.seconds} second${furthestTime.seconds > 1 ? "s" : ""}`;
        }
        if (furthestTime.milliseconds > 0) {
            furthestTimeString += ` ${furthestTime.milliseconds} milliseconds`;
        }

        logServer(furthestTimeString, $file.filePath, $file.lineNumber);
    }
}