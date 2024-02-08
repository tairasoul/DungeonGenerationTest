-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local TileRandomizer = TS.import(script, game:GetService("ServerScriptService"), "TS", "classes", "randomised.tiles").default
local RandomTileAttacher = TS.import(script, game:GetService("ServerScriptService"), "TS", "classes", "random_tile_attachment").default
local Tile = TS.import(script, game:GetService("ServerScriptService"), "TS", "classes", "tile").default
local getRandom = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils").getRandom
local ServerScriptService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ServerScriptService
local FolderMerger = TS.import(script, game:GetService("ServerScriptService"), "TS", "classes", "folderMerger").default
local make = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "make")
local tileStorage = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "vars", "folders").tiles
local nonts = ServerScriptService:WaitForChild("tiles.non-ts")
local tsTiles = ServerScriptService:WaitForChild("TS"):WaitForChild("tiles")
local folder = ServerScriptService:FindFirstChild("tiles") or make("Folder", {
	Name = "tiles",
	Parent = ServerScriptService,
})
local merger = FolderMerger.new(folder)
merger:merge({ nonts, tsTiles })
local test_parts = services.Workspace:WaitForChild("test_parts")
local children = test_parts:GetChildren()
local tiles = TileRandomizer.new(folder)
local random = RandomTileAttacher.new(folder)
local baseTile = random:attachTileToPoint(getRandom(children), "Hallway")
local tc = Tile.new(baseTile)
local tile2 = tiles:getTileOfType("Room")
local clone2 = tile2:Clone()
clone2.Parent = tileStorage
local tc2 = Tile.new(clone2)
local tc1Point = tc.attachmentPoints[1]
local tc2Point = tc2.attachmentPoints[1]
local info = {
	thisTileAttachment = tc1Point,
	attachmentPoint = tc2Point,
}
tc:attachTile(tc2, info)
local hallway = tiles:getTileOfType("Hallway")
local hc = hallway:Clone()
hc.Parent = tileStorage
local hct = Tile.new(hc)
local thisTile = getRandom(tc2.attachmentPoints, function(inst)
	return not inst.hasAttachment
end)
local attach = getRandom(hct.attachmentPoints, function(inst)
	return not inst.hasAttachment
end)
if thisTile ~= nil and attach ~= nil then
	tc2:attachTile(hct, {
		thisTileAttachment = thisTile,
		attachmentPoint = attach,
	})
end
-- let previousTile = tc2;
--[[
	for (let i = 0; i < 3; i++) {
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
