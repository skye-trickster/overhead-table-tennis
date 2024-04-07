/// @description global game logic

switch(global.game_state) {
	case GAME_STATE.MENU:
		if(INPUT_CONFIRM_BUTTON_PRESSED) {
			if (not global.ball) {
				global.ball = instance_create_depth(x, y, depth, obj_ball);	
			}
			// feather ignore GM2016
			serve_ball();
			global.game_state = GAME_STATE.PLAYING;
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
	break;
}

if (keyboard_check_pressed(vk_backspace)) {
	show_debug_message({
		"width": display_get_gui_width(),
		"height": display_get_gui_height(),
	});
}