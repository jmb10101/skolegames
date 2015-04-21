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
   
   -- scene exit message -- use to free memory/remove event listeners
   self.exit_scene = false
   
   -- create display objects
   
   -- add physics
   
   -- add display objects to scene
   

end

-- process scene -- called once per frame
function scene:process()

	
end

-- show scene
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase
   
   -- create local references
   local app_loop = self.app_loop
   local thisScene = self.thisScene
   
   if ( phase == "will" ) then
      -- called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- called when the scene is now on screen.
	  
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
			
			-- clean up
			Runtime:removeEventListener("enterFrame", process)				
		end
		
	  end
	  
	  -- add enter frame event listener
	  Runtime:addEventListener("enterFrame", process)
   end
   
end

-- game controller button touch events
-- button x
function scene:game_controller_button_x_touch(event)

	if event.phase == "began" then 
	elseif event.phase == "moved" then
	elseif event.phase == "touch_leave" then		-- added event phase in scene_game_controller
	elseif event.phase == "touch_enter" then		-- added event phase in scene_game_controller
	elseif event.phase == "ended" then
	end
end

-- button y
function scene:game_controller_button_y_touch(event)

	if event.phase == "began" then 
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
	elseif event.phase == "moved" then
	elseif event.phase == "touch_leave" then
	elseif event.phase == "touch_enter" then
	elseif event.phase == "ended" then
	end
end

-- button directional right
function scene:game_controller_button_dr_touch(event)

	if event.phase == "began" then 
	elseif event.phase == "moved" then
	elseif event.phase == "touch_leave" then
	elseif event.phase == "touch_enter" then
	elseif event.phase == "ended" then
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