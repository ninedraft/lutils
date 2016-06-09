local function newelem(v)
	return {
		next = {}, 
		prev = {}, 
		val = v,
		remove = function(elem)
			elem.prev.next = elem.next
			elem.next.prev = elem.prev
		end,
		append = function(elem, v)
			local nl = newelem(v)
			nl.prev = elem
			nl.next = elem.next
			elem.next.prev = nl
			elem.next = nl
		end,
		prepend = function(elem, v)
			local nl = newelem(v)
			nl.next = elem
			nl.prev = elem.prev
			elem.prev.next = nl
			elem.prev = nl
		end,
		}
end 

local function listfromtable(t)
	if not t then
		t = {}
	end
	local list = newelem(t[1])
	local curr = list
	if #t < 2 then 
		return list
	end
	for i = 1, #t do
		curr.next = newelem(t[i])
		curr.next.prev = curr
		curr = curr.next
	end
	return list
end

local list_meta

local function list(v)
	--newlist
	local nl = {
		head = nil,
		tail = nil,
		len = 0,
		append = function(l, v)
			if l.tail then
				l.tail:append(v)
				l.tail = l.tail.next
				l.len = l.len + 1
			else
				l.head = newelem(v)
				l.tail = l.head
				l.len = 1
			end
		end,
	}
	if v then
		nl.head = newelem(v)
		nl.tail = nl.head
		nl.len = 1
	end
	return setmetatable(nl, list_meta)
end

list_meta = {
	__concat = function(a, b)
		if type(a) ~= "table" or getmetatable(a) ~= list_meta then
			a = list(a)
		end
		if type(b) ~= "table" or getmetatable(b) ~= list_meta then
			b = list(b)
		end
		a.tail.next = b.head
		b.head.prev = a.tail
		a.len = a.len + b.len
		return a
	end,
	--iterator over list
	__call = function(l)
		return function(state)
			local elem = state.elem
			if elem.next then 
				state.elem = elem.next
				return elem, elem.val
			end 
		end, {elem = l.head} --[[state]] --, l.head --[[elem]]
	end
}


return {list = list}