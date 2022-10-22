function love.load()
	-- Init Player
	player = {}
	player.x = 50
	player.y = 300
	player.w = 64
	player.h = 56
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
end

function love.draw()
	
	-- Draw Player
	love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
end