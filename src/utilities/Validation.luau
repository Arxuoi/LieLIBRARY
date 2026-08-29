local Validation = {}
function Validation.config(value) return type(value) == "table" and value or {} end
function Validation.string(value, fallback) return type(value) == "string" and value or fallback end
function Validation.number(value, fallback) return type(value) == "number" and value == value and value or fallback end
function Validation.values(values)
	local output, seen = {}, {}
	if type(values) ~= "table" then return output end
	for _, value in values do
		local text = tostring(value)
		if not seen[text] then seen[text] = true; table.insert(output, text) end
	end
	return output
end
return Validation
