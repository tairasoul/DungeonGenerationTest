import * as services from "@rbxts/services";
import TileRandomizer from "./classes/randomised.tiles";
import RandomTileAttacher from "./classes/random_tile_attachment";
import Tile from "./classes/tile";
import { TileAttachmentInfo } from "./interfaces/tile";
import { getRandom } from "shared/utils";
import { remotes } from "shared/remotes";

const folder = services.ServerScriptService.FindFirstChild("TS")?.FindFirstChild("tiles") as Folder;

const test_parts = services.Workspace.WaitForChild("test_parts") as Folder;

const children = test_parts.GetChildren();

const tiles = new TileRandomizer(folder);

const random = new RandomTileAttacher(folder);

const baseTile = random.attachRandomTile(getRandom(children) as Part) as Model;

const tc = new Tile(baseTile);
const tile2 = tiles.getTileOfType("Room") as Model;
const clone2 = tile2.Clone();
clone2.Parent = services.Workspace;
const tc2 = new Tile(clone2);
const tc1Point = tc.attachmentData[0].attachment;
const tc2Point = tc2.attachmentData[0].attachment;
const info: TileAttachmentInfo = {
    thisTileAttachment: tc1Point,
    attachmentPoint: tc2Point
}
tc.attachTile(tc2, info);

const hallway = tiles.getTileOfType("Hallway") as Model;

const hc = hallway.Clone();
hc.Parent = services.Workspace;
const hct = new Tile(hc);
const thisTile = getRandom(tc2.attachmentData, (inst) => !inst.attachment.hasAttachment);
const attach = getRandom(hct.attachmentData, (inst) => !inst.attachment.hasAttachment);
if (thisTile !== undefined && attach !== undefined)
    tc2.attachTile(hct, {thisTileAttachment: thisTile.attachment, attachmentPoint: attach.attachment})

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