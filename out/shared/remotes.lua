-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _remo = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "remo", "src")
local createRemotes = _remo.createRemotes
local remote = _remo.remote
local throttleMiddleware = _remo.throttleMiddleware
local default = createRemotes({
	generateDungeon = remote(),
	clearDungeon = remote(),
	serverLog = remote(),
	upgradesAvailable = remote(),
	pickUpgrade = remote().middleware(throttleMiddleware({
		throttle = 10,
	})),
})
return {
	default = default,
}
