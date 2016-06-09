
local function ring(...)
	local r = {
		items = {...},
		add = function(self, item)
			self.len = self.len + 1
			self.items[self.len] = item
		end,
	}
	r.i = #r.items ~= 0 and 1 or 0
	r.len = #r.items
	return setmetatable(r, {
		__call = function()
			local res = r.items[r.i]
			if r.i == r.len then
				r.i = 1
			else 
				r.i = r.i + 1
			end
			return res
		end,
	})
end