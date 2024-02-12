import { RunService, ServerStorage } from "@rbxts/services";
import RandomTileAttacher from "./classes/random_tile_attachment";
import { config } from "./dungeon_config";
import { benchmark, getNextAfterCondition_Reverse, getRandom, logServer } from "shared/utils";
import { dungeonFolder } from "shared/vars/folders";
import Tile from "./classes/tile";
import { RoomInfo } from "./interfaces/room";
import { $file } from "rbxts-transform-debug";
import { findFurthestTileFromSpecificTile } from "./pathfinding/findFurthest";
import make from "@rbxts/make";

const folder = ServerStorage.WaitForChild("Tiles") as Folder;

const randomizer = new RandomTileAttacher(folder);

const tiles = randomizer.tileRandomizer;
export default class Generator {
    private config: config;
    private tiles: Tile[] = [];
    private tileStorage: Folder;
    constructor(cfg: config) {
        this.config = cfg;
        this.tileStorage = make("Folder", {Name: this.config.DUNGEON_NAME, Parent: dungeonFolder})
    }

    private clearTilesBatch(children: Instance[], batchSize: number, totalBatches: number) {
        for (let i = 0; i < totalBatches; i++) {
            RunService.Heartbeat.Wait(); // Yield before processing each batch
            const startIdx = i * batchSize;
            const endIdx = math.min((i + 1) * batchSize, children.size());
            
            for (let j = startIdx; j < endIdx; j++) {
                const child = children[j];
                child.Destroy();
            }
        }
        this.tiles.clear();
    };

    clear() {
        const children = this.tileStorage.GetChildren();
        const batchSize = 50; // Define batch size
        const totalBatches = math.ceil(children.size() / batchSize);
        const amt = children.size();
        logServer(`clearing ${children.size()} tiles in ${totalBatches} batches`, $file.filePath, $file.lineNumber);
        const time = benchmark(() => this.clearTilesBatch(children, batchSize, totalBatches));
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

    generate() {
        const baseModel = randomizer.attachTileToPoint(this.config.STARTING_PART, this.config.INITIAL_TILE_TYPE, this.tileStorage) as RoomInfo;
        let tile = new Tile(baseModel.roomModel, baseModel);
        const firstTile = tile;
        this.tiles.push(tile);    
        const genTile = (maxRetries: number = 5) => {
            let randomized = tiles.getTileOfTypes(tile.TileData.types);
            if (!randomized) return;
            let randomThis;
            let attempts = 0;
            while (attempts < 2) {
                randomThis = getRandom(tile.attachmentPoints, (inst) => !inst.FindFirstChild("HasAttachment"));
                if (randomThis) break;
                tile = getNextAfterCondition_Reverse(this.tiles, (item) => item === tile) as Tile;
                randomized = tiles.getTileOfTypes(tile.TileData.types); // Get new tile type
                if (!randomized) return;
                attempts++;
            }
            
            if (!randomThis) return;
        
            const clone = randomized.roomModel.Clone();
            clone.Parent = this.tileStorage;
            const tc = new Tile(clone, randomized);
            if (tile.attachTile(tc, randomThis)) {
                const cframe = tc._model.GetPivot();
                if (cframe.X < this.config.STARTING_PART.Position.X || cframe.Z < this.config.STARTING_PART.Position.Z) {
                    clone.ClearAllChildren();
                    clone.Parent = undefined;
                    if (maxRetries !== 0) genTile(maxRetries - 1)
                    return;
                }
                const index = this.tiles.indexOf(tile) + 1;
                this.tiles.insert(index, tc);
                tile = tc;
            } else {
                clone.ClearAllChildren();
                clone.Parent = undefined;
                if (maxRetries !== 0) genTile(maxRetries - 1);
            }
        }

        const genTileBatch = () => {
            for (let i = 0; i < this.config.TILES - 1; i++) {
                RunService.Heartbeat.Wait();
                genTile(20);
            }
        };

        const genFurthestTile = () => {
            const furthestTile = findFurthestTileFromSpecificTile(firstTile);
            if (!furthestTile) return;
        
            const randomizedTile = tiles.getTileOfType(this.config.LAST_ROOM_TYPE);
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
            clone.Parent = this.tileStorage;
            const newTile = new Tile(clone, randomizedTile);
        
            if (furthestTile.attachTile(newTile, randomAttachmentPoint)) {
                const index = this.tiles.indexOf(furthestTile) + 1;
                this.tiles.insert(index, newTile);
            } else {
                clone.ClearAllChildren();
                clone.Parent = undefined;
                genFurthestTile();
            }
        }

        logServer(`generating ${this.config.TILES} tiles`, $file.filePath, $file.lineNumber);
        const time = benchmark(genTileBatch);
        let timeString = `generation of ${this.config.TILES} tiles took`;
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
        let furthestTimeString = `generation of ${this.config.LAST_ROOM_TYPE} tile type at furthest tile took`;
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