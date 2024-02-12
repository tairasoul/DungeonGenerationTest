-- Compiled with roblox-ts v2.2.0
local ServerStorage = game:GetService("ServerStorage")
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
