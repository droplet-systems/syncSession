return function(Content)
	if not Content then
		return
	end

	warn(string.format("[syncSession] %s", Content))
end
