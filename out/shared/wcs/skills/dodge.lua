-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _wcs = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "wcs", "out")
local Skill = _wcs.Skill
local SkillDecorator = _wcs.SkillDecorator
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local TweenService = _services.TweenService
local Workspace = _services.Workspace
local healthRegistry = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "registries", "healthSystem").default
local Dodge
do
	local super = Skill
	Dodge = setmetatable({}, {
		__tostring = function()
			return "Dodge"
		end,
		__index = super,
	})
	Dodge.__index = Dodge
	function Dodge.new(...)
		local self = setmetatable({}, Dodge)
		return self:constructor(...) or self
	end
	function Dodge:constructor(...)
		super.constructor(self, ...)
	end
	function Dodge:OnStartServer()
		local characterModel = self.Character.Instance
		local primary = characterModel:WaitForChild("HumanoidRootPart")
		local humanoid = characterModel:WaitForChild("Humanoid")
		local system = healthRegistry:addHumanoid(humanoid)
		system.canTakeDamage = false
		primary.Anchored = true
		local lookVector = primary.CFrame.LookVector
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = characterModel:GetDescendants()
		local distance = Vector3.new(-12, 0, -12)
		local _fn = Workspace
		local _exp = characterModel:GetPivot()
		local _exp_1 = (select(2, characterModel:GetBoundingBox()))
		local _distance = distance
		local raycastResult = _fn:Blockcast(_exp, _exp_1, lookVector * _distance, params)
		if raycastResult ~= nil then
			distance = Vector3.new(-raycastResult.Distance, 0, -raycastResult.Distance)
		end
		local tweenI = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		local _fn_1 = TweenService
		local _object = {}
		local _left = "CFrame"
		local _cFrame = primary.CFrame
		local _distance_1 = distance
		local _arg0 = lookVector * _distance_1
		_object[_left] = _cFrame + _arg0
		local tween = _fn_1:Create(primary, tweenI, _object)
		tween:Play()
		tween.Completed:Once(function()
			primary.Anchored = false
			task.wait(0.1)
			system.canTakeDamage = true
		end)
		self:ApplyCooldown(1)
	end
	Dodge = SkillDecorator(Dodge) or Dodge
end
return {
	Dodge = Dodge,
}
