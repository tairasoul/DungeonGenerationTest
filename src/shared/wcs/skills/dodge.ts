import { Skill, SkillDecorator } from "@rbxts/wcs";
import { TweenService } from "@rbxts/services";
import healthRegistry from "shared/registries/healthSystem";

@SkillDecorator
export class Dodge extends Skill {
    protected OnStartServer() {
        const characterModel = this.Character.Instance as Model;
        const primary = characterModel.PrimaryPart as BasePart;
        const humanoid = characterModel.WaitForChild("Humanoid") as Humanoid;
        const system = healthRegistry.addHumanoid(humanoid);
        system.canTakeDamage = false;
        primary.Anchored = true;
        const lookVector = primary.CFrame.LookVector;
        const distance = new Vector3(-12, 0, -12);
        const tweenI = new TweenInfo(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);

        const tween = TweenService.Create(primary, tweenI, {CFrame: primary.CFrame.add(lookVector.mul(distance))});

        tween.Play();

        tween.Completed.Once(() => { 
            primary.Anchored = false
            system.canTakeDamage = true;
        });

        this.ApplyCooldown(1);
    }
}