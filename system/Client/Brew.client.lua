local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.syncSession

local warn = require(Shared.Warn)

local Remotes = Shared.Remotes
local SendSession = Remotes.SendSession
local FilterText = Remotes.FilterText

local Months = {
	[1] = "January",
	[2] = "Feburary",
	[3] = "March",
	[4] = "April",
	[5] = "May",
	[6] = "June",
	[7] = "July",
	[8] = "August",
	[9] = "September",
	[10] = "October",
	[11] = "November",
	[12] = "December",
}

SendSession.OnClientEvent:Connect(function(Information, Text, Time)
	for _, Object in pairs(Information:GetChildren()) do
		if Object:IsA("Frame") then
			local FilteredText = FilterText:InvokeServer(Object.Text.Text)
			Object.Text.Text = FilteredText
		end
	end

	print("Ico", Time)
	Time = DateTime.fromIsoDate(Time):ToLocalTime()
	print("Local", Time)

	local Minute = Time.Minute
	if Minute == 0 then
		Minute = "00"
	end

	Text.Text = string.format("%s %s\n%s:%s", Time.Day, Months[Time.Month], Time.Hour, Minute)
end)

-- os.date('%B', Time.Month)
-- Fails to work, replaced with custom system!
