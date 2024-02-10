import { Players, ReplicatedStorage } from "@rbxts/services";
import { Character, CreateServer } from "@rbxts/wcs";
import main from "shared/wcs/movesets/main";

const server = CreateServer();
server.RegisterDirectory(ReplicatedStorage.TS.wcs.movesets);
server.RegisterDirectory(ReplicatedStorage.TS.wcs.skills);
server.RegisterDirectory(ReplicatedStorage.TS.wcs.statusEffects);
server.Start();

Players.PlayerAdded.Connect((player) => {
    player.CharacterAdded.Connect((model) => {
        const wcs = new Character(model);
        wcs.ApplyMoveset(main);

        (model.WaitForChild("Humanoid") as Humanoid).Died.Once(() => wcs.Destroy());
    })
})