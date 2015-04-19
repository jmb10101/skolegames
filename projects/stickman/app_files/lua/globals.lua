---------------------------------------------------------------------------------
-- Project: 
-- globals.lua
-- constants used throughout the app are defined here, as well as some general
-- helper functions.
---------------------------------------------------------------------------------

local globals = {}

-- paths
globals.path = "app_files"
globals.lua_path = "app_files.lua."
globals.images_path = "app_files/images/"
globals.audio_path = "app_files/audio/"

-- global constants
globals.app_name = "Stickman"			-- app name
globals.font = {						-- fonts
	regular = native.systemFont,
	bold = native.systemFontBold,
}

-- app messages
-- messages that are interpreted by the app_loop are defined here
globals.app_msg = {

	-- messages
	restart = "restart",
	change_scene = "change_scene",		-- loads a new scene, destroying the previous one, and changes the app state
										-- msg_data values: 
										-- msg_data.scene - (required) name of the scene to go to. see globals.app_state for values
										
	change_state = "change_state",		-- only changes the app state
										-- msg_data values:
										-- msg_data.state - (required) name of the state to change to
	
	exit_app = "exit_app",
}

-- app states
-- if globals.app_state.* is a scene, its value will be the file path to that scene
-- else, it will be a string representing that state
globals.app_state = {
	
	-- scenes
	splash = globals.lua_path.."scene_splash",
	menu = globals.lua_path.."scene_menu",
	game = globals.lua_path.."scene_game",
	gameover = globals.lua_path.."scene_gameover",
	
	-- game sub-scenes
	game_lvl1 = globals.lua_path.."scene_game_lvl1",
	
	-- game controller overlay scene
	game_controller = globals.lua_path.."scene_game_controller",
	
	-- app exit message
	app_exit = "appExit",
}


-- helper functions
-- shallow_copy copies primitive types
-- if a table is passed, primitives are copied on the first level and subtables are passed by reference
globals.shallow_copy = function(orig)

	local orig_type = type(orig)
	local cpy
	
	if orig_type == "table" then
		cpy = {}
		for k, v in pairs(orig) do
			cpy[k] = v
		end
	else	-- primitive types
		cpy = orig
	end
	
	return cpy
end

-- deep copy copies primitive types and tables recursively so all subtables are also copied
globals.deep_copy = function(orig)

	local orig_type = type(orig)
	local cpy
	
	if orig_type == "table" then
		cpy = {}
		for k, v in next, orig, nil do
			cpy[globals.deep_copy(k)] = globals.deep_copy(v)
		end
		setmetatable(cpy, globals.deep_copy(getmetatable(orig)))
	else	-- primitive types
		cpy = orig
	end
	
	return cpy
end

return globals