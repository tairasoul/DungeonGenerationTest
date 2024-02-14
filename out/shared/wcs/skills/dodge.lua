-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _wcs = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "wcs", "out")
local Skill = _wcs.Skill
local SkillDecorator = _wcs.SkillDecorator
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local healthRegistry = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "registries", "healthSystem").default
local getAllPlayerParts = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "utils").getAllPlayerParts
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
		local humanoid = characterModel:WaitForChild("Humanoid")
		local system = healthRegistry:addHumanoid(humanoid)
		system.canTakeDamage = false
		task.wait(0.4)
		system.canTakeDamage = true
		self:ApplyCooldown(1)
	end
	function Dodge:OnStartClient(StarterParams)
		local characterModel = self.Character.Instance
		local primary = characterModel:WaitForChild("HumanoidRootPart")
		local lookVector = primary.CFrame.LookVector
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = getAllPlayerParts()
		local _fn = Workspace
		local _exp = characterModel:GetPivot()
		local _vector3 = Vector3.new(2, 0, 2)
		local _arg0 = lookVector * _vector3
		local _exp_1 = _exp + _arg0
		local _exp_2 = (select(2, characterModel:GetBoundingBox()))
		local _vector3_1 = Vector3.new(-2.5, 0, -2.5)
		local initialRaycastCheck = _fn:Blockcast(_exp_1, _exp_2, lookVector * _vector3_1, params)
		if initialRaycastCheck == nil then
			primary.Anchored = true
			local distance = Vector3.new(-12, 0, -12)
			local _fn_1 = Workspace
			local _exp_3 = characterModel:GetPivot()
			local _exp_4 = (select(2, characterModel:GetBoundingBox()))
			local _distance = distance
			local raycastResult = _fn_1:Blockcast(_exp_3, _exp_4, lookVector * _distance, params)
			if raycastResult ~= nil then
				distance = Vector3.new(-raycastResult.Distance, 0, -raycastResult.Distance)
			end
			local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
			local _cFrame = primary.CFrame
			local _distance_1 = distance
			local _arg0_1 = lookVector * _distance_1
			local targetPosition = _cFrame + _arg0_1
			local tween = TweenService:Create(primary, tweenInfo, {
				CFrame = targetPosition,
			})
			tween:Play()
			tween.Completed:Once(function()
				primary.Anchored = false
			end)
		end
	end
	Dodge = SkillDecorator(Dodge) or Dodge
end
return {
	Dodge = Dodge,
}
