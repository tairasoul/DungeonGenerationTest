-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _remo = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "remo", "src")
local createRemotes = _remo.createRemotes
local remote = _remo.remote
local remotes = createRemotes({
	async = remote(),
})
return {
	remotes = remotes,
}
