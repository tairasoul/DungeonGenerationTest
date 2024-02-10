import { ServerScriptService, ServerStorage } from "@rbxts/services";
import FolderMerger from "./classes/folderMerger";
import make from "@rbxts/make";

const nonts = ServerStorage.WaitForChild("tiles.non-ts") as Folder;
const tsTiles = ServerScriptService.WaitForChild("TS").WaitForChild("tiles").WaitForChild("tiles") as Folder;

const folder = ServerStorage.FindFirstChild("tiles") as Folder ?? make("Folder", {Name: "tiles", Parent: ServerStorage}) as Folder;

const merger = new FolderMerger(folder);

merger.merge(nonts, tsTiles);