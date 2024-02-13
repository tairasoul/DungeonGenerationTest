import Tile from '../classes/tile';

export function findFurthestTileFromSpecificTile(startTile: Tile, exclusions: Set<Tile> = new Set()): Tile | undefined {
    const visited: Set<Tile> = new Set(); // Set to track visited tiles
    let furthestTile: Tile | undefined;
    let maxDistance = -math.huge;

    // Coordinates of the specific XZ position
    const targetX = 43;
    const targetZ = 0;

    // Depth-First Search (DFS) function
    function dfs(currentTile: Tile, distance: number) {
        // Mark the current tile as visited
        visited.add(currentTile);

        // Calculate the distance to the target XZ position
        const currentX = currentTile.TileData.centerPoint.Position.X;
        const currentZ = currentTile.TileData.centerPoint.Position.Z;
        const distanceToTargetXZ = math.sqrt((targetX - currentX) ** 2 + (targetZ - currentZ) ** 2);

        // Check if the current tile's XZ position is more than 20 studs away from the target XZ position
        if (distanceToTargetXZ > 20) {
            // Update furthest tile if needed
            if (distance > maxDistance) {
                maxDistance = distance;
                furthestTile = currentTile;
            }

            // Explore neighboring tiles recursively
            for (const [neighborTile, neighborDistance] of currentTile.connections) {
                if (!visited.has(neighborTile) && !exclusions.has(neighborTile)) {
                    dfs(neighborTile, distance + neighborDistance);
                }
            }
        }
    }

    // Start DFS from the given start tile
    dfs(startTile, 0);

    return furthestTile;
}
