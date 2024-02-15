import { HttpService, Players, RunService } from "@rbxts/services";
import remotes from "./remotes";

export function getRandom<T extends defined>(array: T[], filter: (inst: T) => boolean = () => true) {
    const filtered = array.filter(filter);
    if (filtered.size() === 0) {
        return undefined;
    }
    const random = math.random(1, filtered.size());
    return filtered[random - 1];
}

export function getRandomWithWeight<T extends defined>(array: T[], filter: (inst: T) => boolean = () => true, weights: number[] = []) {
    const filtered = array.filter(filter);
    if (filtered.size() === 0) {
        return undefined;
    }
    // Apply weights to the filtered array
    const weightedArray = filtered.map((element, index) => ({
        element,
        weight: weights[index] || 1 // Default weight is 1 if not provided
    }));

    // Calculate total weight
    const totalWeight = weightedArray.reduce((sum, { weight }) => sum + weight, 0);

    // Generate a random number within the total weight range
    let randomWeight = math.random(0, totalWeight);
    
    // Select an element based on weighted probability
    for (const { element, weight } of weightedArray) {
        if (randomWeight <= weight) {
            return element;
        }
        randomWeight -= weight;
    }

    // This should never happen, but just in case
    return undefined;
}

export function getAllBeforeCondition<T extends defined>(array: T[], condition: (item: T) => boolean = () => true) {
    const newArr = [];
    for (const item of array) {
        if (condition(item))
            newArr.push(item);
        else
            break;
    }
    return newArr;
}

export function inverseForEach<T extends defined>(array: T[], callback: (item: T) => void) {
    for (let i = array.size() - 1; i >= 0; i--) {
        callback(array[i]);
    }
}

export function getNextAfterCondition_Reverse<T extends defined>(array: T[], condition: (item: T) => boolean = () => true) {
    let found = false;
    for (let i = array.size() - 1; i >= 0; i--) {
        const item = array[i];
        if (found) {
            return item;
        }
        if (condition(item)) {
            found = true;
        }
    }
    return undefined; // Return undefined if no item satisfies the condition
}

export function getNextAfterCondition<T extends defined>(array: T[], condition: (item: T) => boolean = () => true) {
    let found = false;
    for (let i = 0; i < array.size() - 1; i--) {
        const item = array[i];
        if (found) {
            return item;
        }
        if (condition(item)) {
            found = true;
        }
    }
    return undefined; // Return undefined if no item satisfies the condition
}

export function getLastBeforeCondition<T extends defined>(array: T[], condition: (item: T) => boolean = () => true) {
    for (let i = array.size() - 1; i >= 0; i--) {
        const item = array[i];
        if (condition(item))
            return item;
    }
    return undefined; // Return undefined if no item satisfies the condition
}

export function benchmark(func: () => unknown) {
    const startTime = os.clock();
    func();
    const endTime = os.clock();
    const diff = endTime - startTime;
    const minutes = math.floor(diff / 60);
    const seconds = math.floor(diff % 60);
    const milliseconds = math.floor((diff - math.floor(diff)) * 1000);
    return {
        minutes,
        seconds,
        milliseconds
    };
}


export function getDistance(vector1: Vector3, vector2: Vector3) {
    return vector1.sub(vector2);
}

export function guid() {
    return HttpService.GenerateGUID();
}

export function eulerToVector(euler: LuaTuple<[number, number, number]>) {
    return new Vector3(euler[0], euler[1], euler[2])
}

export function applyOffsetRelativeToPart(part: BasePart, offsetVector: Vector3): Vector3 {
    // Get the part's orientation vector
    const orientationVector = part.CFrame.LookVector;

    // Scale the offset vector by the magnitudes of the part's orientation vectors
    const scaledOffsetVector = new Vector3(
        offsetVector.X * orientationVector.X,
        offsetVector.Y * orientationVector.Y,
        offsetVector.Z * orientationVector.Z
    );

    // Calculate the new position by adding the scaled offset to the part's position
    const newPosition = part.Position.add(scaledOffsetVector);

    return newPosition;
}

export function getAllPlayerParts() {
    const players = Players.GetPlayers();
    const parts: Part[] = [];
    for (const player of players) {
        const char = player.Character ?? player.CharacterAdded.Wait()[0];
        for (const part of char.GetDescendants().filter((v) => v.IsA("Part"))) {
            parts.push(part as Part);
        }
    }
    return parts;
}

export function logServer(str: string, srcFile: string, lineNumber: number, logType: "Warning" | "Error" | "Message" = "Message") {
    remotes.serverLog.fireAll(str, srcFile, lineNumber, logType);
}

export function reverseArray<T extends defined>(array: T[]): T[] {
    const reversedArray: T[] = [];
    for (let i = array.size() - 1; i >= 0; i--) {
        reversedArray.push(array[i]);
    }
    return reversedArray;
}

/**
 * @param chance chance% out of 100
 */

export function randomChance(chance: number) {
    const rnd = math.random(1, 100);
    return rnd <= chance
}