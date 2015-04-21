---------------------------------------------------------------------------------
-- Project: Stickman
-- player class
---------------------------------------------------------------------------------

-- requires
local globals = require("app_files.lua.globals")
local app_timer = require(globals.lua_path.."app_timer")

-- player class

local player = {}

function player:new()

	-- create a new player object
	local new_player = {}
	
	-- add player properties
	new_player.name = ""
	new_player.health = 100
	new_player.max_health = 100
	new_player.lives = 1
	new_player.speed = 100					-- player's general speed in pixels per second
	new_player.dir = "none"					-- horizontal direction player is moving, can be "left", "right", or "none"
	new_player.body = nil					-- display object representing player
	new_player.timer = app_timer.new()		-- timer to control speed
	
	-- init player
	function new_player:init(name, file, world_x, world_y, screen_x, screen_y)		
	
		-- name player and create body
		self.name = name
		self.body = display.newImage(file, screen_x, screen_y)
		physics.addBody(self.body, "dynamic", {bounce=0})
		self.body.isFixedRotation = true
		
		-- start timer
		self.timer:start()
		
	end
	
	-- move player -- should be called once per frame while player is allowed to move
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
		-- if self.dir == "right" or anything else, player will move to the right
		end
		
		-- update player position
		local xdelta = (self.timer.time/1000) * speed
		self:translate(xdelta, 0)
		
		-- reset timer so that the timer's value represents the time between calls to this function
		self.timer:restart()
		
	end
	
	-- change player direction
	function new_player:change_dir(dir)
	
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
	
		-- calculate how much to move player
		local diffx = x - self.body.x
		local diffy = y - self.body.y
		
		-- move player
		self:translate(diffx, diffy)
	end
	
	-- jump
	function new_player:jump()
	
		-- apply upward force on player
		self.body:applyForce(0,-2,self.body.x, self.body.y)
	end
	
	-- destroy player
	function new_player:destroy()
		
		self.timer:destroy()
	end
	
	return new_player
end

return player