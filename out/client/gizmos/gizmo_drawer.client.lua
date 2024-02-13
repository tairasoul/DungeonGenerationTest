-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ceive = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "ceive-im-gizmo", "out")
local Workspace = game:GetService("Workspace")
ceive.Init()
local _class
do
	local GizmoDrawer = setmetatable({}, {
		__tostring = function()
			return "GizmoDrawer"
		end,
	})
	GizmoDrawer.__index = GizmoDrawer
	function GizmoDrawer.new(...)
		local self = setmetatable({}, GizmoDrawer)
		return self:constructor(...) or self
	end
	function GizmoDrawer:constructor()
		self.DRAW_ATTACHMENT_POINT_DIRECTION = true
		self._stoploop = false
		self:init_loop()
	end
	function GizmoDrawer:init_loop()
		self._stoploop = false
		self._loop = task.spawn(function()
			while true do
				local _value = task.wait()
				if not (_value ~= 0 and (_value == _value and _value)) then
					break
				end
				if self._stoploop then
					coroutine.yield()
					break
				end
				if self.DRAW_ATTACHMENT_POINT_DIRECTION then
					local _exp = Workspace:GetDescendants()
					local _arg0 = function(v)
						return v.Name == "AttachmentPoint"
					end
					-- ▼ ReadonlyArray.filter ▼
					local _newValue = {}
					local _length = 0
					for _k, _v in _exp do
						if _arg0(_v, _k - 1, _exp) == true then
							_length += 1
							_newValue[_length] = _v
						end
					end
					-- ▲ ReadonlyArray.filter ▲
					for _, attachmentPoint in _newValue do
						local _fn = ceive.Arrow
						local _position = attachmentPoint.Position
						local _vector3 = Vector3.new(0, 10, 0)
						local _exp_1 = _position + _vector3
						local _position_1 = attachmentPoint.Position
						local _vector3_1 = Vector3.new(0, 10, 0)
						local _lookVector = attachmentPoint.CFrame.LookVector
						local _vector3_2 = Vector3.new(10, 0, 10)
						_fn:Draw(_exp_1, _position_1 + _vector3_1 - (_lookVector * _vector3_2), 1, 1, 15)
					end
				end
			end
		end)
	end
	function GizmoDrawer:stop_loop()
		self._stoploop = true
		if self._loop then
			while coroutine.status(self._loop) ~= "suspended" do
				task.wait()
			end
			coroutine.close(self._loop)
		end
	end
	_class = GizmoDrawer
end
local default = _class.new()
return {
	default = default,
}
