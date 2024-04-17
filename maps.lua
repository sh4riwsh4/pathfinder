require("mapFiles")
require("userMaps")

customMaps = {}

function drawChosenTile(tile)
	tile = tile or "duvar"
	love.graphics.print("Seçili Blok:", 20, 36)
	love.graphics.rectangle("line", 100, 30, 30, 30)
	love.graphics.draw(photos[tile], 100, 30)
end

function drawBorders(tabl)
	local stat = "zemin"
	for x = 1, MAP_LENGTH_X do
		tabl[x] = {}
		for y = 1, MAP_LENGTH_Y do
			stat = "zemin"
			if y == 1 or y == MAP_LENGTH_Y or x == 1 or x == MAP_LENGTH_X then
				stat = "duvar"
			end
			if tabl[x][y] ~= "nil" then
				tabl[x][y] = stat
			end
		end
	end
	return tabl
end

function pressedArea(x, y) 
	if x >= BEGINNING_POINT_X and x <= ENDING_POINT_X then
		if y >= BEGINNING_POINT_Y and y<= ENDING_POINT_Y then
			return true
		else
			return false
		end
	else
		return false
	end
	return false
end

function placeTiles(x, y, button, tile, mapNumber)
	if not pressedArea(x, y) then return end
	x, y = unpack(gridSystem(x, y))
	local map = customMaps[mapNumber]
	local removedTile = nil
	if button == 1 then
		if tile == "character" then
			if not checkMap(mapNumber, true, 1, true) then
				removedTile = map[x][y]
				map[x][y] = tile
			else
				sendAMessage("\tHARİTADA BİR TANE UZAY GEMİSİ\nVE BİR TANE PORTAL OLMAK ZORUNDA!")
			end
		elseif tile == "target" then
			if not checkMap(mapNumber, true, 2, true) then
				removedTile = map[x][y]
				map[x][y] = tile
			else
				sendAMessage("\tHARİTADA BİR TANE UZAY GEMİSİ\nVE BİR TANE PORTAL OLMAK ZORUNDA!")
			end
		else
			removedTile = map[x][y]
			map[x][y] = tile
		end
	elseif button == 2 then
		removedTile = map[x][y]
		map[x][y] = "zemin"
	end
end

function drawMap(map)
	local map = map
	for x, xVal in ipairs(map) do
		for y, yVal in ipairs(xVal) do
			if yVal ~= "zemin" then
				if yVal == "character" then
					love.graphics.draw(photos[currentDirection], unpack(reverseGrid(x,y)))
				else
					love.graphics.draw(photos[yVal], unpack(reverseGrid(x,y)))
				end
			end
		end
	end
end

function checkTheTile(map, x, y)
	if x >= 1 and x<= MAP_LENGTH_X then
		if y >= 1 and y <= MAP_LENGTH_Y then
			if map[x][y] ~= "duvar" then
				return true
			end
		end
	end
	return false
end

function checkMap(mapNumber , bole, ch, custom)
	local map = maps[mapNumber]
	if custom then map = customMaps[mapNumber] end
	local check1 = false
	local check2 = false
	local check3 = false
	for ind, val in ipairs(map) do
		for i, v in ipairs(val) do
			if ind == 1 or ind == MAP_LENGTH_X then
				if v == "zemin" then check3 = true end
			end
			if i == 1 or i == MAP_LENGTH_Y then
				if v == "zemin" then check3 = true end
			end
			if v == "character" then
				check1 = true
			elseif v == "target" then
				check2 = true
			end
		end
	end
	if ch == 1 then return check1 elseif ch == 2 then return check2 end
	if check3 then
		if ch == 3 then return sendAMessage("HARİTANIN KENARLARI YILDIZLARLA \n\t\t\tKAPLI OLMAK ZORUNDA!", true) end
		return sendAMessage("HARİTANIN KENARLARI YILDIZLARLA \n\t\t\tKAPLI OLMAK ZORUNDA!") 
	end
	if check1 and check2 then return true end
	if not bole then
		if ch == 3 then return sendAMessage("\tHARİTADA BİR TANE UZAY GEMİSİ\nVE BİR TANE PORTAL OLMAK ZORUNDA!", true) end
		return sendAMessage("\tHARİTADA BİR TANE UZAY GEMİSİ\nVE BİR TANE PORTAL OLMAK ZORUNDA!")
	else
		return false
	end
end

function saveTheMap(mapNumber)
	print(mapNumber)
	if not checkMap(mapNumber, false, 0, true) then return end
	file = io.open("userMaps.lua", "w")
	file:write("userMaps = {")
	for x, xVal in ipairs(customMaps) do
		file:write("\n\t["..x.."] = {")
		for i , val in ipairs(xVal) do
			file:write("\n\t\t["..i.."] = {")
			for y, yVal in ipairs(val) do
				file:write("'"..yVal.."',")
			end
			file:write("},")
		end
		file:write("\n\t\t[150] = 'Oyuncu Haritası "..x.."'")
		file:write("\n\t},")
	end
	file:write("\n}")
	file:close()
end

function copyTable()
	for ind, val in ipairs(userMaps) do
		customMaps[ind] = {}
		for i, v in ipairs(val) do
			customMaps[ind][i] = {}
			for y, va in ipairs(v) do
				customMaps[ind][i][y] = va
			end
		end
	end
end

function loadCustomMaps()
	local customMapNames = {}
	for mapNum, map in ipairs(userMaps) do
		for x in pairs(map) do				
			if x == 150 then
				table.insert(customMapNames, map[x])
			end
		end
	end
	return customMapNames
end