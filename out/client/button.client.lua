-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").remotes
local iris = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "iris", "out").default
iris.Init()
local num = 0
iris:Connect(function()
	iris.Window({ "tile generation test" })
	if iris.Button({ "generate tile at current position" }).clicked() then
		print("generating tile")
		remotes.generateRoom:fire()
	end
	iris.Text({ "generation with depth" })
	local numInput = iris.InputNum({ "generation depth" })
	if numInput.numberChanged() then
		num = numInput.state.number.value
	end
	if iris.Button({ "generate with depth" }).clicked() then
		print("generating with depth " .. tostring(num))
		remotes.generateRoomWithDepth:fire(num)
	end
	if iris.Button({ "clear tiles" }).clicked() then
		print("clearing tiles")
		remotes.clearTiles:fire()
	end
	iris.End()
end)
