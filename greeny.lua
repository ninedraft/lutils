math.randomseed(os.time())
local rand = math.random
local tasks = {}

local function ghost(t, ...)
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

local printf
do
	local format = string.format
	printf = function (fstring, ...)
		print(format(fstring, unpack({...})))
	end
end

local function addtask(task)
	tasks[#tasks + 1] = {c = coroutine.create(task), events = {}}
end

local function shuffle(arr)
	local a, b
	for i = 1, #arr do
		a = rand(#arr)
		b = rand(#arr)
		arr[a], arr[b] = arr[b], arr[a]
	end
end

local function run()
	local i = 1
	local ret 
	while true do
		i = 1
		shuffle(tasks)
		while i <= #tasks	 do
			ret = {coroutine.resume(tasks[i].c)}
			if not ret[1] then
				print(err)
			end
			if coroutine.status(tasks[i].c) == "dead" then
				tasks = ghost(tasks, i)
			end
			if #tasks == 0 then
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


