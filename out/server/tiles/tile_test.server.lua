-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ServerScriptService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ServerScriptService
local FolderMerger = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "folderMerger").default
local make = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "make")
local nonts = ServerScriptService:WaitForChild("tiles.non-ts")
local tsTiles = ServerScriptService:WaitForChild("TS"):WaitForChild("tiles"):WaitForChild("tiles")
local folder = ServerScriptService:FindFirstChild("tiles") or make("Folder", {
	Name = "tiles",
	Parent = ServerScriptService,
})
local merger = FolderMerger.new(folder)
merger:merge(nonts, tsTiles)
--[[
	const test_parts = services.Workspace.WaitForChild("test_parts") as Folder;
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
	}
]]
