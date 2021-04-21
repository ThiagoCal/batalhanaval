
--[[

(OK) cria cor rgb

(OK) desenha tabuleiro
(OK) desenha coordenadas XY
(OK) desenha os dois tabuleiros
(OK) cria posições (pos) do tabuleiro

(OK) desenha navio
(OK) desenha navio baseado em pos com cor

=> listar todos os navios a serem posicionados
=> pegar navios da lista e colocar no tabuleiro

=> tabuleiro2 fica escondido do player1

]]

local function newcolor(r, g, b, a)
	return {r/256, g/256, b/256, a or 1}
end


-- desenha um caracter centralizado na posição dada
local function drawchar(char, pos)
	love.graphics.print(char, pos.c.x, pos.c.y, 0, 2, 2, 4, 8)
end


-- recebe o ponto referente ao campo superior esquerdo, a quantidade
-- de quadrados da matriz, e o tamanho de cada quadrado
local function drawboard(x0, y0, n, size)
	local board = {}
	local xf = x0 + n * size
	local yf = y0 + n * size
	local alpha = {"A", "B", "C", "D", "E"}
	local x, y = x0, y0

	n = n - 1
	for i = 0, n do
		board[i] = {}
		for j = 0, n do
			love.graphics.line(x, y, x, y + size)
			love.graphics.line(x, y, x + size, y)
			local pos = {
				{x = x       , y = y       },
				{x = x       , y = y + size},
				{x = x + size, y = y + size},
				{x = x + size, y = y       },
				c = {
					x = x + size/2,
					y = y + size/2,
				}
			}
			board[i][j] = pos
			if i == 0 and j == 0 then
				drawchar("*", pos)
			elseif i == 0 then
				drawchar(j, pos)
			elseif j == 0 then
				drawchar(alpha[i], pos)
			end
			x = x + size
		end
		x, y = x0, y + size
	end

	love.graphics.line(x0, yf, xf, yf)
	love.graphics.line(xf, y0, xf, yf)
	return board
end

local function drawship(color, pos)
	local offset = 5
	local x1, y1 = pos[1].x + offset, pos[1].y + offset
	local x2, y2 = pos[2].x + offset, pos[2].y - offset
	local x3, y3 = pos[3].x - offset, pos[3].y - offset
	local x4, y4 = pos[4].x - offset, pos[4].y + offset

	local prevcolor = {love.graphics.getColor()}
	love.graphics.setColor(color)
	love.graphics.polygon("fill", x1, y1, x2, y2, x3, y3, x4, y4)
	love.graphics.setColor(prevcolor)
end

local function drawunplaced()
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function love.load()
	love.window.setMode(500, 600)
	love.graphics.setBackgroundColor(0.36, 0.57, 0.89)
	love.graphics.setColor(newcolor(256, 256, 256))

	unplaced = {
		{1, 3},
		{1, 2},
		{1, 1},
	}
end

function love.update()

end

function love.draw()
	local size = 38
	local n = 6
	local offset = 50

	-- desenha o primeiro tabuleiro
	local x0 = offset
	local y0 = offset
	local enemyboard = drawboard(x0, y0, n, size)

	-- desenha o segundo tabuleiro
	x0 = offset
	y0 = n * size + 2 * offset
	local playerboard = drawboard(x0, y0, n, size)

	drawunplaced()


	-- testes
	local color = newcolor(56, 55, 58)
	drawship(color, {
		playerboard[2][2][1],
		playerboard[2][2][2],
		playerboard[2][4][3],
		playerboard[2][4][4],
	})

	color = newcolor(200, 10, 10)
	drawship(color, {
		enemyboard[2][2][1],
		enemyboard[4][2][2],
		enemyboard[4][2][3],
		enemyboard[2][2][4],
	})
end
