function love.load()
	love.window.setMode(600, 900)
	-- love.graphics.setBackgroundColor(0.36, 0.57, 0.89)
	-- love.graphics.setColor(0, 0, 0)
end

function love.update()

end

-- recebe o ponto referente ao campo superior esquerdo, a quantidade
-- de quadrados da matriz, e o tamanho de cada quadrado
function drawboard(x0, y0, n, size)
	local xf = x0 + n * size - 1
	local yf = y0 + n * size - 1
	for x = x0, xf, size do
		for y = y0, yf, size do
			love.graphics.line(x, y, x, y + size)
			love.graphics.line(x, y, x + size, y)
		end
	love.graphics.line(x0, yf, xf, yf)
	love.graphics.line(xf, y0, xf, yf)
	end
end

function love.draw()
	local size = 38
	local n = 10
	local offset = 50

	local x0 = offset
	local y0 = offset
	drawboard(x0, y0, size, n)

	x0 = offset
	y0 = n * size + 2 * offset
	drawboard(x0, y0, size, n)
end


