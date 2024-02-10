import { ServerStorage } from "@rbxts/services";
import { remotes } from "shared/remotes";
import RandomTileAttacher from "./classes/random_tile_attachment";
import Tile from "./classes/tile";
import TileRandomizer from "./classes/randomised.tiles";
import { getRandom } from "shared/utils";
import { tiles as tileStorage } from "shared/vars/folders";
import make from "@rbxts/make";
import TileParser from "./classes/tileParser";

const folder = ServerStorage.WaitForChild("tiles") as Folder;

const randomizer = new RandomTileAttacher(folder);

const tiles = new TileRandomizer(folder);

const tStorage: Tile[] = [];

remotes.generateRoom.connect((player, roomT) => {
    print("received request to generate tile, generating");
    const character = player.Character ?? player.CharacterAdded.Wait()[0];
    tStorage.push(new Tile(randomizer.attachTileToPoint(character.WaitForChild("HumanoidRootPart") as Part, roomT) as Model));
});

const allowedTilesFilter = [
    "Room"
];

remotes.generateRoomWithDepth.connect((player, depth) => {
    print(`received request to generate with depth ${depth}, generating`);
    const character = player.Character ?? player.CharacterAdded.Wait()[0];
    const baseModel = randomizer.attachRandomTile(character.WaitForChild("Torso") as Part) as Model;
    let tile = new Tile(baseModel);
    tStorage.push(tile);
    for (let i = 0; i < depth; i++) {
        const parser = new TileParser(tile._model);
        const info = parser.getTileData();
        const randomized = tiles.getTileOfTypes(info.types);
        if (randomized === undefined) continue;
        const clone = randomized.roomModel.Clone();
        clone.Parent = tileStorage;
        const tc = new Tile(clone);
        let randomThis = getRandom(tile.attachmentPoints, (inst) => !inst.FindFirstChild("HasAttachment"));
        if (randomThis === undefined) {
            const filtered1 = tStorage.filter((v) => allowedTilesFilter.includes(v._model.Name));
            const filtered = filtered1.filter((v) => v.attachmentPoints.some((part) => !part.FindFirstChild("HasAttachment")));
            randomThis = getRandom(filtered[filtered.size() - 1].attachmentPoints, (inst) => !inst.FindFirstChild("HasAttachment"))
        };
        if (randomThis === undefined) continue;
        if (tile.attachTile(tc, randomThis)) {
            tile = tc;
            tStorage.push(tc);
        }
        else {
            clone.ClearAllChildren();
            clone.Parent = undefined;
        }
    }
})

remotes.clearTiles.connect(() => {
    print("received request to clear tiles, clearing.");
    const children = tileStorage.GetChildren();
    children.forEach((v) => v.Destroy());
    tStorage.clear();
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