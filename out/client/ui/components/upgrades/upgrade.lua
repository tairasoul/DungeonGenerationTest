-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "RoactTS")
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
local function Upgrade(_param)
	local children = _param.children
	local upgradeName = _param.upgradeName
	local upgradeIcon = _param.upgradeIcon
	local upgradeDescription = _param.upgradeDescription
	local identifier = _param.identifier
	local upgradeEvent = _param.upgradeEvent
	local _attributes = {
		key = upgradeName,
		Size = UDim2.new(0, 300, 0, 570),
		BackgroundColor3 = Color3.fromRGB(87, 122, 165),
		BackgroundTransparency = 0.2,
	}
	local _children = {
		Roact.createElement("ImageButton", {
			Transparency = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 300, 0, 570),
			[Roact.Event.MouseButton1Click] = function()
				remotes.pickUpgrade:fire(identifier)
				upgradeEvent()
			end,
			key = "button",
		}),
		Roact.createElement("TextLabel", {
			Size = UDim2.new(0, 200, 0, 50),
			Position = UDim2.new(0, 50, 0, 0),
			key = "UpgradeName",
			Text = upgradeName,
			Font = Enum.Font.Sarpanch,
			BackgroundTransparency = 1,
			TextSize = 25,
			TextColor3 = Color3.fromRGB(255, 255, 255),
		}),
		Roact.createElement("TextLabel", {
			Size = UDim2.new(0, 250, 0, 100),
			Position = UDim2.new(0, 25, 0, 350),
			key = "UpgradeDescription",
			Text = upgradeDescription,
			Font = Enum.Font.Sarpanch,
			BackgroundTransparency = 1,
			TextSize = 25,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextWrapped = true,
		}),
		Roact.createElement("ImageLabel", {
			Size = UDim2.new(0, 280, 0, 280),
			Position = UDim2.new(0, 10, 0, 50),
			key = "Icon",
			Image = upgradeIcon,
			BackgroundTransparency = 1,
		}),
		Roact.createElement("UICorner", {
			key = "uicorner",
			CornerRadius = UDim.new(0, 12),
		}),
		Roact.createElement("UIStroke", {
			key = "uistroke",
			Thickness = 2,
		}),
	}
	local _length = #_children
	if children then
		for _k, _v in children do
			if type(_k) == "number" then
				_children[_length + _k] = _v
			else
				_children[_k] = _v
			end
		end
	end
	return Roact.createElement("Frame", _attributes, _children)
end
return {
	Upgrade = Upgrade,
}
