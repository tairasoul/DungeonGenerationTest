import Roact, { PropsWithChildren } from "@rbxts/roact";
import { Padding } from "../interfaces/Padding";

export function UpgradeUI({ children, Position, AnchorPoint }: Partial<PropsWithChildren<JSX.IntrinsicElement<Frame>>>) {
    const list = <uilistlayout key="uilist" Padding={new UDim(0, children && children.size() >= 3 ? 60 : 30)} FillDirection={"Horizontal"} HorizontalAlignment={children && children.size() === 3 ? "Center" : "Left"} HorizontalFlex={"SpaceEvenly"} SortOrder={"LayoutOrder"} VerticalFlex={"SpaceEvenly"}/>
    return (
        <screengui key="UpgradeUI">
            <frame AnchorPoint={AnchorPoint ?? new Vector2(0.5)} ClipsDescendants={true} Position={Position ?? new UDim2(0.5, 0, 0, 0)} Size={new UDim2(0, 1200, 0, 700)} key="MainFrame" BackgroundTransparency={0.2} BackgroundColor3={Color3.fromRGB(50, 81, 165)}>
                <textlabel Position={new UDim2(0.5, 0, 0, 0)} Size={new UDim2(0, 50, 0, 50)} TextColor3={Color3.fromRGB(255, 255, 255)} Text={"Select an upgrade."} TextSize={40} Font={Enum.Font.Sarpanch} BackgroundTransparency={1} key="uiLabel"/>
                <uicorner key="uicorner" CornerRadius={new UDim(0, 20)}/>
                <uistroke key="uistroke" Thickness={3}/>
                <scrollingframe ScrollBarThickness={0} ScrollingDirection={"X"} ClipsDescendants={false} AutomaticCanvasSize={"X"} AnchorPoint={new Vector2(0.5)} Position={new UDim2(0, 600, 0, 80)} Size={new UDim2(0, 1100, 0, 580)} key="UpgradeContainer" BackgroundTransparency={1} BorderSizePixel={0}>
                    {list}
                    <Padding key="padding" left={new UDim(0, 10)} top={new UDim(0, 2)} right={new UDim(0, 10)}/>
                    {children}
                </scrollingframe>
            </frame>
        </screengui>
    )
}