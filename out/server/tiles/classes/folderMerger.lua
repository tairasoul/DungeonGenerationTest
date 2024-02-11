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
		self.targetFolder = folder
	end
	function FolderMerger:merge(...)
		local folders = { ... }
		for _, folder in folders do
			if folder then
				self:moveChildren(folder)
				self:destroyFolder(folder)
			end
		end
	end
	function FolderMerger:moveChildren(folder)
		local children = folder:GetChildren()
		for _, child in children do
			child.Parent = self.targetFolder
		end
	end
	function FolderMerger:destroyFolder(folder)
		folder:Destroy()
	end
end
return {
	default = FolderMerger,
}
