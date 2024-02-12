-- Compiled with roblox-ts v2.2.0
local function findFurthestTileFromSpecificTile(startTile)
	local visited = {}
	local furthestTile
	local maxDistance = -math.huge
	-- Depth-First Search (DFS) function
	local function dfs(currentTile, distance)
		-- Mark the current tile as visited
		local _currentTile = currentTile
		visited[_currentTile] = true
		-- Check if the current tile has available attachment points
		local _attachmentPoints = currentTile.attachmentPoints
		local _arg0 = function(point)
			return not point:FindFirstChild("HasAttachment")
		end
		-- ▼ ReadonlyArray.some ▼
		local _result = false
		for _k, _v in _attachmentPoints do
			if _arg0(_v, _k - 1, _attachmentPoints) then
				_result = true
				break
			end
		end
		-- ▲ ReadonlyArray.some ▲
		if _result then
			-- Update furthest tile if needed
			if distance > maxDistance then
				maxDistance = distance
				furthestTile = currentTile
			end
		end
		-- Explore neighboring tiles recursively
		for neighborTile, _ in currentTile.connections do
			if not (visited[neighborTile] ~= nil) then
				dfs(neighborTile, distance + currentTile.connections[neighborTile])
			end
		end
	end
	-- Start DFS from the given start tile
	dfs(startTile, 0)
	return furthestTile
end
return {
	findFurthestTileFromSpecificTile = findFurthestTileFromSpecificTile,
}
