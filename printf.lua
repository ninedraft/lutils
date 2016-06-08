
local format = string.format
function printf(fstring, ...)
	print(format(fstring, unpack({...})))
end
