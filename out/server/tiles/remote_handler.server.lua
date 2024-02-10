-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ServerStorage = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ServerStorage
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").remotes
local RandomTileAttacher = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "random_tile_attachment").default
local Tile = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tile").default
local TileRandomizer = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "randomised.tiles").default
local getRandom = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils").getRandom
local tileStorage = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "vars", "folders").tiles
local make = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "make")
local TileParser = TS.import(script, game:GetService("ServerScriptService"), "TS", "tiles", "classes", "tileParser").default
local folder = ServerStorage:WaitForChild("tiles")
local randomizer = RandomTileAttacher.new(folder)
local tiles = TileRandomizer.new(folder)
local tStorage = {}
remotes.generateRoom:connect(function(player, roomT)
	print("received request to generate tile, generating")
	local character = player.Character or (player.CharacterAdded:Wait())
	local _tile = Tile.new(randomizer:attachTileToPoint(character:WaitForChild("HumanoidRootPart"), roomT))
	table.insert(tStorage, _tile)
end)
local allowedTilesFilter = { "Room" }
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
			local parser = TileParser.new(tile._model)
			local info = parser:getTileData()
			local randomized = tiles:getTileOfTypes(info.types)
			if randomized == nil then
				continue
			end
			local clone = randomized.roomModel:Clone()
			clone.Parent = tileStorage
			local tc = Tile.new(clone)
			local randomThis = getRandom(tile.attachmentPoints, function(inst)
				return not inst:FindFirstChild("HasAttachment")
			end)
			if randomThis == nil then
				local _arg0 = function(v)
					local _name = v._model.Name
					return table.find(allowedTilesFilter, _name) ~= nil
				end
				-- ▼ ReadonlyArray.filter ▼
				local _newValue = {}
				local _length = 0
				for _k, _v in tStorage do
					if _arg0(_v, _k - 1, tStorage) == true then
						_length += 1
						_newValue[_length] = _v
					end
				end
				-- ▲ ReadonlyArray.filter ▲
				local filtered1 = _newValue
				local _arg0_1 = function(v)
					local _attachmentPoints = v.attachmentPoints
					local _arg0_2 = function(part)
						return not part:FindFirstChild("HasAttachment")
					end
					-- ▼ ReadonlyArray.some ▼
					local _result = false
					for _k, _v in _attachmentPoints do
						if _arg0_2(_v, _k - 1, _attachmentPoints) then
							_result = true
							break
						end
					end
					-- ▲ ReadonlyArray.some ▲
					return _result
				end
				-- ▼ ReadonlyArray.filter ▼
				local _newValue_1 = {}
				local _length_1 = 0
				for _k, _v in filtered1 do
					if _arg0_1(_v, _k - 1, filtered1) == true then
						_length_1 += 1
						_newValue_1[_length_1] = _v
					end
				end
				-- ▲ ReadonlyArray.filter ▲
				local filtered = _newValue_1
				randomThis = getRandom(filtered[#filtered - 1 + 1].attachmentPoints, function(inst)
					return not inst:FindFirstChild("HasAttachment")
				end)
			end
			if randomThis == nil then
				continue
			end
			if tile:attachTile(tc, randomThis) then
				tile = tc
				table.insert(tStorage, tc)
			else
				clone:ClearAllChildren()
				clone.Parent = nil
			end
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
