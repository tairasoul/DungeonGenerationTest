import Roact from "@rbxts/roact";
import { PropsWithChildren } from "@rbxts/roact";
import remotes from "shared/remotes";

interface UpgradeProps extends PropsWithChildren {
    upgradeName: string;
    upgradeIcon?: string;
    children?: Roact.Children;
    upgradeDescription?: string;
    identifier: string;
    upgradeEvent: () => unknown;
}

export function Upgrade({ children, upgradeName, upgradeIcon, upgradeDescription, identifier, upgradeEvent }: UpgradeProps) {
    return (
        <frame key={upgradeName} Size={new UDim2(0, 300, 0, 570)} BackgroundColor3={Color3.fromRGB(87, 122, 165)} BackgroundTransparency={0.2}>
            <imagebutton Transparency={1} BackgroundTransparency={1} Size={new UDim2(0, 300, 0, 570)} Event={
                {
                    MouseButton1Click: () => {
                        remotes.pickUpgrade.fire(identifier);
                        upgradeEvent();
                    }
                }
            } key="button"/>
            <textlabel Size={new UDim2(0, 200, 0, 50)} Position={new UDim2(0, 50, 0, 0)} key="UpgradeName" Text={upgradeName} Font={Enum.Font.Sarpanch} BackgroundTransparency={1} TextSize={25} TextColor3={Color3.fromRGB(255, 255, 255)}/>
            <textlabel Size={new UDim2(0, 250, 0, 100)} Position={new UDim2(0, 25, 0, 350)} key="UpgradeDescription" Text={upgradeDescription} Font={Enum.Font.Sarpanch} BackgroundTransparency={1} TextSize={25} TextColor3={Color3.fromRGB(255, 255, 255)} TextWrapped={true}/>
            <imagelabel Size={new UDim2(0, 280, 0, 280)} Position={new UDim2(0, 10, 0, 50)} key="Icon" Image={upgradeIcon} BackgroundTransparency={1}/>
            <uicorner key="uicorner" CornerRadius={new UDim(0, 12)}/>
            <uistroke key="uistroke" Thickness={2}/>
            {children}
        </frame>
    )
}