import Roact, { PropsWithChildren } from "@rbxts/roact";
import { Padding } from "../interfaces/Padding";

interface UIProps extends PropsWithChildren {
    children?: Roact.Children
}

export function UpgradeUI({ children }: UIProps) {
    return (
        <screengui Key="UpgradeUI">
            <frame AnchorPoint={new Vector2(0.5)} ClipsDescendants={true} Position={new UDim2(0.5, 0, 0, 0)} Size={new UDim2(0, 1200, 0, 700)} Key="MainFrame" BackgroundTransparency={0.2} BackgroundColor3={Color3.fromRGB(50, 81, 165)}>
                <textlabel TextColor3={Color3.fromRGB(255, 255, 255)} Text={"Select an upgrade."} TextSize={25} BackgroundTransparency={1}/>
                <uicorner Key="uicorner" CornerRadius={new UDim(0, 20)}/>
                <uistroke Key="uistroke" Thickness={3}/>
                <frame ClipsDescendants={false} AnchorPoint={new Vector2(0.5)} Position={new UDim2(0, 600, 0, 80)} Size={new UDim2(0, 1100, 0, 580)} Key="UpgradeContainer" BackgroundTransparency={1} BorderSizePixel={0}>
                    <uilistlayout Key="uilist" FillDirection={"Horizontal"} HorizontalAlignment={"Left"} HorizontalFlex={"SpaceEvenly"} SortOrder={"LayoutOrder"} VerticalFlex={"SpaceEvenly"}/>
                    <Padding Key="padding" left={new UDim(0, 20)} top={new UDim(0, 2)} right={new UDim(0, 20)}/>
                    {children}
                </frame>
            </frame>
        </screengui>
    )
}