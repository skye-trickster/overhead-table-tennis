/// @description global game logic

switch(global.game_state) {
	case GAME_STATE.MENU:
		if (INPUT_UP_PRESSED) {
			global.main_menu.previous();
		} else if (INPUT_DOWN_PRESSED) {
			global.main_menu.next();
		}
		if(INPUT_CONFIRM_BUTTON_PRESSED) {
			switch(global.main_menu.select()) {
				case "start":
					// Feather ignore GM2017
					start_game();
					global.main_menu.selected = 0;
				break;

				case "exit":
					game_end();
				break;
			}
		}
	break;

	case GAME_STATE.PLAYING:
		// Pause if the pause button is pressed
		if (INPUT_PAUSE_BUTTON_PRESSSED) {
			global.game_state = GAME_STATE.PAUSING;
		}
	break;

	case GAME_STATE.BETWEEN_POINTS:
		point_timer += DELTA_TIME;
		if (point_timer > time_between_points) {
			serve_ball();
			point_timer = 0;
			global.game_state = GAME_STATE.PLAYING;
		}
	break;

	case GAME_STATE.PAUSING:
		// resume if the pause button is pressed
		if (INPUT_PAUSE_BUTTON_PRESSSED) {
			global.game_state = GAME_STATE.PLAYING;
		}
		
		if (INPUT_UP_PRESSED) {
			global.pause_menu.previous();
		} else if (INPUT_DOWN_PRESSED) {
			global.pause_menu.next();
		} else if(INPUT_CONFIRM_BUTTON_PRESSED) {
			switch(global.pause_menu.select()) {
				case "resume":
					global.game_state = GAME_STATE.PLAYING;
					global.pause_menu.selected = 0;
				break;

				case "exit":
					game_end();
				break;
			}
		}
	break;
}

if (keyboard_check_pressed(vk_backspace)) {
	show_debug_message({
		"width": display_get_gui_width(),
		"height": display_get_gui_height(),
	});
}