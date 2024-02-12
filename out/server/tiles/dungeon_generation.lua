-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local RandomTileAttacher = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "random_tile_attachment").default
local _utils = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils")
local benchmark = _utils.benchmark
local getNextAfterCondition_Reverse = _utils.getNextAfterCondition_Reverse
local getRandom = _utils.getRandom
local logServer = _utils.logServer
local dungeonFolder = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "vars", "folders").dungeonFolder
local Tile = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tile").default
local findFurthestTileFromSpecificTile = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "pathfinding", "findFurthest").findFurthestTileFromSpecificTile
local make = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "make")
local folder = ServerStorage:WaitForChild("Tiles")
local randomizer = RandomTileAttacher.new(folder)
local tiles = randomizer.tileRandomizer
local Generator
do
	Generator = setmetatable({}, {
		__tostring = function()
			return "Generator"
		end,
	})
	Generator.__index = Generator
	function Generator.new(...)
		local self = setmetatable({}, Generator)
		return self:constructor(...) or self
	end
	function Generator:constructor(cfg)
		self._tiles = {}
		self._config = cfg
		self._tileStorage = make("Folder", {
			Name = self._config.DUNGEON_NAME,
			Parent = dungeonFolder,
		})
	end
	function Generator:_clearTilesBatch(children, batchSize, totalBatches)
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < totalBatches) then
					break
				end
				RunService.Heartbeat:Wait()
				local startIdx = i * batchSize
				local endIdx = math.min((i + 1) * batchSize, #children)
				do
					local j = startIdx
					local _shouldIncrement_1 = false
					while true do
						if _shouldIncrement_1 then
							j += 1
						else
							_shouldIncrement_1 = true
						end
						if not (j < endIdx) then
							break
						end
						local child = children[j + 1]
						child:Destroy()
					end
				end
			end
		end
		table.clear(self._tiles)
	end
	function Generator:clear()
		local children = self._tileStorage:GetChildren()
		local batchSize = 50
		local totalBatches = math.ceil(#children / batchSize)
		local amt = #children
		logServer("clearing " .. (tostring(#children) .. (" tiles in " .. (tostring(totalBatches) .. " batches"))), "src/server/tiles/dungeon_generation.ts", 45)
		local time = benchmark(function()
			return self:_clearTilesBatch(children, batchSize, totalBatches)
		end)
		local timeString = "cleared " .. (tostring(amt) .. (" tiles in " .. (tostring(totalBatches) .. " batches in")))
		if time.minutes > 0 then
			timeString ..= " " .. (tostring(time.minutes) .. (" minute" .. (if time.minutes > 1 then "s" else "")))
		end
		if time.seconds > 0 then
			timeString ..= " " .. (tostring(time.seconds) .. (" second" .. (if time.seconds > 1 then "s" else "")))
		end
		if time.milliseconds > 0 then
			timeString ..= " " .. (tostring(time.milliseconds) .. " milliseconds")
		end
		logServer(timeString, "src/server/tiles/dungeon_generation.ts", 57)
	end
	function Generator:generate()
		local baseModel = randomizer:attachTileToPoint(self._config.STARTING_PART, self._config.INITIAL_TILE_TYPE, self._tileStorage)
		local tile = Tile.new(baseModel.roomModel, baseModel)
		local firstTile = tile
		local __tiles = self._tiles
		local _tile = tile
		table.insert(__tiles, _tile)
		local genTile
		genTile = function(maxRetries)
			if maxRetries == nil then
				maxRetries = 5
			end
			local randomized = tiles:getTileOfTypes(tile.TileData.types)
			if not randomized then
				return nil
			end
			local randomThis
			local attempts = 0
			while attempts < 2 do
				randomThis = getRandom(tile.attachmentPoints, function(inst)
					return not inst:FindFirstChild("HasAttachment")
				end)
				if randomThis then
					break
				end
				tile = getNextAfterCondition_Reverse(self._tiles, function(item)
					return item == tile
				end)
				randomized = tiles:getTileOfTypes(tile.TileData.types)
				if not randomized then
					return nil
				end
				attempts += 1
			end
			if not randomThis then
				return nil
			end
			local clone = randomized.roomModel:Clone()
			clone.Parent = self._tileStorage
			local tc = Tile.new(clone, randomized)
			if tile:attachTile(tc, randomThis, self._tiles) then
				local cframe = tc._model:GetPivot()
				if cframe.X < self._config.STARTING_PART.Position.X or cframe.Z < self._config.STARTING_PART.Position.Z then
					clone:ClearAllChildren()
					clone.Parent = nil
					if maxRetries ~= 0 then
						genTile(maxRetries - 1)
					end
					return nil
				end
				local __tiles_1 = self._tiles
				local _tile_1 = tile
				local index = (table.find(__tiles_1, _tile_1) or 0) - 1 + 1
				table.insert(self._tiles, index + 1, tc)
				tile = tc
			else
				clone:ClearAllChildren()
				clone.Parent = nil
				if maxRetries ~= 0 then
					genTile(maxRetries - 1)
				end
			end
		end
		local genTileBatch = function()
			do
				local i = 0
				local _shouldIncrement = false
				while true do
					if _shouldIncrement then
						i += 1
					else
						_shouldIncrement = true
					end
					if not (i < self._config.TILES - 1) then
						break
					end
					RunService.Heartbeat:Wait()
					genTile(20)
				end
			end
		end
		local genFurthestTile
		genFurthestTile = function()
			local furthestTile = findFurthestTileFromSpecificTile(firstTile)
			if not furthestTile then
				return nil
			end
			local randomizedTile = tiles:getTileOfType(self._config.LAST_ROOM_TYPE)
			if not randomizedTile then
				return nil
			end
			local randomAttachmentPoint
			local attempts = 0
			while attempts < 2 do
				randomAttachmentPoint = getRandom(furthestTile.attachmentPoints, function(inst)
					return not inst:FindFirstChild("HasAttachment")
				end)
				if randomAttachmentPoint then
					break
				end
				attempts += 1
			end
			if not randomAttachmentPoint then
				return nil
			end
			local clone = randomizedTile.roomModel:Clone()
			clone.Parent = self._tileStorage
			local newTile = Tile.new(clone, randomizedTile)
			if furthestTile:attachTile(newTile, randomAttachmentPoint, self._tiles) then
				local index = (table.find(self._tiles, furthestTile) or 0) - 1 + 1
				table.insert(self._tiles, index + 1, newTile)
			else
				clone:ClearAllChildren()
				clone.Parent = nil
				genFurthestTile()
			end
		end
		logServer("generating " .. (tostring(self._config.TILES) .. " tiles"), "src/server/tiles/dungeon_generation.ts", 139)
		local time = benchmark(genTileBatch)
		local timeString = "generation of " .. (tostring(self._config.TILES) .. " tiles took")
		if time.minutes > 0 then
			timeString ..= " " .. (tostring(time.minutes) .. (" minute" .. (if time.minutes > 1 then "s" else "")))
		end
		if time.seconds > 0 then
			timeString ..= " " .. (tostring(time.seconds) .. (" second" .. (if time.seconds > 1 then "s" else "")))
		end
		if time.milliseconds > 0 then
			timeString ..= " " .. (tostring(time.milliseconds) .. " milliseconds")
		end
		logServer(timeString, "src/server/tiles/dungeon_generation.ts", 152)
		local furthestTime = benchmark(genFurthestTile)
		local furthestTimeString = "generation of " .. (self._config.LAST_ROOM_TYPE .. " tile type at furthest tile took")
		if furthestTime.minutes > 0 then
			furthestTimeString ..= " " .. (tostring(furthestTime.minutes) .. (" minute" .. (if furthestTime.minutes > 1 then "s" else "")))
		end
		if furthestTime.seconds > 0 then
			furthestTimeString ..= " " .. (tostring(furthestTime.seconds) .. (" second" .. (if furthestTime.seconds > 1 then "s" else "")))
		end
		if furthestTime.milliseconds > 0 then
			furthestTimeString ..= " " .. (tostring(furthestTime.milliseconds) .. " milliseconds")
		end
		logServer(furthestTimeString, "src/server/tiles/dungeon_generation.ts", 166)
	end
end
return {
	default = Generator,
}
