-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "RoactTS")
local Padding = TS.import(script, script.Parent.Parent, "interfaces", "Padding").Padding
local function UpgradeUI(_param)
	local children = _param.children
	local _children = {}
	local _length = #_children
	local _attributes = {
		AnchorPoint = Vector2.new(0.5),
		ClipsDescendants = true,
		Position = UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(0, 1200, 0, 700),
		BackgroundTransparency = 0.2,
		BackgroundColor3 = Color3.fromRGB(50, 81, 165),
	}
	local _children_1 = {
		Roact.createElement("TextLabel", {
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Text = "Select an upgrade.",
			TextSize = 25,
			BackgroundTransparency = 1,
		}),
		uicorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 20),
		}),
		uistroke = Roact.createElement("UIStroke", {
			Thickness = 3,
		}),
	}
	local _length_1 = #_children_1
	local _attributes_1 = {
		ClipsDescendants = false,
		AnchorPoint = Vector2.new(0.5),
		Position = UDim2.new(0, 600, 0, 80),
		Size = UDim2.new(0, 1100, 0, 580),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}
	local _children_2 = {
		uilist = Roact.createElement("UIListLayout", {
			FillDirection = "Horizontal",
			HorizontalAlignment = "Left",
			HorizontalFlex = "SpaceEvenly",
			SortOrder = "LayoutOrder",
			VerticalFlex = "SpaceEvenly",
		}),
		padding = Roact.createElement(Padding, {
			left = UDim.new(0, 20),
			top = UDim.new(0, 2),
			right = UDim.new(0, 20),
		}),
	}
	local _length_2 = #_children_2
	if children then
		for _k, _v in children do
			if type(_k) == "number" then
				_children_2[_length_2 + _k] = _v
			else
				_children_2[_k] = _v
			end
		end
	end
	_children_1.UpgradeContainer = Roact.createElement("Frame", _attributes_1, _children_2)
	_children.MainFrame = Roact.createElement("Frame", _attributes, _children_1)
	return Roact.createFragment({
		UpgradeUI = Roact.createElement("ScreenGui", {}, _children),
	})
end
return {
	UpgradeUI = UpgradeUI,
}
