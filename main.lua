function love.load()
	-- Init Player
	player = {}
	player.x = 50
	player.y = 300
	player.w = 64
	player.h = 56
end

function love.draw()
	
	-- Draw Player
	love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
end