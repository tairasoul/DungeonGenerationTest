-- Compiled with roblox-ts v2.3.0
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
		self._targetFolder = folder
	end
	function FolderMerger:merge(...)
		local folders = { ... }
		for _, folder in folders do
			if folder then
				self:_moveChildren(folder)
				self:_destroyFolder(folder)
			end
		end
	end
	function FolderMerger:_moveChildren(folder)
		local children = folder:GetChildren()
		for _, child in children do
			child.Parent = self._targetFolder
		end
	end
	function FolderMerger:_destroyFolder(folder)
		folder:Destroy()
	end
end
return {
	default = FolderMerger,
}
