local button = require("Buttons")
local pathfinder = require("Pathfinder")
require("grids")
require("maps")

local currentMap = 1
local currentCustomMap = 1
local stat = 1
local mapToBeDrawen = maps[currentMap]
local textPosX, textPosY = 200, 63
local mapNames = {nil}
local customMapNames = {nil}
local chosenTile = "duvar"
local timer = 0
local msgTimer = 0
local overallTimer = nil
local sendMessage = {false, msg, opacity, false}
usedTiles = {nil}

local state = {
    menu = true,
    maps = false,
    mapEditor = false,
    gameRunning = false,
    gameEnded = false,
    customMaps = false
}

function checkIfUsed(x, y)
	for ind, val in pairs(usedTiles) do
		if x == val[1] and y == val[2] then
 			return val[3]
		end
	end
	return 0
end

function usedTile(x,y)
	local isTileUsed = false
	for ind, val in pairs(usedTiles) do
		if x == val[1] and y == val[2] then
 			isTileUsed = true
 			val[3] = val[3] + 1
		end
	end
	if not isTileUsed then
		table.insert(usedTiles, {x, y, 1})
	end  
end

function changeMode(val)
	for index in pairs(state) do
		if index == val then
			state[index] = true
		else
		state[index] = false
		end
	end
	if val == "customMaps" then
		stat = 2
		mapToBeDrawen = customMaps[currentCustomMap]
	end
end

function sendAMessage(text, v)
	sendMessage[1] = true
	sendMessage[2] = text
	if v then sendMessage[4] = true end
end

local function changeTheTile(tile)
	chosenTile = tile
end

local function startGame(customMap)
	if stat == 2 then customMap = true end 
	if customMap then
		if not checkMap(currentCustomMap, false, 3, true) then return end
		mapToBeDrawen = customMaps[currentCustomMap]
		findTiles(customMaps[currentCustomMap])
	else
		if not checkMap(currentMap) then return end
		mapToBeDrawen = maps[currentMap]
		findTiles(maps[currentMap])
	end

	overallTimer = 0
	changeMode("gameRunning")
end

local function showMaps()
	if state.maps then
		state.maps = false
	elseif not state.maps then
		state.maps = true
	end
end

local function changeMap(mapNum)
	stat = 1
	currentMap = mapNum
	mapToBeDrawen = maps[currentMap]
end

function love.mousepressed(x, y, button)
	if button == 1 then
		if state.maps then
			local control = nil
			for index in pairs(buttons.mapsState) do
				control = buttons.mapsState[index]:checkPressed(x, y) or false
				if control then break end
			end
			if not control then state.maps = false end
		elseif state.mapEditor then
			for index in pairs(buttons.editorState) do
				buttons.editorState[index]:checkPressed(x, y)
			end
			placeTiles(x, y, 1, chosenTile, currentCustomMap)
		elseif state.gameRunning then
			for index in pairs(buttons.gameRunningState) do
				buttons.gameRunningState[index]:checkPressed(x, y)
			end
		elseif state.gameEnded then
			for index in pairs(buttons.gameEndedState) do
				buttons.gameEndedState[index]:checkPressed(x, y)
			end				
		elseif state.menu then
			for index in pairs(buttons.menuState) do
				buttons.menuState[index]:checkPressed(x, y)
			end
		elseif state.customMaps then
			for index in pairs(buttons.customMapsState) do
				buttons.customMapsState[index]:checkPressed(x, y)
			end			
		end
	elseif button == 2 then
		if state.mapEditor then
			placeTiles(x, y, 2, nil , currentCustomMap)
		end
	end
end

local function chooseCustomMap(mapNum)
	stat = 2
	currentCustomMap = mapNum
	mapToBeDrawen = customMaps[currentCustomMap]
	loadButtons()
end

function loadButtons()
	buttons.menuState.playGame = button("BAŞLA", startGame, nil)
    buttons.menuState.maps = button("HARİTALAR", showMaps, nil)
    buttons.menuState.customMapsButton = button("OYUNCU HARİTALARI", changeMode, "customMaps")
    buttons.editorState.duvar = button("duvar", changeTheTile, "duvar", 30, 30)
    buttons.editorState.character = button(currentDirection, changeTheTile, "character", 30, 30)
    buttons.editorState.target = button("target", changeTheTile, "target", 30, 30)
    buttons.editorState.saveTheMap = button("HARİTAYI KAYDET", saveTheMap, currentCustomMap)
    buttons.editorState.back = button("GERİ", changeMode, "menu")
    buttons.gameRunningState.play = button("BAŞLA", startGame, nil)
    buttons.gameRunningState.stop = button("DURDUR", changeMode, "gameEnded")
    buttons.gameRunningState.back = button("GERİ", changeMode, "menu")
    buttons.gameEndedState.play = button("BAŞLA", startGame, nil)
    buttons.gameEndedState.stop = button("DURDUR", changeMode, "gameEnded")
    buttons.gameEndedState.back = button("GERİ", changeMode, "menu")
    buttons.mapsState.map1 = button(mapNames[1], changeMap, 1, 120, 30, "line")
    buttons.mapsState.map2 = button(mapNames[2], changeMap, 2, 120, 30, "line")
    buttons.mapsState.map3 = button(mapNames[3], changeMap, 3, 120, 30, "line")
    buttons.mapsState.map4 = button(mapNames[4], changeMap, 4, 120, 30, "line")
    buttons.mapsState.map5 = button(mapNames[5], changeMap, 5, 120, 30, "line")
    buttons.mapsState.label = button("HARİTALAR:", nil, nil, 120, 32, "line")
    buttons.customMapsState.editMap = button("HARİTAYI DÜZENLE", changeMode, "mapEditor") 
    buttons.customMapsState.back = button("GERİ", changeMode, "menu") 
    buttons.customMapsState.label = button("DÜZENLENEBİLİR HARİTALAR", nil, nil, 270) 
    buttons.customMapsState.map1 = button(customMapNames[1], chooseCustomMap, 1, 270, 20) 
    buttons.customMapsState.map2 = button(customMapNames[2], chooseCustomMap, 2, 270, 20) 
    buttons.customMapsState.map3 = button(customMapNames[3], chooseCustomMap, 3, 270, 20) 
    buttons.customMapsState.map4 = button(customMapNames[4], chooseCustomMap, 4, 270, 20) 
    buttons.customMapsState.map5 = button(customMapNames[5], chooseCustomMap, 5, 270, 20) 
    buttons.customMapsState.map6 = button(customMapNames[6], chooseCustomMap, 6, 270, 20) 
    buttons.customMapsState.map7 = button(customMapNames[7], chooseCustomMap, 7, 270, 20) 
    buttons.customMapsState.map8 = button(customMapNames[8], chooseCustomMap, 8, 270, 20) 
    buttons.customMapsState.map9 = button(customMapNames[9], chooseCustomMap, 9, 270, 20) 
    buttons.customMapsState.start = button("HARİTAYI OYNAT", startGame, true, 270, 30) 
end

function love.load()
	fotolariYukle()    
	mapNames = loadMaps()
	customMapNames = loadCustomMaps()
	loadButtons()
	copyTable()
end

function love.update(dt)
	if state.gameRunning then
		timer = timer + dt
		overallTimer = overallTimer + dt
		if overallTimer >= 60 then changeMode("gameEnded", 1) end
		if timer >= 0.15 then
			possibleMoves()
			timer = 0
		end
	elseif state.gameEnded then
		usedTiles = {nil}
	elseif state.customMaps then
		textPosY = 42+(21*currentCustomMap)
	end
	if sendMessage[1] then
		msgTimer = msgTimer + dt
		sendMessage[3] = 1-(msgTimer/3)
		if msgTimer >= 3 then
			sendMessage[1] = false
			sendMessage[4] = false
			msgTimer = 0
		end
	end
end

function love.draw()
	if state.menu then
		buttons.menuState.playGame:draw(10, 30, 45, 8)
        buttons.menuState.maps:draw(10, 70, 32, 8)
        buttons.menuState.customMapsButton:draw(10,110, 1, 8)
        if state.maps then
	        love.graphics.polygon("fill", 135, 85, 160, 70, 160, 100)
	        love.graphics.rectangle("fill", 160, 70, 120 ,182)
	        buttons.mapsState.label:draw(160, 70, 25, 8)
	        buttons.mapsState.map1:draw(160, 102, 36, 8)
	        buttons.mapsState.map2:draw(160, 132, 36, 8)
	        buttons.mapsState.map3:draw(160, 162, 36, 8)
	        buttons.mapsState.map4:draw(160, 192, 36, 8)
	        buttons.mapsState.map5:draw(160, 222, 36, 8)
	   	end
	elseif state.mapEditor then
		love.graphics.print("Seçilebilir Bloklar: ", 18 ,76)
		love.graphics.print("Yukarıdaki görsellere tıklayarak bloğu \ndeğiştirebilirsin. ", 18 ,112)
		love.graphics.print("Sol fare tuşu ile seçili bloğu yerleştirebilirsin. ", 18 ,152)
		love.graphics.print("Sağ fare tuşu ile seçili bloğu kaldırabilirsin. ", 18 ,188)
		buttons.editorState.duvar:draw(140, 70, 0, 0, 1)
		buttons.editorState.character:draw(180, 70, 0, 0, 1)
		buttons.editorState.target:draw(220, 70, 0, 0, 1)
		buttons.editorState.saveTheMap:draw(BEGINNING_POINT_X - 140, ENDING_POINT_Y - GRID_SIZE, 11, 8)
		buttons.editorState.back:draw(BEGINNING_POINT_X - 280, ENDING_POINT_Y - GRID_SIZE, 50, 8)
		drawChosenTile(chosenTile)
		showBorders()
	elseif state.gameRunning then
		buttons.gameRunningState.play:draw(10, 30, 45, 8)
		buttons.gameRunningState.stop:draw(10, 70, 39, 8)
		buttons.gameRunningState.back:draw(10, 110, 50, 8)
		love.graphics.print("Geçen Süre: "..math.floor(overallTimer).." saniye" , 10, 150)
	elseif state.gameEnded then
		buttons.gameEndedState.play:draw(10,30,45, 8)
		buttons.gameEndedState.stop:draw(10,70,39, 8)
		buttons.gameEndedState.back:draw(10, 110, 50, 8)
		if overallTimer >= 60 then
			love.graphics.print("Harita tamamlanamadı." , 10, 150)
		else
			love.graphics.print("Tamamlama Süresi: "..math.floor(overallTimer).." saniye" , 10, 150)
		end
	elseif state.customMaps then
		buttons.customMapsState.label:draw(10, 30, 47, 8)
		buttons.customMapsState.editMap:draw(BEGINNING_POINT_X - 140, ENDING_POINT_Y - GRID_SIZE, 8, 8)
		buttons.customMapsState.back:draw(BEGINNING_POINT_X - 280, ENDING_POINT_Y - GRID_SIZE, 50, 8)
		buttons.customMapsState.map1:draw(10, 61, 3, 3)
		buttons.customMapsState.map2:draw(10, 82, 3, 3)
		buttons.customMapsState.map3:draw(10, 103, 3, 3)
		buttons.customMapsState.map4:draw(10, 124, 3, 3)
		buttons.customMapsState.map5:draw(10, 145, 3, 3)
		buttons.customMapsState.map6:draw(10, 166, 3, 3)
		buttons.customMapsState.map7:draw(10, 187, 3, 3)
		buttons.customMapsState.map8:draw(10, 208, 3, 3)
		buttons.customMapsState.map9:draw(10, 229, 3, 3)
		buttons.customMapsState.start:draw(10,ENDING_POINT_Y - GRID_SIZE - 41, 88, 8)
		love.graphics.setColor(0, 0, 0)
		love.graphics.print("Seçili", textPosX, textPosY)
		love.graphics.setColor(1, 1, 1)
	end
	if sendMessage[1] == true then
		love.graphics.setColor(1, 1, 1, sendMessage[3])
		if sendMessage[4] then
			love.graphics.print(sendMessage[2], 420, 160)
		else
			love.graphics.print(sendMessage[2], 18, 246)
		end
		love.graphics.setColor(1, 1, 1)
	end
	drawMap(mapToBeDrawen)
end