import { remotes } from "shared/remotes";
import iris from "@rbxts/iris";
import { getRandom } from "shared/utils";

type tiles = "Hallway" | "Room";

const TileTypes = [
    "Hallway",
    "Room"
] as const;

iris.Init();

let num = 0;
let currentTile: tiles = "Hallway";

iris.Connect(() => {
    iris.Window(["tile generation test"]);
        iris.Tree(["singular tile"]);
            iris.Tree(["tile selection"])
                for (let i = 0; i < TileTypes.size(); i++) {
                    if (iris.Button([TileTypes[i]]).clicked()) {
                        currentTile = TileTypes[i];
                    }
                }
            iris.End();
            if (iris.Button([`generate ${currentTile.lower()} at current position`]).clicked()) {
                print("generating tile");
                remotes.generateRoom.fire(currentTile);
            }
            if (iris.Button(["generate random tile at current location"]).clicked()) {
                print("generating random tile");
                remotes.generateRoom.fire(getRandom(TileTypes.filter(() => true)) as tiles);
            }
        iris.End();
        iris.Tree(["generation with depth"])
            num = iris.InputNum(["generation depth"]).state["number"].value as number;
            if (iris.Button(["generate with depth"]).clicked()) {
                print(`generating with depth ${num}`);
                remotes.generateRoomWithDepth.fire(num);
            }
        iris.End();
        iris.Tree(["misc"])
            if (iris.Button(["clear tiles"]).clicked()) {
                print("clearing tiles");
                remotes.clearTiles.fire();
            }
            if (iris.Button(["test remote"]).clicked()) {
                remotes.test.fire();
            }
        iris.End();
    iris.End();
});