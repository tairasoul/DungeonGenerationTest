-- Compiled with roblox-ts v2.3.0
local function findFurthestTileFromSpecificTile(startTile, exclusions)
	if exclusions == nil then
		exclusions = {}
	end
	local visited = {}
	local furthestTile
	local maxDistance = -math.huge
	-- Coordinates of the specific XZ position
	local targetX = 43
	local targetZ = 0
	-- Depth-First Search (DFS) function
	local function dfs(currentTile, distance)
		-- Mark the current tile as visited
		local _currentTile = currentTile
		visited[_currentTile] = true
		-- Calculate the distance to the target XZ position
		local currentX = currentTile.TileData.centerPoint.Position.X
		local currentZ = currentTile.TileData.centerPoint.Position.Z
		local distanceToTargetXZ = math.sqrt((targetX - currentX) ^ 2 + (targetZ - currentZ) ^ 2)
		-- Check if the current tile's XZ position is more than 20 studs away from the target XZ position
		if distanceToTargetXZ > 20 then
			-- Update furthest tile if needed
			if distance > maxDistance then
				maxDistance = distance
				furthestTile = currentTile
			end
		end
		-- Explore neighboring tiles recursively
		for neighborTile, neighborDistance in currentTile.connections do
			if not (visited[neighborTile] ~= nil) and not (exclusions[neighborTile] ~= nil) then
				dfs(neighborTile, distance + neighborDistance)
			end
		end
	end
	-- Start DFS from the given start tile
	dfs(startTile, 0)
	return { furthestTile, maxDistance }
end
return {
	findFurthestTileFromSpecificTile = findFurthestTileFromSpecificTile,
}
