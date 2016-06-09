
function ghost(t, ...)
	local g = {}
	local exc = {...}
	local check = {}
	for i = 1, #exc do 
		check[exc[i]] = true
	end
	for i = 1, #t do 
		if not check[i] then
			g[#g + 1] = t[i]
		end
	end
	return g
end
