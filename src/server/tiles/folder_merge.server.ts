import { ServerScriptService, ServerStorage } from "@rbxts/services";
import FolderMerger from "./classes/folderMerger";
import make from "@rbxts/make";

const nonts = ServerStorage.WaitForChild("tiles.non-ts") as Folder;
const tsTiles = ServerScriptService.WaitForChild("TS").WaitForChild("tiles").WaitForChild("tiles") as Folder;

const folder = ServerStorage.FindFirstChild("tiles") as Folder ?? make("Folder", {Name: "tiles", Parent: ServerStorage}) as Folder;

const merger = new FolderMerger(folder);

merger.merge(nonts, tsTiles);

/*const test_parts = services.Workspace.WaitForChild("test_parts") as Folder;

const children = test_parts.GetChildren();

const tiles = new TileRandomizer(folder);

const random = new RandomTileAttacher(folder);

const baseTile = random.attachTileToPoint(getRandom(children) as Part, "Hallway") as Model;

const tc = new Tile(baseTile);
const tile2 = tiles.getTileOfType("Room") as Model;
const clone2 = tile2.Clone();
clone2.Parent = tileStorage;
const tc2 = new Tile(clone2);
const tc1Point = tc.attachmentPoints[0];
const tc2Point = tc2.attachmentPoints[0];
const info: TileAttachmentInfo = {
    thisTileAttachment: tc1Point,
    attachmentPoint: tc2Point
}
tc.attachTile(tc2, info);

const hallway = tiles.getTileOfType("Hallway") as Model;

const hc = hallway.Clone();
hc.Parent = tileStorage;
const hct = new Tile(hc);
const thisTile = getRandom(tc2.attachmentPoints, (inst) => !inst.hasAttachment);
const attach = getRandom(hct.attachmentPoints, (inst) => !inst.hasAttachment);
if (thisTile !== undefined && attach !== undefined)
    tc2.attachTile(hct, {thisTileAttachment: thisTile, attachmentPoint: attach})

//let previousTile = tc2;

/*for (let i = 0; i < 3; i++) {
    const tile = tiles.getRandomTile();
    if (tile === undefined) continue;
    const clone = tile.Clone();
    clone.Parent = services.Workspace;
    const tc = new Tile(clone);
    const randomThis = getRandom(previousTile.attachmentPoints, (inst) => !inst.hasAttachment);
    const randomOther = getRandom(tc.attachmentPoints, (inst) => !inst.hasAttachment)
    if (randomThis === undefined || randomOther === undefined) continue;
    const points: TileAttachmentInfo = {
        thisTileAttachment: randomThis,
        attachmentPoint: randomOther
    }
    previousTile.attachTile(tc, points);
}*/