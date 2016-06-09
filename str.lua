local sub = string.sub
local concat = table.concat

local str_meta = {
	__index = function(s, i)
		return sub(s.str, i, i)
	end,
	__newindex = function(s, i, v)
		s.str = concat({sub(s.str, 0, i-1), v, sub(s.str, i+1)}, "")
	end,
	__tostring = function()
		return s.str
	end,
	__len = function(s)
		return #s.str
	end,
}

function str(s)
	return setmetatable({str = s}, str_meta)
end	



