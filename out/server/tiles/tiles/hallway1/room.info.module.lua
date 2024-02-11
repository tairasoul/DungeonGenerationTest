-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ServerStorage = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ServerStorage
local _object = {
	roomType = "Hallway",
}
local _left = "roomModel"
local _result = ServerStorage:FindFirstChild("RoomModels")
if _result ~= nil then
	_result = _result:FindFirstChild("StraightHall")
end
_object[_left] = _result
local info = _object
local roomExport = info
return {
	roomExport = roomExport,
}
