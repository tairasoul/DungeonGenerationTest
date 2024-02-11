-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ServerStorage = _services.ServerStorage
local RunService = _services.RunService
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").remotes
local RandomTileAttacher = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "random_tile_attachment").default
local Tile = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tile").default
local TileRandomizer = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "randomised.tiles").default
local _utils = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils")
local benchmark = _utils.benchmark
local getNextAfterCondition_Reverse = _utils.getNextAfterCondition_Reverse
local getRandom = _utils.getRandom
local tileStorage = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "vars", "folders").tiles
local make = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "make")
local tileRegistry = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tileRegistry").default
local folder = ServerStorage:WaitForChild("tiles")
local randomizer = RandomTileAttacher.new(folder)
local tiles = TileRandomizer.new(folder)
local getCharacter = function(player)
	return player.Character or (player.CharacterAdded:Wait())
end
remotes.generateRoom:connect(function(player, roomT)
	print("received request to generate tile, generating")
	local character = getCharacter(player)
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	local tile = randomizer:attachTileToPoint(humanoidRootPart, roomT)
	local _tiles = tileRegistry.tiles
	local _tile = Tile.new(tile.roomModel, tile)
	table.insert(_tiles, _tile)
end)
-- todo:
-- make it so this can't generate anywhere behind the initial tile
-- otherwise it has a chance to have the first tile also be connected to a tile behind it
remotes.generateRoomWithDepth:connect(function(player, depth)
	local character = getCharacter(player)
	local humanoidRootPart = character:WaitForChild("Torso")
	humanoidRootPart.Anchored = true
	local baseModel = randomizer:attachRandomTile(humanoidRootPart)
	local tile = Tile.new(baseModel.roomModel, baseModel)
	local _tiles = tileRegistry.tiles
	local _tile = tile
	table.insert(_tiles, _tile)
	print("generating " .. (tostring(depth) .. " tiles"))
	local function genTile()
		local _exp = tile._model:GetPivot()
		local _vector3 = Vector3.new(0, 100, 0)
		humanoidRootPart.CFrame = _exp + _vector3
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
				if not (i < depth - 1) then
					break
				end
				RunService.Heartbeat:Wait()
				genTile()
			end
		end
	end
	local time = benchmark(genTileBatch)
	local timeString = "generation of " .. (tostring(depth) .. " tiles took")
	if time.minutes > 0 then
		timeString ..= " " .. (tostring(time.minutes) .. (" minute" .. (if time.minutes > 1 then "s" else "")))
	end
	if time.seconds > 0 then
		timeString ..= " " .. (tostring(time.seconds) .. (" second" .. (if time.seconds > 1 then "s" else "")))
	end
	if time.milliseconds > 0 then
		timeString ..= " " .. (tostring(time.milliseconds) .. " milliseconds")
	end
	print(timeString)
	humanoidRootPart.Anchored = false
end)
-- Reuse children array and batch size
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
remotes.clearTiles:connect(function()
	local children = tileStorage:GetChildren()
	local batchSize = 50
	local totalBatches = math.ceil(#children / batchSize)
	local amt = #children
	print("clearing " .. (tostring(#children) .. (" tiles in " .. (tostring(totalBatches) .. " batches"))))
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
	print(timeString)
end)
remotes.test:connect(function(player)
	print("test remote called")
	local char = player.Character or (player.CharacterAdded:Wait())
	local hrp = char:WaitForChild("HumanoidRootPart")
	local part = make("Part", {
		Anchored = true,
		Parent = tileStorage,
	})
	local lookVector = hrp.CFrame.LookVector
	local offset = Vector3.new(10, 0, 20)
	local _position = hrp.Position
	local _arg0 = lookVector * offset
	part.Position = _position + _arg0
end)
