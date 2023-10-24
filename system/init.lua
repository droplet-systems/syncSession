local RunService = game:GetService("RunService")

if RunService:IsClient() then
	warn(
		"[⚠️] Attempted to deploy on the client! Did you complete the setup properly? Perhaps you should read our documentation."
	)
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local syncSession = script
local Server = syncSession.Server
local Shared = syncSession.Shared
local Private = syncSession.Private
local Client = syncSession.Client

local warn = require(Shared.Warn)

local Modules = {
	Board = require(Shared.Board),
	Trello = require(Private.Trello),
}

local AddClientScripts = function(Player)
	local PlayerGui = Player:WaitForChild("PlayerGui")

	if PlayerGui then
		if PlayerGui:FindFirstChild("sessionSync") then
			return
		end

		local Clone = Client:Clone()
		Clone.Name, Clone.Parent = "syncSession", PlayerGui
	else
		warn(
			string.format(
				"[🤔] Attempted to add client scripts to %s, but we were unable to find their PlayerGui.",
				Player.Name
			)
		)
	end
end

return function(Configuration, Boards)
	Configuration = require(Configuration)

	Shared.Name, Shared.Parent = "syncSession", ReplicatedStorage

	for _, Board in pairs(Boards:GetChildren()) do
		Modules.Board.New(Board)
		Modules.Board:ShowNoUpcoming()
	end

	Players.PlayerAdded:Connect(AddClientScripts)
	for _, Player in pairs(Players:GetPlayers()) do
		AddClientScripts(Player)
	end

	local Key = Configuration.Key
	local Token = Configuration.Token

	for _, Object in pairs(Server:GetChildren()) do
		if Object:IsA("ModuleScript") then
			local Status, Result = pcall(function()
				task.spawn(function()
					local Module = require(Object)

					if type(Module) == "function" then
						Module(syncSession, Shared, Boards, Key, Token, Configuration)
					end
				end)
			end)

			if not Status then
				warn(string.format("[🤔] Failed to require module.. %s, there was an error: %s", Object.Name, Result))
			end
		end
	end
end
