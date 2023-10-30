local TextService = game:GetService("TextService")

return function(_, Shared)
	local Remotes = Shared.Remotes
	local FilterText = Remotes.FilterText

	FilterText.OnServerInvoke = function(Player, Text)
		local Status, Result = pcall(function()
			return TextService:FilterStringAsync(Text, Player.UserId)
		end)

		if not Status then
			warn(
				string.format(
					"[🤔] [TextService:FilterStringAsync] Attempted to filter fields, but we were unable to. %s",
					Result
				)
			)
			return
		end

		local Status, FilteredText = pcall(function()
			return Result:GetNonChatStringForUserAsync(Player.UserId)
		end)

		if Status then
			return FilteredText
		else
			warn(
				string.format(
					"[🤔] [TextObject.GetNonChatStringForUserAsync] Attempted to filter fields, but we were unable to. %s",
					FilteredText
				)
			)
			return
		end
	end
end
