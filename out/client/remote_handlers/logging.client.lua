-- Compiled with roblox-ts v2.1.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
remotes.serverLog:connect(function(str, logType)
	repeat
		if logType == "Warning" then
			warn("[Server]: " .. str)
			break
		end
		if logType == "Error" then
			error("[Server]: " .. str, 0)
			break
		end
		if logType == "Message" then
			print("[Server]: " .. str)
			break
		end
	until true
end)
