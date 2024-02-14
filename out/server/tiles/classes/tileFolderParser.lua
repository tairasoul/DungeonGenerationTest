-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local make = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "make")
local tileFolderParser
do
	tileFolderParser = setmetatable({}, {
		__tostring = function()
			return "tileFolderParser"
		end,
	})
	tileFolderParser.__index = tileFolderParser
	function tileFolderParser.new(...)
		local self = setmetatable({}, tileFolderParser)
		return self:constructor(...) or self
	end
	function tileFolderParser:constructor(folder)
		self._folder = folder
		self:_assignTypes()
	end
	function tileFolderParser:getTypes()
		local types = {}
		for _, typeN in self._folder:GetChildren() do
			local _name = typeN.Name
			table.insert(types, _name)
		end
		return types
	end
	function tileFolderParser:_assignTypes()
		for _, typeF in self._folder:GetChildren() do
			for _1, room in typeF:GetChildren() do
				make("StringValue", {
					Name = "RoomType",
					Value = typeF.Name,
					Parent = room,
				})
			end
		end
	end
	function tileFolderParser:getRoomsOfType(roomType)
		local roomFolder = self._folder:FindFirstChild(roomType)
		if not roomFolder then
			error(`Folder for RoomType {roomType} not found.`)
		end
		return roomFolder:GetChildren()
	end
	function tileFolderParser:getRoomsOfTypes(roomTypes)
		local rooms = {}
		for _, room in roomTypes do
			local children = self:getRoomsOfType(room)
			for _1, child in children do
				table.insert(rooms, child)
			end
		end
		return rooms
	end
end
return {
	default = tileFolderParser,
}
