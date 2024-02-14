-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "RoactTS")
local Padding = TS.import(script, script.Parent.Parent, "interfaces", "Padding").Padding
local function UpgradeUI(_param)
	local children = _param.children
	local Position = _param.Position
	local AnchorPoint = _param.AnchorPoint
	local _attributes = {
		key = "uilist",
	}
	local _condition = children
	if _condition then
		-- ▼ ReadonlyMap.size ▼
		local _size = 0
		for _ in children do
			_size += 1
		end
		-- ▲ ReadonlyMap.size ▲
		_condition = _size >= 3
	end
	_attributes.Padding = UDim.new(0, if _condition then 60 else 30)
	_attributes.FillDirection = "Horizontal"
	local _condition_1 = children
	if _condition_1 then
		-- ▼ ReadonlyMap.size ▼
		local _size = 0
		for _ in children do
			_size += 1
		end
		-- ▲ ReadonlyMap.size ▲
		_condition_1 = _size == 3
	end
	_attributes.HorizontalAlignment = if _condition_1 then "Center" else "Left"
	_attributes.HorizontalFlex = "SpaceEvenly"
	_attributes.SortOrder = "LayoutOrder"
	_attributes.VerticalFlex = "SpaceEvenly"
	local list = Roact.createElement("UIListLayout", _attributes)
	local _attributes_1 = {
		key = "UpgradeUI",
	}
	local _children = {}
	local _length = #_children
	local _attributes_2 = {
		AnchorPoint = AnchorPoint or Vector2.new(0.5),
		ClipsDescendants = true,
		Position = Position or UDim2.new(0.5, 0, 0, 0),
		Size = UDim2.new(0, 1200, 0, 700),
		key = "MainFrame",
		BackgroundTransparency = 0.2,
		BackgroundColor3 = Color3.fromRGB(50, 81, 165),
	}
	local _children_1 = {
		Roact.createElement("TextLabel", {
			Position = UDim2.new(0.5, 0, 0, 0),
			Size = UDim2.new(0, 50, 0, 50),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			Text = "Select an upgrade.",
			TextSize = 40,
			Font = Enum.Font.Sarpanch,
			BackgroundTransparency = 1,
			key = "uiLabel",
		}),
		Roact.createElement("UICorner", {
			key = "uicorner",
			CornerRadius = UDim.new(0, 20),
		}),
		Roact.createElement("UIStroke", {
			key = "uistroke",
			Thickness = 3,
		}),
	}
	local _length_1 = #_children_1
	local _attributes_3 = {
		ScrollBarThickness = 0,
		ScrollingDirection = "X",
		ClipsDescendants = false,
		AutomaticCanvasSize = "X",
		AnchorPoint = Vector2.new(0.5),
		Position = UDim2.new(0, 600, 0, 80),
		Size = UDim2.new(0, 1100, 0, 580),
		key = "UpgradeContainer",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}
	local _children_2 = {
		list,
		Roact.createElement(Padding, {
			key = "padding",
			left = UDim.new(0, 10),
			top = UDim.new(0, 2),
			right = UDim.new(0, 10),
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
	_children_1[_length_1 + 1] = Roact.createElement("ScrollingFrame", _attributes_3, _children_2)
	_children[_length + 1] = Roact.createElement("Frame", _attributes_2, _children_1)
	return Roact.createElement("ScreenGui", _attributes_1, _children)
end
return {
	UpgradeUI = UpgradeUI,
}
