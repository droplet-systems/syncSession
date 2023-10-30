local Shared = script.Parent
local Remotes = Shared.Remotes
local SendSession = Remotes.SendSession

local Templates = {
	Board = script.Board,
	Session = script.Session,
	Value = script.Value,
	Button = script.Button,
}

local Board = {
	Boards = {},
	Queue = {},
}
Board.__index = Board

function Board.New(Object: Instance)
	local Data = {
		Interface = nil,
	}

	Data.Interface = Templates.Board:Clone()
	Data.Interface.Parent = Object

	Board.Boards[Object] = Data
end

function Board:ShowSessions()
	for _, Data in pairs(Board.Boards) do
		Data.Interface.Container.Main.Visible = true
	end
end

function Board:HideSessions()
	for _, Data in pairs(Board.Boards) do
		Data.Interface.Container.Main.Visible = false
	end
end

function Board:ShowNoUpcoming()
	for _, Data in pairs(Board.Boards) do
		Data.Interface.Container.Upcoming.Visible = true
	end
end

function Board:HideNoUpcoming()
	for _, Data in pairs(Board.Boards) do
		Data.Interface.Container.Upcoming.Visible = false
	end
end

function Board:ShowError()
	for _, Data in pairs(Board.Boards) do
		Data.Interface.Container.Error.Visible = true
	end
end

function Board:HideError()
	for _, Data in pairs(Board.Boards) do
		Data.Interface.Container.Error.Visible = false
	end
end

function Board:ClearSessions()
	for _, Data in pairs(Board.Boards) do
		local Interface = Data.Interface
		local Container = Interface.Container.Main

		for _, Object in pairs(Container:GetChildren()) do
			if Object:IsA("Frame") then
				Object:Destroy()
			end
		end
	end

	Board:HideSessions()
	Board:ShowNoUpcoming()
end

function Board:NewSession(Title: string, Information: table, Labels: table, Time: string)
	Board:HideNoUpcoming()
	Board:ShowSessions()

	for _, Data in pairs(Board.Boards) do
		local Interface = Data.Interface
		local Container = Interface.Container.Main

		local Session = Templates.Session:Clone()
		local Information_Container = Session.Left.Information
		local Labels_Container = Session.Right.Labels

		for _, Table in pairs(Information) do
			local Clone = Templates.Value:Clone()
			Clone.Icon.Image = Table.Image or "rbxassetid://7072717759"
			Clone.Text.Text = Table.Value or "No <b>data</b> has been found."

			Clone.Icon.ImageColor3 = Table.ImageColor or Color3.new(0, 150, 136)

			Clone.Parent = Information_Container
		end

		for _, Table in pairs(Labels) do
			local Clone = Templates.Label:Clone()
			Clone.Title.Text = Table.LabelName or ""

			Clone.BackgroundColor3 = Table.LabelColor or Color3.new(0, 150, 136)

			Clone.Parent = Labels_Container
		end

		Session.Left.Text.Title.Text = Title or "Session"
		Session.Parent = Container

		SendSession:FireAllClients(Information_Container, Session.Right.Time.Title, Time)
	end
end

return Board
