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
		--[[
			const characterModel = this.Character.Instance as Model;
			const primary = characterModel.WaitForChild("HumanoidRootPart") as BasePart;
			const humanoid = characterModel.WaitForChild("Humanoid") as Humanoid;
			const system = healthRegistry.addHumanoid(humanoid);
			system.canTakeDamage = false;
			primary.Anchored = true;
			const lookVector = primary.CFrame.LookVector;
			const params = new RaycastParams();
			params.FilterType = Enum.RaycastFilterType.Exclude;
			params.FilterDescendantsInstances = characterModel.GetDescendants();
			let distance = new Vector3(-12, 0, -12);
			const raycastResult = Workspace.Raycast(characterModel.GetPivot().Position, lookVector.mul(distance), params);
			if (raycastResult !== undefined) {
			distance = new Vector3(-raycastResult.Distance, 0, -raycastResult.Distance);
			}
			const tweenI = new TweenInfo(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);
			const tween = TweenService.Create(primary, tweenI, {CFrame: primary.CFrame.add(lookVector.mul(distance))});
			tween.Play();
			tween.Completed.Once(() => {
			primary.Anchored = false
			task.wait(0.1);
			system.canTakeDamage = true;
			});
			this.ApplyCooldown(1);
		]]
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
		primary.Anchored = true
		local lookVector = primary.CFrame.LookVector
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = characterModel:GetDescendants()
		local distance = Vector3.new(-12, 0, -12)
		local _fn = Workspace
		local _exp = characterModel:GetPivot().Position
		local _distance = distance
		local raycastResult = _fn:Raycast(_exp, lookVector * _distance, params)
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
		end)
	end
	Dodge = SkillDecorator(Dodge) or Dodge
end
return {
	Dodge = Dodge,
}
