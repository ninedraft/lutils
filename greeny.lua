local list = require "list"

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
math.randomseed(os.time())
local rand = math.random
local tasks = list.list()

function addtask(task)
	tasks:append(coroutine.create(task))
end

function run()
	while true do
		for elem, _ in tasks() do
			if elem then
				coroutine.resume(elem.val)
				if coroutine.status(elem.val) == "dead" then
					elem:remove()
					print("coroutine stopped")
				end
			end
		end
	end
end

local function wait()
	local tick
	while true do
		print("tick")
		tick = os.clock()
		while os.clock() - tick < 3 do
			coroutine.yield()
		end
		print("tock")
	end
end

local function patch(src)
	return string.gsub(src, "\n", "\ncoroutine.yield()\n")
end

local function loadtask(filename)
	local file, err = io.open(filename)
	if not file then
		error(err)
	end
	local src = file:read("*a")
	if not src then
		error("can't read file" .. filename)
	end
	print(patch(src))
	addtask(assert(loadstring(patch(src)), "can't load task"))
end

--addtask(wait)
loadtask("task1.lua")

addtask(function()
	print "hello, world!"
	coroutine.yield()
	print "hello, again"
end)


run()
