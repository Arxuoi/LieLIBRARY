local icons = {
	home = "rbxassetid://10723407389", settings = "rbxassetid://10734950309",
	info = "rbxassetid://10723415903", search = "rbxassetid://10734943674",
	close = "rbxassetid://10747384394", check = "rbxassetid://10709790644",
	chevron = "rbxassetid://10709790948", fallback = "rbxassetid://10723345518",
}
return function(value)
	if type(value) == "number" then return "rbxassetid://" .. value end
	if type(value) ~= "string" or value == "" then return icons.fallback end
	if value:find("rbxassetid://", 1, true) or value:find("rbxthumb://", 1, true) then return value end
	return icons[string.lower(value)] or icons.fallback
end
