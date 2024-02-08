import { ServerScriptService, Workspace } from "@rbxts/services";
import { remotes } from "shared/remotes";
import RandomTileAttacher from "./classes/random_tile_attachment";
import Tile from "./classes/tile";
import TileRandomizer from "./classes/randomised.tiles";
import { getRandom } from "shared/utils";
import { TileAttachmentInfo } from "./interfaces/tile";
import { tiles as tileStorage } from "shared/vars/folders";

const folder = ServerScriptService.WaitForChild("tiles") as Folder;

const randomizer = new RandomTileAttacher(folder);

const tiles = new TileRandomizer(folder);

remotes.generateRoom.connect((player) => {
    print("received request to generate tile, generating");
    const character = player.Character ?? player.CharacterAdded.Wait()[0];
    randomizer.attachRandomTile(character.WaitForChild("Torso") as Part);
});

remotes.generateRoomWithDepth.connect((player, depth) => {
    print(`received request to generate with depth ${depth}, generating`);
    const character = player.Character ?? player.CharacterAdded.Wait()[0];
    const baseModel = randomizer.attachRandomTile(character.WaitForChild("Torso") as Part) as Model;
    let tile = new Tile(baseModel);
    for (let i = 0; i < depth; i++) {
        const randomized = tiles.getRandomTile();
        if (randomized === undefined) continue;
        const clone = randomized.Clone();
        clone.Parent = Workspace;
        const tc = new Tile(clone);
        const randomThis = getRandom(tile.attachmentPoints, (inst) => !inst.hasAttachment);
        const randomOther = getRandom(tc.attachmentPoints, (inst) => !inst.hasAttachment)
        if (randomThis === undefined || randomOther === undefined) continue;
        const points: TileAttachmentInfo = {
            thisTileAttachment: randomThis,
            attachmentPoint: randomOther
        }
        tile.attachTile(tc, points);
        tile = tc;
    }
})

remotes.clearTiles.connect(() => {
    print("received request to clear tiles, clearing.");
    const children = tileStorage.GetChildren();
    children.forEach((v) => v.Destroy());
})