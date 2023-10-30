local HttpService = game:GetService("HttpService")

local sessionSync = script.Parent.Parent
local Shared = sessionSync.Shared
local warn = require(Shared.Warn)

local Trello = {}
Trello.__index = Trello

function Trello.New(Key: string, Token: string)
	local self = setmetatable({}, Trello)

	self.Board = nil
	self.Key = Key
	self.Token = Token
	self.Authorization = string.format("key=%s&token=%s", self.Key, self.Token)

	return self
end

function Trello:GetBoard(Name: string)
	local Status, Response = pcall(function()
		return HttpService:GetAsync(string.format("https://api.trello.com/1/members/me/boards?%s", self.Authorization))
	end)

	if Status and Response then
		Response = HttpService:JSONDecode(Response)

		for _, Data in pairs(Response) do
			if Data.name == Name then
				self.Board = Data.id
				return Data.id
			end
		end
	else
		warn(string.format("[Trello:GetBoard] %s", Response))
		return
	end
end

function Trello:GetLists()
	local Status, Response = pcall(function()
		return HttpService:GetAsync(
			string.format("https://api.trello.com/1/boards/%s/lists?%s", self.Board, self.Authorization)
		)
	end)

	if Status and Response then
		return HttpService:JSONDecode(Response)
	else
		warn(string.format("[Trello:GetLists] %s", Response))
		return
	end
end

function Trello:GetCards(List: string)
	local Status, Response = pcall(function()
		return HttpService:GetAsync(
			string.format("https://api.trello.com/1/lists/%s/cards?%s", List, self.Authorization)
		)
	end)

	if Status and Response then
		return HttpService:JSONDecode(Response)
	else
		warn(string.format("[Trello:GetCards] %s", tostring(Response)))
		return
	end
end

return Trello
