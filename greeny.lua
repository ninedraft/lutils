local list = require "list"
require "ghost"
require "printf"

math.randomseed(os.time())
local rand = math.random
local tasks = {}

function addtask(task)
	tasks[#tasks + 1] = coroutine.create(task)
end

function run()
	local task_len = #tasks
	local i = 1
	local err
	while true do
		i = 1
		while i <= task_len do
			err = coroutine.resume(tasks[i])
			if not err then
				print(err)
			end
			if coroutine.status(tasks[i]) == "dead" then
				tasks = ghost(tasks, i)
				task_len = task_len - 1
			end
			if task_len == 0 then
				os.exit(0)
			end
			i = i + 1
		end
	end
end

local function wait()
	local tick
	while true do
		print("tick")
		tick = os.clock()
		while os.clock() - tick < 1 do
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
	file:close()
	addtask(assert(loadstring(patch(src)), "can't load task"))
end

--addtask(wait)
loadtask("task1.lua")

addtask(function()
	print "hello, world!"
	coroutine.yield()
	print "hello, again"
end)

--addtask(wait)

run()
