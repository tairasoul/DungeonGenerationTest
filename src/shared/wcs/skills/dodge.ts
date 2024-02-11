import { Skill, SkillDecorator } from "@rbxts/wcs";
import { TweenService, Workspace } from "@rbxts/services";
import healthRegistry from "shared/registries/healthSystem";
import { getAllPlayerParts } from "shared/utils";

@SkillDecorator
export class Dodge extends Skill {
    protected OnStartServer() {
        const characterModel = this.Character.Instance as Model;
        const humanoid = characterModel.WaitForChild("Humanoid") as Humanoid;
        const system = healthRegistry.addHumanoid(humanoid);
        system.canTakeDamage = false;
        task.wait(0.4);
        system.canTakeDamage = true;
        this.ApplyCooldown(1);
    }

    protected OnStartClient(StarterParams: void) {
        const characterModel = this.Character.Instance as Model;
        const primary = characterModel.WaitForChild("HumanoidRootPart") as BasePart;
        const lookVector = primary.CFrame.LookVector;

        const params = new RaycastParams();
        params.FilterType = Enum.RaycastFilterType.Exclude;
        params.FilterDescendantsInstances = getAllPlayerParts();

        const initialRaycastCheck = Workspace.Blockcast(
            characterModel.GetPivot().add(lookVector.mul(new Vector3(2, 0, 2))),
            characterModel.GetBoundingBox()[1],
            lookVector.mul(new Vector3(-2.5, 0, -2.5)),
            params
        );

        if (initialRaycastCheck === undefined) {
            primary.Anchored = true;

            let distance = new Vector3(-12, 0, -12);
            const raycastResult = Workspace.Blockcast(characterModel.GetPivot(), characterModel.GetBoundingBox()[1], lookVector.mul(distance), params);
            if (raycastResult !== undefined) {
                distance = new Vector3(-raycastResult.Distance, 0, -raycastResult.Distance);
            }

            const tweenInfo = new TweenInfo(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
            const targetPosition = primary.CFrame.add(lookVector.mul(distance));
            const tween = TweenService.Create(primary, tweenInfo, { CFrame: targetPosition });

            tween.Play();
            tween.Completed.Once(() => { 
                primary.Anchored = false;
            });
        }
    }
}
