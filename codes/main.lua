
--[[

(OK) cria cor rgb

(OK) desenha tabuleiro
(OK) desenha coordenadas XY
(OK) desenha os dois tabuleiros
(OK) cria posiï¿½ï¿½es (pos) do tabuleiro

(OK) desenha navio
(OK) desenha navio baseado em pos com cor

=> listar todos os navios a serem posicionados
=> pegar navios da lista e colocar no tabuleiro

=> tabuleiro2 fica escondido do player1

]]

local function newcolor(r, g, b, a)
	return {r/256, g/256, b/256, a or 1}
end

-- desenha um caracter centralizado na posiï¿½ï¿½o dada
local function drawchar(char, p)
	love.graphics.print(char, p.x, p.y, 0, 2, 2, 4, 8)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local ship = {}
ship.__index = ship

function ship.new(color, w, h, quad)
	local t = {
		color = color,
		w = w,
		h = h,
		quad = quad,
	}
	setmetatable(t, ship)
	return t
end

function ship:updatequad(x, y)
	local dx = x - self.quad[1].x
	local dy = y - self.quad[1].y
	for _, p in ipairs(self.quad) do
		p.x = p.x + dx
		p.y = p.y + dy
	end
end

function ship:draw()
	local offset = 5
	local x1, y1 = self.quad[1].x + offset, self.quad[1].y + offset
	local x2, y2 = self.quad[2].x + offset, self.quad[2].y - offset
	local x3, y3 = self.quad[3].x - offset, self.quad[3].y - offset
	local x4, y4 = self.quad[4].x - offset, self.quad[4].y + offset

	local prevcolor = {love.graphics.getColor()}
	love.graphics.setColor(self.color)
	love.graphics.polygon("fill", x1, y1, x2, y2, x3, y3, x4, y4)
	love.graphics.setColor(prevcolor)
end

function ship:contains(p)
	local x0, y0 = self.quad[1].x, self.quad[1].y
	local xf, yf = self.quad[3].x, self.quad[3].y
	return p.x >= x0 and p.x <= xf and p.y >= y0 and p.y <= yf
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local board = {}
board.__index = board

function board.new(x0, y0, m, n, size, coord)
	local t = {
		x0 = x0,
		y0 = y0,
		xf = x0 + n * size,
		yf = y0 + m * size,
		m = m,
		n = n,
		size = size,
		coord = coord,
		matrix = {},
		ships = {},
	}
	setmetatable(t, board)

	local x, y = x0, y0
	local halfsize = size / 2
	for i = 0, m - 1 do
		t.matrix[i] = {}
		for j = 0, n - 1 do
			t.matrix[i][j] = {
				{x = x, y = y},
				{x = x, y = y + size},
				{x = x + size, y = y + size},
				{x = x + size, y = y},
				c = {x = x + halfsize, y = y + halfsize}
			}
			x = x + size
		end
		x, y = x0, y + size
	end

	return t
end

-- recebe o ponto referente ao campo superior esquerdo, a quantidade
-- de quadrados da matriz, e o tamanho de cada quadrado
function board:draw()
	local alpha = {"A", "B", "C", "D", "E"}
	local x, y = self.x0, self.y0
	local halfsize = self.size / 2

	for i = 0, self.m - 1 do
		for j = 0, self.n - 1 do
			love.graphics.line(x, y, x, y + self.size)
			love.graphics.line(x, y, x + self.size, y)
			if self.coord then -- se for desenharmos
				if i == 0 and j == 0 then
					drawchar("*", self.matrix[i][j].c)
				elseif i == 0 then
					drawchar(j, self.matrix[i][j].c)
				elseif j == 0 then
					drawchar(alpha[i], self.matrix[i][j].c)
				end
			end
			x = x + self.size
		end
		x, y = self.x0, y + self.size
	end

	love.graphics.line(self.x0, self.yf, self.xf, self.yf)
	love.graphics.line(self.xf, self.y0, self.xf, self.yf)

	for _, ship in ipairs(self.ships) do
		ship:draw()
	end
end

function board:addship(i, j, color, w, h)
	local ship = ship.new(color, w, h, {
		self.matrix[i][j][1],
		self.matrix[i + h - 1][j][2],
		self.matrix[i + h - 1][j + w - 1][3],
		self.matrix[i][j + w - 1][4],
	})
	table.insert(self.ships, ship)
	return ship
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function love.load()
	love.window.setMode(600, 600)
	love.graphics.setBackgroundColor(0.36, 0.57, 0.89)
	love.graphics.setColor(newcolor(256, 256, 256))

	unplaced = {
		{1, 3},
		{1, 2},
		{1, 1},
	}

	local size = 38
	local n = 6
	local offset = 50

	-- cria o tabuleiro do inimigo
	local x0 = offset
	local y0 = offset
	enemyboard = board.new(x0, y0, n, n, size, true)

	-- cria o tabuleiro do jogador
	x0 = offset
	y0 = n * size + 2 * offset
	playerboard = board.new(x0, y0, n, n, size, true)

	-- cria o tabuleiro das peças jogáveis
	x0 = offset + (n + 2 ) * size
	y0 = 2 * offset + n * size
	unplacedboard = board.new(x0, y0, 3, 3, size, false)

	-- adiciona peças aos tabuleiros
	enemyships = {
		{2, 2, 3, 1, newcolor(200, 10, 10)},
	}

	playerships = {
		{2, 2, 1, 3, newcolor(30, 30, 30)},
	}

	unplacedships = {
		{0, 0, 1, 3, newcolor(56, 55, 58)},
		{1, 1, 1, 2, newcolor(0, 102, 204)},
		{2, 2, 1, 1, newcolor(0, 102, 102)},
	}

	for i, t in ipairs(enemyships) do
		enemyships[i] = enemyboard:addship(t[1], t[2], t[5], t[3], t[4])
	end
	for i, t in ipairs(playerships) do
		playerships[i] = playerboard:addship(t[1], t[2], t[5], t[3], t[4])
	end
	for i, t in ipairs(unplacedships) do
		unplacedships[i] = unplacedboard:addship(t[1], t[2], t[5], t[3], t[4])
	end
end

-- function love.mousereleased(x, y, button)

-- 	--make the dragging stop happening
-- 	for i,v in ipairs(ship1v) do

-- 		if button == "l"
-- 			then v.drag.active = false
-- 		end

-- 	end
-- end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local clicked = {p = {x = 10, y = 10}, char = "*"}

local draggedship = nil

function love.mousepressed(x, y)
	local p = {x = x, y = y}
	clicked.p = p

	for _, ship in ipairs(unplacedships) do
		if ship:contains(p) then
			draggedship = ship
			clicked.char = "+"
		end
	end
end

function love.mousereleased(x, y)
	-- TODO
	-- se o ponto que soltou está dentro do playerboard AND
	--    o ponto que soltou é uma casa válida
		-- remover o navio do unplacedboard (lógica)
		-- colocar o navio no playerboard (lógica)
	-- se não
		-- volta com o návio para sua posição no unplacedboard
	draggedship = nil
	clicked.char = "*"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function love.update()
	if draggedship ~= nil then
		local x0 = love.mouse.getX()
		local y0 = love.mouse.getY()
		draggedship:updatequad(x0, y0)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function love.draw()
	enemyboard:draw()
	playerboard:draw()
	unplacedboard:draw()

	drawchar(clicked.char, clicked.p)
end
