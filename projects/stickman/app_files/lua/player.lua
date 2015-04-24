---------------------------------------------------------------------------------
-- Project: Stickman
-- player class
---------------------------------------------------------------------------------

-- requires
local globals = require("app_files.lua.globals")
local app_timer = require(globals.lua_path.."app_timer")

-- player class

local player = {}

function player.new()

	-- create a new player object
	local new_player = {}
	
	-- add player properties
	new_player.name = ""
	new_player.health = 100
	new_player.max_health = 100
	new_player.lives = 1
	new_player.speed = 100					-- player's general speed in pixels per second
	new_player.jumps = 2					-- number of jumps player has
	new_player.dir = "none"					-- horizontal direction player is moving, can be "left", "right", or "none"
	new_player.body = nil					-- display object representing player
	new_player.timer = app_timer.new()		-- timer to control speed
	new_player.landed = false

	
	-- init player
	function new_player:init(name, file, x, y)		
	
		-- name player and create body
		self.name = name
		
		-- player image sheet
		local options = {
			frames = 
			{
				{x = 0, y = 0, width = 11, height = 29},
				{x = 12, y = 0, width = 11, height = 29},
				{x = 24, y = 0, width = 11, height = 29},
				{x = 0, y = 30, width = 11, height = 29},
				{x = 12, y = 30, width = 11, height = 29},
				{x = 24, y = 30, width = 11, height = 29},
			}
		}
		local image_sheet = graphics.newImageSheet(file, options)
		
		-- sprite sequence data
		local sequence_data = {
		
			{name = "walking_right", start=1, count=3, time = 300,},
			{name = "walking_left", start=4, count=3, time = 300,},
			{name = "running_right", start=1, count=3, time = 200,},
			{name = "running_left", start=4, count=3, time = 200,},
		}
		self.body = display.newSprite(image_sheet, sequence_data)
		
		-- position and physics
		self.body.x = x
		self.body.y = y
		physics.addBody(self.body, "dynamic", {bounce=0, friction=.5})
		self.body.isFixedRotation = true
		self:change_dir("none")
			

		-- start timer
		self.timer:start()
		
		-- set up a collision listener on player's body
		local body = self.body
		local plr = self
		local function collision(self, event)
		
			-- redirect the local function to new_player:collision()
			plr:collision(event) 
		end	
		
		-- add collision listener
		body.collision = collision
		body:addEventListener("collision", body)
	end
	
	-- move player -- should be called once per frame while player is allowed to move. a dir value of "none" will not move the player
	function new_player:move()
	
		-- ensure player has been initialized before continuing
		if self.body == nil then return end
		
		-- adjust position from player movement
		-- find real speed (+ or -)
		local speed = self.speed
		if self.dir == "left" then
			speed = speed * -1
		elseif self.dir == "none" then
			speed = 0
		elseif self.dir == "right" then
		end
		
		-- update player position
		local xdelta = (self.timer.time/1000) * speed		-- to find the change in pixels, multiply the time since last call by the player speed (in pixels per second)
		self:translate(xdelta, 0)
		
			if self.landed == false then
				self.body:setFrame(1)
			end
		
		-- reset timer so that the timer's value represents the time between calls to this function
		self.timer:restart()
		
	end
	
	-- change player direction
	function new_player:change_dir(dir)
	
		if dir == "left" then
		
			if self.landed == true then
				self.body:setSequence("walking_left")
				self.body:play()
			else
				self.body:setSequence("walking_left")
				self.body:setFrame(1)
			end
		elseif dir == "none" then
		
			-- pause animation
			self.body:pause()
			self.body:setFrame(1)
		elseif dir == "right" then
		
			if self.landed == true then
				self.body:setSequence("walking_right")
				self.body:play()
			else
				self.body:setSequence("walking_right")
				self.body:setFrame(1)
			end
		end
		
		-- change direction
		self.dir = dir
	end
	
	-- translate player -- move player by a specific set of x and y values
	function new_player:translate(x, y)
		
		-- update player position
		self.body.x = self.body.x + x
		self.body.y = self.body.y + y
	end
	
	-- set player position
	function new_player:set_position(x, y)
	
		-- move player
		self.body.x = x
		self.body.y = y
	end
	
	-- jump
	function new_player:jump()
	
		-- check to see if player has any jumps left
		if self.jumps > 0 then 
		
			-- apply upward force on player
			self.body:applyForce(0,-1,self.body.x, self.body.y)
			self.jumps = self.jumps - 1
			self.body:pause()
		end
	end
	
	-- collisions
	function new_player:collision(event)
	
		-- 
		if event.phase == "began" then
			self.jumps = 2
			self.landed = true
			
			if self.dir == "left" then
				self:change_dir("left")
			elseif self.dir == "right" then
				self:change_dir("right")
			end
		elseif event.phase == "ended" then
			-- left ground
			self.landed = false
		end
		
	end
	
	-- destroy player
	function new_player:destroy()
		
		self.timer:destroy()
	end
	
	return new_player
end

return player