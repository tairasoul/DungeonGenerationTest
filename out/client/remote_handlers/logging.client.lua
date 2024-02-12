-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local remotes = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "remotes").default
remotes.serverLog:connect(function(str, filePath, lineNumber, logType)
	repeat
		if logType == "Warning" then
			warn("[" .. (filePath .. (":" .. (tostring(lineNumber) .. ("]: " .. str)))))
			break
		end
		if logType == "Error" then
			error("[" .. (filePath .. (":" .. (tostring(lineNumber) .. ("]: " .. str)))), 0)
			break
		end
		if logType == "Message" then
			print("[" .. (filePath .. (":" .. (tostring(lineNumber) .. ("]: " .. str)))))
			break
		end
	until true
end)
