-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "RoactTS")
local function Padding(_param)
	local all = _param.all
	local left = _param.left
	local right = _param.right
	local top = _param.top
	local bottom = _param.bottom
	return Roact.createElement("UIPadding", {
		PaddingLeft = left or all,
		PaddingRight = right or all,
		PaddingTop = top or all,
		PaddingBottom = bottom or all,
	})
end
return {
	Padding = Padding,
}
