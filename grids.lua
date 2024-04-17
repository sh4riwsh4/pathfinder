SCREEN_WIDTH = love.graphics.getWidth()
SCREN_HEIGHT = love.graphics.getHeight()
GRID_SIZE = 30
MAP_LENGTH_X = 16
MAP_LENGTH_Y = 10
ENDING_POINT_X = SCREEN_WIDTH - GRID_SIZE
ENDING_POINT_Y = SCREN_HEIGHT - GRID_SIZE
BEGINNING_POINT_X = ENDING_POINT_X - (MAP_LENGTH_X*GRID_SIZE)
BEGINNING_POINT_Y = GRID_SIZE

function showBorders()
	for x = BEGINNING_POINT_X, ENDING_POINT_X, GRID_SIZE do
		love.graphics.setColor(1, 1, 1)
		love.graphics.line(x, BEGINNING_POINT_Y, x, ENDING_POINT_Y)
	end
	for y = BEGINNING_POINT_Y, ENDING_POINT_Y, GRID_SIZE do
		love.graphics.setColor(1, 1, 1)
		love.graphics.line(BEGINNING_POINT_X, y, ENDING_POINT_X, y)
	end	
end

function gridSystem(x, y)
	local xPos = x
	local yPos = y
	if (xPos <= ENDING_POINT_X) and (xPos >= BEGINNING_POINT_X) and (yPos <= ENDING_POINT_Y) and (yPos >= BEGINNING_POINT_Y) then
		xPos = x - BEGINNING_POINT_X
		yPos = y - BEGINNING_POINT_Y
		xPos = math.ceil(xPos / GRID_SIZE) 
		yPos = math.ceil(yPos / GRID_SIZE)
		return {xPos, yPos}
	else
		return {-1, -1}
	end
end

function reverseGrid(x, y)
	local startingPointX = BEGINNING_POINT_X
	local startingPointY = BEGINNING_POINT_Y

	return {startingPointX + (GRID_SIZE * (x - 1)), startingPointY + (GRID_SIZE * (y - 1))}
end

