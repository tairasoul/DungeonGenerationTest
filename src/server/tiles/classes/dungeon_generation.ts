import { RunService, ServerStorage } from "@rbxts/services";
import RandomTileAttacher from "./random_tile_attachment";
import { config } from "../interfaces/dungeon_config";
import { benchmark, getDistance, getNextAfterCondition_Reverse, getRandom, logServer } from "shared/utils";
import { dungeonFolder } from "shared/vars/folders";
import Tile from "./tile";
import { RoomInfo } from "../interfaces/room";
import { $file } from "rbxts-transform-debug";
import { findFurthestTileFromSpecificTile } from "../pathfinding/findFurthest";
import make from "@rbxts/make";
import { Observer, Value } from "@rbxts/fusion";

const folder = ServerStorage.WaitForChild("Tiles") as Folder;

const randomizer = new RandomTileAttacher(folder);

const tiles = randomizer.tileRandomizer;
export = class Generator {
    private config: config;
    private tiles: Tile[] = [];
    private tileStorage: Folder;
    private hasGenerated = Value(false);
    private generated = Observer(this.hasGenerated);
    private generatedListeners: {callback: () => unknown, destroy: () => void}[] = [];
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

    addGeneratedListener(callback: () => unknown) {
        this.generatedListeners.push({callback, destroy: this.generated.onChange(callback)})
    }

    removeGeneratedListener(callback: () => unknown) {
        const found = this.generatedListeners.find((v) => v.callback === callback);
        if (!found) throw "Listener not found for Generated observer.";
        found.destroy();
        this.generatedListeners = this.generatedListeners.filter((v) => v.callback !== callback);
    }

    removeListeners() {
        this.generatedListeners.forEach((v) => v.destroy());
        this.generatedListeners.clear();
    }

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
        this.hasGenerated.set(false);
    }

    generate() {
        const baseModel = randomizer.attachTileToPoint(this.config.STARTING_PART, this.config.INITIAL_TILE_TYPE, this.tileStorage) as RoomInfo;
        let tile = new Tile(baseModel);
        const firstTile = tile;
        this.tiles.push(tile);    
        const genTile = (maxRetries: number = 5) => {
            let randomized = tiles.getTileOfTypes(tile.TileData.types);
            if (!randomized) return;
            let randomThis;
            let attempts = 0;
            while (attempts < 15) {
                randomThis = getRandom(tile.attachmentPoints, (inst) => !inst.FindFirstChild("HasAttachment"));
                if (randomThis) break;
                tile = getNextAfterCondition_Reverse(this.tiles, (item) => item === tile) as Tile;
                randomized = tiles.getTileOfTypes(tile.TileData.types); // Get new tile type
                if (!randomized) return;
                attempts++;
            }
            
            if (!randomThis) return;
        
            const clone = randomized.roomModel.Clone();
            randomized.roomModel = clone;
            clone.Parent = this.tileStorage;
            const tc = new Tile(randomized);
            if (tile.attachTile(tc, randomThis, this.tiles)) {
                const cframe = tc._model.GetPivot();
                if (getDistance(cframe.Position, (this.config.STARTING_PART.FindFirstAncestorOfClass("Model") ?? this.config.STARTING_PART).GetPivot().Position).Magnitude < 50) {
                    logServer(`tile ${tostring(tc)} is too close to starting room! removing.`, $file.filePath, $file.lineNumber, "Warning");
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
            logServer(`generating ${this.config.TILES} tiles`, $file.filePath, $file.lineNumber);
            for (let i = 0; i < this.config.TILES - 2; i++) {
                RunService.Heartbeat.Wait();
                genTile(20);
            }
        };

        const genFurthestTile = (exclusions: Set<Tile> = new Set()) => {
            logServer(`generating tile at furthest tile, with type ${this.config.LAST_ROOM_TYPE}`, $file.filePath, $file.lineNumber);
            const furthestTile = findFurthestTileFromSpecificTile(firstTile, exclusions);
            if (!furthestTile[0]) return;
        
            const randomizedTile = tiles.getTileOfType(this.config.LAST_ROOM_TYPE);
            if (!randomizedTile) return;
        
            let randomAttachmentPoint;
            let attempts = 0;
            while (attempts < furthestTile[0].attachmentPoints.size()) {
                randomAttachmentPoint = getRandom(furthestTile[0].attachmentPoints, inst => !inst.FindFirstChild("HasAttachment"));
                if (randomAttachmentPoint) break;
                attempts++;
            }
            if (!randomAttachmentPoint) {
                // Create a new set with the updated exclusions including the current furthest tile
                const newExclusions: Set<Tile> = new Set();
                exclusions.forEach((v) => newExclusions.add(v));
                newExclusions.add(furthestTile[0]);
                
                // Call genFurthestTile again with the updated exclusions set
                genFurthestTile(newExclusions);
                return;
            };
        
            const clone = randomizedTile.roomModel.Clone();
            randomizedTile.roomModel = clone;
            clone.Parent = this.tileStorage;
            const newTile = new Tile(randomizedTile);
        
            if (furthestTile[0].attachTile(newTile, randomAttachmentPoint, this.tiles)) {
                const index = this.tiles.indexOf(furthestTile[0]) + 1;
                this.tiles.insert(index, newTile);
                logServer(`generated last tile ${math.round(furthestTile[1])} studs away`, $file.filePath, $file.lineNumber)
            } else {
                logServer(`failed to generate tile at furthest tile, retrying`, $file.filePath, $file.lineNumber);
                clone.ClearAllChildren();
                clone.Parent = undefined;

                // Create a new set with the updated exclusions including the current furthest tile
                const newExclusions: Set<Tile> = new Set();
                exclusions.forEach((v) => newExclusions.add(v));
                newExclusions.add(furthestTile[0]);
                
                // Call genFurthestTile again with the updated exclusions set
                genFurthestTile(newExclusions);
            }
        }
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
            furthestTimeString += ` ${furthestTime.milliseconds} millisecond${furthestTime.milliseconds > 1 ? "s" : ""}`;
        }

        logServer(furthestTimeString, $file.filePath, $file.lineNumber);
        this.hasGenerated.set(true);
    }
}