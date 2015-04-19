---------------------------------------------------------------------------------
-- Project:
-- 
---------------------------------------------------------------------------------

-- requires
local composer = require( "composer" )
local scene = composer.newScene()
local globals = require("app_files.lua.globals")

local game_world_camera = require(globals.lua_path.."game_world_camera")

-- local forward references

-- create scene
function scene:create( event )

   local sceneGroup = self.view

   -- create a reference to the app_loop
   self.app_loop = event.params.app_loop
   
   -- store the current app state
   self.thisScene = event.params.app_loop.app_state
   
   -- create game world properties and camera
   local game_world_area_width = 1000
   local game_world_area_height = 1000
   
   self.game_camera = game_world_camera.new()
   self.game_camera:init(game_world_area_width, game_world_area_height, display.contentWidth, display.contentHeight)

   
   -- create display objects
   local obj_units = self.game_camera:game_world_units_to_display_units(400,800)									-- bg
   self.bg = display.newImage(globals.images_path.."bg.png", obj_units.x, obj_units.y)
   
   obj_units = self.game_camera:game_world_units_to_display_units(600,500)											-- ground
   self.ground = display.newImage(globals.images_path.."ground.png", obj_units.x, obj_units.y)
   
   obj_units = self.game_camera:game_world_units_to_display_units(700,900)											
   self.ground2 = display.newImage(globals.images_path.."ground.png", obj_units.x, obj_units.y)
   
   obj_units = self.game_camera:game_world_units_to_display_units(600,400)											-- plr
   self.plr = display.newImage(globals.images_path.."guy.png", obj_units.x, obj_units.y)
   --self.plr.alpha = .6
   -- add physics
   physics.addBody(self.ground, "static", {friction=1, bounce=0})													-- static objects
   physics.addBody(self.ground2, "static", {friction=1, bounce=0})	
   physics.addBody(self.plr, "dynamic", {bounce=0})
   self.plr.isFixedRotation = true
   
   -- add display objects to scene
   sceneGroup:insert(self.bg)
   sceneGroup:insert(self.ground)
   sceneGroup:insert(self.plr)
   sceneGroup:insert(self.ground2)
   
   
   -- add timers
   
   -- add plr stuff
   self.plr.moving = false
   self.plr.speed = 1
   self.plr.px = self.plr.x
   self.plr.py = self.plr.y
   self.plr.worldx = 200
   self.plr.worldy = 700
   
   -- set camera position
   
	
   -- scene exit message
   self.exit_scene = false
end

-- process scene -- called once per frame
function scene:process()

	-- check if player has fallen out of game world area
	local plr_world_units = self.game_camera:display_units_to_game_world_units(self.plr.x, self.plr.y)
	if plr_world_units.y > self.game_camera.area_height then
	
		-- send an app state change event to the app_loop
		self.exit_scene = true
		self.app_loop.process_app_message(nil, "change_scene", {scene = globals.app_state.gameover})
		return
	end
	
	-- move player
	if self.plr.moving == true then
	
		-- adjust player 
		self.plr.x = self.plr.x + self.plr.speed
	end
	
	-- center camera on player
	local obj_units = self.game_camera:display_units_to_game_world_units(self.plr.x, self.plr.y)
	self.game_camera:set_position(self.view, obj_units.x - (display.contentWidth/2), obj_units.y - (display.contentHeight/2))
	

end


-- show scene
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase
   
   -- create local references
   local app_loop = self.app_loop
   local thisScene = self.thisScene
   
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
     
	  -- show controller overlay
	  composer.showOverlay(globals.app_state.game_controller, {params = {app_loop = app_loop}})
	  
	  -- add listeners
	  
	  -- add process loop
	  local function process()
	  
		-- if app state has changed, remove the event listener
		if self.exit_scene == false then 
			
			-- process app
			self:process()			
		else 
			
			-- free resources
			Runtime:removeEventListener("enterFrame", process)				
		end		
	  end
	  
	  Runtime:addEventListener("enterFrame", process)
   end
   
end

-- game controller button touch events
-- button x
function scene:game_controller_button_x_touch(event)

	if event.phase == "began" then 
		
	elseif event.phase == "ended" then
	end
end

-- button y
function scene:game_controller_button_y_touch(event)

	if event.phase == "began" then 
		
		-- player jump
		self.plr:applyForce(0,-2,self.plr.x, self.plr.y)
	elseif event.phase == "ended" then
	
	end
end

-- button menu
function scene:game_controller_button_menu_touch(event)

	if event.phase == "began" then 
	
	elseif event.phase == "ended" then
	
	end
end

-- button directional left
function scene:game_controller_button_dl_touch(event)

	if event.phase == "began" then 
		self.plr.moving = true
		self.plr.speed = -1
	elseif event.phase == "moved" then
	
	elseif event.phase == "touch_leave" then
		self.plr.moving = false
	elseif event.phase == "touch_enter" then
		self.plr.moving = true
		self.plr.speed = -1
	elseif event.phase == "ended" then
		self.plr.moving = false
	end
end

-- button directional right
function scene:game_controller_button_dr_touch(event)

	if event.phase == "began" then 
		self.plr.moving = true
		self.plr.speed = 1
	elseif event.phase == "moved" then
	
	elseif event.phase == "touch_leave" then
		self.plr.moving = false
	elseif event.phase == "touch_enter" then
		self.plr.moving = true
		self.plr.speed = 1
	elseif event.phase == "ended" then
		self.plr.moving = false
	end
end
		
		
-- hide scene
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end

-- destroy scene
function scene:destroy( event )

   local sceneGroup = self.view

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
   
   self.exit_scene = true
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene