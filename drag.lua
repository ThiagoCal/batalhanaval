--boxstory 2: the reckoning

function love.load()
	
	love.graphics.setBackgroundColor( 220, 176, 233, 255)
	
	boxes = {} --setting up some boxes
	

	
	for i=1, 5 do --the individual boxes
		box = {
		width = 40,
		height = 40,
		x = 70,
		y = i*80,
		
		drag = { --drag? might not work so much.
		active = false,
		diffX = 0,
		diffY = 0}
		}
		
		table.insert(boxes, box)
				
	end
	
	bigBox = {} --big giant box properties
	
	bigBox.x = 700
	bigBox.y = 250
	bigBox.width = 100
	bigBox.height = 100

end


function love.update(dt)
	
	for i,v in ipairs(boxes) do --mouseclick drag thingy
	
		if v.drag.active then
			v.x = love.mouse.getX() - v.drag.diffX
			v.y = love.mouse.getY() - v.drag.diffY
		end
		
	end
	
end


function love.draw()
	
	--draw big box and flaps
	love.graphics.setColor( 255, 255, 255, 30)
	love.graphics.rectangle("fill", bigBox.x, bigBox.y, bigBox.width, bigBox.height)
	love.graphics.line(670, 200, 700, 250)
	love.graphics.line(670, 400, 700, 350)
	
	--draw all the small boxes	
	for i,v in ipairs(boxes) do
		love.graphics.setColor( 255, 255, 255, 95)
		love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
		
		--make the boxes highlight when little box is in big box
		if v.x > bigBox.x and v.x < bigBox.x + 100 and v.y > bigBox.y and v.y < bigBox.y + 100 then
			love.graphics.setColor( 220, 176, 233, 40)
			love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
			love.graphics.setColor( 255, 255, 255, 30)
			love.graphics.rectangle("fill", bigBox.x, bigBox.y, bigBox.width, bigBox.height)
			love.graphics.line(670, 200, 700, 250)
			love.graphics.line(670, 400, 700, 350)
		end
		
	end
	
	
end


function love.mousepressed(x, y, button)

	--make the dragging happen
	for i,v in ipairs(boxes) do
	
		if button == "l"
		and x > v.x and x < v.x+v.width
		and y > v.y and y < v.y+v.height
		then
			v.drag.active = true
			v.drag.diffX = x - v.x
			v.drag.diffY = y - v.y
		end
		
	end
end
	
	
function love.mousereleased(x, y, button)
	
	--make the dragging stop happening
	for i,v in ipairs(boxes) do
		
		if button == "l"
			then v.drag.active = false
		end
	
	end
end	


function love.keypressed(key)
	
	--quit on "q"
	if key == "escape" then
		love.event.push "q"
	end

end