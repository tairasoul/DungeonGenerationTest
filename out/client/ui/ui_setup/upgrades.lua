-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Roact = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "RoactTS")
local UpgradeUI = TS.import(script, script.Parent.Parent, "components", "upgrades", "upgrade_ui").UpgradeUI
local Upgrade = TS.import(script, script.Parent.Parent, "components", "upgrades", "upgrade").Upgrade
local function Upgrades(props)
	local elems = {}
	local _result = props
	if _result ~= nil then
		_result = _result.upgrades
	end
	local _condition = _result
	if _condition == nil then
		_condition = {}
	end
	for _, upgrade in _condition do
		local _arg0 = Roact.createElement(Upgrade, {
			upgradeName = upgrade.name,
			upgradeDescription = upgrade.description,
			identifier = upgrade.identifier,
			upgradeIcon = upgrade.icon,
		})
		table.insert(elems, _arg0)
	end
	local _children = {}
	local _length = #_children
	for _k, _v in elems do
		_children[_length + _k] = _v
	end
	return Roact.createElement(UpgradeUI, {}, _children)
end
return {
	Upgrades = Upgrades,
}
