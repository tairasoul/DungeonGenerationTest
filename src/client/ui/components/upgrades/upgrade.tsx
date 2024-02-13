import Roact from "@rbxts/roact";
import { PropsWithChildren } from "@rbxts/roact";
import remotes from "shared/remotes";

interface UpgradeProps extends PropsWithChildren {
    upgradeName: string;
    upgradeIcon?: string;
    children?: Roact.Children;
    upgradeDescription?: string;
    identifier: string;
}

export function Upgrade({ children, upgradeName, upgradeIcon, upgradeDescription, identifier }: UpgradeProps) {
    return (
        <frame Key={upgradeName} Size={new UDim2(0, 300, 0, 570)} BackgroundColor3={Color3.fromRGB(87, 122, 165)} BackgroundTransparency={0.2}>
            <textlabel Size={new UDim2(0, 200, 0, 50)} Position={new UDim2(0, 50, 0, 0)} Key="UpgradeName" Text={upgradeName} Font={Enum.Font.Sarpanch} BackgroundTransparency={1} TextSize={25} TextColor3={Color3.fromRGB(255, 255, 255)}/>
            <textlabel Size={new UDim2(0, 250, 0, 100)} Position={new UDim2(0, 25, 0, 350)} Key="UpgradeDescription" Text={upgradeDescription} Font={Enum.Font.Sarpanch} BackgroundTransparency={1} TextSize={25} TextColor3={Color3.fromRGB(255, 255, 255)} TextWrapped={true}/>
            <imagebutton Size={new UDim2(0, 280, 0, 280)} Position={new UDim2(0, 10, 0, 50)} Key="Icon" Image={upgradeIcon} Event={
                {
                    MouseButton1Click: () => {
                        remotes.pickUpgrade.fire(identifier);
                    }
                }
            }/>
            <uicorner Key="uicorner" CornerRadius={new UDim(0, 12)}/>
            <uistroke Key="uistroke" Thickness={2}/>
            {children}
        </frame>
    )
}