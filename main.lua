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
	dolars = {}
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
	
	for i=#dolars, 1, -1 do
		local dolar = dolars[i]
		if playerDolarCollision(player.x, player.y, player.w, player.h, dolar.x, dolar.y, dolar.w, dolar.h) then
			table.remove(dolars, i)
		end
	end
	
	if math.random() < 0.01 then
		local dolar = {}
		dolar.w = 96
		dolar.h = 36
		dolar.x = math.random(0, 800 - dolar.w)
		dolar.y = math.random(0, 600 - dolar.h)
		table.insert(dolars, dolar)
	end
end

function love.draw()
	
	-- Draw Player
	love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
	for i = 1, #dolars, 1 do
		local dolar = dolars[i]
	love.graphics.rectangle("fill", dolar.x, dolar.y, dolar.w, dolar.h)
	end
end