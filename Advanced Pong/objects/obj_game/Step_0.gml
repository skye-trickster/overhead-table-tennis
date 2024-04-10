/// @description Global game logic

switch(global.game_state) {
	case GAME_STATE.MENU:
		switch(global.main_menu.navigate()) {
			case "start":
				// start the game
				// Feather ignore GM2016
				start_game();
				global.main_menu.reset();
			break;

			case "exit":
				end_game();
			break;
			
			// do nothing otherwise
		}
	break;

	case GAME_STATE.PLAYING:
		// Pause if the pause button is pressed
		if (INPUT_PAUSE_BUTTON_PRESSSED) {
			global.game_state = GAME_STATE.PAUSING;
		}
	break;

	case GAME_STATE.BETWEEN_POINTS:
		// TODO: fix issue where you can't pause in between points
		point_timer += DELTA_TIME;
		if (point_timer > time_between_points) {
			switch_serve();
			serve_ball();
			point_timer = 0;
			global.game_state = GAME_STATE.PLAYING;
		}

	break;

	case GAME_STATE.PAUSING:
		// resume if the pause button is pressed
		if (INPUT_PAUSE_BUTTON_PRESSSED) {
			resume_game();
			global.pause_menu.reset();
			break;
		}
		
		switch(global.pause_menu.navigate()) {
			case "resume":
				resume_game();
				global.pause_menu.reset();
			break;
				
			case "menu":
				reset_game();
			break;

			case "exit":
				end_game();
			break;
		}
	break;
	
	case GAME_STATE.WINNING:
		point_timer += DELTA_TIME;
		if (point_timer > time_after_win) {
			point_timer = 0;
			reset_game();
		}
		
		color_rotater += DELTA_TIME;
		if (color_rotater > color_rotate_timer) {
			color_rotater = 0;
			rotate_color();
		}
	break;
}

if (keyboard_check_pressed(vk_f4) and NOT_ON_BROWSER) {
	window_set_fullscreen(not window_get_fullscreen())	
}