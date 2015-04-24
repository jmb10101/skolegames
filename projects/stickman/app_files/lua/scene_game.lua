---------------------------------------------------------------------------------
-- Project:
-- 
---------------------------------------------------------------------------------

-- requires
local composer = require( "composer" )
local scene = composer.newScene()
local globals = require("app_files.lua.globals")

local game_world_camera = require(globals.lua_path.."game_world_camera")
local player = require(globals.lua_path.."player")

-- local forward references

-- create scene
function scene:create( event )

   local sceneGroup = self.view

   -- create a reference to the app_loop
   self.app_loop = event.params.app_loop
   
   -- store the current app state
   self.thisScene = event.params.app_loop.app_state
   
   -- scene exit message
   self.exit_scene = false
   
   -- create game world properties and camera
   local game_world_area_width = 2000
   local game_world_area_height = 1000
   
   self.game_camera = game_world_camera.new()
   self.game_camera:init(game_world_area_width, game_world_area_height, display.contentWidth, display.contentHeight)

   
   -- create display objects
   local obj_units = self.game_camera:game_world_units_to_display_units(400,800)									-- bg
   self.bg = display.newImage(globals.images_path.."bg.png", obj_units.x, obj_units.y)
   
   obj_units = self.game_camera:game_world_units_to_display_units(1400,800)									
   self.bg2 = display.newImage(globals.images_path.."bg.png", obj_units.x, obj_units.y)
   
   obj_units = self.game_camera:game_world_units_to_display_units(150,850)											-- ground
   self.ground = display.newImage(globals.images_path.."large_dirt.png", obj_units.x, obj_units.y)
   
   obj_units = self.game_camera:game_world_units_to_display_units(550,1000)											
   self.ground2 = display.newImage(globals.images_path.."large_dirt.png", obj_units.x, obj_units.y)
 
   
   obj_units = self.game_camera:game_world_units_to_display_units(355,905)											
   self.ground4 = display.newImage(globals.images_path.."large_dirt.png", obj_units.x, obj_units.y)
   self.ground4.rotation = 30
   
   obj_units = self.game_camera:game_world_units_to_display_units(800,950)											-- tree platforms / trunks
   self.tree1 = display.newImage(globals.images_path.."tree_trunk.png", obj_units.x, obj_units.y) 

   obj_units = self.game_camera:game_world_units_to_display_units(900,1050)
   self.tree2 = display.newImage(globals.images_path.."tree_trunk.png", obj_units.x, obj_units.y)  

   obj_units = self.game_camera:game_world_units_to_display_units(1000,1000)
   self.tree3 = display.newImage(globals.images_path.."tree_trunk.png", obj_units.x, obj_units.y)    
   
   
   -- create player																									-- plr
   obj_units = self.game_camera:game_world_units_to_display_units(50,686)
   self.plr = player.new()
   self.plr:init("name", globals.images_path.."plr_sheet.png", obj_units.x, obj_units.y)
   
   
   
   -- add physics
   physics.addBody(self.ground, "static", {friction=.5, bounce=0})													-- static objects
   physics.addBody(self.ground2, "static", {friction=.5, bounce=0})	
   physics.addBody(self.ground4, "static", {friction=.5, bounce=0})	
   physics.addBody(self.tree1, "static", {friction=.5, bounce=0})
   physics.addBody(self.tree2, "static", {friction=.5, bounce=0})
   physics.addBody(self.tree3, "static", {friction=.5, bounce=0})
   
   -- add display objects to scene
   sceneGroup:insert(self.bg)
   sceneGroup:insert(self.bg2)
   sceneGroup:insert(self.ground)
   sceneGroup:insert(self.ground2)
   sceneGroup:insert(self.ground4)
   sceneGroup:insert(self.tree1)
   sceneGroup:insert(self.tree2)  
   sceneGroup:insert(self.tree3)  
   
   sceneGroup:insert(self.plr.body)
   
   -- add timers
   
   
	-- center camera on player
	local world_units = self.game_camera:display_units_to_game_world_units(self.plr.body.x, self.plr.body.y)
	self.game_camera:set_position(self.view, world_units.x - (display.contentWidth/2), world_units.y - (display.contentHeight/2))
end

-- process scene -- called once per frame
function scene:process()

	-- check if player has fallen out of game world area
	local world_units = self.game_camera:display_units_to_game_world_units(self.plr.body.x, self.plr.body.y)
	if world_units.y > self.game_camera.area_height then
	
		-- player is outside the game world area
		-- send an app state change event to the app_loop
		self.exit_scene = true
		self.app_loop.process_app_message(nil, "change_scene", {scene = globals.app_state.gameover})
		return
	end
	
	-- block player from leaving game world area
	if world_units.x < (self.plr.body.width/2) then	
		self.plr.body.x = (self.plr.body.width/2)
	end
	
	-- move player
	self.plr:move()
	
	-- center camera on player
	local world_units = self.game_camera:display_units_to_game_world_units(self.plr.body.x, self.plr.body.y)
	self.game_camera:set_position(self.view, world_units.x - (display.contentWidth/2), world_units.y - (display.contentHeight/2))

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
	elseif event.phase == "moved" then
	elseif event.phase == "touch_leave" then
	elseif event.phase == "touch_enter" then
	elseif event.phase == "ended" then
	end
end

-- button y
function scene:game_controller_button_y_touch(event)

	if event.phase == "began" then 
	
		-- player jumps
		self.plr:jump()
	elseif event.phase == "moved" then
	elseif event.phase == "touch_leave" then
	elseif event.phase == "touch_enter" then
	elseif event.phase == "ended" then
	end
end

-- button menu
function scene:game_controller_button_menu_touch(event)

	if event.phase == "began" then 
	elseif event.phase == "moved" then
	elseif event.phase == "touch_leave" then
	elseif event.phase == "touch_enter" then
	elseif event.phase == "ended" then
	end
end

-- button directional left
function scene:game_controller_button_dl_touch(event)

	if event.phase == "began" then 
		
		self.plr:change_dir("left")
	elseif event.phase == "moved" then
	
	elseif event.phase == "touch_leave" then
	
		self.plr:change_dir("none")
	elseif event.phase == "touch_enter" then
	
		self.plr:change_dir("left")
	elseif event.phase == "ended" then
	
		self.plr:change_dir("none")
	end
end

-- button directional right
function scene:game_controller_button_dr_touch(event)

	if event.phase == "began" then 
		
		self.plr:change_dir("right")
	elseif event.phase == "moved" then
	
	elseif event.phase == "touch_leave" then
	
		self.plr:change_dir("none")
	elseif event.phase == "touch_enter" then
	
		self.plr:change_dir("right")
	elseif event.phase == "ended" then
	
		self.plr:change_dir("none")
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