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
local getAllBeforeCondition = _utils.getAllBeforeCondition
local getRandom = _utils.getRandom
local tileStorage = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "vars", "folders").tiles
local make = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "make")
local tileRegistry = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tileRegistry").default
local folder = ServerStorage:WaitForChild("tiles")
local randomizer = RandomTileAttacher.new(folder)
local tiles = TileRandomizer.new(folder)
remotes.generateRoom:connect(function(player, roomT)
	print("received request to generate tile, generating")
	local character = player.Character or (player.CharacterAdded:Wait())
	local tile = randomizer:attachTileToPoint(character:WaitForChild("HumanoidRootPart"), roomT)
	local _tiles = tileRegistry.tiles
	local _tile = Tile.new(tile.roomModel, tile)
	table.insert(_tiles, _tile)
end)
-- todo:
-- make it so this can't generate anywhere behind the initial tile
-- otherwise it has a chance to have the first tile also be connected to a tile behind it
remotes.generateRoomWithDepth:connect(function(player, depth)
	print("received request to generate with depth " .. (tostring(depth) .. ", generating"))
	local character = player.Character or (player.CharacterAdded:Wait())
	local baseModel = randomizer:attachRandomTile(character:WaitForChild("Torso"))
	local tile = Tile.new(baseModel.roomModel, baseModel)
	local _tiles = tileRegistry.tiles
	local _tile = tile
	table.insert(_tiles, _tile)
	local function genTile()
		local randomized = tiles:getTileOfTypes(tile.TileData.types)
		if randomized == nil then
			return nil
		end
		local clone = randomized.roomModel:Clone()
		clone.Parent = tileStorage
		local tc = Tile.new(clone, randomized)
		local randomThis = getRandom(tile.attachmentPoints, function(inst)
			return not inst:FindFirstChild("HasAttachment")
		end)
		if randomThis == nil then
			clone:ClearAllChildren()
			clone.Parent = nil
			local beforeTile = getAllBeforeCondition(tileRegistry.tiles, function(item)
				return item ~= tile
			end)
			tile = beforeTile[#beforeTile - 1 + 1]
			genTile()
			return nil
		end
		if tile:attachTile(tc, randomThis) then
			tile = tc
			local _tiles_1 = tileRegistry.tiles
			local _tile_1 = tile
			table.insert(_tiles_1, _tile_1)
		else
			clone:ClearAllChildren()
			clone.Parent = nil
		end
	end
	task.spawn(function()
		do
			local i = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					i += 1
				else
					_shouldIncrement = true
				end
				if not (i < depth) then
					break
				end
				RunService.Heartbeat:Wait()
				genTile()
			end
		end
	end)
end)
remotes.clearTiles:connect(function()
	print("received request to clear tiles, clearing.")
	local children = tileStorage:GetChildren()
	print("clearing " .. (tostring(#children) .. " tiles"))
	local _arg0 = function(v)
		return v:Destroy()
	end
	for _k, _v in children do
		_arg0(_v, _k - 1, children)
	end
	table.clear(tileRegistry.tiles)
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
