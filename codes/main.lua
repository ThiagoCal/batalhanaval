function love.load()
        love.window.setMode(800, 600)
        -- love.graphics.setBackgroundColor(0.36, 0.57, 0.89)
        -- love.graphics.setColor(0, 0, 0)
    end

    function love.update()

    end

	function drawboard(pf, pf, size, n)
	end

    function love.draw()
        local size = 38
        local p0 = 10
        local pf = 390

        for x = p0, pf - 1, size do
            for y = p0, pf - 1, size do
                love.graphics.line(x, y, x, y + size)
                love.graphics.line(x, y, x + size, y)
            end
        end
        love.graphics.line(pf, p0, pf, pf)
        love.graphics.line(p0, pf, pf, pf)
    end

