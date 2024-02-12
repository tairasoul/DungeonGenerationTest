-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local RunService = _services.RunService
local ServerStorage = _services.ServerStorage
local tileRegistry = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tileRegistry").default
local RandomTileAttacher = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "random_tile_attachment").default
local TileRandomizer = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "randomised.tiles").default
local _utils = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils")
local benchmark = _utils.benchmark
local getNextAfterCondition_Reverse = _utils.getNextAfterCondition_Reverse
local getRandom = _utils.getRandom
local logServer = _utils.logServer
local tileStorage = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "vars", "folders").tiles
local Tile = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tile").default
local folder = ServerStorage:WaitForChild("tiles")
local randomizer = RandomTileAttacher.new(folder)
local tiles = TileRandomizer.new(folder)
local clearTilesBatch = function(children, batchSize, totalBatches)
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
	table.clear(tileRegistry.tiles)
end
local _class
do
	local Generator = setmetatable({}, {
		__tostring = function()
			return "Generator"
		end,
	})
	Generator.__index = Generator
	function Generator.new(...)
		local self = setmetatable({}, Generator)
		return self:constructor(...) or self
	end
	function Generator:constructor()
	end
	function Generator:clear()
		local children = tileStorage:GetChildren()
		local batchSize = 50
		local totalBatches = math.ceil(#children / batchSize)
		local amt = #children
		logServer("clearing " .. (tostring(#children) .. (" tiles in " .. (tostring(totalBatches) .. " batches"))))
		local time = benchmark(function()
			return clearTilesBatch(children, batchSize, totalBatches)
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
		logServer(timeString)
	end
	function Generator:generate(cfg)
		local baseModel = randomizer:attachRandomTile(cfg.STARTING_PART)
		local tile = Tile.new(baseModel.roomModel, baseModel)
		local _tiles = tileRegistry.tiles
		local _tile = tile
		table.insert(_tiles, _tile)
		logServer("generating " .. (tostring(cfg.TILES) .. " tiles"))
		local function genTile()
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
				tile = getNextAfterCondition_Reverse(tileRegistry.tiles, function(item)
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
			clone.Parent = tileStorage
			local tc = Tile.new(clone, randomized)
			if tile:attachTile(tc, randomThis) then
				local _tiles_1 = tileRegistry.tiles
				local _tile_1 = tile
				local index = (table.find(_tiles_1, _tile_1) or 0) - 1 + 1
				table.insert(tileRegistry.tiles, index + 1, tc)
				tile = tc
			else
				clone:ClearAllChildren()
				clone.Parent = nil
				genTile()
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
					if not (i < cfg.TILES - 1) then
						break
					end
					RunService.Heartbeat:Wait()
					genTile()
				end
			end
		end
		local time = benchmark(genTileBatch)
		local timeString = "generation of " .. (tostring(cfg.TILES) .. " tiles took")
		if time.minutes > 0 then
			timeString ..= " " .. (tostring(time.minutes) .. (" minute" .. (if time.minutes > 1 then "s" else "")))
		end
		if time.seconds > 0 then
			timeString ..= " " .. (tostring(time.seconds) .. (" second" .. (if time.seconds > 1 then "s" else "")))
		end
		if time.milliseconds > 0 then
			timeString ..= " " .. (tostring(time.milliseconds) .. " milliseconds")
		end
		logServer(timeString)
	end
	_class = Generator
end
local default = _class.new()
return {
	default = default,
}
