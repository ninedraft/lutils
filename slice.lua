
function slice(arr, s, e)
	if not e then
		e = #arr
	end
	if s > e then
		error("start index greater than end")
	end
	local except = {}
	return setmetatable({}, {
		__index = function(sl, i)
			if (i > 0 and i <= e - s + 1) or except[i] then
				return arr[i + s - 1]
			else
				return nil
			end
		end,
		__newindex = function(sl, i, v)
			arr[i + s - 1] = v
			if not except[i] and (i < 0 or i > e - s + 1)  then
				except[i] = true
			end
		end,
		__len = function()
			return e - s + 1
		end,
	})
end


