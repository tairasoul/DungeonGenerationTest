-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ServerScriptService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ServerScriptService
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").remotes
local RandomTileAttacher = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "random_tile_attachment").default
local Tile = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tile").default
local TileRandomizer = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "randomised.tiles").default
local getRandom = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils").getRandom
local tileStorage = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "vars", "folders").tiles
local make = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "make")
local folder = ServerScriptService:WaitForChild("tiles")
local randomizer = RandomTileAttacher.new(folder)
local tiles = TileRandomizer.new(folder)
local tStorage = {}
remotes.generateRoom:connect(function(player, roomT)
	print("received request to generate tile, generating")
	local character = player.Character or (player.CharacterAdded:Wait())
	local _tile = Tile.new(randomizer:attachTileToPoint(character:WaitForChild("HumanoidRootPart"), roomT))
	table.insert(tStorage, _tile)
end)
remotes.generateRoomWithDepth:connect(function(player, depth)
	print("received request to generate with depth " .. (tostring(depth) .. ", generating"))
	local character = player.Character or (player.CharacterAdded:Wait())
	local baseModel = randomizer:attachRandomTile(character:WaitForChild("Torso"))
	local tile = Tile.new(baseModel)
	local _tile = tile
	table.insert(tStorage, _tile)
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
			local randomized = tiles:getRandomTile()
			if randomized == nil then
				continue
			end
			local clone = randomized:Clone()
			clone.Parent = tileStorage
			local tc = Tile.new(clone)
			local randomThis = getRandom(tile.attachmentPoints, function(inst)
				return not inst:FindFirstChild("HasAttachment")
			end)
			if randomThis == nil then
				continue
			end
			tile:attachTile(tc, randomThis)
			tile = tc
		end
	end
end)
remotes.clearTiles:connect(function()
	print("received request to clear tiles, clearing.")
	local children = tileStorage:GetChildren()
	local _arg0 = function(v)
		return v:Destroy()
	end
	for _k, _v in children do
		_arg0(_v, _k - 1, children)
	end
	table.clear(tStorage)
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
