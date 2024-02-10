-- Compiled with roblox-ts v2.1.0
local FolderMerger
do
	FolderMerger = setmetatable({}, {
		__tostring = function()
			return "FolderMerger"
		end,
	})
	FolderMerger.__index = FolderMerger
	function FolderMerger.new(...)
		local self = setmetatable({}, FolderMerger)
		return self:constructor(...) or self
	end
	function FolderMerger:constructor(folder)
		self._folder = folder
	end
	function FolderMerger:merge(...)
		local folders = { ... }
		for _, folder in folders do
			if folder ~= nil then
				for _1, child in folder:GetChildren() do
					child.Parent = self._folder
				end
				folder:Destroy()
			end
		end
	end
end
return {
	default = FolderMerger,
}
