import Tile from '../classes/tile';

export function findFurthestTileFromSpecificTile(startTile: Tile): Tile | undefined {
    const visited: Set<Tile> = new Set(); // Set to track visited tiles
    let furthestTile: Tile | undefined;
    let maxDistance = -math.huge;

    // Depth-First Search (DFS) function
    function dfs(currentTile: Tile, distance: number) {
        // Mark the current tile as visited
        visited.add(currentTile);

        // Check if the current tile has available attachment points
        if (currentTile.attachmentPoints.some(point => !point.FindFirstChild("HasAttachment"))) {
            // Update furthest tile if needed
            if (distance > maxDistance) {
                maxDistance = distance;
                furthestTile = currentTile;
            }
        }

        // Explore neighboring tiles recursively
        for (const [neighborTile, _] of currentTile.connections) {
            if (!visited.has(neighborTile)) {
                dfs(neighborTile, distance + currentTile.connections.get(neighborTile)!);
            }
        }
    }

    // Start DFS from the given start tile
    dfs(startTile, 0);

    return furthestTile;
}