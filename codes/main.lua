
--[[

(OK) cria cor rgb

(OK) desenha tabuleiro
(OK) desenha coordenadas XY
(OK) desenha os dois tabuleiros
(OK) cria posi��es (pos) do tabuleiro

(OK) desenha navio
(OK) desenha navio baseado em pos com cor

(OK) listar todos os navios a serem posicionados
(OK) pegar navios da lista e colocar no tabuleiro

=> tabuleiro2 fica escondido do player1

]]

local function newcolor(r, g, b, a)
	return {r/256, g/256, b/256, a or 1}
end

-- desenha um caracter centralizado na posi��o dada
local function drawchar(char, p)
	love.graphics.print(char, p.x, p.y, 0, 2, 2, 4, 8)
end

local function copyquad(quad)
	local t = {}
	for i = 1, 4 do
		t[i] = {x = quad[i].x, y = quad[i].y}
	end
	return t
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
		original = {
			w = w,
			h = h,
			quad = copyquad(quad),
		},
		quad = quad,
	}
	setmetatable(t, ship)
	return t
end

function ship:rotate()
	self.w, self.h = self.h, self.w
	local newquad = copyquad(self.quad)
	local w = self.quad[4].x - self.quad[1].x
	local h = self.quad[2].y - self.quad[1].y
	newquad[2].y = self.quad[1].y + w
	newquad[3].y = newquad[2].y
	newquad[4].y = self.quad[1].y
	newquad[3].x = self.quad[1].x + h
	newquad[4].x = newquad[3].x
	self.quad = newquad
end

function ship:updatequad(x, y)
	local dx = x - self.quad[1].x
	local dy = y - self.quad[1].y
	for _, p in ipairs(self.quad) do
		p.x = p.x + dx
		p.y = p.y + dy
	end
end

function ship:resetquad()
	self.w = self.original.w
	self.h = self.original.h
	self.quad = copyquad(self.original.quad)
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
		matrix = {}, -- matriz de quads
		ships = {matrix = {}},
	}
	setmetatable(t, board)

	local x, y = x0, y0
	local halfsize = size / 2
	for i = 0, m - 1 do
		t.matrix[i] = {}
		t.ships.matrix[i] = {}
		for j = 0, n - 1 do
			if coord and (i == 0 or j == 0)  then
				t.ships.matrix[i][j] = true
			end
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

function board:contains(p)
	local contains = p.x >= self.x0 and p.x <= self.xf and p.y >= self.y0 and p.y <= self.yf
	if not contains then return false end
	local px = p.x - self.x0
	local py = p.y - self.y0
	local i = math.floor(py / self.size)
	local j = math.floor(px / self.size)
	return true, i, j
end

function board:addship(i, j, color, w, h)
	local i0, iF = i, i + h - 1
	local j0, jF = j, j + w - 1

	-- checando se a posi��o para o navio � valida
	for i = i0, iF do
		for j = j0, jF do
			if self.ships.matrix[i][j] ~= nil then
				return nil
			end
		end
	end

	-- criando o navio
	local ship = ship.new(color, w, h, copyquad({
		self.matrix[i0][j0][1],
		self.matrix[iF][j0][2],
		self.matrix[iF][jF][3],
		self.matrix[i0][jF][4],
	}))

	-- adicionando o navio na matriz de marca��o de navios do tabuleiro
	for i = i0, iF do
		for j = j0, jF do
			self.ships.matrix[i][j] = ship
		end
	end

	-- adicionando o navio no vetor de navios do tabuleiro
	table.insert(self.ships, ship)

	return ship
end

function board:removeship(ship)
	-- removendo o navio do vetor de navios do tabuleiro
	local found
	for i, v in ipairs(self.ships) do
		if v == ship then
			found = i
		end
	end
	table.remove(self.ships, assert(found))

	-- removendo o navio da matriz de marca��o de navios do tabuleiro
	for i = 0, self.m - 1 do
		for j = 0, self.n - 1 do
			if self.ships.matrix[i][j] == ship then
				self.ships.matrix[i][j] = nil
			end
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function love.load()
	love.window.setMode(600, 600)
	love.graphics.setBackgroundColor(0.36, 0.57, 0.89)
	love.graphics.setColor(newcolor(256, 256, 256))

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

	-- cria o tabuleiro das pe�as jog�veis
	x0 = offset + (n + 2 ) * size
	y0 = 2 * offset + n * size
	unplacedboard = board.new(x0, y0, 3, 3, size, false)

	-- TODO: remover eventualmente os testes
	-- adiciona pe�as aos tabuleiros
	enemyships = { -- teste
		{2, 2, 3, 1, newcolor(200, 10, 10)},
	}

	playerships = { -- teste
		{2, 2, 1, 3, newcolor(30, 30, 30)},
	}

	unplacedships = {
		{0, 0, 1, 3, newcolor(56, 55, 58)},
		{1, 1, 1, 2, newcolor(0, 102, 204)},
		{2, 2, 1, 1, newcolor(0, 102, 102)},
	}

	for i, t in ipairs(enemyships) do
		enemyships[i] = assert(enemyboard:addship(t[1], t[2], t[5], t[3], t[4]))
	end
	for i, t in ipairs(playerships) do
		playerships[i] = assert(playerboard:addship(t[1], t[2], t[5], t[3], t[4]))
	end
	for i, t in ipairs(unplacedships) do
		unplacedships[i] = assert(unplacedboard:addship(t[1], t[2], t[5], t[3], t[4]))
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local draggedship = nil

function love.mousepressed(x, y)
	local p = {x = x, y = y}
	for _, ship in ipairs(unplacedships) do
		if ship:contains(p) then
			draggedship = ship
		end
	end
end

function love.mousereleased(x, y)
	local p = {x = x, y = y}
	if draggedship then
		local contains, i, j = playerboard:contains(p)
		if contains then
			local color, w, h = draggedship.color, draggedship.w, draggedship.h
			local placedship = playerboard:addship(i, j, color, w, h)
			if placedship then
				unplacedboard:removeship(draggedship)
			else
				draggedship:resetquad()
			end
		else
			draggedship:resetquad()
		end
		draggedship = nil
	end
end

function love.keypressed(key)
	if key == "r" and draggedship then
		draggedship:rotate()
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function love.update()
	if draggedship then
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
end
