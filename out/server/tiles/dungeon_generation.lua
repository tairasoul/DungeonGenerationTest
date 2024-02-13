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
local _fusion = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "fusion", "src")
local Observer = _fusion.Observer
local Value = _fusion.Value
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
		self._hasGenerated = Value(false)
		self._generated = Observer(self._hasGenerated)
		self._generatedListeners = {}
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
	function Generator:addGeneratedListener(callback)
		local __generatedListeners = self._generatedListeners
		local _arg0 = {
			callback = callback,
			destroy = self._generated:onChange(callback),
		}
		table.insert(__generatedListeners, _arg0)
	end
	function Generator:removeGeneratedListener(callback)
		local __generatedListeners = self._generatedListeners
		local _arg0 = function(v)
			return v.callback == callback
		end
		-- ▼ ReadonlyArray.find ▼
		local _result
		for _i, _v in __generatedListeners do
			if _arg0(_v, _i - 1, __generatedListeners) == true then
				_result = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		local found = _result
		if not found then
			error("Listener not found for Generated observer.")
		end
		found.destroy()
		local __generatedListeners_1 = self._generatedListeners
		local _arg0_1 = function(v)
			return v.callback ~= callback
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in __generatedListeners_1 do
			if _arg0_1(_v, _k - 1, __generatedListeners_1) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		self._generatedListeners = _newValue
	end
	function Generator:removeListeners()
		local __generatedListeners = self._generatedListeners
		local _arg0 = function(v)
			return v.destroy()
		end
		for _k, _v in __generatedListeners do
			_arg0(_v, _k - 1, __generatedListeners)
		end
		table.clear(self._generatedListeners)
	end
	function Generator:clear()
		local children = self._tileStorage:GetChildren()
		local batchSize = 50
		local totalBatches = math.ceil(#children / batchSize)
		local amt = #children
		logServer("clearing " .. (tostring(#children) .. (" tiles in " .. (tostring(totalBatches) .. " batches"))), "src/server/tiles/dungeon_generation.ts", 65)
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
		logServer(timeString, "src/server/tiles/dungeon_generation.ts", 77)
		self._hasGenerated:set(false)
	end
	function Generator:generate()
		local baseModel = randomizer:attachTileToPoint(self._config.STARTING_PART, self._config.INITIAL_TILE_TYPE, self._tileStorage)
		local tile = Tile.new(baseModel)
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
			randomized.roomModel = clone
			clone.Parent = self._tileStorage
			local tc = Tile.new(randomized)
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
		genFurthestTile = function(exclusions)
			if exclusions == nil then
				exclusions = {}
			end
			local furthestTile = findFurthestTileFromSpecificTile(firstTile, exclusions)
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
				-- Create a new set with the updated exclusions including the current furthest tile
				local newExclusions = {}
				local _exclusions = exclusions
				local _arg0 = function(v)
					local _v = v
					newExclusions[_v] = true
					return newExclusions
				end
				for _v in _exclusions do
					_arg0(_v, _v, _exclusions)
				end
				newExclusions[furthestTile] = true
				-- Call genFurthestTile again with the updated exclusions set
				genFurthestTile(newExclusions)
				return nil
			end
			local clone = randomizedTile.roomModel:Clone()
			randomizedTile.roomModel = clone
			clone.Parent = self._tileStorage
			local newTile = Tile.new(randomizedTile)
			if furthestTile:attachTile(newTile, randomAttachmentPoint, self._tiles) then
				local index = (table.find(self._tiles, furthestTile) or 0) - 1 + 1
				table.insert(self._tiles, index + 1, newTile)
			else
				logServer("failed to generate tile at furthest tile, retrying", "src/server/tiles/dungeon_generation.ts", 165)
				clone:ClearAllChildren()
				clone.Parent = nil
				-- Create a new set with the updated exclusions including the current furthest tile
				local newExclusions = {}
				local _exclusions = exclusions
				local _arg0 = function(v)
					local _v = v
					newExclusions[_v] = true
					return newExclusions
				end
				for _v in _exclusions do
					_arg0(_v, _v, _exclusions)
				end
				newExclusions[furthestTile] = true
				-- Call genFurthestTile again with the updated exclusions set
				genFurthestTile(newExclusions)
			end
		end
		logServer("generating " .. (tostring(self._config.TILES) .. " tiles"), "src/server/tiles/dungeon_generation.ts", 179)
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
		logServer(timeString, "src/server/tiles/dungeon_generation.ts", 192)
		logServer("generating tile at furthest tile, with type " .. self._config.LAST_ROOM_TYPE, "src/server/tiles/dungeon_generation.ts", 194)
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
		logServer(furthestTimeString, "src/server/tiles/dungeon_generation.ts", 207)
		self._hasGenerated:set(true)
	end
end
return {
	default = Generator,
}
