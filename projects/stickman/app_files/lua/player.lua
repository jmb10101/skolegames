---------------------------------------------------------------------------------
-- Project: Stickman
-- player class
---------------------------------------------------------------------------------

-- requires

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
	new_player.speed = 1
	new_player.dir = "right"
	
	-- init player
	function new_player:init(name)
	
		-- 
		self.name= name
	end
	
	-- move player
	function new_player:move()
	
		local speed = self.speed
		if self.dir == "left" then
			speed = speed * -1
		end
		
		--self.x = self.x + speed	
	end
	
	-- set player position
	function new_player:set_position(x, y)
	end
	
	return new_player
end

return player