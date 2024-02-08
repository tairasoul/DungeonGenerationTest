import { remotes } from "shared/remotes";
import iris from "@rbxts/iris";
iris.Init();

let num = 0;

iris.Connect(() => {
    iris.Window(["tile generation test"])
        if (iris.Button(["generate tile at current position"]).clicked()) {
            print("generating tile");
            remotes.generateRoom.fire();
        }
        iris.Text(["generation with depth"]);
        const numInput = iris.InputNum(["generation depth"]);
        if (numInput.numberChanged()) {
            num = numInput.state["number"].value as number;
        }
        if (iris.Button(["generate with depth"]).clicked()) {
            print(`generating with depth ${num}`);
            remotes.generateRoomWithDepth.fire(num);
        }
        if (iris.Button(["clear tiles"]).clicked()) {
            print("clearing tiles");
            remotes.clearTiles.fire();
        }
    iris.End();
});