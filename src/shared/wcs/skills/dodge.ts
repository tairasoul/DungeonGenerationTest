import { Skill, SkillDecorator } from "@rbxts/wcs";
import { TweenService } from "@rbxts/services";

@SkillDecorator
export class Dodge extends Skill {
    protected OnStartServer() {
        const characterModel = this.Character.Instance as Model;
        const primary = characterModel.PrimaryPart as BasePart;
        primary.Anchored = true;
        const lookVector = primary.CFrame.LookVector;
        const distance = new Vector3(-10, 0, -10);
        const tweenI = new TweenInfo(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);

        const tween = TweenService.Create(primary, tweenI, {CFrame: primary.CFrame.add(lookVector.mul(distance))});

        tween.Play();

        tween.Completed.Once(() => primary.Anchored = false);

        this.ApplyCooldown(1);
    }
}