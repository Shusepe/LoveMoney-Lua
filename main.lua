require "collision"

function love.load()
	
	love.window.setTitle("LoveMoney")
	love.window.setMode(1024, 650)

	-- Take the time for a random number
	math.randomseed(os.time())

	-- Init Player
	player = {}
	player.x = 50
	player.y = 300
	player.w = 64
	player.h = 56
	player.direction = "down"
	
	-- Init Struct Dolar
	dolars = {}
	
	-- timerCheck
	
	-- Init Score variable
	score = 0
	
	-- timerCount
	timeToPlay = 10
	
	-- Charge Sounds
	sounds = {}
	sounds.dolar = love.audio.newSource("LoveMoneyAsset/sfx/MoneySfx.wav", "static")
	sounds.steps = love.audio.newSource("LoveMoneyAsset/sfx/StepsSfx.wav", "static")
	sounds.gamePlay = love.audio.newSource("LoveMoneyAsset/music/GamePlay.mp3", "static")
	
	-- Charge Fonts
	fonts = {}
	fonts.large = love.graphics.newFont("LoveMoneyAsset/fonts/Spongeboy Me Bob.ttf", 36)
	
	-- Charge Images
	images = {}
	images.background = love.graphics.newImage("LoveMoneyAsset/res/Floor.png")
	images.dolar = love.graphics.newImage("LoveMoneyAsset/res/Money.png")
	images.crabPlayerUp = love.graphics.newImage("LoveMoneyAsset/res/CrabPlayerUp.png")
	images.crabPlayerDown = love.graphics.newImage("LoveMoneyAsset/res/CrabPlayerDown.png")
	images.crabPlayerRight = love.graphics.newImage("LoveMoneyAsset/res/CrabPlayerRight.png")
	images.crabPlayerLeft = love.graphics.newImage("LoveMoneyAsset/res/CrabPlayerLeft.png")
end

function love.update(dt)

	-- Play Music
	sounds.gamePlay:play()
	
	-- Check Input User
	if love.keyboard.isDown("right") and (player.x + player.w) <= love.graphics.getWidth() then
		player.x = player.x + 4 -- plus for time
		player.direction = "right"
		sounds.steps:play()
	elseif love.keyboard.isDown("left") and player.x >= 0 then
		player.x = player.x - 4
		player.direction = "left"
		sounds.steps:play()
	elseif love.keyboard.isDown("down") and (player.y + player.h) <= love.graphics.getHeight() then
		player.y = player.y + 4
		player.direction = "down"
		sounds.steps:play()
	elseif love.keyboard.isDown("up") and player.y >= 0 then
		player.y = player.y - 4
		player.direction = "up"
		sounds.steps:play()
	end
	
	-- Check Player Collision Dolar
	for i=#dolars, 1, -1 do
		local dolar = dolars[i]
		if playerDolarCollision(player.x, player.y, player.w, player.h, dolar.x, dolar.y, dolar.w, dolar.h) then
			table.remove(dolars, i)
			score = score + 1
			sounds.dolar:play()
		end
	end
	
	-- Show Random Dollars
	if math.random() < 0.01 then
		local dolar = {}
		dolar.w = 96
		dolar.h = 36
		dolar.x = math.random(0, 950 - dolar.w)
		dolar.y = math.random(0, 600 - dolar.h)
		table.insert(dolars, dolar)
	end
	
	-- Discount Time
	if math.ceil(timeToPlay)~= 0 then
        timeToPlay=timeToPlay-dt
	end
end

function love.draw()

	-- Draw Background
	for x=0, love.graphics.getWidth(), images.background:getWidth() do
		for y=0, love.graphics.getHeight(), images.background:getHeight() do
			love.graphics.draw(images.background, x, y)
		end
	end
	
	-- Init Image Player
	local image = images.crabPlayerUp
	
	-- Check Direction Image Player 
	if player.direction == "right" then
		image = images.crabPlayerRight
	elseif player.direction == "up" then
		image = images.crabPlayerUp
	elseif player.direction == "left" then
		image = images.crabPlayerLeft
	elseif player.direction == "down" then
		image = images.crabPlayerDown
	end
	
	-- Draw Player
	love.graphics.draw(image, player.x, player.y)
	
	-- Draw Dollars
	for i = 1, #dolars, 1 do
		local dolar = dolars[i]
		love.graphics.draw(images.dolar, dolar.x, dolar.y)
	end
	
	if timeToPlay > 0 then
		-- Draw Text Score
		love.graphics.setFont(fonts.large)
		love.graphics.print("Score: " .. score, 10, 10)
	end
	-- Draw Timer
	if timeToPlay>0 then
		love.graphics.print(math.ceil(timeToPlay), 970, 10)
	else
		love.graphics.print(0, 970, 10)
	end
	
	if timeToPlay <= 0 then
		love.graphics.print("Your Score: " .. score, 400, 325)
	end
end