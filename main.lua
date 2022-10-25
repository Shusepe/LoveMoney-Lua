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
	
	-- Init PowerUp
	timePowers = {}
	
	-- Init Score variable
	score = 0
	
	--initScreen
	screen = 0
	
	-- Timer Count
	timeToPlay = 10
	
	-- Timer Lapse
	timeLapse = 1
	
	-- Charge Sounds
	sounds = {}
	sounds.dolar = love.audio.newSource("LoveMoneyAsset/sfx/MoneySfx.wav", "static")
	sounds.steps = love.audio.newSource("LoveMoneyAsset/sfx/StepsSfx.wav", "static")
	sounds.gamePlay = love.audio.newSource("LoveMoneyAsset/music/GamePlay.mp3", "static")
	sounds.screenMusic = love.audio.newSource("LoveMoneyAsset/music/Menu.wav", "static")
	
	-- Charge Fonts
	fonts = {}
	fonts.large = love.graphics.newFont("LoveMoneyAsset/fonts/Spongeboy Me Bob.ttf", 36)
	
	-- Charge Images
	images = {}
	images.background = love.graphics.newImage("LoveMoneyAsset/res/Floor.png")
	images.dolar = love.graphics.newImage("LoveMoneyAsset/res/Money.png")
	images.timePower = love.graphics.newImage("LoveMoneyAsset/res/PlusTime.png")
	images.crabPlayerUp = love.graphics.newImage("LoveMoneyAsset/res/CrabPlayerUp.png")
	images.crabPlayerDown = love.graphics.newImage("LoveMoneyAsset/res/CrabPlayerDown.png")
	images.crabPlayerRight = love.graphics.newImage("LoveMoneyAsset/res/CrabPlayerRight.png")
	images.crabPlayerLeft = love.graphics.newImage("LoveMoneyAsset/res/CrabPlayerLeft.png")
	
	images.howToPlay = love.graphics.newImage("LoveMoneyAsset/res/Screens/HowToPlay.png")
	images.credits1 = love.graphics.newImage("LoveMoneyAsset/res/Screens/Credits1.png")
	images.credits2 = love.graphics.newImage("LoveMoneyAsset/res/Screens/Credits2.png")
	images.credits3 = love.graphics.newImage("LoveMoneyAsset/res/Screens/Credits3.png")
end

function love.update(dt)

	if screen == 0 then
		sounds.screenMusic:play()
		if love.keyboard.isDown ("space") and screen == 0 then
			screen = 1
			love.graphics.clear()
			
		end
	end

	if screen == 1 then
		if math.ceil(timeToPlay)~= 0 then
			-- Play Music
			sounds.screenMusic:stop()
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
				if playerCollision(player.x, player.y, player.w, player.h, dolar.x, dolar.y, dolar.w, dolar.h) then
					table.remove(dolars, i)
					score = score + 1
					sounds.dolar:play()
				end
			end
			
			-- Check Player Collision Power
			for i=#timePowers, 1, -1 do
				local timePower = timePowers[i]
				if playerCollision(player.x, player.y, player.w, player.h, timePower.x, timePower.y, timePower.w, timePower.h) then
					table.remove(timePowers, i)
					timeToPlay = timeToPlay + 2
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
			
			-- Show Random Power
			if math.random() < 0.01 and timeToPlay < 8 then
				local timePower = {}
				timePower.w = 96
				timePower.h = 36
				timePower.x = math.random(0, 950 - timePower.w)
				timePower.y = math.random(0, 600 - timePower.h)
				table.insert(timePowers, timePower)
			end
			
			-- Discount Time
			timeToPlay = timeToPlay-dt
		end
		
		if timeToPlay <= 0 then
			if love.keyboard.isDown("space") then
				score = 0
				dolars = {}
				timePowers = {}
				timeToPlay = 10
			elseif love.keyboard.isDown("right") then
				love.graphics.clear()
				screen = 2
			end
		end
		
	else
		timeLapse = timeLapse-dt
		sounds.gamePlay:stop()
		sounds.screenMusic:play()
		if love.keyboard.isDown("left") and screen ~= 2 and timeLapse <= 0 then
			love.graphics.clear()
			screen = screen - 1
			timeLapse = 1
		elseif love.keyboard.isDown("right") and screen ~= 4 and timeLapse <= 0 then
			love.graphics.clear()
			screen = screen + 1
			timeLapse = 1
		elseif screen == 4 and love.keyboard.isDown("space") then
			love.graphics.clear()
			timeToPlay = 10
			score = 0
			dolars = {}
			timePowers = {}
			screen = 1
		elseif screen == 4 and love.keyboard.isDown("escape") then
			love.event.quit()
		end
	end
end

function love.draw()

	if screen == 0 then
		love.graphics.draw(images.howToPlay, 0, 0)
	elseif screen == 1 then
		
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
		
		-- Draw PowerTime
		for i = 1, #timePowers, 1 do
			local timePower = timePowers[i]
			love.graphics.draw(images.timePower, timePower.x, timePower.y)
		end
		
		-- Draw Text Score
		if timeToPlay > 0 then
			love.graphics.setFont(fonts.large)
			love.graphics.print("Score: " .. score, 10, 10)
		end
		
		-- Draw Timer
		if timeToPlay > 0 then
			love.graphics.print(math.ceil(timeToPlay), 970, 10)
		else
			love.graphics.print(0, 970, 10)
		end
		
		if timeToPlay <= 0 then
			love.graphics.print("Your Score: " .. score, 400, 325)
			love.graphics.print("Press Space to Replay", 335, 385)
			love.graphics.print("Press Right Arrow to Credits", 335, 425)
		end
	elseif screen == 2 then
		love.graphics.draw(images.credits1, 0, 0)
	elseif screen == 3 then
		love.graphics.draw(images.credits2, 0, 0)
	elseif screen == 4 then
		love.graphics.draw(images.credits3, 0, 0)
	end
end