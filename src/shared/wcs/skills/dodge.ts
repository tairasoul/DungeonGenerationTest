import { Skill, SkillDecorator } from "@rbxts/wcs";
import { TweenService, Workspace } from "@rbxts/services";
import healthRegistry from "shared/registries/healthSystem";

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
        primary.Anchored = true;
        const lookVector = primary.CFrame.LookVector;
        const params = new RaycastParams();
        params.FilterType = Enum.RaycastFilterType.Exclude;
        params.FilterDescendantsInstances = characterModel.GetDescendants();
        let distance = new Vector3(-12, 0, -12);
        const raycastResult = Workspace.Raycast(characterModel.GetPivot().Position, lookVector.mul(distance), params);
        if (raycastResult !== undefined) {
            distance = new Vector3(-raycastResult.Distance, 0, -raycastResult.Distance);
        }
        const tweenI = new TweenInfo(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);

        const tween = TweenService.Create(primary, tweenI, {CFrame: primary.CFrame.add(lookVector.mul(distance))});

        tween.Play();

        tween.Completed.Once(() => { 
            primary.Anchored = false
        });
    }
}