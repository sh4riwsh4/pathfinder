photos = {}
buttonItems = {}

buttons = {
    menuState = {},
    editorState = {},
    gameRunningState = {},
    gameEndedState = {},
    mapsState = {},
    customMapsState = {}
}

placableItems = {
	{"duvar", imgData , "/photos/duvar.png"},
	{"character", imgData , "/photos/character.png"},
	{"top", imgData , "/photos/top.png"},
	{"right", imgData , "/photos/right.png"},
	{"bot", imgData , "/photos/bot.png"},
	{"left", imgData , "/photos/left.png"},
	{"target", imgData , "/photos/target.png"},
}

function fotolariYukle()
	for ind, val in ipairs(placableItems) do
		photos[val[1]] = love.graphics.newImage(val[3])
	end
end

function Button(text, func, func_param, width, height, line)
    return {
        width = width or 130,
        height = height or 30,
        func = func or function() print("This button has no function attached") end,
        func_param = func_param,
        text = text or "",
        line = line or "fill",
        button_x = 0,
        button_y = 0,
        text_x = 0,
        text_y = 0,
        photo = nil,

        checkPressed = function (self, mouse_x, mouse_y, cursor_radius)
            if (mouse_x >= self.button_x) and (mouse_x <= self.button_x + self.width) then
                if (mouse_y >= self.button_y) and (mouse_y <= self.button_y + self.height) then
                    if self.func_param then
                        self.func(self.func_param)
                        return true
                    else
                        self.func()
                        return true
                    end
                end
            end
        end,

        draw = function (self, button_x, button_y, text_x, text_y, photo)
            self.button_x = button_x or self.button_x

            self.button_y = button_y or self.button_y 
        
            if text_x then
                self.text_x = text_x + self.button_x
            else
                self.text_x = self.button_x
            end
        
            if text_y then
                self.text_y = text_y + self.button_y
            else
                self.text_y = self.button_y
            end
        
            if photo then
            	love.graphics.draw(photos[self.text], self.button_x, self.button_y)
            else
                if self.line == "line" then
                    love.graphics.setColor(0, 0, 0)
                    love.graphics.rectangle(self.line, self.button_x, self.button_y, self.width, self.height)
                    love.graphics.setColor(1, 1, 1)
                end
	            love.graphics.rectangle(self.line, self.button_x, self.button_y, self.width, self.height)
	            love.graphics.setColor(0, 0, 0)
	            love.graphics.print(self.text, self.text_x, self.text_y)
	            love.graphics.setColor(1, 1, 1)
        	end
        end,
    }
end

return Button