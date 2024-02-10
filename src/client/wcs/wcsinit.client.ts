import { Players, ReplicatedStorage, UserInputService } from "@rbxts/services";
import { Character, CreateClient } from "@rbxts/wcs";
import { Dodge as dodge } from "shared/wcs/skills/dodge";

const client = CreateClient();
client.RegisterDirectory(ReplicatedStorage.TS.wcs.movesets);
client.RegisterDirectory(ReplicatedStorage.TS.wcs.skills);
client.RegisterDirectory(ReplicatedStorage.TS.wcs.statusEffects);
client.Start();

function getCurrentWCS_Character() {
	const characterModel = Players.LocalPlayer.Character;
	if (!characterModel) return;

	return Character.GetCharacterFromInstance_TS(characterModel);
}

UserInputService.JumpRequest.Connect(() => {
    ((Players.LocalPlayer.Character ?? Players.LocalPlayer.CharacterAdded.Wait()[0]).WaitForChild("Humanoid") as Humanoid).Jump = false;
})

UserInputService.JumpRequest.Connect(() => {
    const char = getCurrentWCS_Character();
    char?.GetSkillFromConstructor(dodge)?.Start();
})