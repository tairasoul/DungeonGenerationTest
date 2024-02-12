-- Compiled with roblox-ts v2.2.0
local _class
do
	local TileRegistry = setmetatable({}, {
		__tostring = function()
			return "TileRegistry"
		end,
	})
	TileRegistry.__index = TileRegistry
	function TileRegistry.new(...)
		local self = setmetatable({}, TileRegistry)
		return self:constructor(...) or self
	end
	function TileRegistry:constructor()
		self.tiles = {}
	end
	_class = TileRegistry
end
local default = _class.new()
return {
	default = default,
}
