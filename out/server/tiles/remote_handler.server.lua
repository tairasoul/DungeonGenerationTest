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
local getNextAfterCondition_Reverse = _utils.getNextAfterCondition_Reverse
local getRandom = _utils.getRandom
local inverseForEach = _utils.inverseForEach
local tileStorage = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "vars", "folders").tiles
local make = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "make")
local tileRegistry = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tileRegistry").default
local folder = ServerStorage:WaitForChild("tiles")
local randomizer = RandomTileAttacher.new(folder)
local tiles = TileRandomizer.new(folder)
local cameraPart = make("Part", {
	Parent = game:GetService("Workspace"),
	Anchored = true,
	Name = "cameraPart",
})
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
		local _fn = character
		local _exp = tile._model:GetPivot()
		local _vector3 = Vector3.new(0, 50, 0)
		_fn:PivotTo(_exp + _vector3)
		local _position = tile._model:GetPivot().Position
		local _vector3_1 = Vector3.new(0, 50, 0)
		cameraPart.Position = _position + _vector3_1
		local randomized = tiles:getTileOfTypes(tile.TileData.types)
		if randomized == nil then
			return nil
		end
		local randomThis = getRandom(tile.attachmentPoints, function(inst)
			return not inst:FindFirstChild("HasAttachment")
		end)
		if randomThis == nil then
			tile = getNextAfterCondition_Reverse(tileRegistry.tiles, function(item)
				return item == tile
			end)
			genTile()
			return nil
		end
		local clone = randomized.roomModel:Clone()
		clone.Parent = tileStorage
		local tc = Tile.new(clone, randomized)
		if tile:attachTile(tc, randomThis) then
			local _tiles_1 = tileRegistry.tiles
			local _tiles_2 = tileRegistry.tiles
			local _tile_1 = tile
			local _arg0 = (table.find(_tiles_2, _tile_1) or 0) - 1 + 1
			table.insert(_tiles_1, _arg0 + 1, tc)
			tile = tc
		else
			if getRandom(tile.attachmentPoints, function(inst)
				return not inst:FindFirstChild("HasAttachment")
			end) == nil then
				tile = getNextAfterCondition_Reverse(tileRegistry.tiles, function(item)
					return item == tile
				end)
			end
			clone:ClearAllChildren()
			clone.Parent = nil
			genTile()
		end
	end
	task.spawn(function()
		local startTime = os.time()
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
				print("generating tile " .. (tostring(i) .. ("/" .. tostring(depth))))
				genTile()
			end
		end
		local endTime = os.time()
		local diff = endTime - startTime
		print("generation of " .. (tostring(depth) .. (" tiles took" .. ((if diff > 60 then " " .. (tostring(math.round(diff / 60)) .. " minutes") else "") .. (if (diff % 60) ~= 0 then " " .. (tostring(diff % 60) .. " seconds") else "")))))
	end)
end)
remotes.clearTiles:connect(function()
	print("received request to clear tiles, clearing.")
	local children = tileStorage:GetChildren()
	print("clearing " .. (tostring(#children) .. " tiles"))
	task.spawn(function()
		inverseForEach(children, function(v)
			RunService.Heartbeat:Wait()
			v:Destroy()
		end)
		table.clear(tileRegistry.tiles)
	end)
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
