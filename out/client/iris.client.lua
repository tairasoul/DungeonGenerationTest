-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").remotes
local iris = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "iris", "out").default
local getRandom = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils").getRandom
local TileTypes = { "Hallway", "Room" }
iris.Init()
local num = 0
local currentTile = "Hallway"
iris:Connect(function()
	iris.Window({ "tile generation test" })
	iris.Tree({ "singular tile" })
	iris.Tree({ "tile selection" })
	do
		local i = 0
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				i += 1
			else
				_shouldIncrement = true
			end
			if not (i < #TileTypes) then
				break
			end
			if iris.Button({ TileTypes[i + 1] }).clicked() then
				currentTile = TileTypes[i + 1]
			end
		end
	end
	iris.End()
	if iris.Button({ "generate " .. (string.lower(currentTile) .. " at current position") }).clicked() then
		print("generating tile")
		remotes.generateRoom:fire(currentTile)
	end
	if iris.Button({ "generate random tile at current location" }).clicked() then
		print("generating random tile")
		local _fn = remotes.generateRoom
		local _arg0 = function()
			return true
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in TileTypes do
			if _arg0(_v, _k - 1, TileTypes) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		_fn:fire(getRandom(_newValue))
	end
	iris.End()
	iris.Tree({ "generation with depth" })
	num = iris.InputNum({ "generation depth" }).state.number.value
	if iris.Button({ "generate with depth" }).clicked() then
		print("generating with depth " .. tostring(num))
		remotes.generateRoomWithDepth:fire(num)
	end
	iris.End()
	iris.Tree({ "misc" })
	if iris.Button({ "clear tiles" }).clicked() then
		print("clearing tiles")
		remotes.clearTiles:fire()
	end
	if iris.Button({ "test remote" }).clicked() then
		remotes.test:fire()
	end
	iris.End()
	iris.End()
end)
