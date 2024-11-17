function love.load()
    H_WIDTH = SCREEN_WIDTH / 2
    H_HEIGHT = SCREEN_HEIGHT / 2
    RADIUS = H_HEIGHT - 50
    timeRadius = {}
    timeRadius.sec = RADIUS - 10
    timeRadius.min = RADIUS - 55
    timeRadius.hour = RADIUS - 100
    timeRadius.digit = RADIUS - 30

    clock60 = {}
    for i = 0, 59 do
        clock60[i] = i * 6
    end

    hour = nil
    minute = nil
    second = nil
    font = love.graphics.newFont(42)
    love.graphics.setFont(font)
end

function love.update(dt)
    local now = os.date('*t')
    hour = ( (now.hour%12)*5 + math.floor(now.min/12) ) % 60;
    minute = now.min
    second = now.sec
end

function love.draw()
    drawFace()
    drawClock()
    drawDate()
end 

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end

function getClockPos(clock_hand, key)
    local angle = math.rad(clock60[clock_hand]) - math.pi / 2
    local x = H_WIDTH + timeRadius[key] * math.cos(angle)
    local y = H_HEIGHT + timeRadius[key] * math.sin(angle)
    return x, y
end

function drawFace()
    love.graphics.setLineWidth(7)
    for i = 0, 59 do
        local digit = i
        local radius = 0
        if digit % 3 == 0 and digit % 5 == 0 then
            radius = 20
        elseif digit % 5 == 0 then
            radius = 10
        else
            radius = 4
        end

        local x, y = getClockPos(digit, 'digit')

        if radius == 4 then
            love.graphics.circle('fill', x, y, radius, radius)
        else
            love.graphics.circle('line', x, y, radius, radius)
        end
    end
    love.graphics.setLineWidth(7)
end

function drawClock()
    love.graphics.setLineWidth(10)
    love.graphics.setColor(1, 0, 0)
    local x, y = getClockPos(hour, 'hour')
    love.graphics.line(H_WIDTH, H_HEIGHT, x, y)

    love.graphics.setLineWidth(7)
    love.graphics.setColor(0, 1, 0)
    x, y = getClockPos(minute, 'min')
    love.graphics.line(H_WIDTH, H_HEIGHT, x, y)

    love.graphics.setLineWidth(4)
    love.graphics.setColor(0, 0, 1)
    x, y = getClockPos(second, 'sec')
    love.graphics.line(H_WIDTH, H_HEIGHT, x, y)

    love.graphics.setColor(1, 1, 1)
    love.graphics.circle('fill', H_WIDTH, H_HEIGHT, 8)

    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1)
end

function drawDate()
    local now = os.date('*t')
    love.graphics.print(string.format("%02d:%02d:%02d", now.hour, now.min, now.sec))
end

function love.keypressed(key)
    if key == "c" then
        --love.graphics.captureScreenshot(os.time() .. ".png") -- uncomment if you want to make screenshot
    end
end