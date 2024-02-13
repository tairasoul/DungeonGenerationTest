-- Compiled with roblox-ts v2.2.0
local UpgradeRegistry
do
	UpgradeRegistry = setmetatable({}, {
		__tostring = function()
			return "UpgradeRegistry"
		end,
	})
	UpgradeRegistry.__index = UpgradeRegistry
	function UpgradeRegistry.new(...)
		local self = setmetatable({}, UpgradeRegistry)
		return self:constructor(...) or self
	end
	function UpgradeRegistry:constructor(infoFolder)
		self.upgradeInfo = {}
		self._upgradeInfoFolder = infoFolder
	end
	function UpgradeRegistry:processFolder()
		local _exp = self._upgradeInfoFolder:GetDescendants()
		local _arg0 = function(v)
			return v:IsA("ModuleScript")
		end
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _length = 0
		for _k, _v in _exp do
			if _arg0(_v, _k - 1, _exp) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		for _, descendant in _newValue do
			local info = require(descendant)
			table.insert(self.upgradeInfo, info)
		end
	end
end
return {
	default = UpgradeRegistry,
}
