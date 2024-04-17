require("maps")

local currentMap = nil
local characterPos = nil
local targetPos = nil
currentDirection = "top"

local function findTheCharacter(map)
	for ind, val in ipairs(map) do
		for i, v in ipairs(val) do
			if v == "character" then
				return {ind, i}
			end
		end
	end
end

local function findTheTarget(map)
	for ind, val in ipairs(map) do
		for i, v in ipairs(val) do
			if v == "target" then
				return {ind, i}
			end
		end
	end
end

function moveTheCharacter(direction, x ,y)
	if direction == "right" then
		currentDirection = "right"
		currentMap[x][y] = "zemin"
		currentMap[x+1][y] = "character"
		characterPos[1] = x + 1
		usedTile(x,y)
	elseif direction == "bot" then
		currentDirection = "bot"
		currentMap[x][y] = "zemin"
		currentMap[x][y+1] = "character"
		characterPos[2] = y + 1
		usedTile(x,y)
	elseif direction == "left" then
		currentDirection = "left"
		currentMap[x][y] = "zemin"
		currentMap[x-1][y] = "character"
		characterPos[1] = x - 1
		usedTile(x,y)
	elseif direction == "top" then
		currentDirection = "top"
		currentMap[x][y] = "zemin"
		currentMap[x][y-1] = "character"
		characterPos[2] = y - 1
		usedTile(x,y)
	end
	if characterPos[1] == targetPos[1] and characterPos[2] == targetPos[2] then
		currentMap[x][y] = "zemin"
		changeMode("gameEnded")
	end
end

function possibleMoves()
	local x = characterPos[1]
	local y = characterPos[2]
	local right, bot, left, top = -5000, -5000, -5000, -5000
	local dir = nil
	if checkTheTile(currentMap, x+1, y) then
		right = 0
		right = right - checkIfUsed(x+1, y)
		if x+1 == targetPos[1] and y == targetPos[2] then
			right = right + 1
		end
	end
	if checkTheTile(currentMap, x-1,y) then
		left = 0
		left = left - checkIfUsed(x-1, y)
		if x-1 == targetPos[1] and y == targetPos[2] then
			left = left + 1
		end
	end
	if checkTheTile(currentMap, x,y+1) then
		bot = 0
		bot = bot - checkIfUsed(x, y+1)
		if x == targetPos[1] and y+1 == targetPos[2] then
			bot = bot + 1
		end
	end
	if checkTheTile(currentMap, x,y-1) then
		top = 0
		top = top - checkIfUsed(x, y-1)
		if x == targetPos[1] and y-1 == targetPos[2] then
			top = top + 1
		end
	end
	local maxVal = math.max(right,bot,left,top)
	if maxVal == right then
		dir = "right"
	elseif maxVal == bot then
		dir = "bot"
	elseif maxVal == left then
		dir = "left"
	elseif maxVal == top then
		dir = "top"
	end
	moveTheCharacter(dir, x, y)
end

function findTiles(map)
	currentMap = map
	characterPos = findTheCharacter(map) or {0, 0}
	targetPos = findTheTarget(map) or {0, 0}
end