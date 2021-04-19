function love.load()
	love.window.setMode(350, 600)
	-- love.graphics.setBackgroundColor(0.36, 0.57, 0.89)
	-- love.graphics.setColor(0, 0, 0)
end

function love.update()

end

-- desenha um caracter centralizado na posição dada
function drawchar(c, x, y)
	love.graphics.print(c, x, y, 0, 2, 2, 4, 8)
end


-- recebe o ponto referente ao campo superior esquerdo, a quantidade
-- de quadrados da matriz, e o tamanho de cada quadrado
function drawboard(x0, y0, n, size)
	local board = {}
	local xf = x0 + n * size
	local yf = y0 + n * size
	local alpha = {"A", "B", "C", "D", "E"}
	local x = x0
	local y = y0

	for i = 1, n do
		board[i] = {}
		for j = 1, n do
			-- x = x + size
			-- y = y + size
			x = x0 + (i - 1) * size
			y = y0 + (j - 1) * size

			love.graphics.line(x, y, x, y + size)
			love.graphics.line(x, y, x + size, y)
			local pos = {
				{x = x       , y = y       },
				{x = x       , y = y + size},
				{x = x + size, y = y + size},
				{x = x + size, y = y       },
			}
			pos.c = {
				x = x + size/2,
				y = y + size/2,
			}
			table.insert(board[i], pos)


			if i == 1 and j == 1 then
				drawchar("*", board[i][j].c.x, board[i][j].c.y)
			elseif i == 1 then
				drawchar(j - 1, board[i][j].c.x, board[i][j].c.y)
			elseif j == 1 then
				drawchar(alpha[i - 1], board[i][j].c.x, board[i][j].c.y)
			end

		end
		love.graphics.line(x0, yf, xf, yf)
		love.graphics.line(xf, y0, xf, yf)
	end

	return board
end

function love.draw()
	local size = 38
	local n = 6
	local offset = 50

	-- desenha o primeiro tabuleiro
	local x0 = offset
	local y0 = offset
	local board = drawboard(x0, y0, n, size)

	-- desenha o segundo tabuleiro
	x0 = offset
	y0 = n * size + 2 * offset
	drawboard(x0, y0, n, size)
end


