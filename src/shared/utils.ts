import { HttpService } from "@rbxts/services";

export function getRandom<T extends defined>(array: T[], filter: (inst: T) => boolean = () => true) {
    const filtered = array.filter(filter);
    if (filtered.size() === 0) {
        return undefined;
    }
    const random = math.random(1, filtered.size());
    return filtered[random - 1];
}

export function getDistance(vector1: Vector3, vector2: Vector3) {
    return vector1.sub(vector2);
}

export function guid() {
    return HttpService.GenerateGUID();
}