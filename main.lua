require "collision"

function love.load()
	math.randomseed(os.time())

	-- Init Player
	player = {}
	player.x = 50
	player.y = 300
	player.w = 64
	player.h = 56
	
	-- Init Dolar
	dolar = {}
	dolar.x = 150
	dolar.y = 300
	dolar.w = 64
	dolar.h = 56
end

function love.update(dt)
	if love.keyboard.isDown("right") then
		player.x = player.x + 4
	elseif love.keyboard.isDown("left") then
		player.x = player.x - 4
	elseif love.keyboard.isDown("down") then
		player.y = player.y + 4
	elseif love.keyboard.isDown("up") then
		player.y = player.y - 4
	end
	
	if playerDolarCollision(player.x, player.y, player.w, player.h, dolar.x, dolar.y, dolar.w, dolar.h) then
		dolar.x = math.random(0, 800 - dolar.w)
		dolar.y = math.random(0, 600 - dolar.h)
	end
end

function love.draw()
	
	-- Draw Player
	love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
	
	love.graphics.rectangle("fill", dolar.x, dolar.y, dolar.w, dolar.h)
end