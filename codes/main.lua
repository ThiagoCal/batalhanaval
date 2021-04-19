function love.load()
        love.window.setMode(600,800)
        -- love.graphics.setBackgroundColor(0.36, 0.57, 0.89)
        -- love.graphics.setColor(0, 0, 0)
    end

    function love.update()

    end

function drawboard(x0, y0, xf, yf, size, n)
        for x = x0, xf -1, size do
                for y = y0, yf -1, size do
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
        drawboard(30, 30, 420, 420,size, n)


end


