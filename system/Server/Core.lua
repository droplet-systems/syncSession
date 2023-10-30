return function(syncSession, Shared, Boards, Key, Token, Configuration)
	local Private = syncSession.Private

	local warn = require(Shared.Warn)

	local Modules = {
		Board = require(Shared.Board),
		Trello = require(Private.Trello),
	}

	-- yellow, purple, blue, red, green, orange, black, sky, pink, lime

	local Colors = {
		["yellow"] = Color3.fromRGB(255, 255, 0),
		["purple"] = Color3.fromRGB(153, 51, 255),
		["blue"] = Color3.fromRGB(0, 128, 255),
		["red"] = Color3.fromRGB(255, 0, 0),
		["green"] = Color3.fromRGB(0, 150, 136),
		["orange"] = Color3.fromRGB(255, 178, 102),
		["black"] = Color3.fromRGB(0, 0, 0),
		["sky"] = Color3.fromRGB(135, 206, 235),
		["pink"] = Color3.fromRGB(170, 109, 142),
		["lime"] = Color3.fromRGB(94, 255, 126),
	}
	local Trello = Modules.Trello.New(Key, Token)

	local Board = Trello:GetBoard(Configuration.BoardName)
	local BoardLists = Trello:GetLists()
	local List = nil

	if not (Board or BoardLists) then
		Modules.Board:ShowError()
		return
	end

	for _, Data in pairs(BoardLists) do
		if Data.name == Configuration.List then
			List = Data.id
		end
	end

	local Interval = Configuration.Wait

	if Interval < 10 then
		Interval = 10
		warn("[⚠️] Interval was below 10, this would cause throttling - interval has been automatically set to 10.")
	end

	local Run = function()
		Modules.Board:ClearSessions()

		local Cards = Trello:GetCards(List)

		for _, Card in pairs(Cards or {}) do
			local Date = Card.badges.due

			if not Date then
				continue
			end

			if Card.badges.dueComplete then
				continue
			end

			if not Card.desc then
				continue
			end

			local Description = {}
			local Labels = {}

			if Configuration.Labels == true then
				for _, Label in pairs(Card.labels or {}) do
					print(Label)
					local Name = Label.name
					local Color = Label.color
					if Name then
						table.insert(Labels, {
							LabelName = Name,
							LabelColor = Colors[Color] or Color["green"],
						})
					end
				end
			end

			for Text in string.gmatch(Card.desc, "[^\n]+") do
				local Title, Value = string.match(Text, "(.+)" .. Configuration.Seperator .. "(.+)")

				for _, Field in pairs(Configuration.Fields) do
					local Argument = Field.Argument

					local Image = Field.Image
					local GetImage = Field.GetImage

					local DescValue = Field.Value
					local GetDescValue = Field.GetText

					if Title == Argument then
						if GetImage then
							Image = GetImage(Value)
						end

						if GetDescValue then
							DescValue = GetDescValue(Value)
						else
							DescValue = string.format(DescValue, Value)
						end

						table.insert(Description, {
							Value = DescValue,
							Image = Image,
							ImageColor = Field.ImageColor,
						})
					end
				end
			end

			Modules.Board:NewSession(Card.name or "Session", Description, Labels, Date)
		end
	end

	Run()

	while true do
		task.wait(Interval)
		Run()
	end
end
